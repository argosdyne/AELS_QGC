#include "T30Interface.h"
#include "QGCLoggingCategory.h"
#include <QQmlEngine>
#include <QString>
#include <QTimer>

QGC_LOGGING_CATEGORY(T30InterfaceLog, "T30InterfaceLog")
#define TRANSLATE_CH(x) static_cast<int>(1500 + (x - 600) / 600.0f * 500.0f)
#define TRANSLATE_CH_BOOL(b) (b ? 2000 : 1000)
T30Interface::T30Interface()
    : _portName("\\\\.\\COM5")
    , _baudRate(115200)
{
    QObject::connect(this, &T30Interface::write, this, &T30Interface::_writeBytes);
}

T30Interface::~T30Interface()
{
    stop();
}

void T30Interface::_writeBytes(const QByteArray data)
{
    if(_port && _port->isOpen()) {
        _port->write(data);
    } else {
        // Error occurred
        qCWarning(T30InterfaceLog) << "Serial port not writeable" << _portName;
    }
}

void T30Interface::_readBytes()
{
    if (_port && _port->isOpen()) {
        qint64 byteCount = _port->bytesAvailable();
        if (byteCount) {
            QByteArray buffer;
            buffer.resize(byteCount);
            _port->read(buffer.data(), buffer.size());
            for (int position = 0; position < buffer.size(); position++) {
                quint8 c = buffer[position];
                switch (_t30_parse_state) {
                case T30_PARSE_STATE_GOT_END:
                case T30_PARSE_STATE_IDLE: if(c == 0xFA) { _t30_parse_state = T30_PARSE_STATE_START; } break;
                case T30_PARSE_STATE_START: { _t30_status.func = c; _t30_parse_state = T30_PARSE_STATE_GOT_FUNCTION; } break;
                case T30_PARSE_STATE_GOT_FUNCTION: { _t30_status.len = c; _t30_parse_state = T30_PARSE_STATE_GOT_LENGTH1; } break;
                case T30_PARSE_STATE_GOT_LENGTH1:
                {
                    _t30_status.len |= c<<8;
                    if(_t30_status.len > T30_MAX_PAYLOAD_LENGTH) {
                        _t30_parse_state = T30_PARSE_STATE_IDLE;
                    } else {
                        _t30_parse_state = T30_PARSE_STATE_GOT_LENGTH2;
                    }
                }
                break;
                case T30_PARSE_STATE_GOT_LENGTH2:
                {
                    _t30_status.id = c;
                    _t30_status.index = 0;
                    if(_t30_status.len == 1) {
                        _t30_parse_state = T30_PARSE_STATE_GOT_DATA;
                    } else {
                        _t30_parse_state = T30_PARSE_STATE_GOT_MSGID;
                    }
                }
                break;
                case T30_PARSE_STATE_GOT_MSGID:
                {
                    _t30_status.data[_t30_status.index++] = c;
                    if(_t30_status.index == (_t30_status.len - 1)) {
                        _t30_parse_state = T30_PARSE_STATE_GOT_DATA;
                    }
                }
                break;
                case T30_PARSE_STATE_GOT_DATA:
                { 
                    if(c == 0x5F) { 
                        _t30_parse_state = T30_PARSE_STATE_GOT_END; 
                    } 
                }
                break;
                }
                if(_t30_parse_state == T30_PARSE_STATE_GOT_END && _t30_status.func == 0xA5) {
                    static int chn7Count = 0;
                    if(F1()) chn7Count = 40;
                    else if(chn7Count > 0) chn7Count--;
                    int chn7 = chn7Count > 0 ? 2000 : 1000;
                    int size = qMin<int>(_t30_status.len, sizeof(_payload));
                    memset(_payload, 0, sizeof(_payload));
                    memcpy(_payload, _t30_status.data, size);
                    _rawChannels[0] = TRANSLATE_CH(T4());                      //0 Aircraft Roll
                    _rawChannels[1] = 3000 - TRANSLATE_CH(T3());               //1 Aricraft Pitch
                    _rawChannels[2] = TRANSLATE_CH(T1());                      //2 Aricraft throttle
                    _rawChannels[3] = TRANSLATE_CH(T2());                      //3 Aricraft Yaw
                    _rawChannels[4] = 1500;                                    //4
                    _rawChannels[5] = 1500;                                    //5
                    _rawChannels[6] = TRANSLATE_CH(SA());                      //6 Aricraft RTL
                    _rawChannels[7] = chn7;//TRANSLATE_CH_BOOL(F1());          //7 Aricraft Stop
                    _rawChannels[8] = 3000 - TRANSLATE_CH(T5());               //8 Gimbal Pitch
                    _rawChannels[9] = TRANSLATE_CH(T6());                      //9 Gimbal Yaw
                    _rawChannels[10] = (F7() ? 1000 : (F8() ? 2000 : 1500));   //10 Gimbal Zoom
                    _rawChannels[11] = 3000 - TRANSLATE_CH(SC());              //11 Camera Takephoto
                    _rawChannels[12] = 3000 - TRANSLATE_CH(SF());              //12 Camera Video
                    _rawChannels[13] = 1000;                                   //13
                    _rawChannels[14] = 1000;                                   //14
                    _rawChannels[15] = 1000;                                   //15
                    _rawChannels[16] = 1000;                                   //16
                    _rawChannels[17] = 1000;                                   //17

                    emit rcChannelValues(_rawChannels, 18);
                    qCDebug(T30InterfaceLog) << _rawChannels[0] << _rawChannels[1] << _rawChannels[2]
                                             << _rawChannels[3] << _rawChannels[4] << _rawChannels[5]
                                             << _rawChannels[6] << _rawChannels[7] << _rawChannels[8]
                                             << _rawChannels[9] << _rawChannels[10] << _rawChannels[11]
                                             << _rawChannels[12];
                }
            }
        }
    } else {
        // Error occurred
        qCWarning(T30InterfaceLog) << "Serial port not readable" << _portName;
    }
}

bool T30Interface::start()
{
    if(_port) {
        qCDebug(T30InterfaceLog) << QString::number((qulonglong)this, 16) << "closing port";
        _port->close();
        QObject::disconnect(_port, &QIODevice::readyRead, this, &T30Interface::_readBytes);

        delete _port;
        _port = nullptr;
    }

    qCDebug(T30InterfaceLog) << "init " << _portName;
    _port = new QSerialPort(_portName, this);
    // QObject::connect(_port, static_cast<void (QSerialPort::*)(QSerialPort::SerialPortError)>(&QSerialPort::error), this, &T30Interface::linkError);
    QObject::connect(_port, &QIODevice::readyRead, this, &T30Interface::_readBytes);
    _port->open(QIODevice::ReadWrite);
    if (!_port->isOpen() ) {
        qWarning() << "open failed" << _port->errorString() << _port->error() << _portName;
        _port->close();
        delete _port;
        _port = nullptr;
    } else {
        _port->setDataTerminalReady(true);
        _port->setBaudRate(_baudRate);
        QTimer::singleShot(500, this, &T30Interface::enableDevice);
        return true;
    }
    return false;
}

void T30Interface::stop()
{
    if (_port) {
        // This prevents stale signals from calling the link after it has been deleted
        QObject::disconnect(_port, &QIODevice::readyRead, this, &T30Interface::_readBytes);
        _port->close();
        _port->deleteLater();
        _port = nullptr;
    }
}

void T30Interface::enableDevice()
{
    QByteArray data(7, 0);
    data[0] = 0xFA;
    data[1] = 0xE5;
    data[2] = 0x02;
    data[3] = 0x00;
    data[4] = 0x00;
    data[5] = 0x14;
    data[6] = 0x5F;
    emit write(data);
}
