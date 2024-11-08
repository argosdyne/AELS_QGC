#include "QGCApplication.h"
#include "CustomCameraManager.h"
#include "CustomCameraControl.h"
#include "LinkManager.h"
#include "UDPLink.h"

#define HOPE_IP_ "192.168.2."

//-----------------------------------------------------------------------------
CustomCameraManager::CustomCameraManager(Vehicle *vehicle)
    : QGCCameraManager(vehicle)
{
    // Fixed Me: E90 need send data to bind it.
    static bool HopeIP = isHopeIP();
    if(HopeIP) {
        QList<SharedLinkInterfacePtr> sharedLinks = qgcApp()->toolbox()->linkManager()->links();
        for (int i=0; i<sharedLinks.count(); i++) {
            LinkInterface* link = sharedLinks[i].get();
            if(link->linkConfiguration()->type() == LinkConfiguration::TypeUdp) {
                int index = vehicle->vehicleLinkManager()->isCommLostLink(link);
                if(index == -1 || index == 0) {
                    UDPConfiguration* config = qobject_cast<UDPConfiguration*>(link->linkConfiguration().get());
                    if(config && config->localPort() == 14550) {
                        QString CameraIP = QString(HOPE_IP_) + "119";
                        config->addHost(CameraIP, 14551);
                    }
                }
            }
        }
    }
}

bool CustomCameraManager::isHopeIP()
{
    QList<QNetworkInterface> interfaces = QNetworkInterface::allInterfaces();
    for(auto it = interfaces.begin(); it != interfaces.end(); it++) {
        // IEEE 802.3 Ethernet interfaces, though on many systems other types of
        // IEEE 802 interfaces may also be detected as Ethernet (especially Wi-Fi).
        if(it->flags() & QNetworkInterface::IsLoopBack) { continue; }
        if(!(it->flags() & QNetworkInterface::IsRunning)) { continue; }
        #if !defined (Q_OS_ANDROID)
        if(!(it->flags() & QNetworkInterface::Ethernet)) { continue; }
        #else
        if(!it->humanReadableName().startsWith("eth0")) { continue; }
        #endif
        QList<QNetworkAddressEntry> entries = it->addressEntries();
        for(auto iter = entries.begin(); iter != entries.end(); iter++) {
            QHostAddress ip = iter->ip();
            QHostAddress mask = iter->netmask();
            if(ip.protocol() !=  QAbstractSocket::IPv4Protocol) { continue; }
            if(ip == QHostAddress::LocalHost) { continue; }
            QString localIP = ip.toString();
            #if !defined (Q_OS_ANDROID)
            if(!(localIP.startsWith(HOPE_IP_))) { continue; }
            #endif
            return true;
        }
    }
    return false;
}

void CustomCameraManager::_mavlinkMessageReceived(const mavlink_message_t& message, LinkInterface* link)
{
    QGCCameraManager::_mavlinkMessageReceived(message, link);
    //-- Only pay attention to camera components, as identified by their compId
    if(message.sysid == _vehicle->id() && (message.compid >= MAV_COMP_ID_CAMERA && message.compid <= MAV_COMP_ID_CAMERA6)) {
        switch (message.msgid) {
        case MAVLINK_MSG_ID_COMMAND_ACK:
            _handleCommandAck(message);
            break;
        default:
            break;
        }
    }
}

void CustomCameraManager::_handleCommandAck(const mavlink_message_t& message)
{
    CustomCameraControl* pCamera = qobject_cast<CustomCameraControl*>(_findCamera(message.compid));
    if(pCamera) {
        mavlink_command_ack_t ack;
        mavlink_msg_command_ack_decode(&message, &ack);
        pCamera->handleCommandAck(ack);
    }
}
