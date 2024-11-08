#pragma once
#include <QMap>
#include <QTimer>
#include "QGCToolbox.h"
#include "QGCLoggingCategory.h"
#include "QmlObjectListModel.h"
#include <qmdnsengine/browser.h>
#include <qmdnsengine/cache.h>
#include <qmdnsengine/mdns.h>
#include <qmdnsengine/server.h>
#include <qmdnsengine/service.h>
#include <qmdnsengine/provider.h>
#include <qmdnsengine/hostname.h>
#include <qmdnsengine/resolver.h>

Q_DECLARE_LOGGING_CATEGORY(mDNSManagerLog)
Q_DECLARE_LOGGING_CATEGORY(mDNSManagerVerboseLog)

class AutoConnectSettings;
class MDNSService : public QObject
{
    Q_OBJECT
public:
    MDNSService(const QMdnsEngine::Service& service, QObject* parent = nullptr);

    Q_PROPERTY(QString     name      MEMBER _name CONSTANT)
    Q_PROPERTY(QString     type      MEMBER _type CONSTANT)
    Q_PROPERTY(QString     host      MEMBER _host CONSTANT)
    Q_PROPERTY(int         port      MEMBER _port CONSTANT)
    Q_PROPERTY(QStringList functions MEMBER _functions NOTIFY refreshFunction)
    Q_PROPERTY(QStringList dataList  MEMBER _dataList NOTIFY refreshFunction)

    void refresh(const QMap<QByteArray, QByteArray>& attributes);

signals:
    void refreshFunction();

private:
    QString _name;
    QString _type;
    QString _host;
    int _port;
    QStringList _functions;
    QStringList _dataList;
};

class mDNSManager : public QGCTool
{
    Q_OBJECT
public:
    Q_PROPERTY(QmlObjectListModel* serviceOnLAN READ serviceOnLAN CONSTANT)

    QmlObjectListModel* serviceOnLAN() { return &_serviceOnLAN; }

    mDNSManager(QGCApplication* app, QGCToolbox* toolbox);
    ~mDNSManager() override;

    // Override from QGCTool
    void setToolbox(QGCToolbox *toolbox) final;

public slots:
    void registerProvider(QString name, const quint16& port, const QMap<QByteArray, QByteArray>& attributes);
    void unregisterProvider(QString name);

private slots:
    void _browserServiceAdded(const QMdnsEngine::Service &service);
    void _browserServiceUpdated(const QMdnsEngine::Service &service);
    void _browserServiceRemvoed(const QMdnsEngine::Service &service);
    void _refreshServiceAddress(const QHostAddress &address);

private:
    void _updateCodevService(const QMdnsEngine::Service &service, bool remove = false);

    QMdnsEngine::Server _server;
    QMdnsEngine::Hostname _hostname;
    QMdnsEngine::Browser* _browser{nullptr};
    QMap<QString, QPair<QMdnsEngine::Service, QSharedPointer<QMdnsEngine::Provider>>> _providers;
    QString _type;
    QHostAddress _hostAddress;

    AutoConnectSettings* _autoConnectSettings{nullptr};
    LinkManager* _linkManager{nullptr};

    QmlObjectListModel _serviceOnLAN;
};
