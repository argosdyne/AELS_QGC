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
#include <CGAL/AABB_traits_3.h>
#include <CGAL/AABB_face_graph_triangle_primitive.h>
#include <iostream>
#include <fstream>
#include <cmath>
#include <QDir>

typedef CGAL::Simple_cartesian<double> Kernel;
typedef Kernel::Point_3 Point_3;
typedef CGAL::Polyhedron_3<Kernel> Polyhedron;
typedef CGAL::AABB_face_graph_triangle_primitive<Polyhedron> Primitive;
typedef CGAL::AABB_traits_3<Kernel, Primitive> AABB_traits;
typedef CGAL::AABB_tree<AABB_traits> AABB_tree;

// 지구 둘레 (미터)
double EarthCircumference = 40075017.0;
QGeoCoordinate geoCoordinate;
QList<FlightValidTime> validTimeList;
QList<GeoJsonNameList> geoJsonNameList;


//모든 그룹
QList<QList<NoFlyZone>> allNoFlyZones;

FlightZoneManager::FlightZoneManager() : manager(new QNetworkAccessManager(this))
{
    qInfo() << "FlightZoneManager Start";

    // 이 기능은 USB일때만 사용하는게 좋을듯함 온라인은 어짜피 자동으로 날짜가 바뀌는거 아님? 불러올때마다
    // 0 = USB, 1 = Online

    connect(&_timer, &QTimer::timeout, this, &FlightZoneManager::updatePolygonVisibility);
    _timer.start(1000);

    //testPolyhedronDistance();
    
    connect(manager, &QNetworkAccessManager::finished, this, &FlightZoneManager::onReplyFinished);
    //Start Read GeoJson data from internet

    //Check Zoom Value
    connect(&_zoomTimer, &QTimer::timeout, this, &FlightZoneManager::checkCurrentZoomValue);
    _zoomTimer.start(1000);

    //Check Drone and geoAwareness distance
    connect(&_distanceTimer, &QTimer::timeout, this, &FlightZoneManager::checkDistanceDroneAndGeoAwareness);
    _distanceTimer.start(1000);

    //Update GeoAwareness
    connect(&_updateTimer, &QTimer::timeout, this, &FlightZoneManager::updateGeoAwareness);
    constexpr int dayInterval = 24 * 60 * 60 * 1000;
    _updateTimer.start(dayInterval);

    _toolbox = qgcApp()->toolbox();
    _settingsManager = _toolbox->settingsManager();

    geoCoordinate = qGroundControlQmlGlobal->flightMapPosition();

    qInfo() << "init flightmapPos = " << qGroundControlQmlGlobal->flightMapPosition().latitude() << "," << qGroundControlQmlGlobal->flightMapPosition().longitude();
    qInfo() << "init geoCoord = " << geoCoordinate.latitude() << "," << geoCoordinate.longitude();

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

    // 등록한 드론의 위치를 가져와야함

    // Convert drone's position to Cartesian coordinates
    Point_3 dronePosition = latLonAltToCartesian(droneLat, droneLon, droneAlt);
    std::cout << "Drone position in Cartesian coordinates: "
              << droneLat << ", " << droneLon << ", " << droneAlt << std::endl;

    // Query the distance between the drone's position and the polyhedron
    double distance = std::sqrt(tree.squared_distance(dronePosition)); // distance in meters
    std::cout << "Shortest distance from the drone to the polyhedron is: " << distance << " meters" << std::endl;

}

void FlightZoneManager::checkDistanceDroneAndGeoAwareness(){

#if true
    double alarmDistance = _settingsManager->flyViewSettings()->alarmDistance()->rawValue().toDouble();
    MultiVehicleManager* manager = qgcApp()->toolbox()->multiVehicleManager();
    if(manager){
        if(manager->activeVehicle()){
            if(allNoFlyZones.count() > 0) {
                for(int i = 0; i < allNoFlyZones.count(); i++) {
                    qInfo() << "Group : " << i + 1;
                    std::vector<Point_3> baseVertices; // Bottom
                    std::vector<Point_3> topVertices; //Top
                    Polyhedron P;

                    for(const NoFlyZone& zone: allNoFlyZones[i]){
                        // qInfo() << "  Coordinate:" << zone.coordinate.latitude() << zone.coordinate.longitude()
                        // << "Altitude Range:" << zone.altitudeFloor << "-" << zone.altitudeCeiling;
                        double lat = zone.coordinate.latitude();
                        double lon = zone.coordinate.longitude();
                        double floor = zone.altitudeFloor;
                        double ceiling = zone.altitudeCeiling;

                        if(floor == 0 && ceiling == 0) {
                            floor = 0;
                            ceiling = 100000;
                        }

                        baseVertices.push_back(latLonAltToCartesian(lat,lon,floor));

                        topVertices.push_back(latLonAltToCartesian(lat,lon,ceiling));
                    }

                    if(baseVertices.size() > 0 && topVertices.size() > 0) {
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

                        AABB_tree tree(faces(P).first, faces(P).second, P);
                        tree.accelerate_distance_queries();

                        // Drone's position (lat/lon/alt) for example
                        double droneLat = 0.0;  // Drone's latitude
                        double droneLon = 0.0; // Drone's longitude
                        double droneAlt = 0.0;  // Drone's altitude

                        droneLat = manager->activeVehicle()->latitude();
                        droneLon = manager->activeVehicle()->longitude();
                        droneAlt = manager->activeVehicle()->altitudeAMSL()->rawValue().toDouble();

                        if (std::isnan(droneLat) || std::isnan(droneLon) || std::isnan(droneAlt)) {
                            qWarning() << "Received NaN for vehicle position. Using default values.";
                            droneLat = 0.0; // Default values to handle the NaN case
                            droneLon = 0.0;
                            droneAlt = 0.0;
                        }

                        // 등록한 드론의 위치를 가져와야함

                        // Convert drone's position to Cartesian coordinates
                        Point_3 dronePosition = latLonAltToCartesian(droneLat, droneLon, droneAlt);

                        // Query the distance between the drone's position and the polyhedron
                        double distance = std::sqrt(tree.squared_distance(dronePosition)); // distance in meters
                        std::cout << "Shortest distance from the drone to the polyhedron is: " << distance << " meters" << std::endl;

                        if(distance <= alarmDistance) // 지정한 거리값 안에 들어오면 알람을 띄워야됨
                        {
                            //qInfo() << "Inside Index = " << i;
                            QString msg = tr("The distance between the aircraft and GeoAwareness is close. Distance : %1M").arg(distance);
                            //qgcApp()->showAppMessage(msg);
                            qgcApp()->showGeoAwarenessAlertMessage(msg, i);
                        }
                        else {
                            //qInfo() << "FlightZoneManager Close AlertMessage Popup Index = " << i;
                            qgcApp()->closeGeoAwarenessAlertMessage(i);
                        }
                    }
                }
            }
        }
    }
#endif
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
    validTimeList.clear();
    allNoFlyZones.clear();
}

void FlightZoneManager::updateGeoAwareness(){
    QString dataType = _settingsManager->flyViewSettings()->dataType()->rawValueString();
    // Only for online
    if(dataType == "1"){
        if(_polygons.count() > 0) {
            removeAll();
            qInfo() << "updateGeoAwareness";
            _init();
        }
    }
}
void FlightZoneManager::checkCurrentZoomValue() {

    double zoom = qGroundControlQmlGlobal->flightMapZoom();

    //내가 있는 지도의 가운데 좌표
    QGeoCoordinate mapCoord = qGroundControlQmlGlobal->flightMapPosition();
    QString dataType = _settingsManager->flyViewSettings()->dataType()->rawValueString();
    //  가운데 좌표, zoom값

    //qInfo() << "lat : " << mapCoord.latitude() << "lon : " << mapCoord.longitude();

    //dataType으로 비교를 해서 USB는 줌결과 상관없이 그냥 불러오게?
    //0 = USB, 1 = Online

    if(dataType == "0")
    {
        if(_polygons.count() == 0) { // 이미 생성되어 있음

            //왜 여러번 실행되는지 확인필요
            qInfo()<< "init polygons";
            geoCoordinate = qGroundControlQmlGlobal->flightMapPosition();
            _init();
        }
    }
    else {
        if(zoom >= 12)  { // 테스트용으로 8 원래는 13
            qInfo() << "FlightMap zoom Over 12: " << qGroundControlQmlGlobal->flightMapZoom();
            // 메소드를 한번만 실행시켜야됨
            // 없으면 생성. 있으면 생성 안해야됨. 조건은 추가 필요.
            if(_polygons.count() == 0) { // 이미 생성되어 있음

                //왜 여러번 실행되는지 확인필요
                qInfo()<< "init polygons";
                geoCoordinate = qGroundControlQmlGlobal->flightMapPosition();
                _init();
            }
            // 여기서 화면 이동시 조건도 추가 필요함
            if(qGroundControlQmlGlobal->flightMapPosition() != geoCoordinate) // 위치가 바뀌면
            {
                // if(_polygons.count() > 0){                // 위치 새로고침 후 생성
                //     //removeAll();
                //     QGeoCoordinate flightmapPos = qGroundControlQmlGlobal->flightMapPosition();
                //     QGeoCoordinate geoCoord = geoCoordinate;
                //     // qInfo() << "flightmapPos = " << flightmapPos.latitude() << "," << flightmapPos.longitude();
                //     // qInfo() << "geoCoord = " << geoCoordinate.latitude() << "," << geoCoordinate.longitude();
                //     //드론의 로딩이 다 끝나면 불러와야할듯함
                //     geoCoordinate = qGroundControlQmlGlobal->flightMapPosition();
                //     _init();
                // }
                // 아니면 이렇게 하지말고 불러오는 범위를 좀만 늘리는식? 생각해보면 나라 전체나, 도 전체를 가져와봤자 비행은 다 못함. 내가 보고 있는 화면 근방으로 해서 보여주는식으로 하는게 좋을듯함. 범위만 좀 늘려서
            }
        }
        else if(zoom < 11){
            qInfo() << "FlightMap zoom less 10: " << qGroundControlQmlGlobal->flightMapZoom();
            // 생성된거 전부 삭제
            removeAll();
        }
    }

//드론 정보 가져오는 부분 테스트

// 이거는 qgc를 킨 위치인듯함
#if false
    if(qgcpositionManager) {
        qInfo() << "qgcpositionManager is not null";
        QGeoCoordinate gcsPosition = qgcApp()->toolbox()->qgcPositionManager()->gcsPosition();

        qInfo() << "gcsPosition = " << gcsPosition.latitude() << "," << gcsPosition.longitude() << "," << gcsPosition.altitude();
    }
    else {
        qInfo() << "qgcpositionManager is null";
    }
#endif
}

// 화면 이동 시

void FlightZoneManager::updatePolygonVisibility() {

    // validTimeList valid_from과 valid_to는 이 리스트에 저장되어 있음

    // 읽어온 파일과 현재 시간과 비교
    // 만약 validto를 넘으면 넘은 polygon을 삭제
    // 만약 validfrom 시간에 들어오면 그 들어온 polygon을 생성

    // 현재 시간
    QDateTime currentTime = QDateTime::currentDateTime();

    QString dataType = _settingsManager->flyViewSettings()->dataType()->rawValueString();

    //USB일때만 동작하도록.
    if(dataType == "0"){
        for(int i = 0; i < validTimeList.size(); ++i){
            auto& timeData = validTimeList[i];

            QDateTime validFrom = timeData.validFrom;
            QDateTime validTo = timeData.validTo;
            //qInfo() << timeData.polygonid;
            //qInfo() << "currentTime : " << currentTime <<"validFrom : " << validFrom << "validTo : " << validTo;

            // 유효기간을 넘었으면 Polygon 삭제
            // 아직 보여주는 시간이 안되었어도 Polygon 삭제
            if(currentTime > validTo) {
                qInfo() << "Delete Index : " << i;
                deletePolygon(i);
                validTimeList.removeAt(i);
                --i;
                timeData.isCreated = false;
                qInfo() << "After Delete Polygon count: " << _polygons.count();
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

    //qInfo() << "features count" << features.count();
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
        double altitudeFloor = properties.value("altitudeFloor").toDouble();
        double altitudeCeiling = properties.value("altitudeCeiling").toDouble();

        // qInfo() << "altitudeFloor = " << altitudeFloor;
        // qInfo() << "altitudeCeiling = " << altitudeCeiling;

        QDateTime validFromDateTime = QDateTime::fromString(validFrom, "yyyy-MM-dd HH:mm:ss");
        QDateTime validToDateTime = QDateTime::fromString(validTo, "yyyy-MM-dd HH:mm:ss");



        QGCFencePolygon* polygon = new QGCFencePolygon(false /* inclusion */, this); // true = not fill , false = fill
        QList<NoFlyZone> noFlyZone;
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

                if(validFrom != "" && validTo != ""){
                    polygon->appendVertex(coordinate);
                    noFlyZone.append(NoFlyZone(QGeoCoordinate(lat, lon), altitudeFloor, altitudeCeiling));

                    qInfo() << "polygon count = " << polygon->count();
                }
            }
        }

        if(validFrom != "" && validTo != "") {



            // Set polygon color based on zone type
            if (zoneType == "Excluded") {
                polygon->setcolorInclusion("red");
            } else if (zoneType == "Restricted") {
                polygon->setcolorInclusion("yellow");
            } else if(zoneType == "Facilitated"){
                polygon->setcolorInclusion("green");
            } else {
                polygon->setcolorInclusion("blue"); // Default color
            }

            polygon->setstrokeOpacity(0.5);

            // validFrom 시간과 현재 시간을 비교
            if (currentTime < validFromDateTime) {
                qInfo() << "Polygon is not yet valid. Skipping. validFromDateTime : " << validFromDateTime << "," << validToDateTime;
                validTimeList.append(FlightValidTime(polygonid, validFromDateTime, validToDateTime, false));
                continue; // 유효하지 않으면 건너뛴다.
            }
            else {
                qInfo() << "Polygon valid. Skipping. validToDateTime" << validFromDateTime << "," << validToDateTime;
                validTimeList.append(FlightValidTime(polygonid, validFromDateTime, validToDateTime, true));
            }
            // if(currentTime > validToDateTime) // 현재시간이 목표시간을 넘으면 표시를 해줄 이유가 없으므로.
            // {
            //     qInfo() << "Polygon is not yet valid. Skipping.";
            //     continue;
            // }


            // Add the completed polygon to the polygons list
            if(!_polygons.contains(polygon)){
                _polygons.append(polygon);
            }

            if(!allNoFlyZones.contains(noFlyZone)){
                allNoFlyZones.append(noFlyZone);
            }
        }

        qInfo() << "allNoFlyZones Count = " <<allNoFlyZones.count();


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

    //qInfo() << "features count:" << features.count();
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
        QString strokeOpacity = properties.value("strokeOpacity").toString();

        // 유효 시간 표시
        QJsonObject airac = properties.value("airac").toObject();
        QString operationalFrom = airac.value("from").toString();
        QString operationalTo = airac.value("to").toString();

        // altitudeCeiling 및 altitudeFloor 값 가져오기
        QJsonObject altitudeCeiling = properties.value("altitudeCeiling").toObject();
        double ceilingMeters = altitudeCeiling.value("meters").toDouble();

        QJsonObject altitudeFloor = properties.value("altitudeFloor").toObject();
        double floorMeters = altitudeFloor.value("meters").toDouble();




        QDateTime validFrom = QDateTime::fromString(operationalFrom, "yyyy-MM-dd");
        QDateTime validTo = QDateTime::fromString(operationalTo, "yyyy-MM-dd");

        // geometry의 타입 확인 (Polygon 또는 Point)
        QString geometryType = geometry.value("type").toString();
        QGCFencePolygon* polygon = new QGCFencePolygon(false /* inclusion */, this); // true = not fill , false = fill
        QList<NoFlyZone> noFlyZone;
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



                    // if(category == "airspace"){
                    //     if(geoJsonNameList.count() == 0) // 아무것도 없으면 추가해야함. 추가할때는 중복체크해서
                    //     {
                    //         qInfo() << "geoJsonNameList count = 0";
                    //         geoJsonNameList.append(GeoJsonNameList(name));
                    //     }

                    //     if(!geoJsonNameList.contains(GeoJsonNameList(name))) //객체가 없으면
                    //     {
                    //         geoJsonNameList.append(GeoJsonNameList(name));

                    //         qInfo() << "geoJsonNameList Count : " << geoJsonNameList.count();

                    //     }
                    //     //현재 날짜가 validTo를 넘으면 결국에는 유효기간이 지난거니까 그 부분은 리스트에 안넣도록 한다.
                    //     polygon->appendVertex(coordinate);

                    //     // qInfo() << "altitudeCeiling : " << ceilingMeters;
                    //     // qInfo() << "altitudeFloor : " << floorMeters;

                    //     // list에 바닥 높이와 천장 높이를 추가
                    //     noFlyZones.append(NoFlyZone(QGeoCoordinate(lat, lon), floorMeters, ceilingMeters));

                    //     //qInfo() << "Properties JSON:" << QString(QJsonDocument(properties).toJson(QJsonDocument::Compact));
                    // }

                    if (currentTime < validTo) {
                        if (geoJsonNameList.count() == 0) // 아무것도 없으면 추가해야함. 추가할때는 중복체크해서
                        {
                            qInfo() << "geoJsonNameList count = 0";
                            geoJsonNameList.append(name);
                        }

                        if (!geoJsonNameList.contains(name)) //객체가 없으면
                        {
                            geoJsonNameList.append(GeoJsonNameList(name));

                            qInfo() << "geoJsonNameList Count : " << geoJsonNameList.count();

                        }
                        else {
                            //현재 날짜가 validTo를 넘으면 결국에는 유효기간이 지난거니까 그 부분은 리스트에 안넣도록 한다.
                            polygon->appendVertex(coordinate);

                            noFlyZone.append(NoFlyZone(QGeoCoordinate(lat, lon), floorMeters, ceilingMeters));
                        }
                    }

                }
            }

            // Add to polygon list
            if(currentTime < validTo){
                if(!_polygons.contains(polygon)){
                    _polygons.append(polygon);
                }

                if(!allNoFlyZones.contains(noFlyZone)){
                    allNoFlyZones.append(noFlyZone);
                }
                // Add to polygon list
                if(currentTime < validTo){




                    qInfo() << "allNoFlyZones Count = " <<allNoFlyZones.count();


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
                        //qInfo()<<"geometryType Point = "<< lat << ", " << lon;
                        //polygon->appendVertex(coordinate);
                    }
                }
            }

            //if(category != "airspace" && geometryType != "Point" ) {
            if(geometryType != "Point") {
                qInfo() << "geometryType: " << geometryType;
                qInfo() << "Feature ID:" << polygonid;
                qInfo() << "Name:" << name;
                qInfo() << "Category:" << category;

                qInfo() << "operationFrom" << operationalFrom;
                qInfo() << "operationTo" << operationalTo;
                qInfo() << "strokeColor" << strokeColor;
                qInfo() << "strokeOpacity" << strokeOpacity;

                qInfo() << "altitudeCeiling : " << ceilingMeters;
                qInfo() << "altitudeFloor : " << floorMeters;

                polygon->setcolorInclusion(strokeColor);
                polygon->setstrokeOpacity(strokeOpacity.toDouble());

                //중복 대비. list에도 이름을 넣는다. 만약 이름이 똑같으면 그거는 list에 안넣는거로 한다.
            }

        }

        qInfo() << "Processing complete. Total polygons:" << _polygons.count();
    }
}

void FlightZoneManager::_init(void){
    qInfo() << "flightZone Manager";

    // 알람을 울릴 거리값을 가져오는 코드
    double alarmDistance = _settingsManager->flyViewSettings()->alarmDistance()->rawValue().toDouble();
    qInfo()<< "FlightZoneManager alarmDistance : " << alarmDistance;

    // 읽어올 파일의 타입을 정하는 코드
    //Index 번호를 가져오는 듯함 0 = USB, 1 = Online
    QString dataType = _settingsManager->flyViewSettings()->dataType()->rawValueString();
    //qInfo() << "FlightZoneManager dataType : " << dataType;

    // 읽어올 파일의 저장위치를 가져온다
    QString savePath = _settingsManager->flyViewSettings()->filePath()->rawValueString();
    qInfo() << "FlightZoneManger savePath : " << savePath;

    if(dataType == "0") // USB
    {
        qInfo() << "Make with USB dataType = " << dataType;
        processJsonFile(getFilePath());
    }
    else // Online
    {
        qInfo() << "Make with Online dataType = " << dataType;
        getOnlineGeoJsonData();
    }
}

// 줌 레벨 기반 1픽셀당 거리 계산
double calculateMetersPerPixel(double zoomLevel) {
    return EarthCircumference / (256 * std::pow(2, zoomLevel));
}

void FlightZoneManager::calculateCornerCoordinates(double centerLat, double centerLon, double zoomLevel,double width, double height) {

    // 1픽셀당 거리 계산
    double metersPerPixel = calculateMetersPerPixel(zoomLevel);

    // 위도와 경도 범위 계산
    double latitudeDelta = (width * metersPerPixel) / 111000.0; // 위도 범위
    double longitudeDelta = (height * metersPerPixel) / (111000.0 * std::cos(centerLat * M_PI / 180.0)); // 경도 범위

    // 꼭짓점 좌표 계산
    double topRightLat = centerLat + (latitudeDelta / 2);
    double topRightLon = centerLon + (longitudeDelta / 2);

    double bottomLeftLat = centerLat - (latitudeDelta / 2);
    double bottomLeftLon = centerLon - (longitudeDelta / 2);

    //Draw Line
    fetchGeoJsonDataForRegion(topRightLat, topRightLon, bottomLeftLat, bottomLeftLon);

}

void FlightZoneManager::getOnlineGeoJsonData() {

    //지도의 현재위치에 따른 지도의 꼭짓점 좌표를 가져온다

    //현재 지도 좌표
    QGeoCoordinate mapCoord = qGroundControlQmlGlobal->flightMapPosition();

    //현재 줌값
    double zoom = qGroundControlQmlGlobal->flightMapZoom();

    //계산식

    QQuickWindow* rootWindow = qgcApp()->mainRootWindow();
    double rootWindowWidth = rootWindow->width();
    double rootWindowHeight = rootWindow->height();

    calculateCornerCoordinates(mapCoord.latitude(), mapCoord.longitude(), zoom, rootWindowWidth, rootWindowHeight);
}

