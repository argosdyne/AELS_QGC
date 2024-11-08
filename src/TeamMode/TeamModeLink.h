#ifndef TEAMMODELINK_H
#define TEAMMODELINK_H
#include "UDPLink.h"
#include <QElapsedTimer>

class TeamModeConfiguration : public LinkConfiguration
{
	Q_OBJECT
public:
	Q_PROPERTY(bool connected READ connected NOTIFY connectedChanged)
	bool connected() const { return _targetHost != nullptr; }

	Q_PROPERTY(QString targetName READ targetName NOTIFY connectedChanged)
	QString targetName() const { return _targetHost != nullptr ? _targetHost->address.toString() : "0.0.0.0"; }

	TeamModeConfiguration(const QString& name)
		: LinkConfiguration(name)
        , _localPort(14599)
	{
		_unbindTimer.setInterval(2000);
		_unbindTimer.setSingleShot(true);
		connect(&_unbindTimer, &QTimer::timeout, this, &TeamModeConfiguration::_forceUnbind);
		
		_targetTimer.setInterval(10000);
        _targetTimer.setSingleShot(true);
        connect(&_targetTimer, &QTimer::timeout, this, &TeamModeConfiguration::_forceUnbind);
        connect(this, &TeamModeConfiguration::targetTimerStart, this, [this] {
            _targetTimer.start();
        });
	}
	~TeamModeConfiguration()
	{
		_unbindTimer.stop();
		QMutexLocker locker(&targetMutex);
		delete _targetHost;
		_targetHost = nullptr;
	}

	Q_INVOKABLE void tiggerUnBind(bool ack = true);

	quint16 localPort() { return _localPort; }
	void setHost(const QString& host, quint16 port)
	{
		QMutexLocker locker(&targetMutex);
		if(_targetHost) {
			if(!(_targetHost->address == QHostAddress(host) && _targetHost->port == port)) {
				delete _targetHost;
				_targetHost = new UDPCLient(QHostAddress(host), port);
			}
		} else {
			_targetHost = new UDPCLient(QHostAddress(host), port);
		}
		emit connectedChanged();
		emit targetTimerStart();
	}
	void setLocalPort(quint16 port)
	{
		_localPort = port;
	}
	const UDPCLient* targetHost() { return _targetHost; }
	void clearHost();

	/// From LinkConfiguration
	LinkType type() final { return LinkConfiguration::TypeTeamMode; }
	void loadSettings(QSettings& settings, const QString& root) final {}
	void saveSettings(QSettings& settings, const QString& root) final {}
	QString settingsURL() { return ""; }
	QString settingsTitle() { return tr("Team Mode Settings"); }

	QMutex targetMutex;

signals:
	void connectedChanged();
	void targetTimerStart();

private slots:
	void _forceUnbind()
	{
		QMutexLocker locker(&targetMutex);
		delete _targetHost;
		_targetHost = nullptr;
		emit connectedChanged();
	}

private:
	UDPCLient* _targetHost{nullptr};
	quint16 _localPort;
	QTimer _unbindTimer;
	QTimer _targetTimer;
};

class TeamModeLink : public LinkInterface
{
	Q_OBJECT
	friend class TeamModeConfiguration;
public:
	TeamModeLink(SharedLinkConfigurationPtr& config);
	virtual ~TeamModeLink();

	bool    isConnected() const override;

	// Thread
	void    run() override;

	// These are left unimplemented in order to cause linker errors which indicate incorrect usage of
	// connect/disconnect on link directly. All connect/disconnect calls should be made through LinkManager.
	void    disconnect(void) override;

public slots:
	void    readBytes();

private slots:
	void    _writeBytes(const QByteArray data) override;

private:
	bool    _internalParse(QHostAddress sender, quint16 senderPort, QByteArray& datagram);
	void    _handleCommandLong(QHostAddress sender, quint16 senderPort, mavlink_message_t message);
	void    _handleCommandAck(QHostAddress sender, quint16 senderPort, mavlink_message_t message);

	// From LinkInterface
	bool    _connect(void) override;

	bool    _isIpLocal(const QHostAddress& add);
	bool    _hardwareConnect();
	void    _restartConnection();
	void    _writeDataGram(const QByteArray data, const UDPCLient* target);

	bool                    _running;
	QUdpSocket*             _socket;
	TeamModeConfiguration*  _teamModeConfig;
	bool                    _connectState;
	QList<QHostAddress>     _localAddresses;
};

#endif // TEAMMODELINK_H
