#pragma once
#include <QSerialPort>
#include <QLoggingCategory>
#include "ThridRCFactory.h"

Q_DECLARE_LOGGING_CATEGORY(T30InterfaceLog)
#define T30_MAX_PAYLOAD_LENGTH 90
class T30Interface : public RCInterface
{
    Q_OBJECT
public:
    typedef enum {
        T30_PARSE_STATE_IDLE,
        T30_PARSE_STATE_START,
        T30_PARSE_STATE_GOT_FUNCTION,
        T30_PARSE_STATE_GOT_LENGTH1,
        T30_PARSE_STATE_GOT_LENGTH2,
        T30_PARSE_STATE_GOT_MSGID,
        T30_PARSE_STATE_GOT_DATA,
        T30_PARSE_STATE_GOT_END
    } t30_parse_state_t;

    typedef struct {
        quint8 func;
        quint16 len;
        quint8 id;
        quint16 index;
        quint8 data[T30_MAX_PAYLOAD_LENGTH];
    } t30_status_t;

    quint16 T1() const { return _payload[0]; }
    quint16 T2() const { return _payload[1]; }
    quint16 T3() const { return _payload[2]; }
    quint16 T4() const { return _payload[3]; }
    quint16 T5() const { return _payload[4]; }
    quint16 LD() const { return _payload[5]; }
    quint16 RD() const { return _payload[6]; }
    quint16 T6() const { return _payload[7]; }
    quint16 SA() const { return _payload[8]; }
    quint16 SB() const { return _payload[9]; }
    quint16 SC() const { return _payload[10]; }
    quint16 SD() const { return _payload[11]; }
    quint16 SE() const { return _payload[12]; }
    quint16 SF() const { return _payload[13]; }
    bool    F1() const { return ((_payload[14] >> 0) & 0x0001) == 0; }
    bool    F2() const { return ((_payload[14] >> 1) & 0x0001) == 0; }
    bool    F3() const { return ((_payload[14] >> 2) & 0x0001) == 0; }
    bool    F4() const { return ((_payload[14] >> 3) & 0x0001) == 0; }
    bool    F5() const { return ((_payload[14] >> 4) & 0x0001) == 0; }
    bool    F6() const { return ((_payload[14] >> 5) & 0x0001) == 0; }
    bool    F7() const { return ((_payload[14] >> 6) & 0x0001) == 0; }
    bool    F8() const { return ((_payload[14] >> 7) & 0x0001) == 0; }

    T30Interface();
    ~T30Interface() override;

    bool start() final;
    void stop() final;

public slots:
    void enableDevice();

signals:
    void write(const QByteArray data);

private slots:
    void _writeBytes(const QByteArray data);
    void _readBytes(void);

private:

    QSerialPort* _port{nullptr};
    QString _portName;
    int _baudRate;
    t30_parse_state_t _t30_parse_state{T30_PARSE_STATE_IDLE};
    t30_status_t _t30_status;

    quint16 _payload[15];
    quint16 _rawChannels[18];
};
