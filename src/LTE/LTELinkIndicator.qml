import QtQuick          2.11
import QtQuick.Layouts  1.11
import QtQuick.Dialogs  1.2
import QtQuick.Controls 1.4

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Palette               1.0
import QGroundControl.FactSystem            1.0
import QGroundControl.FactControls          1.0

import CustomQmlInterface                   1.0
import Custom.Widgets                       1.0

Item {
    id:  _root
    width:          signalRow.width

    QGCPalette { id: qgcPal }

    property real _labelWidth: ScreenTools.defaultFontPixelWidth * 8
    property real _valueFieldWidth: ScreenTools.defaultFontPixelWidth * 25
    property real _margin:          ScreenTools.defaultFontPixelWidth
    property real _butttonWidth:    ScreenTools.defaultFontPixelWidth * 10
    property var lteManager: CustomQmlInterface.lteManager
    property var _connectedDrone: lteManager.connectedDrone
    property bool _connected: lteManager.droneConnected

    Component {
        id:                                     lteInfo
        Rectangle {
            id:                                 lteInfoRect
            width:                              lteInfoCol.width  + ScreenTools.defaultFontPixelWidth * 4
            height:                             lteInfoCol.height + ScreenTools.defaultFontPixelWidth * 4
            radius:                             ScreenTools.defaultFontPixelHeight * 0.5
            color:                              qgcPal.window
            border.color:                       qgcPal.text

            MouseArea {
                // This MouseArea prevents the Map below it from getting Mouse events. Without this
                // things like mousewheel will scroll the Flickable and then scroll the map as well.
                anchors.fill:                   parent
                preventStealing:                true
                onWheel:                        wheel.accepted = true
            }

            Column {
                id:                             lteInfoCol
                spacing:                        ScreenTools.defaultFontPixelHeight
                anchors.margins:                ScreenTools.defaultFontPixelHeight
                anchors.centerIn:               parent

                QGCLabel {
                    text:                       _connected ? qsTr("Link Status") : qsTr("Link Disconnected")
                    font.family:                ScreenTools.demiboldFontFamily
                    anchors.horizontalCenter:   parent.horizontalCenter
                }

                GridLayout {
                    visible:                    _connected
                    columnSpacing:              ScreenTools.defaultFontPixelWidth
                    columns:                    2
                    anchors.margins:            ScreenTools.defaultFontPixelHeight
                    anchors.horizontalCenter:   parent.horizontalCenter

                    QGCLabel {
                        text:                   qsTr("ID:")
                        color:                  qgcPal.text
                    }
                    QGCLabel {
                        text:                   _connectedDrone ? _connectedDrone.name : qsTr("N/A")
                        color:                  qgcPal.text
                    }

                    QGCLabel {
                        text:                   qsTr("Aircraft:")
                        color:                  qgcPal.text
                    }
                    QGCLabel {
                        text:                   _connectedDrone ? (_connectedDrone.hasAircraft ? qsTr("online") : qsTr("offline")) : qsTr("N/A")
                        color:                  qgcPal.text
                    }

                    QGCLabel {
                        text:                   qsTr("Airport:")
                        color:                  qgcPal.text
                        visible:                _connectedDrone && _connectedDrone.hasAirport
                    }
                    QGCLabel {
                        text:                   _connectedDrone ? (_connectedDrone.hasAirport ? qsTr("online") : qsTr("offline")) : qsTr("N/A")
                        color:                  qgcPal.text
                        visible:                _connectedDrone && _connectedDrone.hasAirport
                    }
                }

                QGCButton {
                    text:                       qsTr("Reconnect")
                    width:                      ScreenTools.defaultFontPixelWidth * 15
                    anchors.horizontalCenter:   parent.horizontalCenter
                    onClicked: {
                        mainWindow.hideIndicatorPopup()
                        mainWindow.showPopupDialogFromComponent(ltePairGuideComponent)
                    }
                }
            }
        }
    }

    // Signal
    Row {
        id:                                     signalRow
        spacing:                                ScreenTools.defaultFontPixelWidth
        anchors.top:                            parent.top
        anchors.bottom:                         parent.bottom
        anchors.horizontalCenter:               parent.horizontalCenter

        QGCColoredImage {
            source:             "/qmlimages/lte.svg"
            fillMode:           Image.PreserveAspectFit
            width:              ScreenTools.defaultFontPixelHeight * 1.6
            height:             width
            color:              qgcPal.buttonText
            sourceSize.height:  height
            opacity:            _connected ? 1 : 0.6
        }
    }

    Component {
        id: ltePairGuideComponent
        QGCPopupDialog {
            id:         ltePairGuide
            title:      qsTr("LTE Link Connection")
            buttons:    StandardButton.Close
            Timer {
                id: ltePairGuideRefreshTimer
                interval: 10000
                running: lteManager.logined
                repeat: true
                triggeredOnStart: true
                onTriggered: { lteManager.refresh(); }
            }
            Item {
                width: mainWindow.width * 0.6
                height: mainWindow.height * 0.6
                Rectangle {
                    visible: !lteManager.logined
                    anchors.centerIn: parent
                    width: lteLoginGridLayout.width + ScreenTools.defaultFontPixelHeight * 2
                    height: lteLoginTitleRect.height + lteLoginGridLayout.height + lteLoginGridLayout.anchors.topMargin + ScreenTools.defaultFontPixelHeight
                    color: qgcPal.windowShade
                    clip: true
                    radius: 4
                    Rectangle {
                        id: lteLoginTitleRect
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        height: ScreenTools.defaultFontPixelHeight * 2
                        color: qgcPal.colorBlue
                        QGCLabel {
                            text:           qsTr("Login LTE Server")
                            font.family:    ScreenTools.demiboldFontFamily
                            anchors.centerIn: parent
                            font.pointSize: ScreenTools.largeFontPointSize
                        }
                    }
                    GridLayout {
                        id: lteLoginGridLayout
                        anchors.top: lteLoginTitleRect.bottom
                        anchors.left: parent.left
                        anchors.margins: ScreenTools.defaultFontPixelHeight
                        columnSpacing: ScreenTools.defaultFontPixelHeight
                        columns: 2
                        QGCLabel {
                            text:           qsTr("Host:")
                            Layout.minimumWidth: _labelWidth
                        }
                        FactTextField {
                            fact: lteManager.settings.serverURL
                            Layout.minimumWidth: _valueFieldWidth
                            enabled: !lteManager.logined && !lteManager.logining
                        }
                        QGCLabel {
                            Layout.minimumWidth: _labelWidth
                            text: qsTr("User:")
                        }
                        FactTextField {
                            fact: lteManager.settings.username
                            Layout.minimumWidth: _valueFieldWidth
                            enabled: !lteManager.logined && !lteManager.logining
                        }
                        QGCLabel {
                            Layout.minimumWidth: _labelWidth
                            text: qsTr("Password:")
                        }
                        FactTextField {
                            fact: lteManager.settings.password
                            echoMode: TextInput.PasswordEchoOnEdit
                            Layout.minimumWidth: _valueFieldWidth
                            enabled: !lteManager.logined && !lteManager.logining
                        }
                        RowLayout {
                            Layout.columnSpan: 2
                            QGCButton {
                                text: lteManager.logined ? qsTr("Log out") : qsTr("Log in")
                                Layout.fillWidth: true
                                enabled: lteManager.settings.serverURL.valueString !== "" &&
                                        lteManager.settings.username.valueString !== "" &&
                                        lteManager.settings.password.valueString !== "" &&
                                        !lteManager.logining
                                onClicked: {
                                    if(!lteManager.logined)
                                        lteManager.login()
                                    else lteManager.logout()
                                }
                            }
                            QGCColoredImage {
                                id:                 busyIndicator
                                height:             ScreenTools.defaultFontPixelHeight
                                width:              height
                                source:             "/qmlimages/MapSync.svg"
                                sourceSize.height:  height
                                fillMode:           Image.PreserveAspectFit
                                mipmap:             true
                                smooth:             true
                                color:              qgcPal.colorGreen
                                visible:            lteManager.logining
                                RotationAnimation on rotation {
                                    loops:          Animation.Infinite
                                    from:           360
                                    to:             0
                                    duration:       740
                                    running:        busyIndicator.visible
                                }
                            }
                            QGCColoredImage {
                                width: ScreenTools.defaultFontPixelHeight
                                height: width
                                visible: !lteManager.logining
                                source: lteManager.logined ? "qrc:/custom/img/yes.svg" : "qrc:/custom/img/no.svg"
                                color: lteManager.logined ? qgcPal.colorGreen : qgcPal.colorRed
                                sourceSize.height: height
                                sourceSize.width:  width
                            }
                        }
                    }
                }
                RowLayout {
                    visible: lteManager.logined
                    anchors.fill: parent
                    TableView {
                        id: tableView
                        Layout.fillHeight:  true
                        model:              lteManager.drones
                        selectionMode:      SelectionMode.SingleSelection
                        Layout.fillWidth:   true
                        backgroundVisible:  false
                        headerDelegate: Rectangle{
                            color : qgcPal.windowShade
                            height: ScreenTools.defaultFontPixelHeight * ScreenTools.mediumFontPointRatio
                            QGCLabel {
                                anchors.centerIn: parent
                                text: styleData.value
                                font.pointSize: ScreenTools.mediumFontPointSize
                                font.bold: true
                            }
                        }
                        rowDelegate: Rectangle {
                            height: Math.max(ScreenTools.defaultFontPixelHeight * 1.8, ScreenTools.minTouchPixels)
                            color: {
                                var o = lteManager.drones.get(styleData.row);
                                var running = o && (o.running && !o.hasGroundcontrol || o.frpcRunning)
                                return styleData.selected && running ? qgcPal.buttonHighlight : "transparent"//(styleData.alternate ? "lightgray" : "transparent")
                            }
                        }

                        TableViewColumn {
                            title: qsTr("No.")
                            width: tableView.width / tableView.columnCount
                            horizontalAlignment: Text.AlignHCenter
                            delegate : QGCLabel {
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.pointSize: ScreenTools.mediumFontPointSize
                                opacity: {
                                    var o = lteManager.drones.get(styleData.row)
                                    return o && (o.running && !o.hasGroundcontrol || o.frpcRunning) ? 1 : 0.4
                                }
                                text: styleData.row
                            }
                        }

                        TableViewColumn {
                            title: qsTr("Id")
                            width: tableView.width / tableView.columnCount
                            horizontalAlignment: Text.AlignHCenter
                            delegate : QGCLabel  {
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.pointSize: ScreenTools.mediumFontPointSize
                                opacity: {
                                    var o = lteManager.drones.get(styleData.row)
                                    return o && (o.running && !o.hasGroundcontrol || o.frpcRunning) ? 1 : 0.4
                                }
                                text: {
                                    var o = lteManager.drones.get(styleData.row)
                                    return o ? o.name : ""
                                }
                            }
                        }

                        TableViewColumn {
                            title: qsTr("Aircraft")
                            width: tableView.width / tableView.columnCount - 1
                            horizontalAlignment: Text.AlignHCenter
                            delegate : QGCLabel  {
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.pointSize: ScreenTools.mediumFontPointSize
                                opacity: {
                                    var o = lteManager.drones.get(styleData.row)
                                    return o && (o.running && !o.hasGroundcontrol || o.frpcRunning) ? 1 : 0.4
                                }
                                text: {
                                    var o = lteManager.drones.get(styleData.row)
                                    return o ? (o.hasAircraft ? qsTr("online") : qsTr("offline")) : ""
                                }
                            }
                        }

                        TableViewColumn {
                            title: qsTr("Airport")
                            width: tableView.width / tableView.columnCount - 1
                            horizontalAlignment: Text.AlignHCenter
                            delegate : QGCLabel  {
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.pointSize: ScreenTools.mediumFontPointSize
                                opacity: {
                                    var o = lteManager.drones.get(styleData.row)
                                    return o && (o.running && !o.hasGroundcontrol || o.frpcRunning) ? 1 : 0.4
                                }
                                text: {
                                    var o = lteManager.drones.get(styleData.row)
                                    return o ? (o.hasAirport ? qsTr("online") : qsTr("offline")) : ""
                                }
                            }
                        }

                        TableViewColumn {
                            title: qsTr("Status")
                            width: tableView.width / tableView.columnCount
                            horizontalAlignment: Text.AlignHCenter
                            delegate : QGCLabel  {
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                                font.pointSize: ScreenTools.mediumFontPointSize
                                opacity: {
                                    var o = lteManager.drones.get(styleData.row)
                                    return o && (o.running && !o.hasGroundcontrol || o.frpcRunning) ? 1 : 0.4
                                }
                                text: {
                                    var o = lteManager.drones.get(styleData.row)
                                    return o ? (o.frpcRunning || o.hasGroundcontrol ? qsTr("connected") : qsTr("disconnected")) : ""
                                }
                            }
                        }
                    }
                    Column {
                        spacing:            _margin
                        Layout.alignment:   Qt.AlignTop | Qt.AlignLeft
                        QGCButton {
                            text:       qsTr("Logout")
                            checkable:  false
                            width:      _butttonWidth
                            onClicked: {
                                lteManager.logout()
                            }
                        }
                        QGCButton {
                            text:       qsTr("Refresh")
                            checkable:  false
                            width:      _butttonWidth
                            onClicked: {
                                lteManager.refresh()
                            }
                        }
                        QGCButton {
                            width:      _butttonWidth
                            checkable:  false
                            enabled:    lteManager.drones.get(tableView.currentRow) &&
                                        (lteManager.drones.get(tableView.currentRow).running && !lteManager.drones.get(tableView.currentRow).hasGroundcontrol || lteManager.drones.get(tableView.currentRow).frpcRunning)
                            text: {
                                var o = lteManager.drones.get(tableView.currentRow)
                                return o && o.frpcRunning ? qsTr("Disconnect") : qsTr("Connect")
                            }
                            onClicked: {
                                var o = lteManager.drones.get(tableView.currentRow)
                                if(o) {
                                    if(o.frpcRunning) {
                                        o.stop()
                                    } else {
                                        lteManager.start(o)
                                    }
                                    ltePairGuideRefreshTimer.restart()
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    MouseArea {
        anchors.fill:                   parent
        anchors.margins:                -ScreenTools.defaultFontPixelHeight * 0.66
        onClicked: {
            if (_connected) {
                mainWindow.showIndicatorPopup(_root, lteInfo)
            } else {
                mainWindow.hideIndicatorPopup()
                mainWindow.showPopupDialogFromComponent(ltePairGuideComponent)
            }
        }
    }
}
