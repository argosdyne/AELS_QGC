#include "CustomQmlInterface.h"
#include "CustomPlugin.h"
#include "LinkManager.h"
#include "CodevRTCMManager.h"

#define CHAR_NUMBER_EACH_ROW 30

CustomQmlInterface::CustomQmlInterface(QGCApplication* app, QGCToolbox* toolbox)
    : QGCTool(app, toolbox)
    , _plugin(qobject_cast<CustomPlugin*>(toolbox->corePlugin()))
    , _arManager(new ARManager(app, toolbox))
    , _codevRTCMManager(new CodevRTCMManager(app, toolbox))    
{

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

    _arManager->setToolbox(toolbox);
    _codevRTCMManager->setToolbox(toolbox);

#if defined(ENABLE_WIFI_P2P)
    connect(qgcApp(), &QGCApplication::teamModeLocalNameChanged, _teamModeRouter, &TeamModeRouter::setLocalDeviceName);
    connect(qgcApp(), &QGCApplication::teamModeConnectionChanged, _teamModeRouter, &TeamModeRouter::p2pConnectStateChanged);
    connect(qgcApp(), &QGCApplication::teamModeDeviceListChanged, _teamModeRouter, &TeamModeRouter::newP2PDevices);
    connect(qgcApp(), &QGCApplication::teamModeConnectionChanged, this, &CustomQmlInterface::_p2pConnectionStateChanged);
#endif    

    // _actionSound.setSource(QUrl::fromUserInput("qrc:/audio/action.wav"));
    // _actionSound.setLoopCount(1);
    // _actionSound.setVolume(1.0);
}

void CustomQmlInterface::playActionSound()
{
    if(_actionSound.isPlaying()) return;
    _actionSound.setLoopCount(1);
    _actionSound.play();
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
