#include "mDNSManager.h"
#include "LinkManager.h"
#include "SettingsManager.h"
#include "UDPLink.h"
#include "TCPLink.h"
#include <QQmlEngine>

QGC_LOGGING_CATEGORY(mDNSManagerLog, "mDNSManagerLog")
QGC_LOGGING_CATEGORY(mDNSManagerVerboseLog, "mDNSManagerVerboseLog")

MDNSService::MDNSService(const QMdnsEngine::Service& service, QObject* parent)
    : QObject(parent)
{
    _name = QString(service.name());
    _type = QString(service.type());
    _host = QString(service.hostname());
    _port = service.port();
    QMap<QByteArray, QByteArray>::const_iterator it;
    for(it = service.attributes().constBegin(); it != service.attributes().constEnd(); it++) {
        if(QString(it.key()).compare("ipv4") == 0) {
            _host = QString(it.value());
        } else {
            _functions.append(QString(it.key()));
            _dataList.append(QString(it.value()));
        }
    }
}

void MDNSService::refresh(const QMap<QByteArray, QByteArray>& attributes)
{
    _functions.clear();
    _dataList.clear();
    QMap<QByteArray, QByteArray>::const_iterator it;
    for(it = attributes.constBegin(); it != attributes.constEnd(); it++) {
        _functions.append(QString(it.key()));
        _dataList.append(QString(it.value()));
    }
    emit refreshFunction();
}

mDNSManager::mDNSManager(QGCApplication* app, QGCToolbox* toolbox)
    : QGCTool(app, toolbox)
    , _hostname(&_server)
    , _type("codev")
{
    connect(&_hostname, &QMdnsEngine::Hostname::hostnameChanged, this, [this](const QByteArray &hostname) {
        qInfo() << tr("Hostname changed to %1").arg(QString(hostname));
        QMdnsEngine::Resolver* mResolver = new QMdnsEngine::Resolver(&_server, hostname, nullptr, this);
        connect(mResolver, &QMdnsEngine::Resolver::resolved, this, &mDNSManager::_refreshServiceAddress);
    });
}

mDNSManager::~mDNSManager()
{
    if(_browser) {
        delete _browser;
    }
}

void mDNSManager::_refreshServiceAddress(const QHostAddress &address)
{
    _hostAddress = address;
    foreach(QString key, _providers.keys()) {
        _providers[key].first.setName(QString("%1.%2.%3").arg(key).arg(_type).arg(_hostAddress.toString()).toUtf8());
        _providers[key].first.addAttribute("ipv4", _hostAddress.toString().toUtf8());
        _providers[key].second->update(_providers[key].first);
    }
    sender()->deleteLater();
}

void mDNSManager::setToolbox(QGCToolbox *toolbox)
{
    QGCTool::setToolbox(toolbox);
    qmlRegisterUncreatableType<MDNSService>("CustomQuickInterface", 1, 0, "MDNSService", "Reference only");
    _autoConnectSettings = toolbox->settingsManager()->autoConnectSettings();
    _linkManager = toolbox->linkManager();

    _browser = new QMdnsEngine::Browser(&_server, QMdnsEngine::MdnsBrowseType);
    connect(_browser, &QMdnsEngine::Browser::serviceAdded, this, &mDNSManager::_browserServiceAdded);
    connect(_browser, &QMdnsEngine::Browser::serviceUpdated, this, &mDNSManager::_browserServiceUpdated);
    connect(_browser, &QMdnsEngine::Browser::serviceRemoved, this, &mDNSManager::_browserServiceRemvoed);
}

void mDNSManager::registerProvider(QString name, const quint16& port, const QMap<QByteArray, QByteArray>& attributes)
{
    qCDebug(mDNSManagerLog) << "Creating provider:" << name;
    QMdnsEngine::Service service;
    service.setType((name + "." + _type).toUtf8());
    service.setPort(port);
    service.setAttributes(attributes);
    QSharedPointer<QMdnsEngine::Provider> provider;
    if(!_hostAddress.isNull()) {
        provider.reset(new QMdnsEngine::Provider(&_server, &_hostname, this));
        service.setName(QString("%1.%2.%3").arg(name).arg(_type).arg(_hostAddress.toString()).toUtf8());
        service.addAttribute("ipv4", _hostAddress.toString().toUtf8());
        provider->update(service);
    }
    _providers[name] = QPair<QMdnsEngine::Service, QSharedPointer<QMdnsEngine::Provider>>(service, provider);
}

void mDNSManager::unregisterProvider(QString name)
{
    if(_providers.contains(name)) {
        _providers[name].second.clear();
        _providers.remove(name);
    }
}

void mDNSManager::_updateCodevService(const QMdnsEngine::Service &service, bool remove)
{
    QString ojbName;
    ojbName.append(service.name());
    ojbName.append(service.type());
    ojbName.append(service.hostname());
    ojbName += QString::number(service.port());

    int i = 0;
    for(;i < _serviceOnLAN.count();) {
        if(_serviceOnLAN[i]->objectName().compare(ojbName) == 0) {
            break;
        } else {
            i++;
        }
    }

    if(remove) {
        if(i != _serviceOnLAN.count()) {
            _serviceOnLAN.removeAt(i);
        }
    } else {
        if(i == _serviceOnLAN.count()) {
            MDNSService* s = new MDNSService(service);
            s->setObjectName(ojbName);
            _serviceOnLAN.append(s);
        } else {
            _serviceOnLAN.value<MDNSService*>(i)->refresh(service.attributes());
        }
    }
}

void mDNSManager::_browserServiceAdded(const QMdnsEngine::Service &service)
{
    if(service.type().startsWith("_mavlink")) {
        if (_autoConnectSettings->autoConnectZeroConf()->rawValue().toBool()) {
            qCDebug(mDNSManagerVerboseLog) << "Found Zero-Conf:" << service.type() << service.name() << service.hostname() << service.port() << service.attributes();
            
            auto checkIfConnectionLinkExist = [this](LinkConfiguration::LinkType linkType, const QString& linkName){
                QList<SharedLinkInterfacePtr> links = _linkManager->links();
                for (const auto& link : qAsConst(links)) {
                    SharedLinkConfigurationPtr linkConfig = link->linkConfiguration();
                    if (linkConfig->type() == linkType && linkConfig->name() == linkName) {
                        return true;
                    }
                }

                return false;
            };

            // Windows dont accept trailling dots in mdns
            // http://www.dns-sd.org/trailingdotsindomainnames.html
            QString hostname = service.hostname();
            if(hostname.endsWith('.')) {
                hostname.chop(1);
            }

            if(service.type().startsWith("_mavlink._udp")) {
                static QString udpName("ZeroConf UDP");
                if (!checkIfConnectionLinkExist(LinkConfiguration::TypeUdp, udpName)) {
                    auto link = new UDPConfiguration(udpName);
                    link->addHost(hostname, service.port());
                    link->setAutoConnect(true);
                    link->setDynamic(true);
                    SharedLinkConfigurationPtr config = _linkManager->addConfiguration(link);
                    _linkManager->createConnectedLink(config);
                }
            } else if(service.type().startsWith("_mavlink._tcp")) {
                static QString tcpName("ZeroConf TCP");
                if (!checkIfConnectionLinkExist(LinkConfiguration::TypeTcp, tcpName)) {
                    auto link = new TCPConfiguration(tcpName);
                    QHostAddress address(hostname);
                    link->setAddress(address);
                    link->setPort(service.port());
                    link->setAutoConnect(true);
                    link->setDynamic(true);
                    SharedLinkConfigurationPtr config = _linkManager->addConfiguration(link);
                    _linkManager->createConnectedLink(config);
                }
            }
        }
    } else if(service.type().endsWith((_type + ".").toUtf8())) {
        qCDebug(mDNSManagerVerboseLog) << "Found Codev service:" << service.type() << service.name() << service.hostname() << service.port() << service.attributes();
        _updateCodevService(service);
    }
}

void mDNSManager::_browserServiceUpdated(const QMdnsEngine::Service &service)
{
    if(service.type().startsWith(_type.toUtf8())) {
        qCDebug(mDNSManagerVerboseLog) << "Update Codev service:" << service.type() << service.name() << service.hostname() << service.port() << service.attributes();
        _updateCodevService(service);
    }
}

void mDNSManager::_browserServiceRemvoed(const QMdnsEngine::Service &service)
{
    if(service.type().startsWith(_type.toUtf8())) {
        qCDebug(mDNSManagerVerboseLog) << "Remove Codev service:" << service.type() << service.name() << service.hostname() << service.port() << service.attributes();
        _updateCodevService(service, true);
    }
}
