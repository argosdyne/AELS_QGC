#include "ThridRCFactory.h"
#include <QDebug>
#include <QQmlEngine>
#ifndef NO_SERIAL_LINK
#include <QSerialPortInfo>
#endif
#ifdef Q_OS_WIN
#include <Windows.h>
#include <Dbt.h>
#include <atlstr.h>
// #pragma comment(lib, "user32.lib")
#ifndef NO_SERIAL_LINK
#include "FortInterface.h"
FortInterface fortInterface;
#endif
#endif

#if defined(CUSTOM_NPU)
#ifndef NO_SERIAL_LINK
#include "T30Interface.h"
T30Interface t30Interface;
#endif
#endif

ThridRCFactory* ThridRCFactory::_instance = nullptr;

RCInterface::RCInterface()
{
    ThridRCFactory::instance()->registerInterfaceFactory(this);
}

ThridRCFactory::ThridRCFactory()
{
    qmlRegisterUncreatableType<ThridRCFactory>("CustomQmlInterface", 1, 0, "ThridRCFactory", "Reference only");

    connect(this, &ThridRCFactory::request, this, &ThridRCFactory::refreshInterface);
    connect(this, &ThridRCFactory::isHaveChanged, this, &ThridRCFactory::runningChanged);
    connect(this, &ThridRCFactory::isHaveChanged, this, &ThridRCFactory::enabledChanged);
}

void ThridRCFactory::registerInterfaceFactory(RCInterface* interf)
{
    connect(interf, &RCInterface::rcChannelValues, this, &ThridRCFactory::rcChannelValuesChanged);
    connect(interf, &RCInterface::buttonPressed, this, &ThridRCFactory::buttonPressedChanged);
    connect(interf, &RCInterface::runningChanged, this, &ThridRCFactory::runningChanged);
    connect(interf, &RCInterface::enabledChanged, this, &ThridRCFactory::enabledChanged);
    _interfaces.append(interf);
}

ThridRCFactory* ThridRCFactory::instance()
{
    if (!_instance) {
        _instance = new ThridRCFactory;
    }

    return _instance;
}

void ThridRCFactory::refreshInterface()
{
    if(_currentInterface) {
        _currentInterface->stop();
        _currentInterface = nullptr;
    }
    foreach(RCInterface* i, _interfaces) {
        if(i->start()) {
            _currentInterface = i;
            break;
        }
    }
    emit isHaveChanged();
}

bool ThridRCFactory::nativeEventFilter(const QByteArray &eventType, void *message, long *)
{
#ifdef Q_OS_WIN
    if(eventType == "windows_generic_MSG") {
        MSG* msg = reinterpret_cast<MSG*>(message);
        int msgType = msg->message;
        if(msgType == WM_DEVICECHANGE) {
            PDEV_BROADCAST_HDR lpdb = (PDEV_BROADCAST_HDR)(msg->lParam);
            switch(msg->wParam) {
            case DBT_DEVICEARRIVAL:
                if(lpdb->dbch_devicetype == DBT_DEVTYP_PORT) {
                    PDEV_BROADCAST_PORT lpdbp = (PDEV_BROADCAST_PORT)lpdb;
                    QString strName((QChar*)lpdbp->dbcp_name);
                #ifndef NO_SERIAL_LINK
                    QList<QSerialPortInfo> portList = QSerialPortInfo::availablePorts();
                    for (const QSerialPortInfo& portInfo: portList) {
                        if(portInfo.portName().compare(strName) == 0) {
                            foreach(RCInterface* i, _interfaces) {
                                if(i->isEquel(portInfo.vendorIdentifier(), portInfo.productIdentifier())) {
                                    if(_currentInterface == nullptr || _interfaces.indexOf(i) <= _interfaces.indexOf(_currentInterface))
                                        emit request();
                                    break;
                                }
                            }
                        }
                    }
                #endif
                }
                break;
            case DBT_DEVICEREMOVECOMPLETE:
                break;
            case DBT_DEVNODES_CHANGED:
                break;
            default:
                break;
            }
        }
    }
#endif
    return false;
}
