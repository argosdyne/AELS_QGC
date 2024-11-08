#include "TeamModeRouter.h"
#include "MAVLinkProtocol.h"
#include "MultiVehicleManager.h"
#include <QNetworkProxy>
#include <QNetworkInterface>
#include "CustomPlugin.h"
#include "CustomSettings.h"
#include "QGCCameraManager.h"
//#include "CustomCameraControl.h"
#include "QGCApplication.h"
#include "SettingsManager.h"
#include "AppSettings.h"
#include "VideoManager.h"
#if defined(QGC_GST_STREAMING)
#include "CustomVideoReceiver.h"
#endif
#include "CustomQmlInterface.h"
#include "ParameterManager.h"
#if defined(ENABLE_WIFI_P2P)
#include <jni.h>
#include <QtAndroidExtras/QtAndroidExtras>
#include <QtAndroidExtras/QAndroidJniObject>
static const char jniClassName[] {"com/codev/flydynamic/QGCActivity"};
#endif


static SessionTarget* contains_target(QmlObjectListModel& list, const QHostAddress& address, quint16 port)
{
	for(int i = 0; i < list.count(); i++) {
		SessionTarget* target = list.value<SessionTarget*>(i);
		if(target->address() == address && target->port() == port) {
			return target;
		}
	}
	return nullptr;
}

static SessionTarget* valid_target(QmlObjectListModel& list)
{
	for(int i = 0; i < list.count(); i++) {
		SessionTarget* target = list.value<SessionTarget*>(i);
		if(target->enable() && target->connected()) {
			return target;
		}
	}
	return nullptr;
}

TeamModeRouter::TeamModeRouter(MAVLinkProtocol* protocol, MultiVehicleManager* manager, QObject* parent)
	: QObject(parent)
	, _teamModeFact(qobject_cast<CustomPlugin*>(qgcApp()->toolbox()->corePlugin())->settings()->teamMode())
	, _protocol(protocol)
	, _vehicleManager(manager)
{
#if defined(ENABLE_WIFI_P2P)
    QAndroidJniObject::callStaticMethod<void>(jniClassName, "setJniInitTeamMode", "()V");
#endif
	qRegisterMetaType<SessionTarget*>("SessionTarget*");
    connect(_protocol, &MAVLinkProtocol::messageReceived, this, &TeamModeRouter::_handleMessageReceived);
	//connect(_protocol, &MAVLinkProtocol::messageReceivedWithBadCrc, this, &TeamModeRouter::receivedBadCrcFromProtocol);
	connect(this, &TeamModeRouter::receivedFromSlave, this, &TeamModeRouter::_handleFromSlave);
	connect(this, &TeamModeRouter::start, this, &TeamModeRouter::_handleStart);
	connect(this, &TeamModeRouter::stop, this, &TeamModeRouter::_handleStop);
	connect(this, &TeamModeRouter::p2pConnectedChanaged, this, &TeamModeRouter::localIPChanaged);

	_bindTimer.setInterval(2000);
	_bindTimer.setSingleShot(false);
	connect(&_bindTimer, &QTimer::timeout, this, &TeamModeRouter::_bindTimeout);

	_p2pConnectionTiemOutTimer.setSingleShot(true);
	connect(&_p2pConnectionTiemOutTimer, &QTimer::timeout, this, [this]() {
		if(_isPairing) {
			_isPairing = false;
			emit pairingChanaged();
			emit pairingTimeout();
			startP2PScan();
		}
	});

	_slaveChannelsTimer.setSingleShot(true);
	_slaveChannelsTimer.setInterval(3000);
	connect(&_slaveChannelsTimer, &QTimer::timeout, this, [this]() {
		_enableSlaveChannels = false;
	});

	connect(&_scanP2pDeviceTimer, &QTimer::timeout, this, &TeamModeRouter::_scanP2pDevice);
}

TeamModeRouter::~TeamModeRouter()
{
	_videoReceiver = nullptr;
	_thermalVideoReceiver = nullptr;
	_handleStop();
}

#if defined(ENABLE_WIFI_P2P)
void TeamModeRouter::reset_jni()
{
    QAndroidJniEnvironment env;
    if (env->ExceptionCheck()) {
        env->ExceptionDescribe();
        env->ExceptionClear();
    }
}
#endif

void TeamModeRouter::mergeSlaveChannels(quint16* out)
{
	if(_enableSlaveChannels) {
		out[8] = _slave_channels.chan9_raw;     //8 Gimbal Pitch
		out[9] = _slave_channels.chan10_raw;    //9 Gimbal Yaw
		out[10] = _slave_channels.chan11_raw;   //10 Gimbal Zoom
		out[11] = _slave_channels.chan12_raw;   //11 Camera Takephoto
		out[12] = _slave_channels.chan13_raw;   //12 Camera Video
	}
}

void TeamModeRouter::clearConnections()
{
	_bindTimer.stop();
	_isBind = true;
	_isPairing = false;
	emit pairingChanaged();
	_currentEntry = QNetworkAddressEntry();
	QMutexLocker locker(&_sessionTargetsMutex);
	_sessionTargets.clearAndDeleteContents();
	emit connectedChanaged();
}

void TeamModeRouter::connectTo(QObject* object)
{
	if(_bindTimer.isActive()) { return; }
	if(_sessionTargets.contains(object)) {
		qobject_cast<SessionTarget*>(object)->setEnable(true);
		_isBind = true;
		_isPairing = true;
		_bindRetries = -1;
		//_bindTimeout();
		_bindTimer.start();
		if(_teamModeFact->rawValue().toInt() == 1) {
			emit pairingChanaged();
		}
	}
}

void TeamModeRouter::disconnectTo(QObject* object)
{
	if(_bindTimer.isActive()) { return; }
	if(_sessionTargets.contains(object)) {
		SessionTarget* client = qobject_cast<SessionTarget*>(object);
		if(client->connected()) {
			_isBind = false;
			_isPairing = true;
			_bindRetries = -1;
			//_bindTimeout();
			_bindTimer.start();
			emit pairingChanaged();
		} else {
			client->setEnable(false);
		}
	}
}

void TeamModeRouter::startP2PScan(int delay)
{
	_p2pDevices.clearAndDeleteContents();
	_scanP2pEnabled  = true;
	if(delay) {
		QTimer::singleShot(delay, this, &TeamModeRouter::_scanP2pDevice);
	} else {
		_scanP2pDevice();
	}
	_scanP2pDeviceTimer.stop();
	_scanP2pDeviceTimer.setSingleShot(false);
	_scanP2pDeviceTimer.start(20000);
}

void TeamModeRouter::stopP2PScan()
{
#if defined(ENABLE_WIFI_P2P)
    TeamModeRouter::reset_jni();
    QAndroidJniObject::callStaticMethod<void>(jniClassName, "stopTeamSearch", "()V");
#endif
	_scanP2pDeviceTimer.stop();
	_scanP2pEnabled = false;
	_scanningDevice = false;
	emit scanningDeviceChanged();
}

void TeamModeRouter::connectP2PDevice(QString address)
{
	_p2pDevices.clearAndDeleteContents();
	_isPairing = true;
	emit pairingChanaged();
#if defined(ENABLE_WIFI_P2P)
	TeamModeRouter::reset_jni();
	QAndroidJniObject javaAddress = QAndroidJniObject::fromString(address);
	QAndroidJniObject::callStaticMethod<void>(jniClassName, "connectTeamDevice", "(Ljava/lang/String;)V",
			javaAddress.object<jstring>());
	_p2pConnectionTiemOutTimer.start(40000);
#endif
}

void TeamModeRouter::disconnectP2PDevice()
{
#if defined(ENABLE_WIFI_P2P)
	TeamModeRouter::reset_jni();
	QAndroidJniObject::callStaticMethod<void>(jniClassName, "disconnectTeamDevice", "()V");
	_p2pDevices.clearAndDeleteContents();
	_isPairing = true;
	emit pairingChanaged();
	QTimer::singleShot(5000, this, [this]() {
		if(_isPairing) {
			_isPairing = false;
			emit pairingChanaged();
			emit pairingTimeout();
		}
	});
#endif
}

void TeamModeRouter::_scanP2pDevice()
{
#if defined(ENABLE_WIFI_P2P)
	TeamModeRouter::reset_jni();
	QAndroidJniObject::callStaticMethod<void>(jniClassName, "startTeamSearch", "()V");
	_scanningDevice = true;
	emit scanningDeviceChanged();
#endif
}

void TeamModeRouter::newP2PDevices(QStringList devices)
{
#if defined(ENABLE_WIFI_P2P)
    _p2pDevices.clearAndDeleteContents();
    _p2pDevices.beginReset();
    foreach(QString device, devices) {
        QStringList values = device.split(';');
        if(values.count() == 2) {
            QString name = values.at(0);
            QString address = values.at(1);
            P2PDevice* deviceItem = new P2PDevice(name, address);
            _p2pDevices.append(deviceItem);
        }
    }
    _p2pDevices.endReset();
    _scanningDevice = false;
    emit scanningDeviceChanged();
    if(_scanP2pEnabled) {
        _scanP2pDeviceTimer.stop();
        QTimer::singleShot(1000, this, &TeamModeRouter::_scanP2pDevice);
        _scanP2pDeviceTimer.setSingleShot(true);
        _scanP2pDeviceTimer.start(20000);
    }
#endif
}

void TeamModeRouter::p2pConnectStateChanged(int state)
{
	if(state == 1) { // disconnected
		setP2pConnected(false);
		_isPairing = false;
		emit pairingChanaged();
		_p2pConnectionTiemOutTimer.stop();
	} else if(state == 2) { // connected
		setP2pConnected(true);
		stopP2PScan();
		_isPairing = false;
		emit pairingChanaged();
		_p2pConnectionTiemOutTimer.stop();
	} else if(state == 4) { // failed
		_p2pConnectionTiemOutTimer.stop();
		_isPairing = false;
		emit pairingChanaged();
		emit pairingFailed();
	} else if(state == 3) { // connecting
		if(!_p2pConnectionTiemOutTimer.isActive()) {
			_p2pDevices.clearAndDeleteContents();
			_isPairing = true;
			emit pairingChanaged();
			_p2pConnectionTiemOutTimer.start(20000);
		}
	}
}

void TeamModeRouter::p2pConnectionAction(bool active)
{
	if(active == _p2pConnection) { return; }
	clearConnections();
	_p2pConnection = active;
#if defined(ENABLE_WIFI_P2P)
	TeamModeRouter::reset_jni();
	if(_p2pConnection) {
		QAndroidJniObject::callStaticMethod<void>(jniClassName, "enterTeamMode", "()V");
	} else {
		QAndroidJniObject::callStaticMethod<void>(jniClassName, "exitTeamMode", "()V");
	}
#endif
}

void TeamModeRouter::_bindTimeout()
{
	mavlink_message_t msg;
	mavlink_command_long_t cmd;
	memset(&cmd, 0, sizeof(cmd));
	cmd.target_system =     255;
    cmd.target_component =  MAV_COMP_ID_MISSIONPLANNER;
	cmd.command =           MAV_CMD_USER_1;
	cmd.confirmation =      1;
	cmd.param1 =            _isBind ? 1 : 0;
	mavlink_msg_command_long_encode_chan(_protocol->getSystemId(),
					     _protocol->getComponentId(),
					     MAVLINK_TEAMMODE_COMM_ID,
					     &msg,
					     &cmd);
	emit receivedFromProtocol(nullptr, msg);
	if(_bindRetries++ > 3) {
		SessionTarget* client = current();
		if(client) { client->setEnable(false); }
		_isPairing = false;
		_bindTimer.stop();
		emit pairingChanaged();
		emit pairingTimeout();
	}
}

SessionTarget* TeamModeRouter::current()
{
	return valid_target(_sessionTargets);
}

void TeamModeRouter::_refreshCurrentEntry()
{
    QList<QNetworkInterface> interfaces = QNetworkInterface::allInterfaces();
    for (auto it = interfaces.begin(); it != interfaces.end(); it++) {
        if (it->flags() & QNetworkInterface::IsLoopBack) continue;
        if (!(it->flags() & QNetworkInterface::IsRunning)) continue;
        if (_teamModeFact->rawValue().toInt() == 2 && !it->humanReadableName().toLower().startsWith("p2p")) {
            continue;
        }
        if (it->humanReadableName().toLower().contains("tun")) continue;
        if (it->humanReadableName().toLower().contains("eth")) continue;
        QList<QNetworkAddressEntry> entries = it->addressEntries();
        for (auto iter = entries.begin(); iter != entries.end(); iter++) {
            QHostAddress ip = iter->ip();
            QHostAddress mask = iter->netmask();
            if (ip.protocol() !=  QAbstractSocket::IPv4Protocol) continue;
            if (ip == QHostAddress::LocalHost) continue;
//            if (ip.isInSubnet(QHostAddress("192.168.2.100"), 24)) continue;
            if(_currentEntry != *iter) {
                _currentEntry = *iter;
                emit localIPChanaged();
            }
            return;
        }
    }
}

bool TeamModeRouter::isInSameSubnet(QHostAddress address)
{
	QString subnet = QString("%1/%2").arg(_currentEntry.ip().toString()).arg(_currentEntry.netmask().toString());
	return address.isInSubnet(QHostAddress::parseSubnet(subnet));
}

QString TeamModeRouter::localIP()
{
    if(_timer == nullptr) {
        _refreshCurrentEntry();
    }
    return _currentEntry.ip().toString().isEmpty() ? "0.0.0.0" : _currentEntry.ip().toString();
}

QString TeamModeRouter::remoteIP()
{
	auto client = valid_target(_sessionTargets);

	if(client) {
		return client->name();
	} else {
		return QString();
	}
}

bool TeamModeRouter::connected()
{
	bool result = false;

	if(valid_target(_sessionTargets) != nullptr) {
		result = true;
	}

	return result;
}

void TeamModeRouter::_handleMessageReceived(LinkInterface* link, mavlink_message_t message)
{
    Vehicle* vehicle = _vehicleManager->activeVehicle();
    if(vehicle) {
        if(vehicle->vehicleLinkManager()->primaryLink().lock().get() == link ||
           vehicle->vehicleLinkManager()->isCommLostLink(link) == 0) {
            emit receivedFromProtocol(link, message);
        }
    }
}

void TeamModeRouter::_handleStart(quint16 port)
{
#if defined(QGC_GST_STREAMING)
	if(!_videoReceiver) {
		_videoReceiver = qobject_cast<CustomVideoReceiver*>(qgcApp()->toolbox()->videoManager()->videoReceiver());
		connect(this, &TeamModeRouter::connectedChanaged, _videoReceiver, [this] {
			if(!connected())
			{
				_ready = false;
				_videoReceiver->stopForward();
			}
		});
	}
	if(!_thermalVideoReceiver) {
		_thermalVideoReceiver = qobject_cast<CustomVideoReceiver*>
					(qgcApp()->toolbox()->videoManager()->thermalVideoReceiver());
		connect(this, &TeamModeRouter::connectedChanaged, _thermalVideoReceiver, [this] {
			if(!connected()) _thermalVideoReceiver->stopForward();
		});
	}
#endif
	if(!_link) {
		_link = new QUdpSocket(this);
		_link->bind(QHostAddress::AnyIPv4, port, QAbstractSocket::ReuseAddressHint | QUdpSocket::ShareAddress);
		_link->setProxy(QNetworkProxy::NoProxy);

		connect(this, &TeamModeRouter::receivedFromProtocol, this, &TeamModeRouter::_forwardToSlave);
		connect(this, &TeamModeRouter::receivedBadCrcFromProtocol, this, &TeamModeRouter::_forwardBadCrcToSlave);
		connect(_link, &QUdpSocket::readyRead, this, &TeamModeRouter::_socketReadyRead);
	}

	if(!_timer) {
		_timer = new QTimer(this);
		connect(_timer, &QTimer::timeout, this, &TeamModeRouter::_broadcastIdentifyMessage);
		_timer->setInterval(1000);
		_timer->setSingleShot(false);
		_timer->start();
	}

	if(!_httpServer) {
		_httpServer = new QTcpServer(this);
		_httpServer->listen(QHostAddress::Any, 8081);
		_httpServer->setMaxPendingConnections(1);
		connect(_httpServer, &QTcpServer::newConnection, this, &TeamModeRouter::_newHttpConnectSlot);
	}

	_bindTimer.stop();
	_isBind = true;
	_isPairing = false;
	emit pairingChanaged();
}

void TeamModeRouter::_handleStop()
{
	if(_link) {
		disconnect(this, &TeamModeRouter::receivedFromProtocol, this, &TeamModeRouter::_forwardToSlave);
		disconnect(this, &TeamModeRouter::receivedBadCrcFromProtocol, this, &TeamModeRouter::_forwardBadCrcToSlave);
		disconnect(_link, &QUdpSocket::readyRead, this, &TeamModeRouter::_socketReadyRead);
		_link->deleteLater();
		_link = nullptr;
	}

	if(_timer) {
		_timer->stop();
		_timer->deleteLater();
		_timer = nullptr;
	}

	if(_httpServer) {
		_httpServer->close();
		_httpServer->deleteLater();
		_httpServer = nullptr;
	}
#if defined(QGC_GST_STREAMING)
	if(_videoReceiver) {
		_videoReceiver->stopForward();
	}

	if(_thermalVideoReceiver) {
		_thermalVideoReceiver->stopForward();
	}
#endif
	_ready = false;
	clearConnections();

	_bindTimer.stop();
	_isBind = true;
	_isPairing = false;
	emit pairingChanaged();
}

void TeamModeRouter::_newHttpConnectSlot()
{
	auto tcpSocket = _httpServer->nextPendingConnection();
	connect(tcpSocket, &QTcpSocket::readyRead, this, &TeamModeRouter::_getFromHttpClient);
}

void TeamModeRouter::_getFromHttpClient()
{
	QTcpSocket* socket = qobject_cast<QTcpSocket*>(sender());
	Vehicle* vehicle = _vehicleManager->activeVehicle();
	if(socket && vehicle) {
		QByteArray data = socket->readAll();
		qInfo() << data;
        // CustomCameraControl* camera = qobject_cast<CustomCameraControl*>(vehicle->cameraManager()->currentCameraInstance());
        // if(camera) {
        //     QString cacheFile = camera->cacheDefile();
        //     QFile file(cacheFile);
        //     if(file.open(QIODevice::ReadOnly)) {
        //         QString http = "HTTP/1.1 200 OK\r\n";
        //         http += "Server: FlyDynamic\r\n";
        //         http += "Content-Type: application/octet-stream;charset=utf-8\r\n";
        //         http += "Connection: keep-alive\r\n";
        //         http += QString("Content-Length: %1\r\n\r\n").arg(QString::number(file.size()));

        //         QByteArray headData;
        //         headData.append(http);
        //         socket->write(headData);
        //         socket->write(file.readAll());
        //     }
        // }
	}
}

void TeamModeRouter::_broadcastIdentifyMessage()
{
	static quint32 index = 0;
	if((index++ % 3) == 0 && !connected()) {
		_refreshCurrentEntry();
	}

	Vehicle* vehicle = _vehicleManager->activeVehicle();
	if(!vehicle || !vehicle->cameraManager() || vehicle->cameraManager()->cameras()->count() == 0) {
		_ready = false;
	}
#if defined(QGC_GST_STREAMING)
	else if(_videoReceiver && _videoReceiver->streaming()) {
		_ready = true;
	}
#endif
	if(_teamModeFact->rawValue() == 1 && !_scanningDevice) {
		_scanningDevice = true;
		emit scanningDeviceChanged();
	}

	if(!_currentEntry.ip().toString().isEmpty()) {
		mavlink_message_t message;
		mavlink_msg_heartbeat_pack_chan(_protocol->getSystemId(),
						_protocol->getComponentId(),
						MAVLINK_TEAMMODE_COMM_ID,
						&message,
						MAV_TYPE_GCS,            // MAV_TYPE
						MAV_AUTOPILOT_INVALID,   // MAV_AUTOPILOT
						MAV_MODE_MANUAL_ARMED,   // MAV_MODE
						0,                       // custom mode
						MAV_STATE_ACTIVE);       // MAV_STATE

		uint8_t buffer[MAVLINK_MAX_PACKET_LEN];
		int len = mavlink_msg_to_send_buffer(buffer, &message);
		_link->writeDatagram(reinterpret_cast<const char*>(buffer), len, _currentEntry.broadcast(),
				     DEFAULT_REMOTE_PORT_UDP_QGC_SLAVE);
	}
}

void TeamModeRouter::_socketReadyRead()
{
	while(_link && _link->hasPendingDatagrams()) {
		QByteArray datagram;
		datagram.resize(_link->pendingDatagramSize());
		QHostAddress sender;
		quint16 senderPort;
		_link->readDatagram(datagram.data(), datagram.size(), &sender, &senderPort);
		if(sender.isLoopback() && !isInSameSubnet(sender)) { continue; }
		for(int p = 0; p < datagram.size(); p++) {
			mavlink_message_t message;
			mavlink_status_t status;
			// MAVLINK_COMM_0 Avoid conflicts LinkManager::_reserveMavlinkChannel
			uint8_t ret = mavlink_frame_char(MAVLINK_TEAMMODE_COMM_ID, static_cast<uint8_t>(datagram[p]), &message, &status);
			if(ret == MAVLINK_FRAMING_OK) {
				SessionTarget* client = contains_target(_sessionTargets, sender, senderPort);
				if(client == nullptr) {
					QMutexLocker locker(&_sessionTargetsMutex);
					qDebug() << "Adding target" << sender << senderPort;
					client = new SessionTarget(sender, senderPort);
					connect(client, &SessionTarget::enableChanged, this, &TeamModeRouter::connectedChanaged);
					connect(client, &SessionTarget::connectedChanged, this, &TeamModeRouter::connectedChanaged);
					if(_teamModeFact->rawValue().toUInt() == 2 && !connected()) {
						client->setEnable(true);
						if(_sessionTargets.count() != 0) {
							_sessionTargets.clearAndDeleteContents();
						}
					}
					_sessionTargets.append(client);
					locker.unlock();
				} else if(client->enable()) {
					emit receivedFromSlave(client, message);
				} else if(!client->enable()) {
					if(_teamModeFact->rawValue().toUInt() == 2 && !connected()) {
						client->setEnable(true);
					}
				}
				client->setConnected(true);
			} else if(_teamModeFact->rawValue().toUInt() == 1 && ret == MAVLINK_FRAMING_BAD_CRC && (message.msgid == 5002
					|| message.msgid == 5003)) {
				uint8_t crc_extra = 0;
				if(message.msgid == 5002) {
					crc_extra = 224;
				} else if(message.msgid == 5003) {
					crc_extra = 86;
				}
				message.sysid = _protocol->getSystemId();
				message.compid = _protocol->getComponentId();
				mavlink_start_checksum(&message);
				mavlink_update_checksum(&message, message.len);
				mavlink_update_checksum(&message, message.incompat_flags);
				mavlink_update_checksum(&message, message.compat_flags);
				mavlink_update_checksum(&message, message.seq);
				mavlink_update_checksum(&message, message.sysid);
				mavlink_update_checksum(&message, message.compid);
				mavlink_update_checksum(&message, static_cast<uint8_t>(message.msgid & 0xff));
				mavlink_update_checksum(&message, static_cast<uint8_t>((message.msgid >> 8) & 0xff));
				mavlink_update_checksum(&message, static_cast<uint8_t>((message.msgid >> 16) & 0xff));
				for(int i = 0; i < message.len; i++) {
					mavlink_update_checksum(&message, static_cast<uint8_t>(_MAV_PAYLOAD(&message)[i]));
				}
				mavlink_update_checksum(&message, crc_extra);
				bool crc = (message.ck[0] == (message.checksum & 0xff) && message.ck[1] == ((message.checksum >> 8) & 0xff));
				if(crc) {
					SessionTarget* client = contains_target(_sessionTargets, sender, senderPort);
					if(client == nullptr) {
						QMutexLocker locker(&_sessionTargetsMutex);
						qDebug() << "Adding target" << sender << senderPort;
						client = new SessionTarget(sender, senderPort);
						connect(client, &SessionTarget::enableChanged, this, &TeamModeRouter::connectedChanaged);
						connect(client, &SessionTarget::connectedChanged, this, &TeamModeRouter::connectedChanaged);
						_sessionTargets.append(client);
						locker.unlock();
					}
					Vehicle* vehicle = _vehicleManager->activeVehicle();
					if(vehicle != nullptr) {
						WeakLinkInterfacePtr weakLink = vehicle->vehicleLinkManager()->primaryLink();
						if(!weakLink.expired()) {
							SharedLinkInterfacePtr sharedLink = weakLink.lock();
							vehicle->sendMessageOnLinkThreadSafe(sharedLink.get(), message);
						}
					}
				}
			}
		}
	}
}

void TeamModeRouter::_handleFromSlave(SessionTarget* client, mavlink_message_t message)
{
	Vehicle* vehicle = _vehicleManager->activeVehicle();
	bool pass = false;
	switch(message.msgid) {
	case MAVLINK_MSG_ID_RC_CHANNELS:
		break;
	case MAVLINK_MSG_ID_RC_CHANNELS_OVERRIDE:
		_handRCChannelsOverride(message);
		break;
	case MAVLINK_MSG_ID_HEARTBEAT:
		pass = _handHeartBeatFromSlave(client, vehicle, message);
		break;
	case MAVLINK_MSG_ID_COMMAND_LONG:
		pass = _handCommandLongFromSlave(client, vehicle, message);
		break;
	case MAVLINK_MSG_ID_COMMAND_ACK:
		pass = _handCommandAckFromSlave(client, vehicle, message);
		break;
	default:
		pass = true;
		break;
	}
	if(_ready && pass && vehicle != nullptr) {
		const mavlink_msg_entry_t *e = mavlink_get_msg_entry(message.msgid);
		const int target_component_ofs = e->target_component_ofs;
		int target_comp_id = -1;
		if(target_component_ofs != 0) {
			target_comp_id = (_MAV_PAYLOAD(&message))[target_component_ofs];
		}
		if(target_comp_id >= MAV_COMP_ID_CAMERA && target_comp_id <= MAV_COMP_ID_CAMERA6) {
			QGCCameraControl* camera = vehicle->cameraManager()->currentCameraInstance();
			if(camera && camera->compID() == target_comp_id) {
                // CustomCameraControl* c = qobject_cast<CustomCameraControl*>(camera);
                // vehicle->sendMessageOnLinkThreadSafe(c->link(), message);
			}
		} else {
			WeakLinkInterfacePtr weakLink = vehicle->vehicleLinkManager()->primaryLink();
			if(!weakLink.expired()) {
				SharedLinkInterfacePtr sharedLink = weakLink.lock();
				vehicle->sendMessageOnLinkThreadSafe(sharedLink.get(), message);
			}
		}
	}
}

void TeamModeRouter::_handRCChannelsOverride(mavlink_message_t message)
{
	mavlink_msg_rc_channels_override_decode(&message, &_slave_channels);
	_enableSlaveChannels = true;
	_slaveChannelsTimer.start();

	mavlink_rc_channels_override_t rc_channels_override = _slave_channels;
	rc_channels_override.chan18_raw = 0x1f00; // override index 8 9 10 11 12
	mavlink_message_t msg;
	mavlink_msg_rc_channels_override_encode(
		static_cast<uint8_t>(_protocol->getSystemId()),
		static_cast<uint8_t>(_protocol->getComponentId()),
		&msg,
		&rc_channels_override);
	// Write message into buffer, prepending start sign
    uint8_t buf[MAVLINK_MAX_PACKET_LEN];
    int len = mavlink_msg_to_send_buffer(buf, &msg);
	QByteArray buffer((const char*)buf, len);
	emit overrideRCChannelBuffer(buffer);
}

bool TeamModeRouter::_handHeartBeatFromSlave(SessionTarget* client, Vehicle* vehicle, mavlink_message_t message)
{
	Q_UNUSED(vehicle)
	mavlink_heartbeat_t heartbeat;
	mavlink_msg_heartbeat_decode(&message, &heartbeat);
	if(client->enable() && heartbeat.system_status == MAV_STATE_UNINIT) {
		connectTo(client);
	}
	return false;
}

bool TeamModeRouter::_handCommandAckFromSlave(SessionTarget* client, Vehicle* vehicle, mavlink_message_t message)
{
	Q_UNUSED(vehicle)
	mavlink_command_ack_t command_ack;
	mavlink_msg_command_ack_decode(&message, &command_ack);
	if(command_ack.command == MAV_CMD_USER_1 && _isPairing) {
		if(command_ack.result == MAV_RESULT_ACCEPTED) {
			if(command_ack.result_param2 == 0) {
				client->setEnable(false);
			} else {
				client->setEnable(true);
			}
			_isPairing = false;
			_bindTimer.stop();
			emit pairingChanaged();
		} else {
			client->setEnable(false);
			_isPairing = false;
			_bindTimer.stop();
			emit pairingChanaged();
		}
	}
	return false;
}

bool TeamModeRouter::_handCommandLongFromSlave(SessionTarget* client, Vehicle* vehicle, mavlink_message_t message)
{
	bool pass = false, support = true, failed = false;
	mavlink_command_long_t mavlink_command_long;
	mavlink_msg_command_long_decode(&message, &mavlink_command_long);
	if((mavlink_command_long.target_system == 1 &&
	    (mavlink_command_long.target_component == MAV_COMP_ID_ALL ||
	     mavlink_command_long.target_component == MAV_COMP_ID_AUTOPILOT1 ||
	     mavlink_command_long.target_component == MAV_COMP_ID_CAMERA ||
	     mavlink_command_long.target_component == MAV_COMP_ID_GIMBAL)) ||
	    (mavlink_command_long.target_system == _protocol->getSystemId()
	     && mavlink_command_long.target_component == _protocol->getComponentId())) {
		if(mavlink_command_long.command == MAV_CMD_REQUEST_CAMERA_INFORMATION) {
			if(vehicle) {
                // CustomCameraControl* camera = qobject_cast<CustomCameraControl*>(vehicle->cameraManager()->currentCameraInstance());
                // if(camera) {
                //     mavlink_camera_information_t camera_info;
                //     mavlink_message_t message;
                //     camera->get_mavlink_camera_info(camera_info);
                //     QString def_url = QString("http://%1:8081/caminfo.xml").arg(localIP());
                //     memset(camera_info.cam_definition_uri, 0, sizeof(camera_info.cam_definition_uri));
                //     memcpy(camera_info.cam_definition_uri, def_url.toLatin1().data(), def_url.length());
                //     camera_info.flags |= CAMERA_CAP_FLAGS_HAS_VIDEO_STREAM;
                //     mavlink_msg_camera_information_encode_chan(vehicle->id(),
                //             camera->compID(),
                //             MAVLINK_TEAMMODE_COMM_ID,
                //             &message,
                //             &camera_info);
                //     emit receivedFromProtocol(nullptr, message);
                // } else { failed = true; }
			} else { failed = true; }
		} else if(mavlink_command_long.command == MAV_CMD_REQUEST_VIDEO_STREAM_INFORMATION) {
			if(vehicle) {
				QGCCameraControl* camera = vehicle->cameraManager()->currentCameraInstance();
				if(camera) {
					QGCVideoStreamInfo* video_stream = camera->currentStreamInstance();
					QGCVideoStreamInfo* thermal_stream = camera->thermalStreamInstance();
					if(video_stream) {
						QString live_url = QString("udp://0.0.0.0:50001");
						mavlink_video_stream_information_t stream_info;
						mavlink_message_t message;
						video_stream->get_stream_info(stream_info);
						memset(stream_info.uri, 0, sizeof(stream_info.uri));
						memcpy(stream_info.uri, live_url.toLatin1().data(), live_url.length());
						mavlink_msg_video_stream_information_encode_chan(vehicle->id(),
								camera->compID(),
								MAVLINK_TEAMMODE_COMM_ID,
								&message,
								&stream_info);
					#if defined(QGC_GST_STREAMING)
						if(_videoReceiver) { _videoReceiver->startForward(client->address().toString(), 50001); }
					#endif
						emit receivedFromProtocol(nullptr, message);
						if(thermal_stream) {
							QString thermal_url = QString("udp://0.0.0.0:50002");
							thermal_stream->get_stream_info(stream_info);
							memset(stream_info.uri, 0, sizeof(stream_info.uri));
							memcpy(stream_info.uri, thermal_url.toLatin1().data(), thermal_url.length());
							mavlink_msg_video_stream_information_encode_chan(vehicle->id(),
									camera->compID(),
									MAVLINK_TEAMMODE_COMM_ID,
									&message,
									&stream_info);
						#if defined(QGC_GST_STREAMING)
							if(_thermalVideoReceiver) { _thermalVideoReceiver->startForward(client->address().toString(), 50002); }
						#endif
							emit receivedFromProtocol(nullptr, message);
						}
					} else { failed = true; }
				} else { failed = true; }
			} else { failed = true; }
		} else if(mavlink_command_long.command == MAV_CMD_REQUEST_VIDEO_STREAM_STATUS) {
			if(vehicle) {
				QGCCameraControl* camera = vehicle->cameraManager()->currentCameraInstance();
				if(camera) {
					QGCVideoStreamInfo* video_stream = camera->currentStreamInstance();
					QGCVideoStreamInfo* thermal_stream = camera->thermalStreamInstance();
					if(video_stream) {
						QString live_url = QString("udp://0.0.0.0:50001");
						mavlink_video_stream_information_t stream_info;
						mavlink_message_t message;
						video_stream->get_stream_info(stream_info);
						mavlink_video_stream_status_t stream_status = {
							stream_info.framerate,/*< [Hz] Frame rate.*/
							stream_info.bitrate,/*< [bits/s] Bit rate.*/
							stream_info.flags,/*<  Bitmap of stream status flags.*/
							stream_info.resolution_h,/*< [pix] Horizontal resolution.*/
							stream_info.resolution_v,/*< [pix] Vertical resolution.*/
							stream_info.rotation,/*< [deg] Video image rotation clockwise.*/
							stream_info.hfov,/*< [deg] Horizontal Field of view.*/
							1/*<  Video Stream ID (1 for first, 2 for second, etc.)*/
						};
						mavlink_msg_video_stream_status_encode_chan(vehicle->id(),
								camera->compID(),
								MAVLINK_TEAMMODE_COMM_ID,
								&message,
								&stream_status);
						emit receivedFromProtocol(nullptr, message);
						if(thermal_stream) {
							thermal_stream->get_stream_info(stream_info);
							stream_status = {
								stream_info.framerate,/*< [Hz] Frame rate.*/
								stream_info.bitrate,/*< [bits/s] Bit rate.*/
								stream_info.flags,/*<  Bitmap of stream status flags.*/
								stream_info.resolution_h,/*< [pix] Horizontal resolution.*/
								stream_info.resolution_v,/*< [pix] Vertical resolution.*/
								stream_info.rotation,/*< [deg] Video image rotation clockwise.*/
								stream_info.hfov,/*< [deg] Horizontal Field of view.*/
								2/*<  Video Stream ID (1 for first, 2 for second, etc.)*/
							};
							mavlink_msg_video_stream_status_encode_chan(vehicle->id(),
									camera->compID(),
									MAVLINK_TEAMMODE_COMM_ID,
									&message,
									&stream_status);
							emit receivedFromProtocol(nullptr, message);
						}
					} else { failed = true; }
				} else { failed = true; }
			} else { failed = true; }
		} else if(mavlink_command_long.command == MAV_CMD_USER_1
			  && mavlink_command_long.target_system == _protocol->getSystemId()
			  && mavlink_command_long.target_component == _protocol->getComponentId()) {
			if(mavlink_command_long.param1 == 0) {
				if(mavlink_command_long.param2 == 0) {
					disconnectTo(client);
				} else {
					client->setEnable(false);
					_isPairing = false;
					_bindTimer.stop();
					emit pairingChanaged();
				}
			} else {
				support = false;
			}
		} else {
			pass = true;
		}

		if(!pass) {
			mavlink_msg_command_ack_pack_chan(mavlink_command_long.target_system,
							  mavlink_command_long.target_component,
							  MAVLINK_TEAMMODE_COMM_ID,
							  &message,
							  mavlink_command_long.command,
							  support ? (failed ? MAV_RESULT_FAILED : MAV_RESULT_ACCEPTED) : MAV_RESULT_UNSUPPORTED,
							  0, 0, message.sysid, message.compid);
			emit receivedFromProtocol(nullptr, message);
		} else {

		}
	}
	return pass;
}

void TeamModeRouter::_forwardToSlave(LinkInterface* link, mavlink_message_t message)
{
	if(link != nullptr) {
		if(!_ready) { return; }
		if(message.msgid == MAVLINK_MSG_ID_CAMERA_INFORMATION ||
		   message.msgid == MAVLINK_MSG_ID_RC_CHANNELS)
		{ return; }
	}
	if(_teamModeFact->rawValue().toUInt() == 2 && !_p2pConnected) {
        return;
    }
	uint8_t buffer[MAVLINK_MAX_PACKET_LEN];
	if(message.compid == MAV_COMP_ID_ALL ||
        message.compid == MAV_COMP_ID_MISSIONPLANNER ||
	    message.compid == MAV_COMP_ID_AUTOPILOT1 ||
	    message.compid == MAV_COMP_ID_CAMERA ||
	    message.compid == MAV_COMP_ID_GIMBAL) {
		int len = mavlink_msg_to_send_buffer(buffer, &message);
		QMutexLocker locker(&_sessionTargetsMutex);
		// Send to all connected systems
		for(int i = 0; i < _sessionTargets.count(); i++) {
			SessionTarget* target = _sessionTargets.value<SessionTarget*>(i);
			if(!target->enable()) { continue; }
			if(_link->writeDatagram(reinterpret_cast<char*>(buffer), len, target->address(), target->port()) < 0) {
				qWarning() << "Error writing to" << target->address() << target->port();
			}
		}
	}
}

void TeamModeRouter::_forwardBadCrcToSlave(LinkInterface* link, mavlink_message_t message)
{
	uint8_t buffer[MAVLINK_MAX_PACKET_LEN];
	int len = mavlink_msg_to_send_buffer(buffer, &message);
	QMutexLocker locker(&_sessionTargetsMutex);
	// Send to all connected systems
	for(int i = 0; i < _sessionTargets.count(); i++) {
		SessionTarget* target = _sessionTargets.value<SessionTarget*>(i);
		if(_link->writeDatagram(reinterpret_cast<char*>(buffer), len, target->address(), target->port()) < 0) {
			qWarning() << "Error writing to" << target->address() << target->port();
		}
	}
}
