#include <QtGlobal>
#include <QTimer>
#include <QList>
#include <QDebug>
#include <QMutexLocker>
#include <QNetworkProxy>
#include <QNetworkInterface>
#include <iostream>
#include <QHostInfo>

#include "TeamModeLink.h"
#include "QGC.h"
#include "QGCApplication.h"
#include "SettingsManager.h"
#include "AutoConnectSettings.h"

void TeamModeConfiguration::tiggerUnBind(bool ack)
{
	if(targetHost() && !_link.expired()) {
		mavlink_message_t msg;
		mavlink_command_long_t cmd;
		memset(&cmd, 0, sizeof(cmd));
		cmd.target_system =     255;
		cmd.target_component =  MAV_COMP_ID_MISSIONPLANNER;
		cmd.command =           MAV_CMD_USER_1;
		cmd.confirmation =      1;
		cmd.param1 =            0;
		cmd.param2 =            ack ? 0 : 1;
		mavlink_msg_command_long_encode_chan(255,
						     0,
						     MAVLINK_COMM_NUM_BUFFERS - 1,
						     &msg,
						     &cmd);
		uint8_t buffer[MAVLINK_MAX_PACKET_LEN];
		int len = mavlink_msg_to_send_buffer(buffer, &msg);
		SharedLinkInterfacePtr sharedLink = _link.lock();
		sharedLink->writeBytesThreadSafe(reinterpret_cast<const char*>(buffer), len);
		if(ack) { _unbindTimer.start(); }
	}
}

void TeamModeConfiguration::clearHost()
{
	if(_unbindTimer.isActive()) {
		_unbindTimer.stop();
	}
	QMutexLocker locker(&targetMutex);
	if(_targetHost != nullptr && !_link.expired()) {
		SharedLinkInterfacePtr sharedLink = _link.lock();
		TeamModeLink* tmlink = qobject_cast<TeamModeLink*>(sharedLink.get());
		if(tmlink) {
			mavlink_message_t msg;
			mavlink_command_long_t cmd;
			memset(&cmd, 0, sizeof(cmd));
			cmd.target_system =     255;
            cmd.target_component =  MAV_COMP_ID_MISSIONPLANNER;
			cmd.command =           MAV_CMD_USER_1;
			cmd.confirmation =      1;
			cmd.param1 =            0;
			cmd.param2 =            1;
			mavlink_msg_command_long_encode_chan(255,
                                 MAV_COMP_ID_MISSIONPLANNER,
							     MAVLINK_COMM_NUM_BUFFERS - 1,
							     &msg,
							     &cmd);
			uint8_t buffer[MAVLINK_MAX_PACKET_LEN];
			int len = mavlink_msg_to_send_buffer(buffer, &msg);
			tmlink->_writeDataGram(QByteArray(reinterpret_cast<const char*>(buffer), len), _targetHost);
		}
		delete _targetHost;
		_targetHost = nullptr;
	}
	emit connectedChanged();
}

TeamModeLink::TeamModeLink(SharedLinkConfigurationPtr& config)
	: LinkInterface(config)
	, _running(false)
	, _socket(nullptr)
	, _teamModeConfig(qobject_cast<TeamModeConfiguration*>(config.get()))
	, _connectState(false)
{
	if(!_teamModeConfig) {
		qWarning() << "Internal error";
	}
	auto allAddresses = QNetworkInterface::allAddresses();
	for(int i = 0; i < allAddresses.count(); i++) {
		QHostAddress& address = allAddresses[i];
		_localAddresses.append(QHostAddress(address));
	}
	moveToThread(this);
}

TeamModeLink::~TeamModeLink()
{
	disconnect();
	// Tell the thread to exit
	_running = false;
	quit();
	// Wait for it to exit
	wait();
	this->deleteLater();
}

void TeamModeLink::run()
{
	if(_hardwareConnect()) {
		exec();
	}
	if(_socket) {
		_socket->close();
	}
}

void TeamModeLink::_restartConnection()
{
	if(this->isConnected()) {
		disconnect();
		_connect();
	}
}

bool TeamModeLink::_isIpLocal(const QHostAddress& add)
{
	// In simulation and testing setups the vehicle and the GCS can be
	// running on the same host. This leads to packets arriving through
	// the local network or the loopback adapter, which makes it look
	// like the vehicle is connected through two different links,
	// complicating routing.
	//
	// We detect this case and force all traffic to a simulated instance
	// onto the local loopback interface.
	// Run through all IPv4 interfaces and check if their canonical
	// IP address in string representation matches the source IP address
	//
	// On Windows, this is a very expensive call only Redmond would know
	// why. As such, we make it once and keep the list locally. If a new
	// interface shows up after we start, it won't be on this list.
	for(int i = 0; i < _localAddresses.count(); i++) {
		QHostAddress& address = _localAddresses[i];
		if(address == add) {
			// This is a local address of the same host
			return true;
		}
	}
	return false;
}

void TeamModeLink::_writeBytes(const QByteArray data)
{
	if(!_socket) {
		return;
	}
	QMutexLocker locker(&_teamModeConfig->targetMutex);
	const UDPCLient* target = _teamModeConfig->targetHost();
	if(target == nullptr) {
		return;
	}
	emit bytesSent(this, data);
	_writeDataGram(data, target);
}

void TeamModeLink::_writeDataGram(const QByteArray data, const UDPCLient* target)
{
	//qDebug() << "UDP Out" << target->address << target->port;
	if(_socket->writeDatagram(data, target->address, target->port) < 0) {
		qWarning() << "Error writing to" << target->address << target->port;
	} else {
		// Only log rate if data actually got sent. Not sure about this as
		// "host not there" takes time too regardless of size of data. In fact,
		// 1 byte or "UDP frame size" bytes are the same as that's the data
		// unit sent by UDP.
		//_logOutputDataRate(data.size(), QDateTime::currentMSecsSinceEpoch());
	}
}

void TeamModeLink::readBytes()
{
	if(!_socket) {
		return;
	}
	QByteArray databuffer;
	while(_socket->hasPendingDatagrams()) {
		QByteArray datagram;
		datagram.resize(_socket->pendingDatagramSize());
		QHostAddress sender;
		quint16 senderPort;
		//-- Note: This call is broken in Qt 5.9.3 on Windows. It always returns a blank sender and 0 for the port.
		_socket->readDatagram(datagram.data(), datagram.size(), &sender, &senderPort);
		bool need = _internalParse(sender, senderPort, datagram);
		if(need) {
			databuffer.append(datagram);
		}
		//-- Wait a bit before sending it over
		if(databuffer.size() > 10 * 1024) {
			emit bytesReceived(this, databuffer);
			databuffer.clear();
		}
		//_logInputDataRate(datagram.length(), QDateTime::currentMSecsSinceEpoch());
	}
	//-- Send whatever is left
	if(databuffer.size()) {
		emit bytesReceived(this, databuffer);
	}
}

bool TeamModeLink::_internalParse(QHostAddress sender, quint16 senderPort, QByteArray& datagram)
{
	bool need = false;
	if(_teamModeConfig->targetHost() != nullptr &&
	    _teamModeConfig->targetHost()->address == sender &&
	    _teamModeConfig->targetHost()->port == senderPort) {
		need = true;
		emit _teamModeConfig->targetTimerStart();
	}

	int i = 0;
	while(datagram.count() - i > 12) {
		if(static_cast<quint8>(datagram.at(i)) == MAVLINK_STX) {
			int msg_id = (static_cast<quint8>(datagram.at(i + 7)) | (static_cast<quint8>(datagram.at(i + 8)) << 8) |
				      (static_cast<quint8>(datagram.at(i + 9)) << 16));
			if(msg_id == MAVLINK_MSG_ID_COMMAND_LONG) {
				if(datagram.count() - i > 41) {
					quint8 target_sys_id = static_cast<quint8>(datagram.at(i + 10 + 30));
					quint8 target_comp_id = static_cast<quint8>(datagram.at(i + 10 + 31));
                    if(target_sys_id == 255 && target_comp_id == MAV_COMP_ID_MISSIONPLANNER) {
						for(; i < datagram.count(); i++) {
							mavlink_message_t message;
							mavlink_status_t status;
							int start = i;
							if(mavlink_parse_char(MAVLINK_COMM_NUM_BUFFERS - 1, static_cast<uint8_t>(datagram.at(i)), &message,
									      &status) == MAVLINK_FRAMING_OK) {
								_handleCommandLong(sender, senderPort, message);
								datagram.remove(start, i - start);
								i = datagram.count();
								break;
							}
						}
					} else {
						i += static_cast<quint8>(datagram.at(i + 1)) + 12;
					}
				} else {
					i += static_cast<quint8>(datagram.at(i + 1)) + 12;
				}
			} else if(msg_id == MAVLINK_MSG_ID_COMMAND_ACK) {
				if(datagram.count() - i > 21) {
					quint8 target_sys_id = static_cast<quint8>(datagram.at(i + 10 + 8));
					//quint8 target_comp_id = static_cast<quint8>(datagram.at(i+10+31));//0
					if(target_sys_id == 255) {
						for(; i < datagram.count(); i++) {
							mavlink_message_t message;
							mavlink_status_t status;
							int start = i;
							if(mavlink_parse_char(MAVLINK_COMM_NUM_BUFFERS - 1, static_cast<uint8_t>(datagram.at(i)), &message,
									      &status) == MAVLINK_FRAMING_OK) {
								_handleCommandAck(sender, senderPort, message);
								datagram.remove(start, i - start);
								i = datagram.count();
								break;
							}
						}
					} else {
						i += static_cast<quint8>(datagram.at(i + 1)) + 12;
					}
				} else {
					i += static_cast<quint8>(datagram.at(i + 1)) + 12;
				}
			} else if(msg_id == MAVLINK_MSG_ID_HEARTBEAT) {
				quint8 sys_id = static_cast<quint8>(datagram.at(i + 5));
				quint8 comp_id = static_cast<quint8>(datagram.at(i + 6));
                if(sys_id == 255 && comp_id == MAV_COMP_ID_MISSIONPLANNER) {
					if(need || _teamModeConfig->targetHost() == nullptr) {
						mavlink_message_t message;
						mavlink_msg_heartbeat_pack_chan(255,
                                        MAV_COMP_ID_MISSIONPLANNER,
										MAVLINK_COMM_NUM_BUFFERS - 1,
										&message,
										MAV_TYPE_GCS,            // MAV_TYPE
										MAV_AUTOPILOT_INVALID,   // MAV_AUTOPILOT
										MAV_MODE_MANUAL_ARMED,   // MAV_MODE
										0,                       // custom mode
										_teamModeConfig->targetHost() == nullptr ? MAV_STATE_UNINIT : MAV_STATE_ACTIVE);       // MAV_STATE
						uint8_t buffer[MAVLINK_MAX_PACKET_LEN];
						int len = mavlink_msg_to_send_buffer(buffer, &message);
						if(_running) { _socket->writeDatagram(reinterpret_cast<const char*>(buffer), len, sender, senderPort); }
					}
				}
				i += static_cast<quint8>(datagram.at(i + 1)) + 12;
			} else {
				i += static_cast<quint8>(datagram.at(i + 1)) + 12;
			}
		} else { i++; }
	}

	return need;
}

void TeamModeLink::_handleCommandLong(QHostAddress sender, quint16 senderPort, mavlink_message_t message)
{
	mavlink_command_long_t command_long;
	mavlink_msg_command_long_decode(&message, &command_long);
	bool support = true, failed = false;
	if(command_long.command == MAV_CMD_USER_1) {
		const UDPCLient* target = _teamModeConfig->targetHost();
		if(target == nullptr) {
			if(command_long.param1 == 0) {
				failed = true;
			} else {
				_teamModeConfig->setHost(sender.toString(), senderPort);
			}
		} else if(target->address == sender && target->port == senderPort) {
			if(command_long.param1 == 0) {
				_teamModeConfig->clearHost();
			}
		} else {
			failed = true;
		}
	} else {
		support = false;
	}
	mavlink_message_t message_ack;
	mavlink_msg_command_ack_pack_chan(command_long.target_system,
					  command_long.target_component,
					  MAVLINK_COMM_NUM_BUFFERS - 1,
					  &message_ack,
					  command_long.command,
                      support ? (failed ? MAV_RESULT_FAILED : MAV_RESULT_ACCEPTED) : MAV_RESULT_UNSUPPORTED,
					  0, command_long.param1, message.sysid, message.compid);
	uint8_t buffer[MAVLINK_MAX_PACKET_LEN];
	int len = mavlink_msg_to_send_buffer(buffer, &message_ack);
	if(_running) { _socket->writeDatagram(reinterpret_cast<const char*>(buffer), len, sender, senderPort); }
}

void TeamModeLink::_handleCommandAck(QHostAddress sender, quint16 senderPort, mavlink_message_t message)
{

}

void TeamModeLink::disconnect(void)
{
	const UDPCLient* client = _teamModeConfig->targetHost();
	if(client && _socket) {
		mavlink_message_t msg;
		mavlink_command_long_t cmd;
		memset(&cmd, 0, sizeof(cmd));
		cmd.target_system =     255;
        cmd.target_component =  MAV_COMP_ID_MISSIONPLANNER;
		cmd.command =           MAV_CMD_USER_1;
		cmd.confirmation =      1;
		cmd.param1 =            0;
		cmd.param2 =            1;
		mavlink_msg_command_long_encode_chan(255,
                             MAV_COMP_ID_MISSIONPLANNER,
						     MAVLINK_COMM_NUM_BUFFERS - 1,
						     &msg,
						     &cmd);
		uint8_t buffer[MAVLINK_MAX_PACKET_LEN];
		int len = mavlink_msg_to_send_buffer(buffer, &msg);
		_socket->writeDatagram(reinterpret_cast<const char*>(buffer), len, client->address, client->port);
	}
	_running = false;
	quit();
	wait();
	if(_socket) {
		// Make sure delete happen on correct thread
		_socket->deleteLater();
		_socket = nullptr;
		emit disconnected();
	}
	_connectState = false;
}

bool TeamModeLink::_connect(void)
{
	if(this->isRunning() || _running) {
		_running = false;
		quit();
		wait();
	}
	_running = true;
	start(NormalPriority);
	return true;
}

bool TeamModeLink::_hardwareConnect()
{
	if(_socket) {
		delete _socket;
		_socket = nullptr;
	}
	QHostAddress host = QHostAddress::AnyIPv4;
	_socket = new QUdpSocket(this);
	_socket->setProxy(QNetworkProxy::NoProxy);
	_connectState = _socket->bind(host, _teamModeConfig->localPort(),
				      QAbstractSocket::ReuseAddressHint | QUdpSocket::ShareAddress);
	if(_connectState) {
		_socket->joinMulticastGroup(QHostAddress("224.0.0.1"));
		//-- Make sure we have a large enough IO buffers
#ifdef __mobile__
		_socket->setSocketOption(QAbstractSocket::SendBufferSizeSocketOption,     64 * 1024);
		_socket->setSocketOption(QAbstractSocket::ReceiveBufferSizeSocketOption, 128 * 1024);
#else
		_socket->setSocketOption(QAbstractSocket::SendBufferSizeSocketOption,    256 * 1024);
		_socket->setSocketOption(QAbstractSocket::ReceiveBufferSizeSocketOption, 512 * 1024);
#endif
		QObject::connect(_socket, &QUdpSocket::readyRead, this, &TeamModeLink::readBytes);
		emit connected();
	} else {
		emit communicationError(tr("TeamMode Link Error"), tr("Error binding TeamMode port: %1").arg(_socket->errorString()));
	}
	return _connectState;
}

bool TeamModeLink::isConnected() const
{
	return _connectState;
}
