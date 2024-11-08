#pragma once

#include <QLoggingCategory>
#include <QSerialPort>
#include <QTimer>
#include "ThridRCFactory.h"

Q_DECLARE_LOGGING_CATEGORY(FortInterfaceLog)
#define FORT_MAX_PAYLOAD_LENGTH 128
class FortInterface : public RCInterface
{
    Q_OBJECT
public:
    typedef enum {
        FORT_PARSE_STATE_IDLE,
        FORT_PARSE_STATE_PRE1,
        FORT_PARSE_STATE_PRE2,
        FORT_PARSE_STATE_MSGID,
        FORT_PARSE_STATE_LENGTH,
        FORT_PARSE_STATE_DATA,
        FORT_PARSE_STATE_CRC1,
        FORT_PARSE_STATE_CRCE,
        FORT_PARSE_STATE_END
    } fort_parse_state_t;

    typedef struct {
        quint8 pre1;
        quint8 pre2;
        quint8 id;
        quint8 len;
        quint8 data[FORT_MAX_PAYLOAD_LENGTH];
        quint16 crc16;
        quint8 index;
    } fort_status_t;

    FortInterface();
    ~FortInterface() override;

    qint16 LX() const { return (_payload[0] & 0x0003) == 0x0001 ? 0 : ((_payload[0] >> 6) * ((_payload[0] & 0x000C) == 0x0004 ? -1 : 1)); }
    qint16 LY() const { return (_payload[1] & 0x0003) == 0x0001 ? 0 : ((_payload[1] >> 6) * ((_payload[1] & 0x000C) == 0x0004 ? -1 : 1)); }
    qint16 LZ() const { return (_payload[2] & 0x0003) == 0x0001 ? 0 : ((_payload[2] >> 6) * ((_payload[2] & 0x000C) == 0x0004 ? -1 : 1)); }
    qint16 RX() const { return (_payload[3] & 0x0003) == 0x0001 ? 0 : ((_payload[3] >> 6) * ((_payload[3] & 0x000C) == 0x0004 ? -1 : 1)); }
    qint16 RY() const { return (_payload[4] & 0x0003) == 0x0001 ? 0 : ((_payload[4] >> 6) * ((_payload[4] & 0x000C) == 0x0004 ? -1 : 1)); }
    qint16 RZ() const { return (_payload[5] & 0x0003) == 0x0001 ? 0 : ((_payload[5] >> 6) * ((_payload[5] & 0x000C) == 0x0004 ? -1 : 1)); }

    bool LU() const { return ((_payload[6] & 0x0030) == 0x0010); }
    bool LD() const { return ((_payload[6] & 0x0003) == 0x0001); }
    bool LL() const { return ((_payload[6] & 0x00C0) == 0x0040); }
    bool LR() const { return ((_payload[6] & 0x000C) == 0x0004); }

    bool RU() const { return ((_payload[6] & 0x3000) == 0x1000); }
    bool RD() const { return ((_payload[6] & 0x0300) == 0x0100); }
    bool RL() const { return ((_payload[6] & 0xC000) == 0x4000); }
    bool RR() const { return ((_payload[6] & 0x0C00) == 0x0400); }

    bool start() final;
    void stop() final;
    bool isEquel(quint16 vid, quint16 pid) final;
    bool running() final { return _running; }
    bool enabled() final { return _enabled; }

private slots:
    void _readBytes(void);
    void _timeout();

private:
    QSerialPort* _port{nullptr};
    QTimer       _timer;

    fort_parse_state_t _fort_parse_state{FORT_PARSE_STATE_IDLE};
    fort_status_t _fort_status;

    quint16 _payload[7];
    quint16 _rawChannels[18];

    bool _enabled{true};
    bool _running{false};

    bool _ld_button_pressed_delay{false};

    bool _ld_button_pressed{false};
    bool _rd_button_pressed{false};
    bool _rl_button_pressed{false};
    bool _rr_button_pressed{false};
};
