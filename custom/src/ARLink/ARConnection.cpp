#include "ARConnection.h"
#include <QNetworkProxy>
#include <QtConcurrent>

#define AR_PREAMBLE1 0xA2
#define AR_PREAMBLE2 0xA5

static quint16 crc16(quint8 *buffer, quint16 length)
{
    quint16 i = 0;
    quint16 j = 0;
    const quint16 polynom = 0x1021;
    quint16 crc = 0x0000;

    for (i = 0; i < length; ++i) {
        crc ^= (quint16)buffer[i] << 8;
        for (j = 0; j < 8; ++j) {
            crc = (crc & 0x8000) ? (crc << 1) ^ polynom : (crc << 1);
        }
    }

    return crc;
}

ARConnection::ARConnection(QString targetIP, quint16 targetPort)
    : _targetIP(targetIP)
    , _targetPort(targetPort)
    , _remoteTargetIP("192.168.241.101")
    , _remoteTargetPort(targetPort)
{
    QString tmpStr = _targetIP;
    QRegExp rx("(\\.\\d{1,3})");
    int pos = rx.lastIndexIn(tmpStr);
    if(rx.captureCount() > 0) {
        QString replace_str = rx.cap(1);
        _remoteTargetIP = tmpStr.remove(pos, replace_str.size()) + ".101";
    }

    memset(&_message, 0, sizeof(ar_message_t));
    memset(&_status, 0, sizeof(ar_status_t));
    QHostAddress host = QHostAddress::AnyIPv4;
    setProxy(QNetworkProxy::NoProxy);
    bind(host, _targetPort + 1, QAbstractSocket::ReuseAddressHint | QTcpSocket::ShareAddress);

    QObject::connect(this, &ARConnection::readyRead, this, &ARConnection::_socketReadyRead);
    QObject::connect(this, &ARConnection::connected, this, &ARConnection::_handleConnected);
    QObject::connect(this, &ARConnection::disconnected, this, &ARConnection::_handleDisconnected);
    QObject::connect(this, &ARConnection::enable, this, &ARConnection::_enable);
    QObject::connect(this, &ARConnection::asyncConnect, this, &ARConnection::_asyncConnect);
    QObject::connect(this, &ARConnection::asyncDisconnect, this, &ARConnection::_asyncDisconnect);
}

void ARConnection::sendPayload(quint16 cmd, quint8* paylod, quint16 length)
{
    if(!_isOpened) return;
    QByteArray data(length + 8, 0);
    data[0] = AR_PREAMBLE1;
    data[1] = AR_PREAMBLE2;
    data[2] = static_cast<quint8>(cmd & 0xff);
    data[3] = static_cast<quint8>((cmd >> 8) & 0xff);
    data[4] = static_cast<quint8>(length & 0xff);
    data[5] = static_cast<quint8>((length >> 8) & 0xff);
    uint16_t crc = 0;
    if(paylod && length != 0) {
        crc = crc16(paylod, length);
    }
    data[6] = static_cast<quint8>(crc & 0xff);
    data[7] = static_cast<quint8>((crc >> 8) & 0xff);
    if(paylod && length != 0) {
        data.append(reinterpret_cast<char*>(paylod), length);
    }
    write(data);
}

void ARConnection::sendPayloadToRemote(quint16 cmd, quint8* paylod, quint16 length)
{
    if(_workFutrueWatcher.isRunning() || !_isConnected) return;
    QByteArray data(length + 8, 0);
    data[0] = AR_PREAMBLE1;
    data[1] = AR_PREAMBLE2;
    data[2] = static_cast<quint8>(cmd & 0xff);
    data[3] = static_cast<quint8>((cmd >> 8) & 0xff);
    data[4] = static_cast<quint8>(length & 0xff);
    data[5] = static_cast<quint8>((length >> 8) & 0xff);
    uint16_t crc = 0;
    if(paylod && length != 0) {
        crc = crc16(paylod, length);
    }
    data[6] = static_cast<quint8>(crc & 0xff);
    data[7] = static_cast<quint8>((crc >> 8) & 0xff);
    if(paylod && length != 0) {
        data.append(reinterpret_cast<char*>(paylod), length);
    }

    QFuture<void> futrue = QtConcurrent::run([this, data] {
        QTcpSocket socket;
        QHostAddress host = QHostAddress::AnyIPv4;
        socket.setProxy(QNetworkProxy::NoProxy);
        socket.bind(host, _targetPort + 2, QAbstractSocket::ReuseAddressHint | QTcpSocket::ShareAddress);
        socket.connectToHost(_remoteTargetIP, _remoteTargetPort);
        if(socket.waitForConnected(1000)) {
            socket.write(data);
        }
        socket.waitForDisconnected(1000);
        socket.abort();
    });
    _workFutrueWatcher.setFuture(futrue);
}

void ARConnection::requestInfo()
{
    sendPayload(AR_CMD_ID_REQUEST_INFO);
}

void ARConnection::triggerPair()
{
    sendPayload(AR_CMD_ID_TRIGGER_PAIR);
}

void ARConnection::restartDevice()
{
    sendPayload(AR_CMD_ID_RESTART_DEVICE);
}

void ARConnection::setWorkMode(int mode)
{
    if(mode == 0) { // 2.4G
        sendPayload(AR_CMD_ID_SWITCH_24G);
    } else if(mode == 1) { // 5.8G
        sendPayload(AR_CMD_ID_SWITCH_58G);
    }
}

void ARConnection::restartRemoteDevice()
{
    sendPayload(AR_CMD_ID_RESTART_DEVICE_REMOTE);
}

void ARConnection::setRemoteWorkMode(int mode)
{
    if(mode == 0) { // 2.4G
        sendPayload(AR_CMD_ID_SWITCH_24G_REMOTE);
    } else if(mode == 1) { // 5.8G
        sendPayload(AR_CMD_ID_SWITCH_58G_REMOTE);
    }
}

ARConnection::ar_framing_t ARConnection::_ar_parse_char(quint8 c)
{
    _status.flag_received = AR_FRAMING_INCOMPLETE;

    switch (_status.parse_state) {
    case AR_PARSE_STATE_IDLE:
        if(c == AR_PREAMBLE1) {
            _status.parse_state = AR_PARSE_STATE_GOT_PREAMBLE1;
            _message.magic = ((c << 8) & 0xFF00);
        }
        break;
    case AR_PARSE_STATE_GOT_PREAMBLE1:
        if(c == AR_PREAMBLE2) {
            _message.magic |= c;
            _status.parse_state = AR_PARSE_STATE_GOT_PREAMBLE2;
        } else {
            _status.parse_state = AR_PARSE_STATE_IDLE;
        }
        break;
    case AR_PARSE_STATE_GOT_PREAMBLE2:
        {
            _message.cmd = c;
            _status.parse_state = AR_PARSE_STATE_GOT_MSGID1;
        }
        break;
    case AR_PARSE_STATE_GOT_MSGID1:
        {
            _message.cmd |= c<<8;
            _status.parse_state = AR_PARSE_STATE_GOT_MSGID2;
        }
        break;
    case AR_PARSE_STATE_GOT_MSGID2:
        {
            _message.len = c;
            _status.parse_state = AR_PARSE_STATE_GOT_LENGTH1;
        }
        break;
    case AR_PARSE_STATE_GOT_LENGTH1:
        {
            _message.len |= c<<8;
            _status.parse_state = AR_PARSE_STATE_GOT_LENGTH2;
            if(_message.len > AR_PAYLOAD_MAX_SIZE) {
                _status.parse_state = AR_PARSE_STATE_IDLE;
            }
        }
        break;
    case AR_PARSE_STATE_GOT_LENGTH2:
        {
            _message.crc = c;
            _status.parse_state = AR_PARSE_STATE_GOT_CRC1;
        }
        break;
    case AR_PARSE_STATE_GOT_CRC1:
        {
            _message.crc |= c<<8;
            _status.packet_idx = 0;
            _status.parse_state = AR_PARSE_STATE_GOT_CRC2;
            if(0 == _message.len) {
                _status.crc = crc16(_message.payload, _message.len);
                if(_status.crc == _message.crc) {
                    _status.flag_received = AR_FRAMING_OK;
                } else {
                    _status.flag_received = AR_FRAMING_BAD_CRC;
                }
                _status.parse_state = AR_PARSE_STATE_IDLE;
            }
        }
        break;
    case AR_PARSE_STATE_GOT_CRC2:
        {
            _message.payload[_status.packet_idx++] = c;
            if(_status.packet_idx == _message.len) {
                _status.crc = crc16(_message.payload, _message.len);
                if(_status.crc == _message.crc) {
                    _status.flag_received = AR_FRAMING_OK;
                } else {
                    _status.flag_received = AR_FRAMING_BAD_CRC;
                }
                _status.parse_state = AR_PARSE_STATE_IDLE;
            }
        }
        break;
    }

    return _status.flag_received;
}

void ARConnection::_socketReadyRead()
{
    QByteArray datagram = readAll();
    for(int p = 0; p < datagram.size(); p++) {
        if(_ar_parse_char(static_cast<quint8>(datagram[p])) == AR_FRAMING_OK) {
            _elapsedTimer.restart();
            if(_message.len) {
                emit receivedMessage(_message.cmd, QByteArray(reinterpret_cast<char*>(_message.payload), _message.len));
            } else {
                emit receivedMessage(_message.cmd, QByteArray());
            }
        }
    }
}

void ARConnection::_checkConnection()
{
    if(_elapsedTimer.elapsed() < 2000) {
        if(!_isConnected) {
            _isConnected = true;
            emit isConnectedChanged(_isConnected);
        }
    } else {
        if(_isConnected) {
            _isConnected = false;
            emit isConnectedChanged(_isConnected);
        }
        if(state() == QAbstractSocket::ConnectingState) {
            return;
        } else if(state() == QAbstractSocket::UnconnectedState) {
            _isOpened = false;
            emit asyncConnect();
        } else if(state() == QAbstractSocket::ConnectedState) {
            if(_elapsedTimer.elapsed() > 6000) {
                _isOpened = true;
                emit asyncDisconnect();
                return;
            }
        } else if(state() == QAbstractSocket::ClosingState) {
            return;
        } else {
            qInfo() << "Check Connection Unknown state:" << state();
            return;
        }
    }
    requestInfo();
}

void ARConnection::_enable()
{
    _elapsedTimer.restart();

    if(_timer == nullptr) {
        emit asyncConnect();

        _timer = new QTimer(this);
        _timer->setSingleShot(false);
        connect(_timer, &QTimer::timeout, this, &ARConnection::_checkConnection);
        _timer->start(1000);
    }
}

void ARConnection::_asyncConnect()
{
    if(!_isOpened) {
        qInfo() << "_asyncConnect" << _targetIP << _targetPort;
        connectToHost(QHostAddress(_targetIP), _targetPort);
    }
}

void ARConnection::_asyncDisconnect()
{
    if(_isOpened) {
        qInfo() << "_asyncDisconnect" << _targetIP << _targetPort;
        disconnectFromHost();
    }
}

void ARConnection::_handleConnected()
{
    _elapsedTimer.restart();
    _isOpened = true;
}

void ARConnection::_handleDisconnected()
{
    _isOpened = false;
}
