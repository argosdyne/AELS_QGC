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
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QUrl>

#include "JsonHelper.h"
#include "FlyViewSettings.h"
#include "QGCApplication.h"
#include "QGroundControlQmlGlobal.h"
#include <QQuickWindow>
#include <QScreen>

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

// 지구 둘레 (미터)
double EarthCircumference = 40075017.0;
QGeoCoordinate geoCoordinate;

FlightZoneManager::FlightZoneManager() : manager(new QNetworkAccessManager(this))
{
    qInfo() << "FlightZoneManager Start";

    // 이 기능은 USB일때만 사용하는게 좋을듯함 온라인은 어짜피 자동으로 날짜가 바뀌는거 아님? 불러올때마다
    // 0 = USB, 1 = Online

    connect(&_timer, &QTimer::timeout, this, &FlightZoneManager::updatePolygonVisibility);
    _timer.start(1000);
    testPolyhedronDistance();
    
    connect(manager, &QNetworkAccessManager::finished, this, &FlightZoneManager::onReplyFinished);
    //Start Read GeoJson data from internet

    //Check Zoom Value
    connect(&_zoomTimer, &QTimer::timeout, this, &FlightZoneManager::checkCurrentZoomValue);
    _zoomTimer.start(1000);

    _toolbox = qgcApp()->toolbox();
    _settingsManager = _toolbox->settingsManager();

    if(_toolbox) {
        qInfo()<< "_toolbox is not null";
    }
    else {
        qInfo() << "_toolbox is null";
    }

    if(_settingsManager) {
        qInfo() << "_settingsManager is not null";
    }
    else {
        qInfo() << "_settingsManager is null";
    }

    // 어떻게 해도 가져올 방법이 없음.(하려고 하면 구조를 아예 바꿔야됨) 따라서 반복적으로 돌면서 줌값을 체크하는 함수를 돌려야 할듯함.

    //여기서 호출해서 connect할 수 있으면 가장 좋긴함.

    // 포인터로 호출한거라서 초기화를 한번 해야지 Connect가능하다고 함

    if(qGroundControlQmlGlobal) {
        qInfo() << "qGroundControlQmlGlobal is not null";
        qInfo() << "FlightMap zoom : " << qGroundControlQmlGlobal->flightMapZoom();
    }
    else {
        qInfo() << "qGroundControlQmlGlobal is null";
    }

    geoCoordinate = qGroundControlQmlGlobal->flightMapPosition();


}


void FlightZoneManager::fetchGeoJsonData()
{
    // API endpoint with query parameters for bounding box
    QString url = "https://api.altitudeangel.com/v2/mapdata/geojson";
    //QString url = "https://api.altitudeangel.com/mapdata/GB";
    QUrl fullUrl(url);

    // Set query parameters (bounding box: n, e, s, w)
    // 영국
    QUrlQuery query;

    //체코
    query.addQueryItem("n", "51.0557");    // 북쪽 위도
    query.addQueryItem("e", "18.0");       // 동쪽 경도
    query.addQueryItem("s", "49.8");       // 남쪽 위도
    query.addQueryItem("w", "15.5");       // 서쪽 경도
    fullUrl.setQuery(query);



    QNetworkRequest request(fullUrl);

    // Add headers
    request.setRawHeader("Authorization", "X-AA-ApiKey laxXQuijuwMUVFCFYcmnuhdDu3K78xI4fUKroC_A0");
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    // Send GET request
    manager->get(request);
}

void FlightZoneManager::onReplyFinished(QNetworkReply *reply)
{
    if(reply->error() == QNetworkReply::NoError){
        QByteArray responseData = reply->readAll();

        QJsonDocument jsonDoc = QJsonDocument::fromJson(responseData);
        if(!jsonDoc.isNull()){
            //qInfo() << "GeoJson Data" << jsonDoc.toJson(QJsonDocument::Indented);
            processJsonFile(jsonDoc);
        } else {
            qInfo() << "Failed to parse GeoJson";
        }

    }
    else {
        qInfo() << "Error fetching GeoJson" << reply->errorString();
    }

    reply->deleteLater();
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

void FlightZoneManager::fetchGeoJsonDataForRegion(double n, double e, double s, double w)
{
    QString url = "https://api.altitudeangel.com/v2/mapdata/geojson";
    QUrl fullUrl(url);

    QUrlQuery query;
    query.addQueryItem("n", QString::number(n)); // 북쪽 위도
    query.addQueryItem("e", QString::number(e)); // 동쪽 경도
    query.addQueryItem("s", QString::number(s)); // 남쪽 위도
    query.addQueryItem("w", QString::number(w)); // 서쪽 경도
    fullUrl.setQuery(query);

    QNetworkRequest request(fullUrl);

    // Add headers
    request.setRawHeader("Authorization", "X-AA-ApiKey S_QjUlIuo3mYvFzlHR4K8iyYAVPuPBwaKHHCq2780");
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    // Send GET request
    manager->get(request);
}



void FlightZoneManager::fetchGeoJsonForCzechRepublic()
{

#if true
    // 프라하 (Praha)
    fetchGeoJsonDataForRegion(50.2, 14.6, 50.0, 14.2);

    // // 중앙보헤미아 주 (Středočeský kraj)
    // fetchGeoJsonDataForRegion(50.5, 15.0, 49.5, 14.0);

    // // 남보헤미아 주 (Jihočeský kraj)
    // fetchGeoJsonDataForRegion(49.3, 14.8, 48.6, 14.0);

    // // 플젠 주 (Plzeňský kraj)
    // fetchGeoJsonDataForRegion(49.9, 13.6, 49.5, 13.0);

    // // 카를로비바리 주 (Karlovarský kraj)
    // fetchGeoJsonDataForRegion(50.4, 13.2, 50.0, 12.5);

    // // 우스티 주 (Ústecký kraj)
    // fetchGeoJsonDataForRegion(51.0, 14.5, 50.6, 13.9);

    // // 리베레츠 주 (Liberecký kraj)
    // fetchGeoJsonDataForRegion(50.9, 15.5, 50.5, 15.0);

    // // 흐라데츠크랄로베 주 (Královéhradecký kraj)
    // fetchGeoJsonDataForRegion(50.5, 16.2, 50.0, 15.5);

    // // 파르두비체 주 (Pardubický kraj)
    // fetchGeoJsonDataForRegion(50.1, 16.3, 49.7, 15.6);

    // // 비소치나 주 (Kraj Vysočina)
    // fetchGeoJsonDataForRegion(49.7, 15.8, 49.1, 15.2);

    // // 남모라비아 주 (Jihomoravský kraj)
    // fetchGeoJsonDataForRegion(49.4, 17.0, 48.6, 16.0);

    // // 올로모우츠 주 (Olomoucký kraj)
    // fetchGeoJsonDataForRegion(49.9, 17.8, 49.3, 16.8);

    // // 즐린 주 (Zlínský kraj)
    // fetchGeoJsonDataForRegion(49.3, 18.2, 48.8, 17.5);

    // // 모라비아-실레지아 주 (Moravskoslezský kraj)
    // fetchGeoJsonDataForRegion(49.9, 18.5, 49.4, 18.0);
#endif


}


QString getExternalStoragePath() {
    // Get the directory for storing external files.
    return QStandardPaths::writableLocation(QStandardPaths::DownloadLocation);
}
QString FlightZoneManager::getFilePath() {

    QString savePath = _settingsManager->flyViewSettings()->filePath()->rawValueString();
    qInfo() << "FlightZoneManger savePath : " << savePath;

#ifdef Q_OS_ANDROID
    // Android에서 파일 경로
    //QString filePath = getExternalStoragePath() + "/map.geojson";
    //QString filePath = "content://com.android.providers.downloads.documents/document/msf%3A87334";
    QString filePath = savePath;
    return filePath;
#else
    // Windows에서 사용자 Documents 폴더 경로
    //QString documentsPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation) + "/map.geojson";
    QString documentsPath = savePath;
    return documentsPath ;
#endif
}

QList<FlightValidTime> validTimeList;
QList<GeoJsonNameList> geoJsonNameList;

void FlightZoneManager::deletePolygon(int index)
{
    //qInfo() << "deletepolygon index" << index;
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
    geoJsonNameList.clear();
}

void FlightZoneManager::checkCurrentZoomValue() {

    double zoom = qGroundControlQmlGlobal->flightMapZoom();

    //내가 있는 지도의 가운데 좌표
    QGeoCoordinate mapCoord = qGroundControlQmlGlobal->flightMapPosition();

    //  가운데 좌표, zoom값

    qInfo() << "lat : " << mapCoord.latitude() << "lon : " << mapCoord.longitude();

    if(zoom >= 12)  { // 테스트용으로 8 원래는 13
        qInfo() << "FlightMap zoom Over 12: " << qGroundControlQmlGlobal->flightMapZoom();
        // 메소드를 한번만 실행시켜야됨
        // 없으면 생성. 있으면 생성 안해야됨. 조건은 추가 필요.
        if(_polygons.count() == 0) { // 이미 생성되어 있음

            //왜 여러번 실행되는지 확인필요
            qInfo()<< "init polygons";
            _init();
        }
        // 여기서 화면 이동시 조건도 추가 필요함
        if(qGroundControlQmlGlobal->flightMapPosition() != geoCoordinate) // 위치가 바뀌면
        {
            // 위치 새로고침 후 생성
            //removeAll();
            geoCoordinate = qGroundControlQmlGlobal->flightMapPosition();
            _init();
        }

    }
    else {
        qInfo() << "FlightMap zoom less 12: " << qGroundControlQmlGlobal->flightMapZoom();
        // 생성된거 전부 삭제
        removeAll();
    }
}

// 화면 이동 시

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
        //qInfo() << timeData.polygonid;
        //qInfo() << "currentTime : " << currentTime <<"validFrom : " << validFrom << "validTo : " << validTo;

        // 유효기간을 넘었으면 Polygon 삭제
        // 아직 보여주는 시간이 안되었어도 Polygon 삭제
        if(currentTime > validTo) {
            //qInfo() << "Delete Index : " << i;
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

    //File이 없다면 온라인에서 읽어오도록 하는게 맞을듯함
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

void FlightZoneManager::processJsonFile(QJsonDocument jsonDoc) {

    QJsonObject root = jsonDoc.object();
    QJsonArray features = root.value("features").toArray();

    qInfo() << "features count:" << features.count();
    validTimeList.clear();

    QDateTime currentTime = QDateTime::currentDateTime();

    for (const QJsonValue& feature : features) {
        if (!feature.isObject()) continue;

        QJsonObject featureObj = feature.toObject();
        QJsonObject geometry = featureObj.value("geometry").toObject();
        QJsonObject properties = featureObj.value("properties").toObject();

        // 고유 ID 추출
        qint64 polygonid = featureObj.value("id").toInt(); // 정수 타입 ID

        // 속성 처리
        QString name = properties.value("name").toString();
        QString category = properties.value("category").toString();
        QString strokeColor = properties.value("strokeColor").toString();

        // 유효 시간 표시
        QJsonObject airac = properties.value("airac").toObject();
        QString operationalFrom = airac.value("from").toString();
        QString operationalTo = airac.value("to").toString();

        QDateTime validFrom = QDateTime::fromString(operationalFrom, "yyyy-MM-dd");
        QDateTime validTo = QDateTime::fromString(operationalTo, "yyyy-MM-dd");

        // geometry의 타입 확인 (Polygon 또는 Point)
        QString geometryType = geometry.value("type").toString();
        QGCFencePolygon* polygon = new QGCFencePolygon(false /* inclusion */, this); // true = not fill , false = fill
        // Polygon 처리
        if (geometryType == "Polygon") {
            QJsonArray coordinates = geometry.value("coordinates").toArray();
            if (coordinates.isEmpty()) continue;

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



                    if(category != "airspace"){
                        if(geoJsonNameList.count() == 0) // 아무것도 없으면 추가해야함. 추가할때는 중복체크해서
                        {
                            qInfo() << "geoJsonNameList count = 0";
                            geoJsonNameList.append(GeoJsonNameList(name));
                        }

                        if(!geoJsonNameList.contains(GeoJsonNameList(name))) //객체가 없으면
                        {
                            geoJsonNameList.append(GeoJsonNameList(name));

                            qInfo() << "geoJsonNameList Count : " << geoJsonNameList.count();

                        }
                        polygon->appendVertex(coordinate);
                    }

                }
            }

            // 날짜 비교
            // if(currentTime > validTo) {
            //     qInfo() << "Polygon is not yet valid. Skipping";
            //     validTimeList.append(FlightValidTime(polygonid, validFrom, validTo, false));
            //     continue; // 유효하지 않으면 건너뛴다.
            // }
            // else {
            //     qInfo() << "Polygon valid. Skipping";
            //     validTimeList.append(FlightValidTime(polygonid, validFrom, validTo, true));
            // }

            //일단 날짜 무시하고?

            // Add to polygon list
            if(category != "airspace"){
                if(!_polygons.contains(polygon)){
                    _polygons.append(polygon);


                }


                qInfo() << "Polygon added with ID:" << polygonid;
                qInfo() << "Current polygon count:" << _polygons.count();
            }
        }
        // Point 처리
        else if (geometryType == "Point") {
            QJsonArray coordinates = geometry.value("coordinates").toArray();
            if (coordinates.isEmpty()) continue;

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
                    qInfo()<<"geometryType Point = "<< lat << ", " << lon;
                    //polygon->appendVertex(coordinate);
                }
            }
        }

        if(category != "airspace" && geometryType != "Point" ) {
            qInfo() << "geometryType: " << geometryType;
            qInfo() << "Feature ID:" << polygonid;
            qInfo() << "Name:" << name;
            qInfo() << "Category:" << category;

            qInfo() << "operationFrom" << operationalFrom;
            qInfo() << "operationTo" << operationalTo;
            qInfo() << "strokeColor" << strokeColor;

            polygon->setcolorInclusion(strokeColor);

            //중복 대비. list에도 이름을 넣는다. 만약 이름이 똑같으면 그거는 list에 안넣는거로 한다.
        }
    }

    qInfo() << "Processing complete. Total polygons:" << _polygons.count();
}

void FlightZoneManager::processPolygons(const QmlObjectListModel& polygons) {

    //    QMetaObject::invokeMethod(qmlEngine->rootObjects().first(), "addPolygon", Q_ARG(QVariant, QVariant::fromValue(polygon)));
        //QMetaObject::invokeMethod(qgcApp()->qmlAppEngine()->rootObjects().first(), "addPolygon", Q_ARG(QVariant, QVariant::fromValue(polygons)));

}

void FlightZoneManager::_init(void){
    qInfo() << "flightZone Manager";



    //processJsonFile(getFilePath());
    //Test
    //fetchGeoJsonData();
    //fetchGeoJsonForCzechRepublic();

    //여기서 한번 변수를 호출해본다.
    //호출 방법 확인 필요함


    // 값을 가져오면 이 값을 어떻게 처리할지 생각 필요함.
    //업데이트 될때마다 계속 새로고침?

    // 알람을 울릴 거리값을 가져오는 코드
    double alarmDistance = _settingsManager->flyViewSettings()->alarmDistance()->rawValue().toDouble();
    qInfo()<< "FlightZoneManager alarmDistance : " << alarmDistance;





    // 읽어올 파일의 타입을 정하는 코드
    //Index 번호를 가져오는 듯함 0 = USB, 1 = Online
    QString dataType = _settingsManager->flyViewSettings()->dataType()->rawValueString();
    qInfo() << "FlightZoneManager dataType : " << dataType;

    // 읽어올 파일의 저장위치를 가져온다
    QString savePath = _settingsManager->flyViewSettings()->filePath()->rawValueString();
    qInfo() << "FlightZoneManger savePath : " << savePath;



    //지도가 움직이는지?




    if(dataType == 0) // USB
    {
        processJsonFile(getFilePath());
    }
    else // Online
    {
        getOnlineGeoJsonData();
    }

}






// 줌 레벨 기반 1픽셀당 거리 계산
double calculateMetersPerPixel(double zoomLevel) {
    return EarthCircumference / (256 * std::pow(2, zoomLevel));
}

void FlightZoneManager::calculateCornerCoordinates(double centerLat, double centerLon, double zoomLevel,double width, double height) {

    QQuickWindow* rootWindow = qgcApp()->mainRootWindow();
    double rootWindowWidth = rootWindow->width();
    double rootWindowHeight = rootWindow->height();
    // if(rootWindow) {
    //     qInfo() << "FlightZoneManager.cpp rootWindow is not null";
    //     qInfo() << "QGCApplication rootWindow width : " << rootWindowWidth;
    //     qInfo() << "QGCApplication rootWindow height : " << rootWindowHeight;
    // }

    // 1픽셀당 거리 계산
    double metersPerPixel = calculateMetersPerPixel(zoomLevel);

    // 위도와 경도 범위 계산
    double latitudeDelta = (rootWindowHeight * metersPerPixel) / 111000.0; // 위도 범위
    double longitudeDelta = (rootWindowWidth * metersPerPixel) / (111000.0 * std::cos(centerLat * M_PI / 180.0)); // 경도 범위

    // double paddingRatio = 0.9; // 90% 영역만 계산
    // double adjustedWidth = rootWindowWidth * paddingRatio;
    // double adjustedHeight = rootWindowHeight * paddingRatio;

    // double latitudeDelta = (adjustedHeight * metersPerPixel) / 111000.0;
    // double longitudeDelta = (adjustedWidth * metersPerPixel) / (111000.0 * std::cos(centerLat * M_PI / 180.0));

    // 꼭짓점 좌표 계산
    double topRightLat = centerLat + (latitudeDelta / 2);
    double topRightLon = centerLon + (longitudeDelta / 2);

    double bottomLeftLat = centerLat - (latitudeDelta / 2);
    double bottomLeftLon = centerLon - (longitudeDelta / 2);
    // qInfo() << "Top-Right : (" << topRightLat << ", " << topRightLon << ")";
    // qInfo() << "Bottom-Left : (" << bottomLeftLat << ", " << bottomLeftLon << ")" ;

    //Draw Line


    // qInfo() << "geoCoordinate : " << geoCoordinate.latitude() << "," << geoCoordinate.longitude();
    // qInfo() << "flightMapPosition : " << qGroundControlQmlGlobal->flightMapPosition().latitude() << "," << qGroundControlQmlGlobal->flightMapPosition().longitude();
    fetchGeoJsonDataForRegion(topRightLat, topRightLon, bottomLeftLat, bottomLeftLon);

}

void FlightZoneManager::getOnlineGeoJsonData() {

    //지도의 현재위치에 따른 지도의 꼭짓점 좌표를 가져온다

    //현재 지도 좌표
    QGeoCoordinate mapCoord = qGroundControlQmlGlobal->flightMapPosition();

    //현재 줌값
    double zoom = qGroundControlQmlGlobal->flightMapZoom();

    //계산식

    double width = 800;
    double height = 600;

    //qInfo() << "calc";

    calculateCornerCoordinates(mapCoord.latitude(), mapCoord.longitude(), zoom, width, height);

    //fetchGeoJsonDataForRegion();
}





//이부분에서 지도의 좌표를 가지고 부분부분 호출하는 계산식이 필요함
void FlightZoneManager::fetchGeoJsonDataForRegion(){
    QString url = "https://api.altitudeangel.com/v2/mapdata/geojson";
    QUrl fullUrl(url);

    double n = 0;
    double e = 0;
    double s = 0;
    double w = 0;

    QUrlQuery query;
    query.addQueryItem("n", QString::number(n)); // 북쪽 위도
    query.addQueryItem("e", QString::number(e)); // 동쪽 경도
    query.addQueryItem("s", QString::number(s)); // 남쪽 위도
    query.addQueryItem("w", QString::number(w)); // 서쪽 경도
    fullUrl.setQuery(query);

    QNetworkRequest request(fullUrl);

    // Add headers
    request.setRawHeader("Authorization", "X-AA-ApiKey laxXQuijuwMUVFCFYcmnuhdDu3K78xI4fUKroC_A0");
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    // Send GET request
    manager->get(request);
}


void FlightZoneManager::test(){

}


