/****************************************************************************
 *
 * (c) 2009-2019 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 * @file
 *   @brief Custom Autopilot Plugin
 *   @author Gus Grubba <gus@auterion.com>
 */

#include "CustomAutoPilotPlugin.h"

#include "APMAirframeComponent.h"
#include "APMCameraComponent.h"
#include "APMFlightModesComponent.h"
#include "APMHeliComponent.h"
#include "APMLightsComponent.h"
#include "APMMotorComponent.h"
#include "APMPowerComponent.h"
#include "APMRadioComponent.h"
#include "APMSafetyComponent.h"
#include "APMSensorsComponent.h"
#include "APMSubFrameComponent.h"
#include "APMTuningComponent.h"
#include "ESP8266Component.h"
#include "ParameterManager.h"
#include "QGCApplication.h"
#include "QGCCorePlugin.h"




CustomAutoPilotPlugin::CustomAutoPilotPlugin(Vehicle* vehicle, QObject* parent)
    : APMAutoPilotPlugin(vehicle, parent)
{
    // Whenever we go on/out of advanced mode the available list of settings pages will change
    connect(qgcApp()->toolbox()->corePlugin(), &QGCCorePlugin::showAdvancedUIChanged, this, &CustomAutoPilotPlugin::_advancedChanged);
}

// This signals that when Advanced Mode changes the list of Vehicle Settings page also changed
void CustomAutoPilotPlugin::_advancedChanged(bool)
{
    _components.clear();
    emit vehicleComponentsChanged();
}

// This allows us to hide most Vehicle Setup pages unless we are in Advanced Mmode
const QVariantList& CustomAutoPilotPlugin::vehicleComponents()
{
    if (_components.count() == 0 && !_incorrectParameterVersion) {
        bool showAdvanced = qgcApp()->toolbox()->corePlugin()->showAdvancedUI();
        if (_vehicle->parameterManager()->parametersReady()) {
            if (showAdvanced) {
                _airframeComponent = new APMAirframeComponent(_vehicle, this);
                _airframeComponent->setupTriggerSignals();
                _components.append(QVariant::fromValue((VehicleComponent*)_airframeComponent));


                if ( _vehicle->supportsRadio() ) {
                    _radioComponent = new APMRadioComponent(_vehicle, this);
                    _radioComponent->setupTriggerSignals();
                    _components.append(QVariant::fromValue((VehicleComponent*)_radioComponent));
                }

                // No flight modes component for Sub versions 3.5 and up
                if (!_vehicle->sub() || (_vehicle->versionCompare(3, 5, 0) < 0)) {
                    _flightModesComponent = new APMFlightModesComponent(_vehicle, this);
                    _flightModesComponent->setupTriggerSignals();
                    _components.append(QVariant::fromValue((VehicleComponent*)_flightModesComponent));
                }

                _sensorsComponent = new APMSensorsComponent(_vehicle, this);
                _sensorsComponent->setupTriggerSignals();
                _components.append(QVariant::fromValue((VehicleComponent*)_sensorsComponent));

                _powerComponent = new APMPowerComponent(_vehicle, this);
                _powerComponent->setupTriggerSignals();
                _components.append(QVariant::fromValue((VehicleComponent*)_powerComponent));

                if (!_vehicle->sub() || (_vehicle->sub() && _vehicle->versionCompare(3, 5, 3) >= 0)) {
                    _motorComponent = new APMMotorComponent(_vehicle, this);
                    _motorComponent->setupTriggerSignals();
                    _components.append(QVariant::fromValue((VehicleComponent*)_motorComponent));
                }
            }

            _safetyComponent = new APMSafetyComponent(_vehicle, this);
            _safetyComponent->setupTriggerSignals();
            _components.append(QVariant::fromValue((VehicleComponent*)_safetyComponent));

#if 0
    // Follow me not ready for Stable

            if ((qobject_cast<ArduCopterFirmwarePlugin*>(_vehicle->firmwarePlugin()) || qobject_cast<ArduRoverFirmwarePlugin*>(_vehicle->firmwarePlugin())) &&
                    _vehicle->parameterManager()->parameterExists(-1, QStringLiteral("FOLL_ENABLE"))) {
                _followComponent = new APMFollowComponent(_vehicle, this);
                _followComponent->setupTriggerSignals();
                _components.append(QVariant::fromValue((VehicleComponent*)_followComponent));
            }
#endif

            if (showAdvanced) {
                _tuningComponent = new APMTuningComponent(_vehicle, this);
                _tuningComponent->setupTriggerSignals();
                _components.append(QVariant::fromValue((VehicleComponent*)_tuningComponent));

                if(_vehicle->parameterManager()->parameterExists(-1, "MNT_RC_IN_PAN")) {
                    _cameraComponent = new APMCameraComponent(_vehicle, this);
                    _cameraComponent->setupTriggerSignals();
                    _components.append(QVariant::fromValue((VehicleComponent*)_cameraComponent));
                }

                if (_vehicle->sub()) {
                    _lightsComponent = new APMLightsComponent(_vehicle, this);
                    _lightsComponent->setupTriggerSignals();
                    _components.append(QVariant::fromValue((VehicleComponent*)_lightsComponent));

                    if(_vehicle->versionCompare(3, 5, 0) >= 0) {
                        _subFrameComponent = new APMSubFrameComponent(_vehicle, this);
                        _subFrameComponent->setupTriggerSignals();
                        _components.append(QVariant::fromValue((VehicleComponent*)_subFrameComponent));
                    }
                }

                //-- Is there an ESP8266 Connected?
                if(_vehicle->parameterManager()->parameterExists(MAV_COMP_ID_UDP_BRIDGE, "SW_VER")) {
                    _esp8266Component = new ESP8266Component(_vehicle, this);
                    _esp8266Component->setupTriggerSignals();
                    _components.append(QVariant::fromValue((VehicleComponent*)_esp8266Component));
                }
            }
        } else {
            qWarning() << "Call to vehicleCompenents prior to parametersReady";
        }
    }

    return _components;

}
