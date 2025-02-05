#ifndef CODEVRTCMMANAGER_H
#define CODEVRTCMMANAGER_H
#include "QGCToolbox.h"
#include "mavlink.h"
#include <QVariant>

class RTCMBase;
class Vehicle;
class LinkInterface;
class CodevRTCMManager : public QGCTool
{
    Q_OBJECT
public:
    Q_PROPERTY(RTCMBase* rtcmSource READ rtcmSource NOTIFY rtcmSourceChanged)
    CodevRTCMManager(QGCApplication *app, QGCToolbox *toolbox);

    RTCMBase* rtcmSource() { return _rtcmSource; }

    // Override from QGCTool
    virtual void setToolbox(QGCToolbox *toolbox);

signals:
    void rtcmSourceChanged();
    void received_gps_raw_int_status(const mavlink_message_t &message);

private slots:
    void _setActiveVehicle(Vehicle* vehicle);
    void _mavlinkReceived(const mavlink_message_t &message);
    void _setRTCMSource(QVariant value);
    void _sendMavlinkRTCM(mavlink_gps_rtcm_data_t message);

private:
    RTCMBase* _rtcmSource{nullptr};
    Vehicle* _vehicle{nullptr};
};

#endif // CODEVRTCMMANAGER_H
