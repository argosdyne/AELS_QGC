#include <sstream>
#include <stdio.h>
#include <stdlib.h>
#include <QJsonObject>
#include <QJsonDocument>
#include <QByteArray>
#include <QFile>
#include <QQuickWindow>
#include "JsonHelper.h"
#include "HttpService.h"
#include "PlanMasterController.h"
#include "QGCApplication.h"
#include "QGCCameraManager.h"
#include "QGCCameraControl.h"
#include "SettingsManager.h"
#include "mDNSManager.h"
#include "MultiVehicleManager.h"
#include "VehicleBatteryFactGroup.h"
#include "PlanMasterController.h"
#include "MissionManager.h"
#include "JsonHelper.h"
#include "SurveyPlanCreator.h"
#include "SurveyComplexItem.h"
#include "SimpleMissionItem.h"
#include "MissionSettingsItem.h"
#include "CameraMetaData.h"

#define COOK_RESULT_CHAR_PTR(str) "\"" + std::string(str) + "\""
#define COOK_RESULT_STRING_VAR(str) "\"" + str + "\""
#define COMMIT_PLAN_STR "/commit/plan"

PlanMasterController* getPlanMasterController()
{
    static PlanMasterController* planMasterController = nullptr;
    if(planMasterController == nullptr) {
        QQuickWindow* root = qgcApp()->mainRootWindow();

        if(root) {
            planMasterController = root->findChild<PlanMasterController*>("PlanViewMasterController");
        }
    }
    return planMasterController;
}

QVariantList getPolygonVertices(const QJsonObject& geometryObject, QString& errorString)
{
    QVariantList coordinates;

    QList<JsonHelper::KeyValidateInfo> keyInfoList = {
        { "type",                 QJsonValue::String, true },
        { "coordinates",          QJsonValue::Array,  true }
    };

    if (JsonHelper::validateKeys(geometryObject, keyInfoList, errorString)) {
        if(geometryObject["type"].toString().compare("Polygon") == 0) {
            QJsonArray array = geometryObject["coordinates"].toArray();
            if(array.count() == 1) {
                QJsonArray coors = array.at(0).toArray();
                foreach(QJsonValue obj, coors) {
                    if(obj.isArray() && obj.toArray().count() >= 2) {
                        double lon = obj.toArray().at(0).toDouble();
                        double lat = obj.toArray().at(1).toDouble();
                        coordinates.append(QVariant::fromValue(QGeoCoordinate(lat, lon)));
                    } else {
                        continue;
                    }
                }
            } else {
                errorString = "The 'Polygon' is not unique";
            }
        } else {
            errorString = "The 'geometry' of GEOJSON must be 'Polygon'";
            qWarning() << errorString;
        }
    } else {
        qWarning() << errorString;
    }

    return coordinates;
}

QFileInfoList get_mission_files() {
    QDir missionDir(qgcApp()->toolbox()->settingsManager()->appSettings()->missionSavePath());
    missionDir.setFilter(QDir::Files | QDir::Hidden | QDir::NoSymLinks);
    missionDir.setSorting(QDir::Name | QDir::Reversed);
    QStringList filters;
    filters << "*.plan";
    missionDir.setNameFilters(filters);

    return missionDir.entryInfoList();
}

HttpService::HttpService(QObject* parent)
    : QObject(parent)
    , _vehicleManager(qgcApp()->toolbox()->multiVehicleManager())
{
    QString name("_http");
    QMap<QByteArray, QByteArray> attributes;
    connect(this, &HttpService::start, this, &HttpService::listen);
    _thread = new QThread(this);
    Server::Handler handler;

    // Test
    _svr.Get("/hi", std::bind(&HttpService::_hello_world, this, std::placeholders::_1, std::placeholders::_2));
    _svr.Get(R"(/numbers/(\d+))", std::bind(&HttpService::_test_number, this, std::placeholders::_1, std::placeholders::_2));
    _svr.Get("/body-header-param", std::bind(&HttpService::_body_header_param, this, std::placeholders::_1, std::placeholders::_2));

    // Integration
    connect(_vehicleManager, &MultiVehicleManager::vehicleAdded, this, &HttpService::_handle_new_vehicle, Qt::DirectConnection);
    _telemetry_thread = std::thread(std::bind(&HttpService::_refresh_telemetry_data, this));
    _svr.Get("/Integration/Planes", std::bind(&HttpService::_get_integration_planes, this, std::placeholders::_1, std::placeholders::_2));
    _svr.Get("/Integration/Routes", std::bind(&HttpService::_get_integration_routes, this, std::placeholders::_1, std::placeholders::_2));
    _svr.Get("/Integration/Videos", std::bind(&HttpService::_get_integration_videos, this, std::placeholders::_1, std::placeholders::_2));
    handler = std::bind(&HttpService::_post_integration_controls_routes, this, std::placeholders::_1, std::placeholders::_2);
    _svr.Post("/Integration/Controls/Routes", handler);
    handler = std::bind(&HttpService::_post_integration_controls_takeoff, this, std::placeholders::_1, std::placeholders::_2);
    _svr.Post("/Integration/Controls/Takeoff", handler);
    handler = std::bind(&HttpService::_post_integration_controls_returntohome, this, std::placeholders::_1, std::placeholders::_2);
    _svr.Post("/Integration/Controls/ReturnToHome", handler);
    handler = std::bind(&HttpService::_post_integration_controls_land, this, std::placeholders::_1, std::placeholders::_2);
    _svr.Post("/Integration/Controls/Land", handler);
    _svr.Get("/Integration/Plane/Telemetry/Stream", std::bind(&HttpService::_get_integration_plane_telemetry_stream, this, std::placeholders::_1, std::placeholders::_2));
    _svr.Get("/Integration/Plane/Telemetry", std::bind(&HttpService::_get_integration_plane_telemetry, this, std::placeholders::_1, std::placeholders::_2));
    _svr.Get("/status", std::bind(&HttpService::_get_active_vehicle_status, this, std::placeholders::_1, std::placeholders::_2));
    handler = std::bind(&HttpService::_post_send_command_to_active, this, std::placeholders::_1, std::placeholders::_2);
    _svr.Post("/command", handler);
    handler = std::bind(&HttpService::_post_mission_to_active_vehicle, this, std::placeholders::_1, std::placeholders::_2);
    _svr.Post("/mission", handler);

    // Other
    handler = std::bind(&HttpService::_post_plan, this, std::placeholders::_1, std::placeholders::_2);
    attributes["Submit Plan"] = COMMIT_PLAN_STR;
//    qgcApp()->toolbox()->mdnsManager()->registerProvider(name, 8080, attributes);
    _svr.Post(COMMIT_PLAN_STR, handler);
    this->moveToThread(_thread);
    _thread->start();
    emit start();
}

HttpService::~HttpService()
{
    _svr.stop();
    _thread->quit();
    _stopped.store(true);
    for (auto& prom : _service_stop_promises) {
        if (auto handle = prom.lock()) {
            handle->set_value();
        }
    }
    for (auto ed : _eds) {
        ed.second->send_event("Stopping");
    }
    _telemetry_thread.join();
}

std::string HttpService::create_result(int result, std::string data, std::string message)
{
    std::stringstream out;
    out << "{"
        << "\"sno\":" << _sno++ << ","
        << "\"result\":" << result << ","
        << "\"data\":" << (data.size() == 0 ? "null" : data);
    if(message.size() != 0) {
    out << ",\"message\":\"" << message << "\"";
    }
    out << "}";
    return out.str();
}

void HttpService::_hello_world(const Request&, Response& res)
{
    res.set_content("Hello World!", "text/plain");
}

void HttpService::_test_number(const Request& req, Response& res)
{
    auto numbers = req.matches[1];
    res.set_content(numbers, "text/plain");
}

void HttpService::_body_header_param(const Request& req, Response& res)
{
    std::string retStr = "no param key";
    if (req.has_header("Content-Length")) {
        auto val = req.get_header_value("Content-Length");
    }
    if (req.has_param("key")) {
        auto val = req.get_param_value("key");
        retStr = val;
    }
    res.set_content(retStr, "text/plain");
}

void HttpService::listen()
{
    _svr.listen("0.0.0.0", 8080);
}

void HttpService::_post_plan(const Request& req, Response& res)
{
    QString errorString;
    QJsonDocument jsonDoc;
    QByteArray bytes(req.body.c_str(), static_cast<int>(req.body.size()));
    if (JsonHelper::isJsonFile(bytes, jsonDoc, errorString)) {
        QJsonObject json = jsonDoc.object();
        int version;
        if (JsonHelper::validateExternalQGCJsonFile(json, PlanMasterController::kPlanFileType, PlanMasterController::kPlanFileVersion, PlanMasterController::kPlanFileVersion, version, errorString)) {
            QList<JsonHelper::KeyValidateInfo> rgKeyInfo = {
                { PlanMasterController::kJsonMissionObjectKey,        QJsonValue::Object, true },
                { PlanMasterController::kJsonGeoFenceObjectKey,       QJsonValue::Object, true },
                { PlanMasterController::kJsonRallyPointsObjectKey,    QJsonValue::Object, true },
            };
            if (JsonHelper::validateKeys(json, rgKeyInfo, errorString)) {
                QString missionPath = qgcApp()->toolbox()->settingsManager()->appSettings()->missionSavePath();
                QString filePath = QDir(missionPath).filePath("http_server_mission.tmp");
                QFile file(filePath);
                if(file.open(QFile::WriteOnly)) {
                    file.write(bytes);
                    file.close();
                    emit pushPlanFilePath(filePath);
                } else {
                    errorString = "Server Error!";
                }
            }
        }
    }
    if(errorString.isEmpty()) {
        res.set_content(create_result(SERVER_RESULT_ACCEPTED, COOK_RESULT_CHAR_PTR("Submitted successfully!")), "application/json");
    } else {
        res.set_content(create_result(SERVER_RESULT_FAILED, COOK_RESULT_STRING_VAR(errorString.toStdString())), "application/json");
    }
}

std::string HttpService::get_mission_from_local(std::string table_raw, std::stringstream& error)
{
    std::stringstream route;
    int index = atoi(table_raw.c_str());
    QFileInfoList infos = get_mission_files();
    if(index >= 0 && infos.count() > index) {
        QFileInfo info = infos.at(index);

        QFile file(info.absoluteFilePath());
        if(file.open(QFile::ReadOnly)) {
            route << file.readAll().toStdString();
        } else {
            error << "Failed to open task file";
        }
    } else {
        error << "No task file found";
    }

    return route.str();
}

void HttpService::_handle_new_vehicle(Vehicle* vehicle)
{
    if(vehicle) {
        _eds[vehicle->id()] = std::make_shared<EventDispatcher>();
    }
}

void HttpService::_refresh_telemetry_data()
{
    while (!_stopped.load()) {
        std::this_thread::sleep_for(std::chrono::seconds(1));
        size_t len = _vehicleManager->vehicles()->count();
        for (size_t i =0; i < len; i ++) {
            auto system = _vehicleManager->vehicles()->value<Vehicle*>(i);
            if(system && _eds.find(system->id()) != _eds.end()) {
                std::stringstream ss;
                ss.precision(10);
                VehicleGPSFactGroup* gps = qobject_cast<VehicleGPSFactGroup*>(system->gpsFactGroup());
                VehicleBatteryFactGroup* battery = qobject_cast<VehicleBatteryFactGroup*>(system->batteries()->get(0));
                auto ed = _eds[system->id()];
                ss << "{"
                   << "\"Timestamp\":" << QDateTime::currentDateTimeUtc().toSecsSinceEpoch() << ","
                   << "\"FlightMode\":" << "\"" << system->flightMode().toStdString() << "\",";
                if(battery) {
                ss << "\"Battery\":" << battery->percentRemaining()->rawValueString().toStdString() << ",";
                }
                ss << "\"Latitude\":" << gps->lat()->rawValueString().toStdString() << ","
                   << "\"Longitude\":" << gps->lon()->rawValueString().toStdString() << ","
                   << "\"Altitude\":" << system->altitudeAMSL()->rawValueString().toStdString() << ","
                   << "\"Yaw\":" << system->heading()->rawValueString().toStdString() << ","
                   << "\"Pitch\":" << system->pitch()->rawValueString().toStdString() << ","
                   << "\"Roll\":" << system->roll()->rawValueString().toStdString() << ","
                   << "\"Speed\":" << system->groundSpeed()->rawValueString().toStdString()
                   << "}";
                ed->send_event(ss.str());
            }
        }
    }
}

void HttpService::_get_integration_planes(const Request&, Response& res)
{
    std::stringstream vehicles;
    size_t len = _vehicleManager->vehicles()->count();
    vehicles << "[";
    for (size_t i =0; i < len; i ++) {
        auto system = _vehicleManager->vehicles()->value<Vehicle*>(i);
        vehicles << static_cast<int>(system->id());
        if(i != len - 1)
            vehicles << ",";
    }
    vehicles << "]";
    res.set_content(create_result(SERVER_RESULT_ACCEPTED, vehicles.str()), "application/json");
}

void HttpService::_get_integration_routes(const Request& req, Response& res)
{
    if(req.has_param("routeID")) {
        auto routeID = req.get_param_value("routeID");
        if(routeID.size() != 0) {
            std::stringstream error;
            std::string resultStr = get_mission_from_local(routeID, error);
            if(error.str().size() == 0) {
                if(resultStr.size() == 0) {
                    res.set_content(create_result(SERVER_RESULT_FAILED, "-2", "Non-existent mission!"), "application/json");
                } else {
                    res.set_content(create_result(SERVER_RESULT_ACCEPTED, resultStr), "application/json");
                }
            } else {
                res.set_content(create_result(SERVER_RESULT_FAILED, COOK_RESULT_STRING_VAR(error.str())), "application/json");
            }
        } else {
            res.set_content(create_result(SERVER_RESULT_DENIED, COOK_RESULT_CHAR_PTR("Arguments Error!")), "application/json");
        }
    } else {
        QFileInfoList missionList = get_mission_files();
        std::stringstream result;
        result << "{";
        size_t len = missionList.size();
        for (size_t i =0; i < len; i ++) {
            result << "\"" << i << "\":\"" << missionList.at(i).fileName().toStdString() << "\"";
            if(i != (len - 1)) {
                result << ",";
            }
        }
        result << "}";
        res.set_content(create_result(SERVER_RESULT_ACCEPTED, result.str()), "application/json");
    }
}

void HttpService::_get_integration_videos(const Request& req, Response& res)
{
    std::stringstream rtsp;
    if(req.has_param("planeID")) {
        auto planeID = req.get_param_value("planeID");
        int id = atoi(planeID.c_str());
        Vehicle* system = _vehicleManager->getVehicleById(id);
        if(system) {
            if(system->cameraManager()->currentCameraInstance()) {
                rtsp << "\"" << system->cameraManager()->currentCameraInstance()->currentStreamInstance()->uri().toStdString() << "\"";
            } else {
                res.set_content(create_result(SERVER_RESULT_FAILED, COOK_RESULT_CHAR_PTR("Non-existent RTSP!")), "application/json");
                return;
            }
        } else {
            res.set_content(create_result(SERVER_RESULT_FAILED, "-1", "Non-existent vehicle!"), "application/json");
            return;
        }
    } else {
        res.set_content(create_result(SERVER_RESULT_DENIED, COOK_RESULT_CHAR_PTR("Arguments Error!")), "application/json");
        return;
    }
    res.set_content(create_result(SERVER_RESULT_ACCEPTED, rtsp.str()), "application/json");
}

void HttpService::_post_integration_controls_routes(const Request& req, Response& res)
{
    if(req.has_param("missionID") && req.has_param("planeID")) {
        auto planeID = req.get_param_value("planeID");
        auto missionID = req.get_param_value("missionID");
        int pid = atoi(planeID.c_str());
        Vehicle* system = _vehicleManager->getVehicleById(pid);
        if(system && system->initialPlanRequestComplete()) {
            std::stringstream error;
            std::string missionResultStr = get_mission_from_local(missionID, error);
            if(error.str().size() == 0) {
                if(missionResultStr.size() == 0) {
                    res.set_content(create_result(SERVER_RESULT_FAILED, "-2", "Non-existent mission!"), "application/json"); //Non-existent mission!
                    return;
                }
            } else {
                res.set_content(create_result(SERVER_RESULT_DENIED, COOK_RESULT_STRING_VAR(error.str())), "application/json");
                return;
            }
            QObject* tmp = new QObject();
            auto stream_closed_promise = std::make_shared<std::promise<void>>();
            auto stream_closed_future = stream_closed_promise->get_future();
            register_stream_stop_promise(stream_closed_promise);
            auto is_finished = std::make_shared<bool>(false);
            auto subscribe_mutex = std::make_shared<std::mutex>();
            int mid = atoi(missionID.c_str());
            connect(system->missionManager(), &MissionManager::sendComplete, tmp, [&stream_closed_promise, is_finished, subscribe_mutex](bool error){
                std::unique_lock<std::mutex> lock(*subscribe_mutex);
                if (!*is_finished) {
                    *is_finished = !error;
                    stream_closed_promise->set_value();
                }
            }, Qt::DirectConnection);
            QMetaObject::invokeMethod(system, "sendPlan",
                                      Q_ARG(QString, get_mission_files().at(mid).absoluteFilePath()));
            stream_closed_future.wait_for(std::chrono::seconds(60));
            unregister_stream_stop_promise(stream_closed_promise);
            disconnect(system->missionManager(), nullptr, tmp, nullptr);
            tmp->deleteLater();
            std::unique_lock<std::mutex> lock(*subscribe_mutex);
            if(!*is_finished) {
                res.set_content(create_result(SERVER_RESULT_FAILED, COOK_RESULT_CHAR_PTR("Mission uploaded failed!")), "application/json");
            } else {
                res.set_content(create_result(SERVER_RESULT_ACCEPTED, "0", "Mission uploaded!"), "application/json");
            }
        } else {
            res.set_content(create_result(SERVER_RESULT_FAILED, "-1", "Non-existent vehicle!"), "application/json"); //Non-existent vehicle!
            return;
        }
    } else {
        res.set_content(create_result(SERVER_RESULT_DENIED, COOK_RESULT_CHAR_PTR("Arguments Error!")), "application/json");
    }
}

void HttpService::_post_integration_controls_takeoff(const Request& req, Response& res)
{
    if(req.has_param("planeID")) {
        auto planeID = req.get_param_value("planeID");
        int id = atoi(planeID.c_str());
        Vehicle* system = _vehicleManager->getVehicleById(id);
        if(system) {
            system->startMission();
            res.set_content(create_result(SERVER_RESULT_ACCEPTED, "0", "Success"), "application/json");
        } else {
            res.set_content(create_result(SERVER_RESULT_FAILED, "-1", "Non-existent vehicle!"), "application/json");
        }
    } else {
        res.set_content(create_result(SERVER_RESULT_DENIED, COOK_RESULT_CHAR_PTR("Arguments Error!")), "application/json");
    }
}

void HttpService::_post_integration_controls_returntohome(const Request& req, Response& res)
{
    if(req.has_param("planeID")) {
        auto planeID = req.get_param_value("planeID");
        int id = atoi(planeID.c_str());
        Vehicle* system = _vehicleManager->getVehicleById(id);
        if(system) {
            system->guidedModeRTL(false);
            res.set_content(create_result(SERVER_RESULT_ACCEPTED, "0", "Success"), "application/json");
        } else {
            res.set_content(create_result(SERVER_RESULT_FAILED, "-1", "Non-existent vehicle!"), "application/json");
        }
    } else {
        res.set_content(create_result(SERVER_RESULT_DENIED, COOK_RESULT_CHAR_PTR("Arguments Error!")), "application/json");
    }
}

void HttpService::_post_integration_controls_land(const Request& req, Response& res)
{
    if(req.has_param("planeID")) {
        auto planeID = req.get_param_value("planeID");
        int id = atoi(planeID.c_str());
        Vehicle* system = _vehicleManager->getVehicleById(id);
        if(system) {
            system->guidedModeLand();
            res.set_content(create_result(SERVER_RESULT_ACCEPTED, "0", "Success"), "application/json");
        } else {
            res.set_content(create_result(SERVER_RESULT_FAILED, "-1", "Non-existent vehicle!"), "application/json");
        }
    } else {
        res.set_content(create_result(SERVER_RESULT_DENIED, COOK_RESULT_CHAR_PTR("Arguments Error!")), "application/json");
    }
}

void HttpService::_get_integration_plane_telemetry_stream(const Request& req, Response& res)
{
    if(req.has_param("planeID")) {
        auto planeID = req.get_param_value("planeID");
        int id = atoi(planeID.c_str());
        if(id > 0 && id < 255 && _eds.find(id) != _eds.end()) {
            auto ed = _eds[id];
            res.set_chunked_content_provider("text/plain",
                                     [ed, this](size_t /*offset*/, DataSink &sink) {
                                        std::stringstream desStr;
                                        ed->wait_event(desStr);
                                        std::string resStr = create_result(SERVER_RESULT_ACCEPTED, desStr.str());
                                        if (sink.is_writable()) {
                                            sink.write(resStr.data(), resStr.size());
                                            return true;
                                        } else {
                                            sink.done();
                                            return false;
                                        }
                                     });
        } else {
            res.set_content(create_result(SERVER_RESULT_FAILED, "-1", "Non-existent vehicle!"), "application/json");
        }
    } else {
        res.set_content(create_result(SERVER_RESULT_DENIED, COOK_RESULT_CHAR_PTR("Arguments Error!")), "application/json");
    }
}

void HttpService::_get_integration_plane_telemetry(const Request& req, Response& res)
{
    if(req.has_param("planeID")) {
        auto planeID = req.get_param_value("planeID");
        int id = atoi(planeID.c_str());
        if(id > 0 && id < 255 && _eds.find(id) != _eds.end()) {
            auto ed = _eds[id];
            std::stringstream desStr;
            ed->wait_event(desStr);
            res.set_content(create_result(SERVER_RESULT_ACCEPTED, desStr.str()), "application/json");
        } else {
            res.set_content(create_result(SERVER_RESULT_FAILED, "-1", "Non-existent vehicle!"), "application/json");
        }
    } else {
        res.set_content(create_result(SERVER_RESULT_DENIED, COOK_RESULT_CHAR_PTR("Arguments Error!")), "application/json");
    }
}

void HttpService::_get_active_vehicle_status(const Request&, Response& res)
{
    if(_eds.size() > 0) {
        auto ed = _eds.begin()->second;
        std::stringstream desStr;
        ed->wait_event(desStr);
        res.set_content(create_result(SERVER_RESULT_ACCEPTED, desStr.str()), "application/json");
    } else {
        res.set_content(create_result(SERVER_RESULT_FAILED, "", "Non-existent vehicle!"), "application/json");
    }
}

void HttpService::_post_send_command_to_active(const Request& req, Response& res)
{
    Vehicle* system = _vehicleManager->getVehicleById(1);
    if(system) {
        QByteArray bodyBuffer(req.body.c_str(), req.body.size());
        QJsonDocument bodyJsonDoc = QJsonDocument::fromJson(bodyBuffer);
        if(bodyJsonDoc.isObject() && bodyJsonDoc.object().contains("tasktype") && bodyJsonDoc.object()["tasktype"].isString()) {
            QString tasktype = bodyJsonDoc.object()["tasktype"].toString();
            if(tasktype.compare("takeoff") == 0) {
                system->startMission();
            } else if(tasktype.compare("return") == 0) {
                system->guidedModeRTL(false);
            } else if(tasktype.compare("land") == 0) {
                system->guidedModeLand();
            } else {
                res.set_content(create_result(SERVER_RESULT_UNSUPPORTED, "", "unsupport " + tasktype.toStdString()), "application/json");
                return;
            }
            res.set_content(create_result(SERVER_RESULT_ACCEPTED, "", "Success"), "application/json");
        } else {
            res.set_content(create_result(SERVER_RESULT_DENIED, "", "Arguments Error!"), "application/json");
        }
    } else {
        res.set_content(create_result(SERVER_RESULT_FAILED, "", "Non-existent vehicle!"), "application/json");
    }
}

void HttpService::_post_mission_to_active_vehicle(const Request& req, Response& res)
{
    Vehicle* system = _vehicleManager->getVehicleById(1);
    if(system) {
        QByteArray bodyBuffer(req.body.c_str(), req.body.size());
        QJsonDocument bodyJsonDoc = QJsonDocument::fromJson(bodyBuffer);
        if(bodyJsonDoc.isObject() && bodyJsonDoc.object().contains("poly") &&
           bodyJsonDoc.object().contains("height") && bodyJsonDoc.object()["poly"].toObject().contains("geometry")) {
            QJsonObject bodyObj = bodyJsonDoc.object();
            QJsonObject geometryObj = bodyObj["poly"].toObject()["geometry"].toObject();
            QString errorString;
            QVariantList initialVertices = getPolygonVertices(geometryObj, errorString);
            if(initialVertices.count() && errorString.isEmpty()) {
                PlanMasterController* controller = getPlanMasterController();
                if(controller) {
                    QMetaObject::invokeMethod(controller->property("planCreators").value<QmlObjectListModel*>()->get(1),
                                              "createPlan", Qt::BlockingQueuedConnection,
                                              Q_ARG(QGeoCoordinate, system->coordinate()));
                    SurveyComplexItem* item = controller->missionController()->visualItems()->value<SurveyComplexItem*>(2);
                    QMetaObject::invokeMethod(item->surveyAreaPolygon(),
                                              "appendVertices", Qt::BlockingQueuedConnection,
                                              Q_ARG(const QVariantList&, initialVertices));
                    item->setWizardMode(false);
                    item->cameraCalc()->setCameraBrand("Yuneec");
                    item->cameraCalc()->setCameraModel("E90");
                    if(bodyObj.contains("angle") && bodyObj["angle"].isDouble()) {
                        auto angle = bodyObj["angle"].toDouble();
                        item->gridAngle()->setRawValue(angle);
                    }
                    if(bodyObj.contains("height") && bodyObj["height"].isDouble()) {
                        auto height = bodyObj["height"].toDouble();
                        item->cameraCalc()->distanceToSurface()->setRawValue(height);
                    }
                    if(bodyObj.contains("overlap") && bodyObj["overlap"].isArray()) {
                        QJsonArray values = bodyObj["overlap"].toArray();
                        if(values.count() == 2) {
                            double frontalOverlap = values.at(0).toDouble();
                            double sideOverlap = values.at(1).toDouble();
                            item->cameraCalc()->frontalOverlap()->setRawValue(frontalOverlap);
                            item->cameraCalc()->sideOverlap()->setRawValue(sideOverlap);
                        }
                    }
                    if(bodyObj.contains("speed") && bodyObj["speed"].isDouble()) {
                        double speed = bodyObj["speed"].toDouble();
                        MissionSettingsItem* missionItem = controller->missionController()->visualItems()->value<MissionSettingsItem*>(0);
                        missionItem->speedSection()->setSpecifyFlightSpeed(true);
                        missionItem->speedSection()->flightSpeed()->setRawValue(speed);
                    }

                    // Waiting for _rebuildTransects
                    {
                        QObject* tmp = new QObject();
                        auto stream_closed_promise = std::make_shared<std::promise<void>>();
                        auto stream_closed_future = stream_closed_promise->get_future();
                        register_stream_stop_promise(stream_closed_promise);
                        connect(item, &SurveyComplexItem::_updateFlightPathSegmentsSignal, tmp, [&stream_closed_promise](){
                            stream_closed_promise->set_value();
                        }, Qt::DirectConnection);
                        stream_closed_future.wait_for(std::chrono::seconds(1));
                        unregister_stream_stop_promise(stream_closed_promise);
                        disconnect(item, nullptr, tmp, nullptr);
                        tmp->deleteLater();
                    }

                    // Waiting for uploading
                    QObject* tmp = new QObject();
                    auto stream_closed_promise = std::make_shared<std::promise<void>>();
                    auto stream_closed_future = stream_closed_promise->get_future();
                    auto subscribe_mutex = std::make_shared<std::mutex>();
                    register_stream_stop_promise(stream_closed_promise);
                    auto is_finished = std::make_shared<bool>(false);
                    connect(system->missionManager(), &MissionManager::sendComplete, tmp, [&stream_closed_promise, is_finished, subscribe_mutex](bool error){
                        std::unique_lock<std::mutex> lock(*subscribe_mutex);
                        if (!*is_finished) {
                            *is_finished = !error;
                            stream_closed_promise->set_value();
                        }
                    }, Qt::DirectConnection);
                    QMetaObject::invokeMethod(controller, "sendToVehicle");
                    stream_closed_future.wait_for(std::chrono::seconds(60));
                    unregister_stream_stop_promise(stream_closed_promise);
                    disconnect(system->missionManager(), nullptr, tmp, nullptr);
                    tmp->deleteLater();
                    std::unique_lock<std::mutex> lock(*subscribe_mutex);
                    if(!*is_finished) {
                        res.set_content(create_result(SERVER_RESULT_FAILED, "", "Mission uploaded failed!"), "application/json");
                    } else {
                        QJsonObject lineObject;
                        lineObject["type"] = QString("LineString");
                        {
                            QJsonArray  missionItemsJsonArray;
                            const QList<MissionItem*> missionItems = system->missionManager()->missionItems();
                            for (const MissionItem* missionItem: missionItems) {
                                QJsonArray missionItemJsonObject;
                                if(qIsNaN(missionItem->param6()) || missionItem->param6() == 0) continue;
                                missionItemJsonObject.append(QJsonValue(missionItem->param6()));
                                missionItemJsonObject.append(QJsonValue(missionItem->param5()));
                                missionItemJsonObject.append(QJsonValue(missionItem->param7()));
                                missionItemsJsonArray.append(missionItemJsonObject);
                            }
                            lineObject["coordinates"] = missionItemsJsonArray;
                        }
                        QJsonDocument document;
                        document.setObject(lineObject);
                        QByteArray byteArray = document.toJson(QJsonDocument::Compact);
                        res.set_content(create_result(SERVER_RESULT_ACCEPTED, byteArray.toStdString(), "Success"), "application/json");
                    }
                } else {
                    res.set_content(create_result(SERVER_RESULT_FAILED, "", "Internal error!"), "application/json");
                }
            } else {
                res.set_content(create_result(SERVER_RESULT_DENIED, "", errorString.toStdString()), "application/json");
            }
        } else {
            res.set_content(create_result(SERVER_RESULT_DENIED, "", "Arguments Error!"), "application/json");
            //res.set_content(create_result(SERVER_RESULT_DENIED, "", "Geojson format is incorrect!"), "application/json");
        }
    } else {
        res.set_content(create_result(SERVER_RESULT_FAILED, "", "Non-existent vehicle!"), "application/json");
    }
}
