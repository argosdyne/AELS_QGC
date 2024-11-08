#include "CustomQmlInterface.h"
#include "CustomPlugin.h"
#include "LinkManager.h"
//#include "CustomCameraControl.h"
#include "CodevRTCMManager.h"
#include "CustomSettings.h"
#include "mDNSManager.h"
#include "AVIATORInterface.h"
#include "LTEManager.h"

#define CHAR_NUMBER_EACH_ROW 30

CustomQmlInterface::CustomQmlInterface(QGCApplication* app, QGCToolbox* toolbox)
    : QGCTool(app, toolbox)
    , _plugin(qobject_cast<CustomPlugin*>(toolbox->corePlugin()))
    , _arManager(new ARManager(app, toolbox))
    , _codevRTCMManager(new CodevRTCMManager(app, toolbox))
    , _teamModeRouter(new TeamModeRouter(toolbox->mavlinkProtocol(), toolbox->multiVehicleManager()))
{
    if(_plugin->hasFrpc()) {
        _lteManager = new LTEManager(app, toolbox);
    }
    // We clear the parent on this object since we run into shutdown problems caused by hybrid qml app. Instead we let it leak on shutdown.
    setParent(nullptr);
    setToolbox(toolbox);
}

CustomQmlInterface::~CustomQmlInterface()
{
}

void CustomQmlInterface::setToolbox(QGCToolbox* toolbox)
{
    QGCTool::setToolbox(toolbox);
    qRegisterMetaType<SystemMessage::SystemMessageType>("SystemMessage::SystemMessageType");
    //qmlRegisterUncreatableType<CustomCameraControl>("CustomQmlInterface", 1, 0, "CustomCameraControl", "Reference only");

    _arManager->setToolbox(toolbox);
    _codevRTCMManager->setToolbox(toolbox);
    if(_plugin->hasFrpc()) {
        _lteManager->setToolbox(_toolbox);
    }

    _mDNSManager = toolbox->mdnsManager();
    //-- Check for persistent slave mode
    if(_plugin->slaveMode()) {
        _slaveModeChanged(true);
    } else {
        //-- Reset Slave Link
        _toolbox->settingsManager()->appSettings()->audioMuted()->setRawValue(false);
    }
    connect(_plugin, &CustomPlugin::slaveModeChanged, this, &CustomQmlInterface::_slaveModeChanged);
    connect(_plugin, &CustomPlugin::slaveModeChanged, this, &CustomQmlInterface::_teamModeChanged);
    //-- Team Mode
    connect(_plugin->settings()->teamMode(), &Fact::rawValueChanged, this, &CustomQmlInterface::_teamModeChanged);
#if defined(ENABLE_WIFI_P2P)
    connect(qgcApp(), &QGCApplication::teamModeLocalNameChanged, _teamModeRouter, &TeamModeRouter::setLocalDeviceName);
    connect(qgcApp(), &QGCApplication::teamModeConnectionChanged, _teamModeRouter, &TeamModeRouter::p2pConnectStateChanged);
    connect(qgcApp(), &QGCApplication::teamModeDeviceListChanged, _teamModeRouter, &TeamModeRouter::newP2PDevices);
    connect(qgcApp(), &QGCApplication::teamModeConnectionChanged, this, &CustomQmlInterface::_p2pConnectionStateChanged);
#endif
    _teamModeChanged();

    _actionSound.setSource(QUrl::fromUserInput("qrc:/audio/action.wav"));
    _actionSound.setLoopCount(1);
    _actionSound.setVolume(1.0);
}

void CustomQmlInterface::playActionSound()
{
    if(_actionSound.isPlaying()) return;
    _actionSound.setLoopCount(1);
    _actionSound.play();
}

void CustomQmlInterface::_slaveModeChanged(bool slaveMode)
{
    _teamModeLinkconfig.reset();
    if(slaveMode) {
        //-- Stop auto connect and disconnect all links
        LinkManager* pLinkMgr = _toolbox->linkManager();
        pLinkMgr->setConnectionsSuspended(QString(tr("Switching to Slave Mode")));
        pLinkMgr->disconnectAll();
        //-- Set Slave Link
        _toolbox->settingsManager()->appSettings()->audioMuted()->setRawValue(false);
        _toolbox->settingsManager()->autoConnectSettings()->autoConnectUDP()->setRawValue(false);
        _toolbox->settingsManager()->autoConnectSettings()->disableConnectSerial()->setRawValue(true);
        TeamModeConfiguration* teammodeConfig = new TeamModeConfiguration("TeamMode Link");
        //UDPConfiguration* udpConfig = new UDPConfiguration("UDP Link (AutoConnect)");
        teammodeConfig->setDynamic(true);
        teammodeConfig->setAutoConnect(true);
        teammodeConfig->setHighLatency(true);
        teammodeConfig->setLocalPort(DEFAULT_REMOTE_PORT_UDP_QGC_SLAVE);
        _teamModeLinkconfig = pLinkMgr->addConfiguration(teammodeConfig);
        //-- Enable slave link
        pLinkMgr->setConnectionsAllowed();
        pLinkMgr->createConnectedLink(_teamModeLinkconfig);
    } else {
        //-- Disconnect all links
        LinkManager* pLinkMgr = _toolbox->linkManager();
        pLinkMgr->setConnectionsSuspended(QString(tr("Switching to Master Mode")));
        pLinkMgr->disconnectAll();
        //-- Reset Slave Link
        _toolbox->settingsManager()->appSettings()->audioMuted()->setRawValue(true);
        _toolbox->settingsManager()->autoConnectSettings()->autoConnectUDP()->setRawValue(true);
        _toolbox->settingsManager()->autoConnectSettings()->disableConnectSerial()->setRawValue(false);
        //-- Enable normal link
        pLinkMgr->setConnectionsAllowed();
    }
    emit teamModeLinkChanged();
}

void CustomQmlInterface::_teamModeChanged()
{
    static Fact* teamMode = _plugin->settings()->teamMode();
    if(teamMode->rawValue().toInt() != 0 && !_plugin->slaveMode()) {
        emit _teamModeRouter->start(DEFAULT_REMOTE_PORT_UDP_QGC_SLAVE - 1);
    } else {
        emit _teamModeRouter->stop();
    }
    if(teamMode->rawValue().toInt() == 0) {
        _plugin->setSlaveMode(false);
    } else if(sender() == teamMode && _plugin->slaveMode() && teamModeLink()) {
        teamModeLink()->clearHost();
    }
    _teamModeRouter->p2pConnectionAction(teamMode->rawValue().toInt() == 2);
}

void CustomQmlInterface::_p2pConnectionStateChanged(int state)
{
    static Fact* teamModeFact = _plugin->settings()->teamMode();
    if(state == 1 && _plugin->slaveMode() && teamModeLink() && teamModeFact->rawValue().toInt() == 2) {
        teamModeLink()->clearHost();
    }
}

void CustomQmlInterface::showMessage(const QString& message, SystemMessage::SystemMessageType type)
{
    SystemMessage* m = new SystemMessage(this);
    m->setContext(message);
    m->setType(type);
    if(type != SystemMessage::SystemMessageType::Warning && type != SystemMessage::SystemMessageType::Error) {
        while (_normalSystemMessages.count() >= 5) _normalSystemMessages.first()->closeItstyle();
        _normalSystemMessages.append(m);
    }
    _systemMessages.append(m);
    _refreshSystemMessageUI(true);
}

void CustomQmlInterface::handleCustomButtonFunction(int type, bool pressed)
{
    if(type == CUSTOM_FUNCTION_COACH_WAYPOINT) {
        if(_plugin->coachMode()) emit coachWaypointTigger(pressed);
    } else if(type == CUSTOM_FUNCTION_THERMAL_ZOOM) {
        emit thermalZoomTigger(pressed);
    } else if(type == CUSTOM_FUNCTION_IR_SWITCH) {
        emit irSwitchTigger(pressed);
    } else if(type == CUSTOM_FUNCTION_GIMBAL_RESET) {
        emit gimbalResetTigger(pressed);
    } else if(type == CUSTOM_FUNCTION_AIRCRAFT_RTL) {
        if(pressed) {
            Vehicle* vehicle = _toolbox->multiVehicleManager()->activeVehicle();
            if(vehicle) {
                vehicle->guidedModeRTL(false);
            }
        }
    } else if(type == CUSTOM_FUNCTION_START_MISSION) {
        if(pressed) {
            Vehicle* vehicle = _toolbox->multiVehicleManager()->activeVehicle();
            if(vehicle) {
                vehicle->startMission();
            }
        }
    }
}

void CustomQmlInterface::_refreshSystemMessageUI(bool from)
{
    if(_group.state() == QAbstractAnimation::Running) _group.stop();
    _group.clear();
    float y = _defaultFontPixelHeight * 0.5;
    for(int i = _systemMessages.count() - 1; i >= 0; i--) {
        SystemMessage* m = _systemMessages.value<SystemMessage*>(i);
        QPropertyAnimation* animation = from ? m->createYAnimation(y - m->height(), y) : m->createYAnimation(m->y(), y);
        _group.addAnimation(animation);
        y += m->height() + _defaultFontPixelHeight * 0.5;
    }
    _group.start();
}

SystemMessage::SystemMessage(CustomQmlInterface* parent)
    : QObject(parent)
    , _width(0)
    , _height(0)
    , _opacity(1)
    , _customQmlInterface(parent)
    , _yAnimation(nullptr)
{
    QPropertyAnimation *opacityAnimation = new QPropertyAnimation(this, "opacity", this);
    opacityAnimation->setDuration(200);
    opacityAnimation->setStartValue(0);
    opacityAnimation->setEndValue(1);
    opacityAnimation->start();

    _timer.setSingleShot(true);
    connect(&_timer, &QTimer::timeout, this, &SystemMessage::startCloseItstyle);
}

QPropertyAnimation* SystemMessage::createYAnimation(QVariant from, QVariant to)
{
    _yAnimation = new QPropertyAnimation(this, "y", this);
    _yAnimation->setDuration(200);
    _yAnimation->setStartValue(from);
    _yAnimation->setEndValue(to);

    return _yAnimation;
}

void SystemMessage::startCloseItstyle()
{
    QPropertyAnimation *animation = new QPropertyAnimation(this, "opacity", this);
    animation->setDuration(2000);
    animation->setStartValue(1);
    animation->setEndValue(0);
    connect(animation, &QPropertyAnimation::finished, this, &SystemMessage::closeItstyle);
    animation->start();
}

void SystemMessage::closeItstyle()
{
    if(_customQmlInterface->_group.indexOfAnimation(_yAnimation) > -1) {
        _customQmlInterface->_group.removeAnimation(_yAnimation);
        _yAnimation->deleteLater();
        _yAnimation = nullptr;
    }
    int index = _customQmlInterface->_systemMessages.indexOf(this);
    _customQmlInterface->_normalSystemMessages.removeOne(this);
    _customQmlInterface->_systemMessages.removeAt(index)->deleteLater();
    if(index > 0) {
        _customQmlInterface->_refreshSystemMessageUI(false);
    }
}

QString SystemMessage::icon() const
{
    switch (_type) {
    case SystemMessageType::Info:
        return QString("qrc:/custom/img/png/info.png");
    case SystemMessageType::Error:
        return QString("qrc:/custom/img/png/error.png");
    case SystemMessageType::Warning:
        return QString("qrc:/custom/img/png/warning.png");
    case SystemMessageType::Success:
        return QString("qrc:/custom/img/png/success.png");;
    default:
        return QString();
    }
}

QString SystemMessage::color() const
{
    switch (_type) {
    case SystemMessageType::Info:
        return QString("#00DA90");
    case SystemMessageType::Error:
        return QString("red");
    case SystemMessageType::Warning:
        return QString("#FFC21E");
    case SystemMessageType::Success:
        return QString("#00DA90");;
    default:
        return QString("white");
    }
}

void SystemMessage::setContext(const QString &context)
{
    _context = context;
    _width = _customQmlInterface->_defaultFontPixelWidth * 1 * (CHAR_NUMBER_EACH_ROW + 3) + _customQmlInterface->_defaultFontPixelHeight * 1 * 2;
    _height = _customQmlInterface->_defaultFontPixelWidth * 1 * 2 + _customQmlInterface->_defaultFontPixelHeight * 1 * (_context.length() / CHAR_NUMBER_EACH_ROW + 1);
}

void SystemMessage::setType(const SystemMessageType &type)
{
    _type = type;
    if(_timer.isActive()) _timer.stop();
    if(type == SystemMessageType::Error) {
        _timer.start(10000);
    } else _timer.start(5000);
}

void SystemMessage::setOpacity(const float &opacity)
{
    _opacity = opacity;
    emit opacityChanged(_opacity);
}

void SystemMessage::setY(const float &y)
{
    _y = y;
    emit yChanged(_y);
}
