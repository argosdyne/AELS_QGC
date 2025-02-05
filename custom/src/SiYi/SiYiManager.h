#ifndef SIYIMANAGER_H
#define SIYIMANAGER_H

#include <QObject>
#include <QMutex>
#include <QObject>
#include <QVariant>
#include "QGCToolbox.h"
#include "SiYiCamera.h"
#include "SiYiTransmitter.h"



class SiYiManager : public QGCTool
{
    Q_OBJECT
    Q_PROPERTY(QVariant camera READ camera CONSTANT)
    Q_PROPERTY(QVariant transmitter READ transmitter CONSTANT)
    Q_PROPERTY(bool isAndroid READ isAndroid CONSTANT)
public:
    explicit SiYiManager(QGCApplication *app, QGCToolbox *toolbox);
    SiYiCamera *cameraInstance();
    SiYiTransmitter *transmitterInstance();

    // Override from QGCTool
    virtual void setToolbox(QGCToolbox *toolbox);
private:
    static SiYiManager *instance_;
    SiYiCamera *camera_;
    SiYiTransmitter *transmitter_;
    bool isTransmitterConnected_{false};
private:
    QVariant camera(){return QVariant::fromValue(camera_);}
    QVariant transmitter();
private:
    bool isAndroid_;
    bool isAndroid(){return isAndroid_;}
};

inline QVariant SiYiManager::transmitter(){return QVariant::fromValue(transmitter_);}


#endif // SIYIMANAGER_H
