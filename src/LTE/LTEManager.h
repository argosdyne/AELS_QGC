#pragma once

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkCookieJar>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QProcess>
#include "QGCToolbox.h"
#include "QGCLoggingCategory.h"
#include "LTESettings.h"
#include "CustomPlugin.h"

Q_DECLARE_LOGGING_CATEGORY(LTEManagerLog)

class LTEItem : public QObject
{
    Q_OBJECT
public:
    Q_PROPERTY(QString name          MEMBER _name             NOTIFY stateChanged)
    Q_PROPERTY(bool running          MEMBER _running          NOTIFY stateChanged)
    Q_PROPERTY(bool hasAircraft      MEMBER _hasAircraft      NOTIFY stateChanged)
    Q_PROPERTY(bool hasAirport       MEMBER _hasAirport       NOTIFY stateChanged)
    Q_PROPERTY(bool hasGroundcontrol MEMBER _hasGroundcontrol NOTIFY stateChanged)
    Q_PROPERTY(bool frpcRunning      MEMBER _frpcRunning      NOTIFY frpcRunningChanged)
    Q_PROPERTY(bool busy             MEMBER _busy             NOTIFY busyChanged)

    QString name() const { return _name; }
    bool frpcRunning() const { return _frpcRunning; }

    LTEItem(QNetworkAccessManager* manager, LTESettings* settings, QObject* parent = nullptr);
    ~LTEItem();

    void update(const QJsonObject& data);

public slots:
    void start(QString name = "groundcontrol.ini");
    void stop();

signals:
    void stateChanged();
    void busyChanged();
    void frpcRunningChanged();
    void downloadComplete(QString localFile);

private slots:
    void _runFrpc(QString localFile);
    void _downloadFinished(void);
    void _downloadError(QNetworkReply::NetworkError code);
    void _frpcFinished(int exitCode, QProcess::ExitStatus exitStatus);

private:
    QString _name;
    bool _frpcRunning{false};
    bool _busy{false};
    bool _running{false};
    bool _hasAircraft{false};
    bool _hasAirport{false};
    bool _hasGroundcontrol{false};
    QMap<QString, QString> _downloads;

    QProcess *_frpc{nullptr};
    QNetworkAccessManager* _manager{nullptr};
    LTESettings* _settings{nullptr};
};

class LTEManager : public QGCTool
{
    Q_OBJECT
public:
    Q_PROPERTY(bool logined READ logined NOTIFY loginedChanged)
    bool logined() const { return _logined; }
    void setLogined(const bool& logined);

    Q_PROPERTY(bool logining READ logining NOTIFY loginingChanged)
    bool logining() const { return _logining; }
    void setLogining(const bool& logining);

    Q_PROPERTY(bool droneConnected READ droneConnected NOTIFY droneConnectedChanged)
    bool droneConnected();

    Q_PROPERTY(LTEItem* connectedDrone READ connectedDrone NOTIFY droneConnectedChanged)
    LTEItem* connectedDrone();

    Q_PROPERTY(LTESettings* settings READ settings CONSTANT)
    LTESettings* settings(){ return _settings; }

    Q_PROPERTY(QmlObjectListModel* drones READ drones CONSTANT)
    QmlObjectListModel* drones() { return &_drones; }

    LTEManager(QGCApplication *app, QGCToolbox *toolbox);
    ~LTEManager();

    LTEItem* getLTEItem(QString name);

    Q_INVOKABLE void login();
    Q_INVOKABLE void logout();
    Q_INVOKABLE void refresh();

    Q_INVOKABLE void start(LTEItem* item);

    // Override from QGCTool
    virtual void setToolbox(QGCToolbox *toolbox);

signals:
    void loginedChanged(bool logined);
    void loginingChanged(bool logining);
    void droneConnectedChanged();

private slots:
    void _handleNetworkManagerFinished(QNetworkReply *reply);

private:
    CustomPlugin* _plugin{nullptr};
    LTESettings* _settings{nullptr};
    QNetworkAccessManager _networkManager;
    QmlObjectListModel _drones;

    bool _logined{false};
    bool _logining{false};
};
