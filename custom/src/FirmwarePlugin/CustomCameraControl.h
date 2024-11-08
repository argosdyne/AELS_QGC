#pragma once

#include "QGCCameraControl.h"

#include <QSize>
#include <QPoint>
#include <QSoundEffect>

Q_DECLARE_LOGGING_CATEGORY(CustomCameraLog)
Q_DECLARE_LOGGING_CATEGORY(CustomCameraVerboseLog)

//-----------------------------------------------------------------------------
class CustomCameraControl : public QGCCameraControl
{
    Q_OBJECT
public:
    Q_PROPERTY(QString visualQML READ visualQML CONSTANT)
    Q_PROPERTY(bool hasTrackingPoint     READ hasTrackingPoint     NOTIFY infoChanged)
    Q_PROPERTY(bool hasTrackingRectangle READ hasTrackingRectangle NOTIFY infoChanged)
    Q_PROPERTY(bool hasTrackingGeoStatus READ hasTrackingGeoStatus NOTIFY infoChanged)

    Q_PROPERTY(bool supportFormat READ supportFormat CONSTANT)
    Q_PROPERTY(bool supportReset  READ supportReset CONSTANT)
    Q_PROPERTY(bool supportLapse  READ supportLapse CONSTANT)
    virtual bool supportFormat() const { return true; }
    virtual bool supportReset() const { return true; }
    virtual bool supportLapse() const { return true; }

    CustomCameraControl(const mavlink_camera_information_t* info, Vehicle* vehicle, int compID, QObject* parent = nullptr, LinkInterface* link = nullptr);

    LinkInterface* link() { return _link; }
    QString cacheDefile() { return _cacheFile; }
    void get_mavlink_camera_info(mavlink_camera_information_t& info);

    typedef struct {
        int         component;
        MAV_CMD     command;
        MAV_FRAME   frame;
        double      rgParam[7];
    } MavCommandQueueEntry_t;
    QList<MavCommandQueueEntry_t>   _mavCommandQueue;
    QTimer                          _mavCommandAckTimer;
    int                             _mavCommandRetryCount;
    static const int                _mavCommandMaxRetryCount = 3;
    static const int                _mavCommandAckTimeoutMSecs = 500;
    void sendMavCommand(MAV_CMD command, float param1 = 0.0f, float param2 = 0.0f, float param3 = 0.0f, float param4 = 0.0f, float param5 = 0.0f, float param6 = 0.0f, float param7 = 0.0f);

    void handleVideoInfo(const mavlink_video_stream_information_t *vi) override;
    void handleCommandAck(const mavlink_command_ack_t& ack);
    bool hasTrackingPoint() { return _info.flags & CAMERA_CAP_FLAGS_HAS_TRACKING_POINT; }
    bool hasTrackingRectangle() { return _info.flags & CAMERA_CAP_FLAGS_HAS_TRACKING_RECTANGLE; }
    bool hasTrackingGeoStatus() { return _info.flags & CAMERA_CAP_FLAGS_HAS_TRACKING_GEO_STATUS; }
    Q_INVOKABLE void startTracking(float x, float y, float radius = 1);
    Q_INVOKABLE void startTracking(float x1, float y1, float x2, float y2);
    Q_INVOKABLE void stopTracking();
    Q_INVOKABLE void centerGimbal();

    virtual QString visualQML() const { return QString("qrc:/custom/qml/CustomCameraVisual.qml"); }

    // Override from QGCCameraControl
    bool takePhoto() override;
    bool stopTakePhoto() override;
    bool startVideo() override;
    bool stopVideo() override;
    void resetSettings() override;
    void formatCard(int id = 1) override;
    void setVideoMode() override;
    void setPhotoMode() override;
    void startZoom(int direction) override;
    void stopZoom() override;
    void setZoomLevel(qreal level) override;
    void _requestStreamInfo(uint8_t streamID) override;
    void _requestStreamStatus(uint8_t streamID) override;
    void _requestCameraSettings() override;
    void _requestAllParameters() override;
    void _requestCaptureStatus() override;
    void _requestStorageInfo() override;

signals:
    void playCameraSound(int loop);
    void playVideoSound(int loop);
    void playErrorSound(int loop);

protected slots:
    void        _sendMavCommandAgain();
    void        _mavCommandResult   (int vehicleId, int component, int command, int result, bool noReponseFromVehicle) override;
    void        _buttonTakePhoto();
    void        _buttonToggleVideo();

protected:
    void    _sendNextQueuedMavCommand();
    bool    _isTakingPhotoTimelapse();

    QSoundEffect _cameraSound;
    QSoundEffect _videoSound;
    QSoundEffect _errorSound;

    MAVLinkProtocol* _pMavlink;
};
