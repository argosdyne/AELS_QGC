#ifndef TEAMMODEROUTER_H
#define TEAMMODEROUTER_H
#include "QGCToolbox.h"
#include "QGCMAVLink.h"
#include "QmlObjectListModel.h"
#include <QUdpSocket>
#include <QMutex>
#include <QTimer>
#include <QTcpServer>
#include <QNetworkAddressEntry>
#define MAVLINK_TEAMMODE_COMM_ID (MAVLINK_COMM_NUM_BUFFERS - 1)
class LinkInterface;
class MAVLinkProtocol;
class MultiVehicleManager;
class Vehicle;
class CustomVideoReceiver;
class Fact;
class P2PDevice : public QObject
{
	Q_OBJECT
public:
	Q_PROPERTY(QString address READ address CONSTANT)
	QString address() const { return _address; }

	P2PDevice(QString name, QString address)
		: _address(address)
	{
		setObjectName(name);
	}

private:
	QString _address;
};

class SessionTarget : public QObject
{
	Q_OBJECT
public:
	Q_PROPERTY(QString name READ name CONSTANT)
	Q_PROPERTY(bool enable READ enable WRITE setEnable NOTIFY enableChanged)
	Q_PROPERTY(bool connected READ connected NOTIFY connectedChanged)

	SessionTarget(const QHostAddress& address_, quint16 port_)
		: _address(address_)
		, _port(port_)
	{
		_timer.setInterval(5000);
		_timer.setSingleShot(true);
		connect(&_timer, &QTimer::timeout, this, &SessionTarget::_timeout);
	}

	QString name() const { return _address.toString(); }
	bool enable() const { return _enable; }
	quint16 port() const { return _port; }
	QHostAddress address() const { return _address; }
	bool connected() const { return _connected; }

	void setEnable(const bool& enable)
	{
		if(_enable == enable) { return; }
		_enable = enable;
		emit enableChanged(_enable);
	}

	void setConnected(const bool& connected)
	{
		if(connected) {
			_timer.start();
		} else {
			_timer.stop();
		}
		if(_connected == connected) { return; }
		_connected = connected;
		emit connectedChanged(_connected);
	}

signals:
	void enableChanged(bool checked);
	void connectedChanged(bool connected);

private slots:
	void _timeout()
	{
		_connected = false;
		emit connectedChanged(_connected);
	}

private:
	QHostAddress _address;
	quint16      _port;
	bool         _enable{false};
	bool         _connected{false};
	QTimer       _timer;
};

class TeamModeRouter : public QObject
{
	Q_OBJECT
public:
	Q_PROPERTY(QmlObjectListModel* clients READ clients CONSTANT)
	QmlObjectListModel* clients() { return &_sessionTargets; }

	Q_PROPERTY(QmlObjectListModel* p2pDevices READ p2pDevices CONSTANT)
	QmlObjectListModel* p2pDevices() { return &_p2pDevices; }

	Q_PROPERTY(SessionTarget* current READ current NOTIFY connectedChanaged)
	SessionTarget* current();

	Q_PROPERTY(bool connected READ connected NOTIFY connectedChanaged)
	bool connected();

	Q_PROPERTY(QString localIP READ localIP NOTIFY localIPChanaged)
	QString localIP();

	Q_PROPERTY(QString remoteIP READ remoteIP NOTIFY connectedChanaged)
	QString remoteIP();

	Q_PROPERTY(bool pairing READ pairing NOTIFY pairingChanaged)
	bool pairing() const { return _isPairing; }

	Q_PROPERTY(bool isBind READ isBind NOTIFY pairingChanaged)
	bool isBind() const { return _isBind; }

	Q_PROPERTY(bool scanningDevice READ scanningDevice NOTIFY scanningDeviceChanged)
	bool scanningDevice() { return _scanningDevice; }

	Q_PROPERTY(QString localDeviceName READ localDeviceName NOTIFY localDeviceNameChanged)
	QString localDeviceName() const { return _localDeviceName; }

	Q_PROPERTY(bool p2pConnected READ p2pConnected NOTIFY p2pConnectedChanaged)
	bool p2pConnected() const { return _p2pConnected; }
	void setP2pConnected(const bool& connceted) {
		if(connceted == _p2pConnected) { return; }
		_p2pConnected = connceted;
		emit p2pConnectedChanaged();
	}

	bool ready() const { return _ready; }

	TeamModeRouter(MAVLinkProtocol* protocol, MultiVehicleManager* manager, QObject* parent = nullptr);
	~TeamModeRouter();

	void clearConnections();
	void mergeSlaveChannels(quint16* out);

	//-- LAN
	Q_INVOKABLE void connectTo(QObject* object);
	Q_INVOKABLE void disconnectTo(QObject* object);

	//-- P2P
	Q_INVOKABLE void startP2PScan(int delay = 0);
	Q_INVOKABLE void stopP2PScan();
	Q_INVOKABLE void connectP2PDevice(QString address);
	Q_INVOKABLE void disconnectP2PDevice();
	void p2pConnectionAction(bool active);

#if defined(ENABLE_WIFI_P2P)
    static void reset_jni();
#endif

public slots:
	void newP2PDevices(QStringList devices);
	void p2pConnectStateChanged(int state);
	void setLocalDeviceName(QString name) {
		if(_localDeviceName.compare(name) == 0) { return; }
		_localDeviceName = name;
		emit localDeviceNameChanged();
	}

private slots:
    void _handleMessageReceived(LinkInterface* link, mavlink_message_t message);
	void _socketReadyRead();
	void _handleStart(quint16 port);
	void _handleStop();
	void _handleFromSlave(SessionTarget* client, mavlink_message_t message);
	void _forwardToSlave(LinkInterface* link, mavlink_message_t message);
	void _forwardBadCrcToSlave(LinkInterface* link, mavlink_message_t message);
	void _broadcastIdentifyMessage();
	void _newHttpConnectSlot();
	void _getFromHttpClient();
	void _bindTimeout();

signals:
	void start(quint16 port);
	void stop();
	void receivedFromSlave(SessionTarget* client, mavlink_message_t message);
	void receivedFromProtocol(LinkInterface* link, mavlink_message_t message);
	void receivedBadCrcFromProtocol(LinkInterface* link, mavlink_message_t message);
	void connectedChanaged();
	void localIPChanaged();
	void pairingChanaged();
	void scanningDeviceChanged();
	void localDeviceNameChanged();
	void pairingTimeout();
	void pairingFailed();
	void p2pConnectedChanaged();
	void overrideRCChannelBuffer(const QByteArray data);

private:
	bool _handHeartBeatFromSlave(SessionTarget* client, Vehicle* vehicle, mavlink_message_t message);
	bool _handCommandAckFromSlave(SessionTarget* client, Vehicle* vehicle, mavlink_message_t message);
	bool _handCommandLongFromSlave(SessionTarget* client, Vehicle* vehicle, mavlink_message_t message);
	void _handRCChannelsOverride(mavlink_message_t message);

	void _scanP2pDevice();

	void _refreshCurrentEntry();
	bool isInSameSubnet(QHostAddress address);

	mavlink_rc_channels_override_t _slave_channels;
	bool _enableSlaveChannels{false};
	QTimer _slaveChannelsTimer;

	Fact* _teamModeFact{nullptr};
	QNetworkAddressEntry _currentEntry;
	QmlObjectListModel _sessionTargets;
	QMutex _sessionTargetsMutex;
	QUdpSocket* _link{nullptr};
	MAVLinkProtocol* _protocol{nullptr};
	MultiVehicleManager* _vehicleManager{nullptr};
	QTimer* _timer{nullptr};
	QTcpServer* _httpServer{nullptr};
	CustomVideoReceiver* _videoReceiver{nullptr};
	CustomVideoReceiver* _thermalVideoReceiver{nullptr};
	bool _ready{false};
	bool _scanningDevice{false};

	QmlObjectListModel _p2pDevices;
	QTimer _scanP2pDeviceTimer;
	bool _scanP2pEnabled{false};
	QString _localDeviceName;
	bool _p2pConnected{false};
	bool _p2pConnection{false};
	QTimer _p2pConnectionTiemOutTimer;

	bool _isPairing{false};
	bool _isBind{true};
	QTimer _bindTimer;
	int _bindRetries{-1};
};

#endif // TEAMMODEROUTER_H
