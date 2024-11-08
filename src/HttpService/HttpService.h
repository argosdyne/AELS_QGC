#pragma once
#include <QObject>
#include <iostream>
#include <future>
#include <condition_variable>
#include <QThread>
#include "cpp-httplib/httplib.h"

using namespace httplib;
class Vehicle;
class MultiVehicleManager;
class EventDispatcher
{
public:
    EventDispatcher() {}
    ~EventDispatcher() {}

    void wait_event(std::stringstream& stream) {
        std::unique_lock<std::mutex> lk(m_);
        int id = id_;
        cv_.wait(lk, [&] { return cid_ == id; });
        stream << message_;
    }

    void wait_event(DataSink *sink) {
        std::unique_lock<std::mutex> lk(m_);
        int id = id_;
        cv_.wait(lk, [&] { return cid_ == id; });
        if (sink->is_writable()) { sink->write(message_.data(), message_.size()); }
    }

    void send_event(const std::string &message) {
        std::lock_guard<std::mutex> lk(m_);
        cid_ = id_++;
        message_ = message;
        cv_.notify_all();
    }

private:
    std::atomic_bool stopped_{false};
    std::mutex m_;
    std::condition_variable cv_;
    std::atomic_int id_{0};
    std::atomic_int cid_{-1};
    std::string message_;
};

class HttpService : public QObject
{
    Q_OBJECT
public:
    typedef enum {
        SERVER_RESULT_ACCEPTED=0, /* Command is valid (is supported and has valid parameters), and was executed. | */
        SERVER_RESULT_TEMPORARILY_REJECTED=1, /* Command is valid, but cannot be executed at this time. This is used to indicate a problem that should be fixed just by waiting (e.g. a state machine is busy, can't arm because have not got GPS lock, etc.). Retrying later should work. | */
        SERVER_RESULT_DENIED=2, /* Command is invalid (is supported but has invalid parameters). Retrying same command and parameters will not work. | */
        SERVER_RESULT_UNSUPPORTED=3, /* Command is not supported (unknown). | */
        SERVER_RESULT_FAILED=4, /* Command is valid, but execution has failed. This is used to indicate any non-temporary or unexpected problem, i.e. any problem that must be fixed before the command can succeed/be retried. For example, attempting to write a file when out of memory, attempting to arm when sensors are not calibrated, etc. | */
        SERVER_RESULT_IN_PROGRESS=5, /* Command is valid and is being executed. This will be followed by further progress updates, i.e. the component may send further COMMAND_ACK messages with result SERVER_RESULT_IN_PROGRESS (at a rate decided by the implementation), and must terminate by sending a COMMAND_ACK message with final result of the operation. The COMMAND_ACK.progress field can be used to indicate the progress of the operation. | */
        SERVER_RESULT_CANCELLED=6, /* Command has been cancelled (as a result of receiving a COMMAND_CANCEL message). | */
        SERVER_RESULT_ENUM_END=7, /*  | */
    } SERVER_RESULT;

    HttpService(QObject* parent = nullptr);
    ~HttpService();

signals:
    void start();
    void pushPlanFilePath(QString path);

private slots:
    void _handle_new_vehicle(Vehicle* vehicle);
    void listen();

private:
    std::atomic_uint16_t _sno{0};
    std::string create_result(int result, std::string data, std::string message = "");

    std::atomic<bool> _stopped{false};
    std::vector<std::weak_ptr<std::promise<void>>> _service_stop_promises{};
    void register_stream_stop_promise(std::weak_ptr<std::promise<void>> prom) {
        // If we have already stopped, set promise immediately and don't add it to list.
        if (_stopped.load()) {
            if (auto handle = prom.lock()) {
                handle->set_value();
            }
        } else {
            _service_stop_promises.push_back(prom);
        }
    }
    void unregister_stream_stop_promise(std::shared_ptr<std::promise<void>> prom) {
        for (auto it = _service_stop_promises.begin(); it != _service_stop_promises.end();
             /* ++it */) {
            if (it->lock() == prom) {
                it = _service_stop_promises.erase(it);
            } else {
                ++it;
            }
        }
    }

    void _hello_world(const Request&, Response&);
    void _test_number(const Request&, Response&);
    void _body_header_param(const Request&, Response&);

    void _post_plan(const Request&, Response&);

    std::string get_mission_from_local(std::string table_row, std::stringstream& error);
    void _refresh_telemetry_data();
    void _get_integration_planes(const Request&, Response&);
    void _get_integration_routes(const Request&, Response&);
    void _get_integration_videos(const Request&, Response&);
    void _post_integration_controls_routes(const Request&, Response&);
    void _post_integration_controls_takeoff(const Request&, Response&);
    void _post_integration_controls_returntohome(const Request&, Response&);
    void _post_integration_controls_land(const Request&, Response&);
    void _get_integration_plane_telemetry_stream(const Request&, Response&);
    void _get_integration_plane_telemetry(const Request&, Response&);
    void _get_active_vehicle_status(const Request&, Response&);
    void _post_send_command_to_active(const Request&, Response&);
    void _post_mission_to_active_vehicle(const Request&, Response&);
    std::thread _telemetry_thread;
    MultiVehicleManager* _vehicleManager{nullptr};

    Server _svr;
    std::map<int, std::shared_ptr<EventDispatcher>> _eds;

    QThread* _thread{nullptr};
};
