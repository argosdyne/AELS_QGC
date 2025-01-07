#include "FlightZoneManager.h"
#include <QJsonDocument>
#include <QJsonArray>
#include <QObject>
#include <QFile>
#include <QCoreApplication>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QList>
#include <QDateTime>

#include "Vehicle.h"
#include "FirmwarePlugin.h"
#include "MAVLinkProtocol.h"
#include "QGCApplication.h"
#include "ParameterManager.h"
#include "JsonHelper.h"
#include "QGCQGeoCoordinate.h"
#include "AppSettings.h"
#include "PlanMasterController.h"
#include "SettingsManager.h"
#include "AppSettings.h"

#include <CGAL/Simple_cartesian.h>
#include <CGAL/Polyhedron_3.h>
#include <CGAL/AABB_tree.h>
#include <CGAL/AABB_traits.h>
#include <CGAL/AABB_face_graph_triangle_primitive.h>
#include <iostream>
#include <fstream>
#include <cmath>
#include <QDir>

typedef CGAL::Simple_cartesian<double> Kernel;
typedef Kernel::Point_3 Point_3;
typedef CGAL::Polyhedron_3<Kernel> Polyhedron;
typedef CGAL::AABB_face_graph_triangle_primitive<Polyhedron> Primitive;
typedef CGAL::AABB_traits<Kernel, Primitive> AABB_traits;
typedef CGAL::AABB_tree<AABB_traits> AABB_tree;

FlightZoneManager::FlightZoneManager()
{
    // qInfo() << "FlightZoneManager Start";

    //
    connect(&_timer, &QTimer::timeout, this, &FlightZoneManager::updatePolygonVisibility);
    _timer.start(1000);
    testPolyhedronDistance();
}

// Function to convert latitude, longitude, altitude to Cartesian coordinates
Point_3 latLonAltToCartesian(double lat, double lon, double alt) {
    // Earth's radius in meters
    const double R = 6371000.0;

    // Convert latitude and longitude from degrees to radians
    double latRad = lat * M_PI / 180.0;
    double lonRad = lon * M_PI / 180.0;

    // Cartesian coordinates
    double x = (R + alt) * std::cos(latRad) * std::cos(lonRad);
    double y = (R + alt) * std::cos(latRad) * std::sin(lonRad);
    double z = (R + alt) * std::sin(latRad);

    return Point_3(x, y, z);
}

void FlightZoneManager::testPolyhedronDistance() {

    // Define vertices (arbitrary number)
    std::vector<Point_3> vertices;
    //vertices.push_back(latLonAltToCartesian(37.347564, 126.719884, 20.0));
    vertices.push_back(latLonAltToCartesian(37.347914, 126.719012, 20.0));
    //vertices.push_back(latLonAltToCartesian(37.347162, 126.719104, 20.0));
    vertices.push_back(latLonAltToCartesian(37.347546, 126.718293, 20.0));
    vertices.push_back(latLonAltToCartesian(37.348000, 126.718500, 20.0));
    vertices.push_back(latLonAltToCartesian(37.347800, 126.719200, 20.0));
    // Add more vertices as needed...

    // Create the polyhedron (e.g., a triangular prism)
    Polyhedron P;

    // Connect base vertices (e.g., a quadrilateral base with triangles)
    for (size_t i = 0; i < vertices.size() - 2; ++i) {
        P.make_triangle(vertices[0], vertices[i + 1], vertices[i + 2]);  // base triangle faces
    }

    // Build AABB tree
    AABB_tree tree(faces(P).first, faces(P).second, P);
    tree.accelerate_distance_queries();
    qDebug() << "AABB tree built successfully!";

    // Query point
    //Lat, lng, Alt
    //Point_3에서 사용하는 값들은 위경고도값이 아닌 x,y,z느낌으로 바꿔줘야되는 듯함

    // Drone's position (lat/lon/alt) for example
    double droneLat = 37.346608;  // Drone's latitude
    double droneLon = 126.720336; // Drone's longitude
    double droneAlt = 20.0;  // Drone's altitude

    // Convert drone's position to Cartesian coordinates
    Point_3 dronePosition = latLonAltToCartesian(droneLat, droneLon, droneAlt);
    std::cout << "Drone position in Cartesian coordinates: "
              << droneLat << ", " << droneLon << ", " << droneAlt << std::endl;

    // Query the distance between the drone's position and the polyhedron
    double distance = std::sqrt(tree.squared_distance(dronePosition)); // distance in meters
    std::cout << "Shortest distance from the drone to the polyhedron is: " << distance << " meters" << std::endl;
}

QString getExternalStoragePath() {
    // Get the directory for storing external files.
    return QStandardPaths::writableLocation(QStandardPaths::DownloadLocation);
}
QString FlightZoneManager::getFilePath() {
#ifdef Q_OS_ANDROID
    // Android에서 파일 경로
    QString filePath = getExternalStoragePath() + "/map.geojson";
    return filePath;
#else
    // Windows에서 사용자 Documents 폴더 경로
    QString documentsPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    return documentsPath + "/map.geojson";
#endif
}

QList<FlightValidTime> validTimeList;

void FlightZoneManager::deletePolygon(int index)
{
    qInfo() << "deletepolygon index" << index;
    if (index < 0 || index > _polygons.count() - 1) {
        return;
    }

    QGCFencePolygon* polygon = qobject_cast<QGCFencePolygon*>(_polygons.removeAt(index));
    if (polygon) {
        polygon->deleteLater(); // 메모리 해제
    }
}

void FlightZoneManager::removeAll(void)
{
    _polygons.clearAndDeleteContents();
    _circles.clearAndDeleteContents();
}

void FlightZoneManager::updatePolygonVisibility() {

    // validTimeList valid_from과 valid_to는 이 리스트에 저장되어 있음

    // 읽어온 파일과 현재 시간과 비교
    // 만약 validto를 넘으면 넘은 polygon을 삭제
    // 만약 validfrom 시간에 들어오면 그 들어온 polygon을 생성

    // 현재 시간
    QDateTime currentTime = QDateTime::currentDateTime();

    for(int i = 0; i < validTimeList.size(); ++i){
        auto& timeData = validTimeList[i];

        QDateTime validFrom = timeData.validFrom;
        QDateTime validTo = timeData.validTo;
        qInfo() << timeData.polygonid;
        qInfo() << "currentTime : " << currentTime <<"validFrom : " << validFrom << "validTo : " << validTo;

        // 유효기간을 넘었으면 Polygon 삭제
        // 아직 보여주는 시간이 안되었어도 Polygon 삭제
        if(currentTime > validTo) {
            qInfo() << "Delete Index : " << i;
            deletePolygon(i);
            validTimeList.removeAt(i);
            --i;
            timeData.isCreated = false;
            continue;
        }

        //현재 시간이 validFrom에 해당하면 생성
        if (!timeData.isCreated && currentTime >= validFrom && currentTime <= validTo) {
            qInfo() << "Create Polygon for ID: " << timeData.polygonid;
            qInfo() << "시간 지남 index : " << i ;
            //Delete All
            removeAll();
            // AddNew
            processJsonFile(getFilePath());

            timeData.isCreated = true; // 생성 완료 상태 설정
        }
    }
}

void FlightZoneManager::processJsonFile(const QString& filePath) {
    qInfo() << "filePath :" << filePath;
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly)) {
        qWarning() << "Failed to open file:" << filePath;
        return;
    }

    QByteArray data = file.readAll();
    file.close();

    QJsonDocument doc = QJsonDocument::fromJson(data);
    if (!doc.isObject()) {
        qWarning() << "Invalid JSON format";
        return;
    }

    QJsonObject root = doc.object();
    QJsonArray features = root.value("features").toArray();

    qInfo() << "features count" << features.count();
    validTimeList.clear();
    QDateTime currentTime = QDateTime::currentDateTime(); // 현재 시간

    for (const QJsonValue& feature : features) {
        if (!feature.isObject()) continue;

        QJsonObject featureObj = feature.toObject();
        QJsonObject geometry = featureObj.value("geometry").toObject();
        QJsonObject properties = featureObj.value("properties").toObject();

        qint64 polygonid = featureObj.value("id").toInt(); //Int 타입

        if (geometry.value("type").toString() != "Polygon") continue;

        QJsonArray coordinates = geometry.value("coordinates").toArray();
        if (coordinates.isEmpty()) continue;

        QString zoneType = properties.value("zone_type").toString();
        QString validFrom = properties.value("valid_from").toString();
        QString validTo = properties.value("valid_to").toString();

        QDateTime validFromDateTime = QDateTime::fromString(validFrom, "yyyy-MM-dd HH:mm:ss");
        QDateTime validToDateTime = QDateTime::fromString(validTo, "yyyy-MM-dd HH:mm:ss");



        QGCFencePolygon* polygon = new QGCFencePolygon(false /* inclusion */, this); // true = not fill , false = fill

        for (const QJsonValue& ring : coordinates) {
            if (!ring.isArray()) continue;

            QJsonArray points = ring.toArray();
            for (const QJsonValue& point : points) {
                if (!point.isArray()) continue;

                QJsonArray latLon = point.toArray();
                if (latLon.size() < 2) continue;

                double lon = latLon[0].toDouble();
                double lat = latLon[1].toDouble();

                QGeoCoordinate coordinate(lat, lon);
                qInfo() << "lat = " << lat << "lon = " << lon;
                polygon->appendVertex(coordinate);

                qInfo() << "polygon count = " << polygon->count();
            }
        }


        // Set polygon color based on zone type
        if (zoneType == "Excluded") {
            polygon->setcolorInclusion("red");
        } else if (zoneType == "Restricted") {
            polygon->setcolorInclusion("yellow");
        } else if(zoneType == "Facilitated"){
            polygon->setcolorInclusion("green"); // Default color
        } else {
            polygon->setcolorInclusion("blue");
        }



        // validFrom 시간과 현재 시간을 비교
        if (currentTime < validFromDateTime) {
            qInfo() << "Polygon is not yet valid. Skipping.";
            validTimeList.append(FlightValidTime(polygonid, validFromDateTime, validToDateTime, false));
            continue; // 유효하지 않으면 건너뛴다.
        }
        else {
            qInfo() << "Polygon valid. Skipping.";
            validTimeList.append(FlightValidTime(polygonid, validFromDateTime, validToDateTime, true));
        }

        // Add the completed polygon to the polygons list
        _polygons.append(polygon);




        //PlanView에서도 호출하고 FlyView에서도 호출해서 그럼.
        //따라서 하나의 View에서만 호출하도록 하던지 아니면 중복체크를해서 한번만 하게 하던지 해야할


        qInfo() << "_polygons Count = " << _polygons.count();
        qInfo() << "Polygon added successfully.";

        qInfo() << "Zone Type:" << zoneType;
        qInfo() << "Valid From:" << validFrom;
        qInfo() << "Valid To:" << validTo;

        //각 polygon마다 고유한 ID가 있는듯함. Index 번호로
        // 그렇다면 고유한 ID로 비교해서
        qInfo() << "polygon ID : " << polygonid;

    }
    qInfo() << "validTimeList Count" << validTimeList.count();

}


void FlightZoneManager::_init(void){
    qInfo() << "flightZone Manager";

    processJsonFile(getFilePath());
}

