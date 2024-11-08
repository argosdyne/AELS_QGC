#pragma once

#include <QRemoteObjectNode>
#include <QRemoteObjectDynamicReplica>
#include <QSharedPointer>
#include "QGCToolbox.h"
#include "QmlObjectListModel.h"
#include "QGCLoggingCategory.h"

Q_DECLARE_LOGGING_CATEGORY(DynamicRepcManagerLog)

class DynamicRepcInterface : public QObject
{
    Q_OBJECT
public:
    Q_PROPERTY(bool ready READ ready NOTIFY readyChanged)
    Q_PROPERTY(QString videoOverlyQml READ videoOverlyQml NOTIFY readyChanged)
    Q_PROPERTY(QString settingsQml READ settingsQml NOTIFY readyChanged)
    Q_PROPERTY(QString toolBarQml READ toolBarQml NOTIFY readyChanged)
    Q_PROPERTY(QString switchQml READ switchQml NOTIFY readyChanged)
    Q_PROPERTY(QObject* data READ data NOTIFY readyChanged)

    bool ready() const { return _ready; }
    QString videoOverlyQml() const { return _videoOverlyQml; }
    QString settingsQml() const { return _settingsQml; }
    QString toolBarQml() const { return _toolBarQml; }
    QString switchQml() const { return _switchQml; }
    QObject* data() const { return _replicaPtr.data(); }

    DynamicRepcInterface(QRemoteObjectDynamicReplica* replica);

signals:
    void readyChanged();

private slots:
    void _handleRemoteObjectInitialized();
    void _hanldeRemoteObjectStateChanged(QRemoteObjectDynamicReplica::State state, QRemoteObjectDynamicReplica::State oldState);

private:
    QSharedPointer<QRemoteObjectDynamicReplica> _replicaPtr;
    bool _ready{false};
    QString _videoOverlyQml;
    QString _settingsQml;
    QString _toolBarQml;
    QString _switchQml;
    bool _registered{false};
};

class DynamicRepcManager : public QGCTool
{
    Q_OBJECT
public:
    Q_PROPERTY(QmlObjectListModel* replicas READ replicas CONSTANT)
    QmlObjectListModel* replicas(void) { return &_replicas; }

    DynamicRepcManager(QGCApplication* app, QGCToolbox* toolbox);
    ~DynamicRepcManager() override;

    Q_INVOKABLE QObject* getReplica(QString name);

    // Overrides from QGCTool
    void setToolbox(QGCToolbox* toolbox) override;

private slots:
    void _handleRemoteObjectAdded(const QRemoteObjectSourceLocation& info);
    void _handleRemoteObjectRemoved(const QRemoteObjectSourceLocation& info);

private:
    QRemoteObjectRegistryHost* regHost{nullptr};
    QRemoteObjectNode* node{nullptr};
    QmlObjectListModel _replicas;
};
