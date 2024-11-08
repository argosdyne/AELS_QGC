#pragma once
#include <QElapsedTimer>
#include <QTimer>
#include <QTcpSocket>
#include <QFutureWatcher>

#define AR_PAYLOAD_MAX_SIZE 2048
#define AR_CMD_ID_REQUEST_INFO 1
#define AR_CMD_ID_TRIGGER_PAIR 2
#define AR_CMD_ID_RESTART_DEVICE 3
#define AR_CMD_ID_SWITCH_24G 4
#define AR_CMD_ID_SWITCH_58G 5
#define AR_CMD_ID_RESTART_DEVICE_REMOTE 6
#define AR_CMD_ID_SWITCH_24G_REMOTE 7
#define AR_CMD_ID_SWITCH_58G_REMOTE 8
class ARConnection : public QTcpSocket
{
    Q_OBJECT
public:
    typedef enum {
        AR_PARSE_STATE_IDLE,
        AR_PARSE_STATE_GOT_PREAMBLE1,
        AR_PARSE_STATE_GOT_PREAMBLE2,
        AR_PARSE_STATE_GOT_MSGID1,
        AR_PARSE_STATE_GOT_MSGID2,
        AR_PARSE_STATE_GOT_LENGTH1,
        AR_PARSE_STATE_GOT_LENGTH2,
        AR_PARSE_STATE_GOT_CRC1,
        AR_PARSE_STATE_GOT_CRC2
    } ar_parse_state_t;

    typedef enum {
        AR_FRAMING_INCOMPLETE=0,
        AR_FRAMING_OK=1,
        AR_FRAMING_BAD_CRC=2
    } ar_framing_t;

    typedef struct {
        quint16 packet_idx;
        quint16 crc;
        ar_framing_t flag_received;
        ar_parse_state_t parse_state;
    } ar_status_t;

    typedef struct {
        quint16 magic;
        quint16 cmd;
        quint16 len;
        quint16 crc;
        quint8 payload[AR_PAYLOAD_MAX_SIZE];
    } ar_message_t;

    ARConnection(QString targetIP, quint16 targetPort = 1235);

    void sendPayload(quint16 cmd, quint8* paylod = nullptr, quint16 length = 0);
    void sendPayloadToRemote(quint16 cmd, quint8* paylod = nullptr, quint16 length = 0);

    bool isConnected() { return _isConnected; }

public slots:
    void requestInfo();
    void triggerPair();
    void restartDevice();
    void setWorkMode(int mode); // 0: 2.4G 1: 5.8G
    void restartRemoteDevice();
    void setRemoteWorkMode(int mode); // 0: 2.4G 1: 5.8G

signals:
    void enable();
    void receivedMessage(quint16 cmd, QByteArray message);
    void isConnectedChanged(bool isConnected);
    void asyncConnect();
    void asyncDisconnect();

private slots:
    void _enable();
    void _socketReadyRead();
    void _checkConnection();
    void _handleConnected();
    void _handleDisconnected();
    void _asyncConnect();
    void _asyncDisconnect();

private:
    ar_framing_t _ar_parse_char(quint8 c);

    QFutureWatcher<void> _workFutrueWatcher;
    QElapsedTimer _elapsedTimer;
    QString _targetIP;
    quint16 _targetPort{0};
    QString _remoteTargetIP;
    quint16 _remoteTargetPort{0};
    QTimer* _timer{nullptr};
    bool _isConnected{false};
    bool _isOpened{false};

    ar_message_t _message;
    ar_status_t _status;
};