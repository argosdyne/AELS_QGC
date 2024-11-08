#include "DynamicRepcManager.h"
#include "QGCApplication.h"
#include "SettingsManager.h"
#include <QResource>
#include <QQmlEngine>

QGC_LOGGING_CATEGORY(DynamicRepcManagerLog, "DynamicRepcManagerLog")

DynamicRepcManager::DynamicRepcManager(QGCApplication* app, QGCToolbox* toolbox)
    : QGCTool(app, toolbox)
{
    qmlRegisterUncreatableType<DynamicRepcManager>("CustomQmlInterface", 1, 0, "DynamicRepcManager", "Reference only");
}

DynamicRepcManager::~DynamicRepcManager()
{

}

void DynamicRepcManager::setToolbox(QGCToolbox* toolbox)
{
    QGCTool::setToolbox(toolbox);

    regHost = new QRemoteObjectRegistryHost(QUrl("tcp://0.0.0.0:27400"));
    node = new QRemoteObjectNode(QUrl("tcp://127.0.0.1:27400"));
    QObject::connect(node->registry(), &QRemoteObjectRegistry::remoteObjectAdded, this, &DynamicRepcManager::_handleRemoteObjectAdded);
    QObject::connect(node->registry(), &QRemoteObjectRegistry::remoteObjectRemoved, this, &DynamicRepcManager::_handleRemoteObjectRemoved);
}

QObject* DynamicRepcManager::getReplica(QString name)
{
    foreach(QObject* obj, *_replicas.objectList()) {
        if(obj->objectName().compare(name) == 0) {
            return obj;
        }
    }

    return nullptr;
}

void DynamicRepcManager::_handleRemoteObjectAdded(const QRemoteObjectSourceLocation& info)
{
    if(getReplica(info.first) == nullptr) {
        qCDebug(DynamicRepcManagerLog) << "New QtRos source added: " << info;
        QRemoteObjectDynamicReplica* replica = node->acquireDynamic(info.first);
        DynamicRepcInterface* intf = new DynamicRepcInterface(replica);
        intf->setObjectName(info.first);
        _replicas.append(intf);
    }
}

void DynamicRepcManager::_handleRemoteObjectRemoved(const QRemoteObjectSourceLocation& info)
{
    qCDebug(DynamicRepcManagerLog) << "QtRos source removed: " << info;
    QObject* obj = getReplica(info.first);
    if(obj) {
        _replicas.removeOne(obj)->deleteLater();
    }
}

DynamicRepcInterface::DynamicRepcInterface(QRemoteObjectDynamicReplica* replica)
    : QObject(nullptr)
    , _replicaPtr(replica)
{
    QObject::connect(replica, &QRemoteObjectDynamicReplica::initialized, this, &DynamicRepcInterface::_handleRemoteObjectInitialized);
    QObject::connect(replica, &QRemoteObjectDynamicReplica::stateChanged, this, &DynamicRepcInterface::_hanldeRemoteObjectStateChanged);
}

void DynamicRepcInterface::_hanldeRemoteObjectStateChanged(QRemoteObjectDynamicReplica::State state, QRemoteObjectDynamicReplica::State oldState)
{
    if(oldState == QRemoteObjectDynamicReplica::Valid) {
        _ready = false;
        emit readyChanged();
    }
}

void DynamicRepcInterface::_handleRemoteObjectInitialized()
{
    QVariant value = _replicaPtr->property("rccData");
    if(value.isValid() && !value.isNull()) {
        QString cacheFile = QString("%1/%2.rcc").
            arg(qgcApp()->toolbox()->settingsManager()->appSettings()->parameterSavePath()).
            arg(this->objectName());
        if(_registered) {
            QResource::unregisterResource(cacheFile);
            _registered = false;
        }
        QFile file(cacheFile);
        if(file.open(QFile::WriteOnly | QFile::Truncate)) {
            file.write(qUncompress(value.toByteArray()));
            file.close();
            _registered = QResource::registerResource(cacheFile, "/ros");

            // Add Dynamic Property
            QString baseUrl = this->objectName().replace('~', "/ros/");
            QString videoOverlyQml = QString(":%1/VideoOverly.qml").arg(baseUrl);
            QString toolBarQml = QString(":%1/ToolBar.qml").arg(baseUrl);
            QString settingsQml = QString(":%1/Settings.qml").arg(baseUrl);
            QString switchQml = QString(":%1/Switch.qml").arg(baseUrl);

            if(QFileInfo::exists(videoOverlyQml)) {
                _videoOverlyQml = "qrc" + videoOverlyQml;
            }
            if(QFileInfo::exists(toolBarQml)) {
                _toolBarQml = "qrc" + toolBarQml;
            }
            if(QFileInfo::exists(settingsQml)) {
                _settingsQml = "qrc" + settingsQml;
            }
            if(QFileInfo::exists(switchQml)) {
                _switchQml = "qrc" + switchQml;
            }
        } else {
            qCWarning(DynamicRepcManagerLog) << "Create RCC File failed. Ros plugin may be not work properly.";
        }
    }
    _ready = true;
    emit readyChanged();
}
