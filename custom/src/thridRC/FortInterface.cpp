#include "FortInterface.h"
#include "QGCLoggingCategory.h"
#include <QSerialPortInfo>
#include "CustomQmlInterface.h"

QGC_LOGGING_CATEGORY(FortInterfaceLog, "FortInterfaceLog")
#define TRANSLATE_CH(x) static_cast<int>(1500 + x / 1023.0f * 500.0f)
#define TRANSLATE_CH_BOOL(b) (b ? 2000 : 1000)

uint16_t checksum16(uint8_t* data, int count)
{
    uint16_t sum1 = 0;
    uint16_t sum2 = 0;
    int index;

    for(index = 0; index < count; ++index) {
        sum1 = (sum1 + data[index]) & 255;
        sum2 = (sum2 + sum1) & 255;
    }

    return (sum2 << 8) | sum1;
}

FortInterface::FortInterface()
{
    _timer.setInterval(500);
    _timer.setSingleShot(false);
    connect(&_timer, &QTimer::timeout, this, &FortInterface::_timeout);
    _timer.start();
}

FortInterface::~FortInterface()
{
    stop();
}

void FortInterface::_timeout()
{
    if(_running) {
        _running = false;
        emit runningChanged();
    }
}

bool FortInterface::start()
{
    stop();

    QList<QSerialPortInfo> portList = QSerialPortInfo::availablePorts();
    for (const QSerialPortInfo& portInfo: portList) {
        if(isEquel(portInfo.vendorIdentifier(), portInfo.productIdentifier())) {
            _port = new QSerialPort(portInfo);
            break;
        }
    }
    if(_port) {
        QObject::connect(_port, &QIODevice::readyRead, this, &FortInterface::_readBytes);
        _port->open(QIODevice::ReadWrite);
        if (!_port->isOpen()) {
            qCWarning(FortInterfaceLog) << "open failed" << _port->errorString() << _port->error() << _port->portName();
            _port->close();
            delete _port;
            _port = nullptr;
        } else {
            _port->setDataTerminalReady(true);
            _port->setBaudRate(115200);
            return true;
        }
    }
    return false;
}

void FortInterface::stop()
{
    if(_port) {
        qCDebug(FortInterfaceLog) << QString::number((qulonglong)this, 16) << "closing port";
        _port->close();
        QObject::disconnect(_port, &QIODevice::readyRead, this, &FortInterface::_readBytes);

        delete _port;
        _port = nullptr;
    }
}

bool FortInterface::isEquel(quint16 vid, quint16 pid)
{
    return (vid == 0x2A99 && pid == 0xC011);
}

void FortInterface::_readBytes()
{
    if (_port && _port->isOpen()) {
        qint64 byteCount = _port->bytesAvailable();
        if (byteCount) {
            QByteArray buffer;
            buffer.resize(byteCount);
            _port->read(buffer.data(), buffer.size());
            for (int position = 0; position < buffer.size(); position++) {
                quint8 c = buffer[position];
                quint16 crc = 0;
                switch (_fort_parse_state) {
                case FORT_PARSE_STATE_END:
                case FORT_PARSE_STATE_CRCE:
                case FORT_PARSE_STATE_IDLE: if(c == 0x10) { _fort_status.pre1 = 0x10; _fort_parse_state = FORT_PARSE_STATE_PRE1; } break;
                case FORT_PARSE_STATE_PRE1: if(c == 0x01) { _fort_status.pre2 = 0x01; _fort_parse_state = FORT_PARSE_STATE_PRE2; } break;
                case FORT_PARSE_STATE_PRE2: { _fort_status.id = c; _fort_parse_state = FORT_PARSE_STATE_MSGID; } break;
                case FORT_PARSE_STATE_MSGID:
                {
                    _fort_status.len = c;
                    _fort_status.index = 0;
                    _fort_status.crc16 = 0;
                    if(_fort_status.len > FORT_MAX_PAYLOAD_LENGTH) {
                        _fort_parse_state = FORT_PARSE_STATE_IDLE;
                    } else if(_fort_status.len == 0) {
                        _fort_parse_state = FORT_PARSE_STATE_DATA;
                    } else {
                        _fort_parse_state = FORT_PARSE_STATE_LENGTH;
                    }
                }
                break;
                case FORT_PARSE_STATE_LENGTH:
                {
                    _fort_status.data[_fort_status.index++] = c;
                    if(_fort_status.index == _fort_status.len) {
                        _fort_parse_state = FORT_PARSE_STATE_DATA;
                    }
                }
                break;
                case FORT_PARSE_STATE_DATA:
                {
                    _fort_status.crc16 = c;
                    _fort_parse_state = FORT_PARSE_STATE_CRC1;
                }
                break;
                case FORT_PARSE_STATE_CRC1:
                {
                    _fort_status.crc16 |= c<<8;
                    crc = checksum16(&_fort_status.pre1, _fort_status.len + 4);
                    if(crc != _fort_status.crc16)
                        _fort_parse_state = FORT_PARSE_STATE_CRCE;
                    else _fort_parse_state = FORT_PARSE_STATE_END;
                }
                break;
                default: break;
                }
                if(_fort_parse_state == FORT_PARSE_STATE_END && _fort_status.id == 0x10) {
                    _timer.start();
                    if(!_running) {
                        _running = true;
                        emit runningChanged();
                    }
                    int size = qMin<int>(_fort_status.len, sizeof(_payload));
                    memset(_payload, 0, sizeof(_payload));
                    memcpy(_payload, _fort_status.data, size);
                    if(_enabled) {
                        _rawChannels[0] = TRANSLATE_CH(RX());                      //0 Aircraft Roll
                        _rawChannels[1] = 3000 - TRANSLATE_CH(RY());               //1 Aricraft Pitch
                        _rawChannels[2] = TRANSLATE_CH(LY());                      //2 Aricraft throttle
                        _rawChannels[3] = TRANSLATE_CH(LX());                      //3 Aricraft Yaw
                        _rawChannels[4] = 1500;                                    //4
                        _rawChannels[5] = 1500;                                    //5
                        _rawChannels[6] = 1000;                                    //6 Aricraft RTL(Disable)
                        _rawChannels[7] = 1000;                                    //7 Aricraft Stop
                        _rawChannels[8] = TRANSLATE_CH(LZ());                      //8 Gimbal Pitch
                        _rawChannels[9] = TRANSLATE_CH(RZ());                      //9 Gimbal Yaw
                        _rawChannels[10] = (LL() ? 1000 : (LR() ? 2000 : 1500));   //10 Gimbal Zoom
                        _rawChannels[11] = 3000 - TRANSLATE_CH_BOOL(LU());         //11 Camera Takephoto
                        _rawChannels[12] = 3000 - TRANSLATE_CH_BOOL(RU());         //12 Camera Video
                        _rawChannels[13] = 1000;                                   //13
                        _rawChannels[14] = 1000;                                   //14
                        _rawChannels[15] = 1000;                                   //15
                        _rawChannels[16] = 1000;                                   //16
                        _rawChannels[17] = 1000;                                   //17
                        emit rcChannelValues(_rawChannels, 18);

                        bool btn = RD();
                        if(btn != _rd_button_pressed) {
                            _rd_button_pressed = btn;
                            //emit buttonPressed(CustomQmlInterface::CUSTOM_FUNCTION_IR_SWITCH, _rd_button_pressed);
                        }

                        btn = RL();
                        if(btn != _rl_button_pressed) {
                            _rl_button_pressed = btn;
                            //emit buttonPressed(CustomQmlInterface::CUSTOM_FUNCTION_THERMAL_ZOOM, _rl_button_pressed);
                        }

                        btn = RR();
                        if(btn != _rr_button_pressed) {
                            _rr_button_pressed = btn;
                           // emit buttonPressed(CustomQmlInterface::CUSTOM_FUNCTION_GIMBAL_RESET, _rr_button_pressed);
                        }

                        static int ld_delay_count = 0;
                        btn = LD();
                        if(btn != _ld_button_pressed) {
                            _ld_button_pressed = btn;
                            if(!_ld_button_pressed && !_ld_button_pressed_delay) {
                                _enabled = !_enabled;
                                emit enabledChanged();
                            }
                        }
                        if(btn) {
                            if(!_ld_button_pressed_delay && ld_delay_count++ > 150) { // 20ms * 150 = 3000ms
                                _ld_button_pressed_delay = true;
                                //emit buttonPressed(CustomQmlInterface::CUSTOM_FUNCTION_AIRCRAFT_RTL, _ld_button_pressed_delay);
                            }
                        } else if(_ld_button_pressed_delay) {
                            ld_delay_count = 0;
                            _ld_button_pressed_delay = false;
                            //emit buttonPressed(CustomQmlInterface::CUSTOM_FUNCTION_AIRCRAFT_RTL, _ld_button_pressed_delay);
                        }
                    } else {
                        _rawChannels[0] = 1500;                      //0 Aircraft Roll
                        _rawChannels[1] = 1500;                      //1 Aricraft Pitch
                        _rawChannels[2] = 1500;                      //2 Aricraft throttle
                        _rawChannels[3] = 1500;                      //3 Aricraft Yaw
                        _rawChannels[4] = 1500;                      //4
                        _rawChannels[5] = 1500;                      //5
                        _rawChannels[6] = 1000;                      //6 Aricraft RTL(Disable)
                        _rawChannels[7] = 1000;                      //7 Aricraft Stop
                        _rawChannels[8] = 1500;                      //8 Gimbal Pitch
                        _rawChannels[9] = 1500;                      //9 Gimbal Yaw
                        _rawChannels[10] = 1500;                     //10 Gimbal Zoom
                        _rawChannels[11] = 2000;                     //11 Camera Takephoto
                        _rawChannels[12] = 2000;                     //12 Camera Video
                        _rawChannels[13] = 1000;                     //13
                        _rawChannels[14] = 1000;                     //14
                        _rawChannels[15] = 1000;                     //15
                        _rawChannels[16] = 1000;                     //16
                        _rawChannels[17] = 1000;                     //17
                        emit rcChannelValues(_rawChannels, 18);

                        bool btn = LD();
                        if(btn != _ld_button_pressed) {
                            _ld_button_pressed = btn;
                            if(!_ld_button_pressed) {
                                _enabled = !_enabled;
                                emit enabledChanged();
                            }
                        }

                        // reset all pressed status
                        btn = false;
                        if(btn != _rd_button_pressed) {
                            _rd_button_pressed = btn;
                            //emit buttonPressed(CustomQmlInterface::CUSTOM_FUNCTION_IR_SWITCH, _rd_button_pressed);
                        }
                        if(btn != _rl_button_pressed) {
                            _rl_button_pressed = btn;
                            //emit buttonPressed(CustomQmlInterface::CUSTOM_FUNCTION_THERMAL_ZOOM, _rl_button_pressed);
                        }
                        if(btn != _rr_button_pressed) {
                            _rr_button_pressed = btn;
                           // emit buttonPressed(CustomQmlInterface::CUSTOM_FUNCTION_GIMBAL_RESET, _rr_button_pressed);
                        }
                        if(btn != _ld_button_pressed_delay) {
                            _ld_button_pressed_delay = false;
                           // emit buttonPressed(CustomQmlInterface::CUSTOM_FUNCTION_AIRCRAFT_RTL, _ld_button_pressed_delay);
                        }
                    }

                    qCDebug(FortInterfaceLog) << _rawChannels[0] << _rawChannels[1] << _rawChannels[2]
                                              << _rawChannels[3] << _rawChannels[4] << _rawChannels[5]
                                              << _rawChannels[6] << _rawChannels[7] << _rawChannels[8]
                                              << _rawChannels[9] << _rawChannels[10] << _rawChannels[11]
                                              << _rawChannels[12];
                }
            }
        }
    } else {
        // Error occurred
        qCWarning(FortInterfaceLog) << "Serial port not readable" << _port->portName();
    }
}
