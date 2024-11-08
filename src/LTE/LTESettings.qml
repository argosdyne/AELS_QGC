import QtQuick                  2.3
import QtQuick.Controls         1.2
import QtQuick.Controls.Styles  1.4
import QtQuick.Dialogs          1.2
import QtQuick.Layouts          1.2

import QGroundControl                       1.0
import QGroundControl.FactSystem            1.0
import QGroundControl.FactControls          1.0
import QGroundControl.Controls              1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.Palette               1.0
import QGroundControl.Controllers           1.0
import QGroundControl.SettingsManager       1.0

import CustomQmlInterface                   1.0

Rectangle {
    id:                 _root
    color:              qgcPal.window
    anchors.fill:       parent
    anchors.margins:    ScreenTools.defaultFontPixelWidth

    property var lteManager: CustomQmlInterface.lteManager
    property real _labelWidth: ScreenTools.defaultFontPixelWidth * 10
    property real _valueFieldWidth: ScreenTools.defaultFontPixelWidth * 30

    QGCFlickable {
        clip:               true
        anchors.fill:       parent
        contentHeight:      outerItem.height
        contentWidth:       outerItem.width

        Item {
            id:     outerItem
            width:  Math.max(_root.width, settingsColumn.width)
            height: settingsColumn.height

            GridLayout {
                id:                         settingsColumn
                anchors.margins:    ScreenTools.defaultFontPixelHeight
                columnSpacing:      ScreenTools.defaultFontPixelHeight
                anchors.horizontalCenter: parent.horizontalCenter
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
                QGCButton {
                    text: qsTr("Refresh")
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    enabled: lteManager.logined
                    onClicked: {
                        lteManager.refresh()
                    }
                }
                Repeater {
                    model: lteManager.drones
                    RowLayout {
                        Layout.columnSpan: 2
                        QGCLabel {
                            Layout.minimumWidth: _labelWidth
                            text: object.name
                        }
                        QGCButton {
                            text: qsTr("Connect")
                            Layout.minimumWidth: _valueFieldWidth
                            onClicked: {
                                object.start()
                            }
                        }
                    }
                }
            }
        }
    }
}
