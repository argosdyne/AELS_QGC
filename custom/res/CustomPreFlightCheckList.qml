import QtQuick                      2.11
import QtQuick.Controls             2.4
import QtQml.Models                 2.1
import QtQuick.Layouts              1.12

import QGroundControl               1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Controls      1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FactControls  1.0
import QGroundControl.Palette       1.0

RowLayout {
    id: _rootRow
    spacing: ScreenTools.defaultFontPixelWidth
    property var  _activeVehicle:   QGroundControl.multiVehicleManager.activeVehicle
    property bool allChecksPassed: false

    FactPanelController { id: controller }
    QGCPalette { id: qgcPal; colorGroupEnabled: enabled }

    property real _margins:         ScreenTools.defaultFontPixelHeight
    property real _editFieldWidth:  ScreenTools.defaultFontPixelWidth * 20
    property real _imageWidth:      ScreenTools.defaultFontPixelWidth * 15
    property real _imageHeight:     ScreenTools.defaultFontPixelHeight * 3

    property Fact _fenceAction:     controller.getParameterFact(-1, "GF_ACTION")
    property Fact _fenceRadius:     controller.getParameterFact(-1, "GF_MAX_HOR_DIST")
    property Fact _fenceAlt:        controller.getParameterFact(-1, "GF_MAX_VER_DIST")
    property Fact _stealMode:       controller.getParameterFact(-1, "COM_STEAL_MODE", false)
    property Fact _cpAVDOn:         controller.getParameterFact(-1, "CP_AVD_ON", false)
    // property Fact _rtlLandDelay:        controller.getParameterFact(-1, "RTL_LAND_DELAY")
    // property Fact _maxVelDn:        controller.getParameterFact(-1, "MPC_VEL_MAN_DN")
    // property Fact _maxVelUp:        controller.getParameterFact(-1, "MPC_VEL_MAN_UP")
    // property Fact _maxVelHz:        controller.getParameterFact(-1, "MPC_VEL_MANUAL")
    GridLayout {
        rowSpacing: 0.8 * ScreenTools.defaultFontPixelWidth
        columnSpacing: 0.8 * ScreenTools.defaultFontPixelWidth
        columns:    2
        Layout.alignment: Qt.AlignTop | Qt.AlignLeft
        QGCColoredImage {
            color:                  qgcPal.text
            mipmap:                 true
            fillMode:               Image.PreserveAspectFit
            Layout.maximumWidth:    _imageWidth * 0.8
            Layout.maximumHeight:   _imageHeight * 0.8
            source:                 controller.vehicle.fixedWing ? "/qmlimages/ReturnToHomeAltitude.svg" : "/qmlimages/ReturnToHomeAltitudeCopter.svg"
            Layout.alignment:       Qt.AlignCenter
            height:                 _imageHeight * 0.8
            width:                  _imageWidth * 0.8
        }
        QGCLabel {
            text:               qsTr("RTL Settings")
        }

        QGCLabel {
            text:                   qsTr("Climb to ALT:")
            Layout.fillWidth:       true
            Layout.alignment:       Qt.AlignVCenter
        }
        FactTextField {
            fact:                   controller.getParameterFact(-1, "RTL_RETURN_ALT")
            Layout.minimumWidth:    _editFieldWidth
            Layout.alignment:       Qt.AlignVCenter
        }

//        QGCLabel {
//            text:                   qsTr("RTL, then:")
//        }
//        Column {
//            QGCRadioButton {
//                id:                 homeLandRadio
//                checked:            _rtlLandDelay ? _rtlLandDelay.value === 0 : false
//                text:               qsTr("Land immediately")
//                onClicked:          _rtlLandDelay.value = 0
//            }
//            QGCRadioButton {
//                id:                 homeLoiterNoLandRadio
//                checked:            _rtlLandDelay ? _rtlLandDelay.value < 0 : false
//                text:               qsTr("Do not land")
//                onClicked:          _rtlLandDelay.value = -1
//            }
//            QGCRadioButton {
//                id:                 homeLoiterLandRadio
//                checked:            _rtlLandDelay ? _rtlLandDelay.value > 0 : false
//                text:               qsTr("Land after specified time")
//                onClicked:          _rtlLandDelay.value = 60
//            }
//        }

//        QGCLabel {
//            text:                   qsTr("Loiter Time:")
//            Layout.fillWidth:       true
//        }
//        FactTextField {
//            fact:                   controller.getParameterFact(-1, "RTL_LAND_DELAY")
//            enabled:                homeLoiterLandRadio.checked === true
//            Layout.fillWidth:       true
//        }

//        QGCLabel {
//            text:                   qsTr("Loiter Altitude:")
//            Layout.fillWidth:       true
//        }
//        FactTextField {
//            fact:                   controller.getParameterFact(-1, "RTL_DESCEND_ALT")
//            enabled:                homeLoiterLandRadio.checked === true || homeLoiterNoLandRadio.checked === true
//            Layout.fillWidth:       true
//        }

        Item { height: ScreenTools.defaultFontPixelWidth; Layout.fillWidth: true; Layout.columnSpan: 2; visible: _stealMode }
        Image {
            mipmap:             true
            fillMode:           Image.PreserveAspectFit
            source:             qgcPal.globalTheme === qgcPal.Light ? "" : ""
            Layout.maximumWidth:    _imageWidth * 0.8
            Layout.maximumHeight:   _imageHeight * 0.8
            Layout.alignment:    Qt.AlignCenter * 0.8
            width:                  _imageWidth * 0.8
            height:                 _imageHeight * 0.8
            visible: _stealMode
        }
        QGCLabel {
            text: qsTr("Stealth")
            visible: _stealMode
        }

        QGCLabel {
            text:               qsTr("LED & Sounds:")
            Layout.fillWidth:   true
            visible: _stealMode
        }
        FactComboBox {
            fact: _stealMode
            visible: _stealMode
            indexModel:         false
            Layout.minimumWidth:_editFieldWidth
        }

//        Item { height: ScreenTools.defaultFontPixelWidth; Layout.fillWidth: true; Layout.columnSpan: 2; visible: _cpAVDOn }
//        Image {
//            mipmap:             true
//            fillMode:           Image.PreserveAspectFit
//            source:             qgcPal.globalTheme === qgcPal.Light ? "" : ""
//            Layout.maximumWidth:    _imageWidth * 0.8
//            Layout.maximumHeight:   _imageHeight * 0.8
//            Layout.alignment:    Qt.AlignCenter * 0.8
//            width:                  _imageWidth * 0.8
//            height:                 _imageHeight * 0.8
//            visible: _cpAVDOn
//        }
//        QGCLabel {
//            text: qsTr("Avoidance")
//            visible: _cpAVDOn
//        }

//        QGCLabel {
//            text:               qsTr("On/Off")
//            Layout.fillWidth:   true
//            visible: _cpAVDOn
//        }
//        FactComboBox {
//            fact: _cpAVDOn
//            visible: _cpAVDOn
//            indexModel:         false
//            Layout.minimumWidth:_editFieldWidth
//        }
    }

    Rectangle { width: 2; radius: 1; color: qgcPal.text; Layout.fillHeight: true }

    GridLayout {
        rowSpacing: 0.8 * ScreenTools.defaultFontPixelWidth
        columnSpacing: 0.8 * ScreenTools.defaultFontPixelWidth
        columns:    2
        Layout.alignment: Qt.AlignTop | Qt.AlignLeft

        Image {
            mipmap:             true
            fillMode:           Image.PreserveAspectFit
            source:             qgcPal.globalTheme === qgcPal.Light ? "/qmlimages/GeoFenceLight.svg" : "/qmlimages/GeoFence.svg"
            Layout.maximumWidth:    _imageWidth
            Layout.maximumHeight:   _imageHeight
            Layout.alignment:    Qt.AlignCenter
            width:                  _imageWidth
            height:                 _imageHeight
        }
        QGCLabel {
            text: qsTr("Geofence Failsafe")
        }

        QGCLabel {
            text:               qsTr("Action on breach:")
            Layout.fillWidth:   true
        }
        FactComboBox {
            fact:                   _fenceAction
            indexModel:             false
            Layout.minimumWidth:    _editFieldWidth
        }

        QGCCheckBox {
            id:                 fenceRadiusCheckBox
            text:               qsTr("Max Radius:")
            checked:            _fenceRadius ? (_fenceRadius.value > 0) : false
            onClicked: {
                if(_fenceRadius)
                    _fenceRadius.value = checked ? 100 : 0
            }
            Layout.fillWidth:   true
        }
        FactTextField {
            fact:                   _fenceRadius
            enabled:                fenceRadiusCheckBox.checked
            Layout.minimumWidth:    _editFieldWidth
        }

        QGCCheckBox {
            id:                 fenceAltMaxCheckBox
            text:               qsTr("Max Altitude:")
            checked:            _fenceAlt ? _fenceAlt.value > 0 : false
            onClicked:          _fenceAlt.value = checked ? 100 : 0
            Layout.fillWidth:   true
        }
        FactTextField {
            fact:                   _fenceAlt
            enabled:                fenceAltMaxCheckBox.checked
            Layout.minimumWidth:    _editFieldWidth
        }

        Item { height: ScreenTools.defaultFontPixelWidth; Layout.fillWidth: true; Layout.columnSpan: 2 }
        Image {
            mipmap:             true
            fillMode:           Image.PreserveAspectFit
            source:             qgcPal.globalTheme === qgcPal.Light ? "/qmlimages/RCLossLight.svg" : "/qmlimages/RCLoss.svg"
            Layout.maximumWidth:    _imageWidth
            Layout.maximumHeight:   _imageHeight
            Layout.alignment:    Qt.AlignCenter
            width:                  _imageWidth
            height:                 _imageHeight
        }
        QGCLabel {
            text:               qsTr("Link Loss Failsafe")
        }

        QGCLabel {
            text:               qsTr("Channels Failsafe:")
            Layout.fillWidth:   true
        }
        FactComboBox {
            fact:               controller.getParameterFact(-1, "NAV_RCL_ACT")
            indexModel:         false
            Layout.minimumWidth:_editFieldWidth
        }

        QGCLabel {
            text:               qsTr("Channels Timeout:")
            Layout.fillWidth:   true
        }
        FactTextField {
            fact:               controller.getParameterFact(-1, "COM_RC_LOSS_T")
            Layout.minimumWidth:    _editFieldWidth
        }

        QGCLabel {
            text:               qsTr("Data Failsafe:")
            Layout.fillWidth:   true
        }
        FactComboBox {
            fact:               controller.getParameterFact(-1, "NAV_DLL_ACT")
            indexModel:         false
            Layout.minimumWidth:_editFieldWidth
        }

        QGCLabel {
            text:               qsTr("Data Timeout:")
            Layout.fillWidth:   true
        }
        FactTextField {
            fact:               controller.getParameterFact(-1, "COM_DL_LOSS_T")
            Layout.minimumWidth:    _editFieldWidth
        }
    }

    Rectangle { width: 2; radius: 1; color: qgcPal.text; Layout.fillHeight: true; visible: _activeVehicle && !_activeVehicle.armed }

    Loader {
        id:     checkList
        Layout.alignment: Qt.AlignTop | Qt.AlignLeft
        visible: _activeVehicle && !_activeVehicle.armed
        source: "qrc:/qml/PreFlightCheckList.qml"
        Connections {
            target: checkList.item
            function onAllChecksPassedChanged() {
                _rootRow.allChecksPassed = target.allChecksPassed
            }
        }
    }
}
