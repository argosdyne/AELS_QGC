/****************************************************************************
 *
 * (c) 2009-2019 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 *   @brief Custom QGCCorePlugin Declaration
 *   @author Gus Grubba <gus@auterion.com>
 */

#pragma once

#include "QGCCorePlugin.h"
#include "QGCOptions.h"
#include "QGCLoggingCategory.h"
#include "SettingsManager.h"
#include "SiYiManager.h"
#include <QTranslator>
#include "codevsettings.h"
#include "AVIATORInterface.h"
#include <QLoggingCategory>
#include "ThridRCFactory.h"
#include "CustomQmlInterface.h"
#include "DynamicRepcManager.h"

class CustomOptions;
class CustomPlugin;
class CustomSettings;
class SiYiManager;
class CodevRTCMManager;
class HttpService;

Q_DECLARE_LOGGING_CATEGORY(CustomLog)

class CustomFlyViewOptions : public QGCFlyViewOptions
{
public:
    CustomFlyViewOptions(CustomOptions* options, QObject* parent = nullptr);

    // Overrides from CustomFlyViewOptions
    bool                    showInstrumentPanel         (void) const final;
    bool                    showMultiVehicleList        (void) const final;
};

class CustomOptions : public QGCOptions
{
// public:
//     CustomOptions(CustomPlugin*, QObject* parent = nullptr);

//     // Overrides from QGCOptions
//     bool                    wifiReliableForCalibration  (void) const final;
//     bool                    showFirmwareUpgrade         (void) const final;
//     QGCFlyViewOptions*      flyViewOptions(void) final;
public:
CustomOptions(CustomPlugin*, QObject* parent = nullptr);

// Overrides from QGCOptions
double                  toolbarHeightMultiplier     () final {
#ifdef __mobile__
    return 0.8;
#else
    return 1;
#endif
}
bool                    useMobileFileDialog   () const final {
#if defined(Q_OS_MAC)
    return true;
#elif defined(__mobile__)
    return true;
#else
    return false;
#endif
}

bool                    showSensorCalibrationGyro       () const final;
bool                    showSensorCalibrationAccel      () const final;
bool                    showSensorCalibrationLevel      () const final;
bool                    showSensorCalibrationAirspeed   () const final;
bool                    sensorsHaveFixedOrientation     () const final;
bool                    wifiReliableForCalibration  (void) const final;
bool                    showFirmwareUpgrade         (void) const final;
QGCFlyViewOptions*      flyViewOptions              (void) final;
QUrl                    preFlightChecklistUrl           () const final;

private:
    CustomFlyViewOptions* _flyViewOptions = nullptr;
};

class CustomPlugin : public QGCCorePlugin
{
    Q_OBJECT
public:
    Q_PROPERTY(bool has3DMap READ has3DMap CONSTANT)
    bool has3DMap() const {
#if defined(ENABLE_ARCGIS)
        return true;
#else
        return false;
#endif
    }

    Q_PROPERTY(bool coachMode READ coachMode WRITE setCoachMode NOTIFY coachModeChanged)
    bool coachMode() { return _coachMode; }
    void setCoachMode(const bool& coachMode);

    Q_PROPERTY(CodevSettings* codevSettings READ codevSettings CONSTANT)
    Q_PROPERTY(CodevRTCMManager* codevRTCMManager READ codevRTCMManager CONSTANT)
    Q_PROPERTY(SiYiManager* siyiManager READ siyiManager CONSTANT)

    Q_PROPERTY(CustomSettings* settings READ settings CONSTANT)
    CustomSettings* settings(){ return _settings; }

    Q_PROPERTY(AVIATORInterface* aviatorInterface READ aviatorInterface CONSTANT)
    AVIATORInterface* aviatorInterface(){ return _aviatorInterface; }

    Q_PROPERTY(ThridRCFactory* thridRCFactory READ thridRCFactory CONSTANT)
    ThridRCFactory* thridRCFactory(){ return ThridRCFactory::instance(); }

    Q_PROPERTY(bool hasFrpc READ hasFrpc CONSTANT)
    bool hasFrpc() const;

    Q_PROPERTY(QString iconURL READ iconURL CONSTANT)
    QString iconURL() const;

    Q_PROPERTY(bool slaveMode READ slaveMode WRITE setSlaveMode NOTIFY slaveModeChanged)
    bool slaveMode() { return _slaveMode; }
    void setSlaveMode(bool mode);

    Q_PROPERTY(DynamicRepcManager* dynamicRepcManager READ dynamicRepcManager CONSTANT)
    DynamicRepcManager* dynamicRepcManager(){ return _dynamicRepcManager; }

    CustomPlugin(QGCApplication* app, QGCToolbox *toolbox);
    ~CustomPlugin();

    // Overrides from QGCCorePlugin
    QVariantList&           settingsPages                   (void) final;
    QGCOptions*             options                         (void) final;
    QString                 brandImageIndoor                (void) const final;
    QString                 brandImageOutdoor               (void) const final;
    bool                    overrideSettingsGroupVisibility (QString name) final;
    bool                    adjustSettingMetaData           (const QString& settingsGroup, FactMetaData& metaData) final;
    void                    paletteOverride                 (QString colorName, QGCPalette::PaletteColorInfo_t& colorInfo) final;
    QQmlApplicationEngine*  createQmlApplicationEngine      (QObject* parent) final;
    VideoReceiver*          createVideoReceiver             (QObject* parent) final;

    SiYiManager* siyiManager(){return _siyiManager;};
    CodevSettings* codevSettings() { return _codevSettings; }
    CodevRTCMManager* codevRTCMManager() { return _codevRTCMManager; }

    // Overrides from QGCTool
    void                    setToolbox                      (QGCToolbox* toolbox);

signals:
    void coachModeChanged(bool coachMode);
    void requestCreatePlan(QString path);
    void slaveModeChanged(bool slaveMode);
    void rcChannelValuesChanged(const quint16* channels, int count);

public slots:
    void showMessage(const QString& message, SystemMessage::SystemMessageType type = SystemMessage::Info);

private slots:
    void _advancedChanged(bool advanced);
    void _handleRCChannelValues(const quint16* channels, int count);

private:
    void _addSettingsEntry(const QString& title, const char* qmlFile, const char* iconFile = nullptr);

private:
    SiYiManager* _siyiManager = nullptr;
    CodevSettings*      _codevSettings = nullptr;
    CodevRTCMManager*   _codevRTCMManager = nullptr;

    CustomOptions*  _options = nullptr;
    QVariantList    _customSettingsList; // Not to be mixed up with QGCCorePlugin implementation
    CustomSettings* _settings{nullptr};
    CustomQmlInterface* _qmlInterface{nullptr};
    AVIATORInterface* _aviatorInterface{nullptr};
    HttpService*    _httpService{nullptr};
    DynamicRepcManager* _dynamicRepcManager{nullptr};

    bool _coachMode{false};
    bool _slaveMode{false};
};
