/****************************************************************************
 *
 * (c) 2009-2019 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 * @file
 *   @brief Custom Firmware Plugin (PX4)
 *   @author Gus Grubba <gus@auterion.com>
 *
 */

#include "CustomFirmwarePlugin.h"
#include "CustomAutoPilotPlugin.h"

//-----------------------------------------------------------------------------
CustomFirmwarePlugin::CustomFirmwarePlugin() : ArduCopterFirmwarePlugin()
{
    // THANH: TODO Disable some redundant mode
    setSupportedModes({
        APMCopterMode(APMCopterMode::STABILIZE,     true),
            APMCopterMode(APMCopterMode::ACRO,          true),
            APMCopterMode(APMCopterMode::ALT_HOLD,      true),
            APMCopterMode(APMCopterMode::AUTO,          true),
            APMCopterMode(APMCopterMode::GUIDED,        true),
            APMCopterMode(APMCopterMode::LOITER,        true),
            APMCopterMode(APMCopterMode::RTL,           true),
            APMCopterMode(APMCopterMode::CIRCLE,        true),
            APMCopterMode(APMCopterMode::LAND,          true),
            APMCopterMode(APMCopterMode::DRIFT,         true),
            APMCopterMode(APMCopterMode::SPORT,         true),
            APMCopterMode(APMCopterMode::FLIP,          true),
            APMCopterMode(APMCopterMode::AUTOTUNE,      true),
            APMCopterMode(APMCopterMode::POS_HOLD,      true),
            APMCopterMode(APMCopterMode::BRAKE,         true),
            APMCopterMode(APMCopterMode::THROW,         true),
            APMCopterMode(APMCopterMode::AVOID_ADSB,    true),
            APMCopterMode(APMCopterMode::GUIDED_NOGPS,  true),
            APMCopterMode(APMCopterMode::SMART_RTL,     true),
            APMCopterMode(APMCopterMode::FLOWHOLD,      true),
#if 0
    // Follow me not ready for Stable
        APMCopterMode(APMCopterMode::FOLLOW,        true),
#endif
            APMCopterMode(APMCopterMode::ZIGZAG,        true),
    });
}

//-----------------------------------------------------------------------------
AutoPilotPlugin* CustomFirmwarePlugin::autopilotPlugin(Vehicle* vehicle)
{
    return new CustomAutoPilotPlugin(vehicle, vehicle);
}

const QVariantList& CustomFirmwarePlugin::toolIndicators(const Vehicle* vehicle)
{
    if (_toolIndicatorList.size() == 0) {
        // First call the base class to get the standard QGC list. This way we are guaranteed to always get
        // any new toolbar indicators which are added upstream in our custom build.
        _toolIndicatorList = FirmwarePlugin::toolIndicators(vehicle);
        // Then specifically remove the RC RSSI indicator.
        _toolIndicatorList.removeOne(QVariant::fromValue(QUrl::fromUserInput("qrc:/toolbar/RCRSSIIndicator.qml")));
        // THANH: TODO: Remove some unused tool and add some custom tool here
    }
    return _toolIndicatorList;
}

// Tells QGC that your vehicle has a gimbal on it. This will in turn cause thing like gimbal commands to point
// the camera straight down for surveys to be automatically added to Plans.
bool CustomFirmwarePlugin::hasGimbal(Vehicle* /*vehicle*/, bool& rollSupported, bool& pitchSupported, bool& yawSupported)
{
    rollSupported = false;
    pitchSupported = true;
    yawSupported = true;

    return true;
}
