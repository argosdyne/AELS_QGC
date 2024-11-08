import QtQuick              2.3
import QtQuick.Controls     1.2
import QtQuick.Layouts      1.11
import QtQuick.Dialogs      1.2
import QtGraphicalEffects   1.0

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Palette               1.0

import CustomQmlInterface                1.0
import Custom.Widgets                       1.0

//-------------------------------------------------------------------------
//-- Team Mode Indicator
Item {
    id: _root
    width:          height
    anchors.top:    parent.top
    anchors.bottom: parent.bottom

    property var teamRounter:   CustomQmlInterface.teamModeRouter
    property var teamMode:      QGroundControl.corePlugin.settings.teamMode
    property var teamLink:      CustomQmlInterface.teamModeLink
    property bool _isLAN:       teamMode.value === 1
    property bool _isP2P:       teamMode.value === 2
    property bool teamModeConnected: teamRounter.connected || (QGroundControl.corePlugin.slaveMode && teamLink && teamLink.connected)

    QGCColoredImage {
        width:              height
        anchors.top:        parent.top
        anchors.bottom:     parent.bottom
        sourceSize.height:  height
        source:             "qrc:/qmlimages/teammode.svg"
        fillMode:           Image.PreserveAspectFit
        opacity:            teamModeConnected ? 1 : 0.25
        color:              QGroundControl.corePlugin.slaveMode ? qgcPal.colorBlue : qgcPal.text
    }

    MouseArea {
        anchors.fill: parent
        anchors.margins: -ScreenTools.defaultFontPixelHeight * 0.66
        onClicked: {
            if(teamModeConnected) {
                mainWindow.showIndicatorPopup(_root, wifiRSSIInfo)
            } else {
                mainWindow.hideIndicatorPopup()
                mainWindow.showPopupDialogFromComponent(teamManagementComponent)
            }
        }
    }

    //-------------------------------------------------------------------------
    //-- Team Devices Management
    Component {
        id:             teamManagementComponent
        QGCPopupDialog {
            id:         teamManagement
            title:      qsTr("Team Devices Management")
            buttons:    StandardButton.Close
            property var    _activeVehicle:       QGroundControl.multiVehicleManager.activeVehicle
            property real   _labelWidth:          ScreenTools.defaultFontPixelWidth * 15
            property real   _editFieldWidth:      ScreenTools.defaultFontPixelWidth * 30
            property var    _connectText:         qsTr("Connect")
            Item {
                id:         teamManagementItem
                width:  mainWindow.width  * 0.3
                height: mainWindow.height * 0.6

                ExclusiveGroup  { id: ssidGroup }

                Timer {
                    id: pairConnectedTimer
                    interval: 3000
                    running: false
                    repeat: false
                    triggeredOnStart: false
                    onTriggered: { teamManagement.hideDialog(); }
                }

                Connections {
                    target: teamRounter
                    function onPairingTimeout() {
                        timeoutDialog.failed = false
                        timeoutDialog.visible = true
                    }
                    function onPairingFailed() {
                        timeoutDialog.failed = true
                        timeoutDialog.visible = true                       
                    }
                    function onConnectedChanaged() {
                        if(teamModeConnected) {
                            pairConnectedTimer.restart()
                        }
                    }
                }

                Connections {
                    target: teamLink
                    function onConnectedChanged() {
                        if(teamModeConnected) {
                            pairConnectedTimer.restart()
                        }
                    }
                }

                Component.onDestruction: {
                    if(_isP2P) teamRounter.stopP2PScan();
                }

                Component.onCompleted: {
                    if(_isP2P && !teamRounter.p2pConnected) teamRounter.startP2PScan(2000)
                    Qt.inputMethod.hide();
                }

                Column {
                    id:                 wifiRectHeader
                    spacing:            ScreenTools.defaultFontPixelHeight * 0.5
                    anchors.top:        parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width - ScreenTools.defaultFontPixelHeight * 4
                    Row {
                        spacing:    ScreenTools.defaultFontPixelWidth
                        height:     scanningIcon.height
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.horizontalCenterOffset: scanningIcon.width * 0.5
                        QGCLabel {
                            text: QGroundControl.corePlugin.slaveMode && _isLAN ? qsTr("Slave Mode") : qsTr("Select Device to Connect")
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        QGCColoredImage {
                            height:             ScreenTools.defaultFontPixelHeight
                            width:              height
                            source:             "qrc:/qmlimages/teammode.svg"
                            sourceSize.height:  height
                            fillMode:           Image.PreserveAspectFit
                            mipmap:             true
                            smooth:             true
                            color:              qgcPal.buttonText
                            anchors.verticalCenter: parent.verticalCenter
                            visible:            teamModeConnected || teamRounter.p2pConnected
                        }
                        QGCColoredImage {
                            id:                 scanningIcon
                            height:             ScreenTools.defaultFontPixelHeight * 2
                            width:              height
                            source:             "/qmlimages/MapSync.svg"
                            sourceSize.height:  height
                            fillMode:           Image.PreserveAspectFit
                            mipmap:             true
                            smooth:             true
                            color:              qgcPal.buttonText
                            anchors.verticalCenter: parent.verticalCenter
                            visible:            !teamModeConnected && !teamRounter.p2pConnected
                            RotationAnimation on rotation {
                                id:             imageRotation
                                loops:          Animation.Infinite
                                from:           360
                                to:             0
                                duration:       750
                                running:        _isLAN ? true : teamRounter.scanningDevice
                            }
                            MouseArea {
                                anchors.fill:   parent
                                enabled:        _isP2P
                                onClicked:      teamRounter.startP2PScan();
                            }
                        }
                    }
                    CustomOnOffSwitch {
                        width: parent.width
                        anchors.horizontalCenter: parent.horizontalCenter
                        checked: QGroundControl.corePlugin.slaveMode
                        leftText: qsTr("Master")
                        rightText: qsTr("Slave")
                        enabled: !teamModeConnected
                        opacity: teamModeConnected ? 0.5 : 1
                        onClicked: QGroundControl.corePlugin.slaveMode = (checked ? true : false)
                    }
                    QGCLabel {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: qsTr("Mode: ") + teamMode.enumOrValueString
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    QGCLabel {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: qsTr("Local Device Name: ") + (teamRounter.localDeviceName.length == 0 ? qsTr("UNKNOWN") : teamRounter.localDeviceName)
                        anchors.horizontalCenter: parent.horizontalCenter
                        visible: _isP2P
                    }
                    QGCLabel {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: qsTr("Local Device IP: ") + teamRounter.localIP
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    QGCLabel {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: qsTr("Remote Device IP: ") + ((QGroundControl.corePlugin.slaveMode && teamLink) ? teamLink.targetName : teamRounter.remoteIP)
                        anchors.horizontalCenter: parent.horizontalCenter
                        visible: _isP2P && teamRounter.p2pConnected
                    }
                    QGCLabel {
                        width: parent.width
                        wrapMode: Text.WordWrap
                        text: qsTr("Please select on the master controller to connect to the slave controller.")
                        font.pointSize: ScreenTools.mediumFontPointSize
                        visible: _isLAN && QGroundControl.corePlugin.slaveMode
                    }
                }
                QGCFlickable {
                    clip:               true
                    width:              scanCol.width
                    contentHeight:      scanCol.height
                    contentWidth:       scanCol.width
                    visible:            true
                    anchors.top:        wifiRectHeader.bottom
                    anchors.bottom:     wifiRectFooter.top
                    anchors.topMargin:  ScreenTools.defaultFontPixelHeight * 0.5
                    anchors.bottomMargin:  ScreenTools.defaultFontPixelHeight * 0.5
                    anchors.horizontalCenter: parent.horizontalCenter
                    Column {
                        id:         scanCol
                        spacing:    ScreenTools.defaultFontPixelHeight * 0.25
                        width:      ScreenTools.defaultFontPixelWidth * 25
                        anchors.centerIn: parent
                        Repeater {
                            model: {
                                if(_isP2P && !teamRounter.p2pConnected)
                                    return teamRounter.p2pDevices
                                else if(_isLAN)
                                    return teamRounter.clients
                                else return 0
                            }
                            delegate: _isP2P ? p2pDelegate : lanDelegate
                        }
                        Component {
                            id: p2pDelegate
                            CustomSSIDButton {
                                width:              ScreenTools.defaultFontPixelWidth * 25
                                exclusiveGroup:     ssidGroup
                                text:               object.objectName// + "(" + object.address + ")"
                                rssi:               0
                                source:             "qrc:/InstrumentValueIcons/checkmark.svg"
                                showRssi:           false
                                showIcon:           false
                                enabled:            true
                                anchors.horizontalCenter:   parent.horizontalCenter
                                onClicked: {
                                    if(teamRounter.p2pConnected) return;
                                    teamRounter.connectP2PDevice(object.address)
                                }
                            }
                        }
                        Component {
                            id: lanDelegate
                            CustomSSIDButton {
                                width:              ScreenTools.defaultFontPixelWidth * 25
                                exclusiveGroup:     ssidGroup
                                text:               object.name
                                rssi:               0
                                source:             "qrc:/InstrumentValueIcons/checkmark.svg"
                                showRssi:           false
                                showIcon:           object.enable
                                anchors.horizontalCenter:   parent.horizontalCenter
                                visible:            object.enable || object.connected
                                enabled:            !teamRounter.current || teamRounter.current === object
                                opacity:            enabled ? 1 : 0.5
                                onClicked:  {
                                    //object.enable = !object.enable
                                    if(object.enable)
                                        teamRounter.disconnectTo(object)
                                    else teamRounter.connectTo(object)
                                    checked = Qt.binding(function() { return object.enable })
                                }
                            }
                        }
                    }
                }
                Row {
                    id:                     wifiRectFooter
                    spacing:                ScreenTools.defaultFontPixelWidth * 4
                    visible:                true
                    anchors.bottom:         parent.bottom
                    anchors.bottomMargin:   ScreenTools.defaultFontPixelHeight
                    anchors.horizontalCenter: parent.horizontalCenter
                    QGCButton {
                        text:           qsTr("Disconnect")
                        width:          ScreenTools.defaultFontPixelWidth  * 12
                        height:         ScreenTools.defaultFontPixelHeight * 2
                        //-- Don't allow restting if vehicle is connected and armed
                        enabled:        ((_isLAN && QGroundControl.corePlugin.slaveMode && teamModeConnected) || teamRounter.p2pConnected) && !teamRounter.pairing
                        visible:        QGroundControl.corePlugin.slaveMode || _isP2P
                        onClicked: {
                            if(teamRounter.p2pConnected)
                                teamRounter.disconnectP2PDevice()
                            if(QGroundControl.corePlugin.slaveMode) {
                                teamLink.tiggerUnBind(true)
                            }
                        }
                    }
                }
                Rectangle {
                    id:     connectingRect
                    anchors.fill: parent
                    radius: ScreenTools.defaultFontPixelWidth
                    color:  qgcPal.window
                    visible: teamRounter.pairing
                    QGCLabel {
                        text:               ((_isP2P && !teamRounter.p2pConnected) || (_isLAN && teamRounter.isBind)) ? qsTr("Connecting...") : qsTr("Disconnecting...")
                        font.family:        ScreenTools.demiboldFontFamily
                        anchors.top:        parent.top
                        anchors.topMargin:  parent.height * 0.3333
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    QGCColoredImage {
                        height:             ScreenTools.defaultFontPixelHeight * 2
                        width:              height
                        source:             "/qmlimages/MapSync.svg"
                        sourceSize.height:  height
                        fillMode:           Image.PreserveAspectFit
                        mipmap:             true
                        smooth:             true
                        color:              qgcPal.buttonText
                        anchors.centerIn:   parent
                        RotationAnimation on rotation {
                            id:             connectionRotation
                            loops:          Animation.Infinite
                            from:           360
                            to:             0
                            duration:       740
                            running:        connectingRect.visible
                        }
                    }
                }
                //-- Connection Timeout/Failed
                Rectangle {
                    id:         timeoutDialog
                    width:      timeoutCol.width  * 1.5
                    height:     timeoutCol.height * 1.5
                    radius:     ScreenTools.defaultFontPixelWidth * 0.5
                    color:      qgcPal.window
                    visible:    false
                    border.width:   1
                    border.color:   qgcPal.text
                    anchors.top:    parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    property bool failed: false
                    Keys.onBackPressed: {
                        timeoutDialog.visible = false
                    }
                    DeadMouseArea {
                        anchors.fill:   parent
                    }
                    Column {
                        id:         timeoutCol
                        spacing:    ScreenTools.defaultFontPixelHeight
                        anchors.centerIn: parent
                        QGCLabel {
                            text:   timeoutDialog.failed ? qsTr("Connection failed") : qsTr("Connection Timeout")
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                        QGCButton {
                            text:       qsTr("Close")
                            width:      _labelWidth
                            anchors.horizontalCenter: parent.horizontalCenter
                            onClicked:  {
                                timeoutDialog.visible = false
                            }
                        }
                    }
                }
            }
        }
    }

    Component {
        id: wifiRSSIInfo
        Rectangle {
            id:     wifiInfoRect
            width:  rcrssiCol.width   + ScreenTools.defaultFontPixelWidth  * 3
            height: rcrssiCol.height  + ScreenTools.defaultFontPixelHeight * 2
            radius: ScreenTools.defaultFontPixelHeight * 0.5
            color:  qgcPal.window
            border.color:   qgcPal.text

            Column {
                id:                 rcrssiCol
                spacing:            ScreenTools.defaultFontPixelHeight * 0.5
                width:              Math.max(rcrssiGrid.width, rssiLabel.width)
                anchors.margins:    ScreenTools.defaultFontPixelHeight
                anchors.centerIn:   parent

                QGCLabel {
                    id:             rssiLabel
                    text:           qsTr("Team Mode Work Status")
                    font.family:    ScreenTools.demiboldFontFamily
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                GridLayout {
                    id:                 rcrssiGrid
                    anchors.margins:    ScreenTools.defaultFontPixelHeight
                    columnSpacing:      ScreenTools.defaultFontPixelWidth
                    columns:            2
                    anchors.horizontalCenter: parent.horizontalCenter

                    QGCLabel { text: qsTr("Mode:"); }
                    QGCLabel { text: teamMode.enumOrValueString; }
                    QGCLabel { text: qsTr("Role:"); }
                    QGCLabel { text: QGroundControl.corePlugin.slaveMode ? qsTr("Slave") : qsTr("Master"); }
                    QGCLabel { text: qsTr("Name:"); visible: _isP2P }
                    QGCLabel { text: teamRounter.localDeviceName; visible: _isP2P }
                    QGCLabel { text: qsTr("Local:"); }
                    QGCLabel { text: teamRounter.localIP; }
                    QGCLabel { text: qsTr("Remote:"); }
                    QGCLabel { text: QGroundControl.corePlugin.slaveMode ? teamLink.targetName : teamRounter.remoteIP; }
                }

                QGCButton {
                    text: qsTr("Team Management")
                    onClicked: {
                        mainWindow.showPopupDialogFromComponent(teamManagementComponent)
                        mainWindow.hideIndicatorPopup()
                    }
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }
}
