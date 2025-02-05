#include "SiYiManager.h"
#include <QCoreApplication>
#include <QQmlEngine>

SiYiManager::SiYiManager(QGCApplication *app, QGCToolbox *toolbox)
    : QGCTool(app, toolbox)
{

    camera_ = new SiYiCamera(this);
    transmitter_ = new SiYiTransmitter(this);
    connect(transmitter_, &SiYiCamera::connected, this, [=](){
        this->isTransmitterConnected_ = true;
        camera_->start();
    });
    connect(transmitter_, &SiYiCamera::disconnected, this, [=](){
        this->isTransmitterConnected_ = false;
        transmitter_->exit();
    });

    connect(camera_, &SiYiCamera::ipChanged, this, [=](){
        if (camera_->isRunning()) {
            camera_->exit();
            camera_->wait();
        }

        camera_->start();
    });

#ifdef Q_OS_ANDROID
    isAndroid_ = true;
#else
    isAndroid_ = false;
#endif

    transmitter_->start();
#if 1   //When it is 1, the PTZ control does not need to be connected first.
    camera_->start();
#endif

}


SiYiCamera *SiYiManager::cameraInstance()
{
    return camera_;
}

SiYiTransmitter *SiYiManager::transmitterInstance()
{
    return transmitter_;
}

void SiYiManager::setToolbox(QGCToolbox *toolbox)
{
    static const char* kRefOnly         = "Reference only";
    QGCTool::setToolbox(toolbox);

//    qmlRegisterSingletonType<SiYiManager>("SiYi.Object", 1, 0, "SiYi", [](QQmlEngine*, QJSEngine*)->QObject*{
//        return SiYiManager::instance();
//    });
    QQmlEngine::setObjectOwnership(this, QQmlEngine::CppOwnership);
    qmlRegisterUncreatableType<SiYiManager>("SiYi.Object", 1, 0, "SiYiManager", kRefOnly); // TODO: Check
    qmlRegisterUncreatableType<SiYiCamera>("SiYi.Object", 1, 0, "SiYiCamera", kRefOnly);
    qmlRegisterUncreatableType<SiYiTransmitter>("SiYi.Object", 1, 0, "SiYiTransmitter", kRefOnly);
}
