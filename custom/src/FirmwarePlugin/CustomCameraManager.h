#pragma once

#include "QGCCameraManager.h"

//-----------------------------------------------------------------------------
class CustomCameraManager : public QGCCameraManager
{
    Q_OBJECT
public:
    CustomCameraManager(Vehicle* vehicle);
    bool isHopeIP();

private:
    void _handleCommandAck(const mavlink_message_t& message);

protected slots:
    void _mavlinkMessageReceived(const mavlink_message_t& message, LinkInterface* link) final;
};
