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
#include <CGAL/AABB_traits_3.h>
#include <CGAL/AABB_face_graph_triangle_primitive.h>
#include <iostream>
#include <fstream>
#include <cmath>
#include <QDir>
#include <CGAL/Side_of_triangle_mesh.h>
#include <CGAL/Polyhedron_incremental_builder_3.h>

typedef CGAL::Simple_cartesian<double> Kernel;
typedef Kernel::Point_3 Point_3;
typedef CGAL::Polyhedron_3<Kernel> Polyhedron;
typedef CGAL::AABB_face_graph_triangle_primitive<Polyhedron> Primitive;
typedef CGAL::AABB_traits_3<Kernel, Primitive> AABB_traits;
typedef CGAL::AABB_tree<AABB_traits> AABB_tree;
typedef CGAL::Side_of_triangle_mesh<Polyhedron, Kernel> Point_inside;

FlightZoneManager::FlightZoneManager()
{
    qInfo() << "FlightZoneManager Start";
    connect(&_timer, &QTimer::timeout, this, &FlightZoneManager::updatePolygonVisibility);
    _timer.start(1000);

    testPolyhedronDistance();
    testinout();
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
    // Define base and top vertices
    std::vector<Point_3> baseVertices;
    std::vector<Point_3> topVertices;

    // Add base vertices with bottom altitude
    baseVertices.push_back(latLonAltToCartesian(37.347914, 126.719012, 100.0));
    baseVertices.push_back(latLonAltToCartesian(37.347546, 126.718293, 100.0));
    baseVertices.push_back(latLonAltToCartesian(37.348000, 126.718500, 100.0));
    baseVertices.push_back(latLonAltToCartesian(37.347800, 126.719200, 100.0));

    // Add corresponding top vertices with top altitude
    topVertices.push_back(latLonAltToCartesian(37.347914, 126.719012, 130.0));
    topVertices.push_back(latLonAltToCartesian(37.347546, 126.718293, 130.0));
    topVertices.push_back(latLonAltToCartesian(37.348000, 126.718500, 130.0));
    topVertices.push_back(latLonAltToCartesian(37.347800, 126.719200, 130.0));

    // Create the polyhedron
    Polyhedron P;

    // Create bottom face (base polygon)
    for (size_t i = 0; i < baseVertices.size() - 2; ++i) {
        P.make_triangle(baseVertices[0], baseVertices[i + 1], baseVertices[i + 2]);
    }

    // Create top face (top polygon)
    for (size_t i = 0; i < topVertices.size() - 2; ++i) {
        P.make_triangle(topVertices[0], topVertices[i + 1], topVertices[i + 2]);
    }

    // Create side faces (connect base and top vertices)
    for (size_t i = 0; i < baseVertices.size(); ++i) {
        size_t next = (i + 1) % baseVertices.size(); // Wrap around to the first vertex
        P.make_triangle(baseVertices[i], baseVertices[next], topVertices[i]); // Side triangle 1
        P.make_triangle(baseVertices[next], topVertices[next], topVertices[i]); // Side triangle 2
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

    // 등록한 드론의 위치를 가져와야함

    // Convert drone's position to Cartesian coordinates
    Point_3 dronePosition = latLonAltToCartesian(droneLat, droneLon, droneAlt);
    std::cout << "Drone position in Cartesian coordinates: "
              << droneLat << ", " << droneLon << ", " << droneAlt << std::endl;

    // Query the distance between the drone's position and the polyhedron
    double distance = std::sqrt(tree.squared_distance(dronePosition)); // distance in meters
    std::cout << "Shortest distance from the drone to the polyhedron is: " << distance << " meters" << std::endl;

}

// Polyhedron 생성 함수
void createPolyhedron(const std::vector<Point_3>& vertices, Polyhedron& polyhedron) {
    if (vertices.size() < 8 || vertices.size() % 2 != 0) {
        throw std::runtime_error("Vertices must be even and at least 8 to form a closed polyhedron.");
    }

    CGAL::Polyhedron_incremental_builder_3<Polyhedron::HalfedgeDS> builder(polyhedron.hds(), true);
    builder.begin_surface(vertices.size(), vertices.size());

    std::vector<size_t> v_indices;

    // 정점 추가
    for (size_t i = 0; i < vertices.size(); ++i) {
        builder.add_vertex(vertices[i]);
        v_indices.push_back(i);
    }

    size_t half_size = vertices.size() / 2;

    // ⬆️ 윗면 (삼각형으로 구성)
    for (size_t i = 1; i < half_size - 1; ++i) {
        builder.begin_facet();
        builder.add_vertex_to_facet(v_indices[0]);
        builder.add_vertex_to_facet(v_indices[i + 1]);
        builder.add_vertex_to_facet(v_indices[i]);
        builder.end_facet();
    }

    // ⬇️ 아랫면 (삼각형으로 구성)
    for (size_t i = 1; i < half_size - 1; ++i) {
        builder.begin_facet();
        builder.add_vertex_to_facet(v_indices[half_size]);
        builder.add_vertex_to_facet(v_indices[half_size + i]);
        builder.add_vertex_to_facet(v_indices[half_size + i + 1]);
        builder.end_facet();
    }

    // 🔄 측면 (각 변을 두 개의 삼각형으로 구성)
    for (size_t i = 0; i < half_size; ++i) {
        size_t next = (i + 1) % half_size;

        // 삼각형 1
        builder.begin_facet();
        builder.add_vertex_to_facet(v_indices[i]);
        builder.add_vertex_to_facet(v_indices[next]);
        builder.add_vertex_to_facet(v_indices[next + half_size]);
        builder.end_facet();

        // 삼각형 2
        builder.begin_facet();
        builder.add_vertex_to_facet(v_indices[i]);
        builder.add_vertex_to_facet(v_indices[next + half_size]);
        builder.add_vertex_to_facet(v_indices[i + half_size]);
        builder.end_facet();
    }

    builder.end_surface();

    if (!polyhedron.is_valid() || !polyhedron.is_closed()) {
        throw std::runtime_error("Error: Invalid or non-closed polyhedron.");
    }
}

bool checkPointInsidePolyhedron(const Polyhedron& polyhedron, const Point_3& point) {
    bool ret = false;
    try {
        qInfo() << "CheckPointInsidePolyhedron";

        // Polyhedron의 정점이 있는지 확인
        if (polyhedron.size_of_vertices() == 0) {
            qInfo() << "Polyhedron has no vertices!";
        } else {
            qInfo() << "Polyhedron vertices:";
            for (auto v = polyhedron.vertices_begin(); v != polyhedron.vertices_end(); ++v) {
                const Point_3& vertex = v->point();
                qInfo() << "Vertex:" << vertex.x() << vertex.y() << vertex.z();
            }
        }

        // Point의 좌표 출력
        qInfo() << "Point to check:" << point.x() << point.y() << point.z();

        Point_inside inside(polyhedron);
        if (inside(point) == CGAL::ON_BOUNDED_SIDE) {
            ret = true;
            qInfo() << "The point is inside the polyhedron.";
        } else {
            ret = false;
            qInfo() << "The point is outside the polyhedron.";
        }
        return ret;
    }
    catch (const std::exception& e) {
        std::cerr << "Error: " << e.what() << std::endl;
        return ret;
    }
}

void FlightZoneManager::testinout(){

    // Polyhedron의 정점 정의 (위경고도 및 고도를 Cartesian으로 변환)
    std::vector<Point_3> vertices = {
        latLonAltToCartesian(37.5665, 126.9780, 100),  // 정점 0
        latLonAltToCartesian(37.5665, 126.9790, 100),  // 정점 1
        latLonAltToCartesian(37.5675, 126.9790, 100),  // 정점 2
        latLonAltToCartesian(37.5675, 126.9780, 100),  // 정점 3
        latLonAltToCartesian(37.5665, 126.9780, 200),  // 정점 4
        latLonAltToCartesian(37.5665, 126.9790, 200),  // 정점 5
        latLonAltToCartesian(37.5675, 126.9790, 200),  // 정점 6
        latLonAltToCartesian(37.5675, 126.9780, 200)   // 정점 7
    };

    // Polyhedron 생성
    Polyhedron polyhedron;
    //    createPolyhedron(vertices, faces, polyhedron);
    createPolyhedron(vertices, polyhedron);

    // 테스트할 점 (Cartesian 좌표)
    Point_3 testPoint = latLonAltToCartesian(37.5667, 126.9785, 198);

    // 점이 Polyhedron 내부에 있는지 확인
    checkPointInsidePolyhedron(polyhedron, testPoint);
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
