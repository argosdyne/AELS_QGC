import QtQuick          2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts  1.11
import QtQuick.Dialogs  1.3
import QtQuick.Window 2.0

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.Palette               1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Controllers           1.0
import QtGraphicalEffects                   1.12

Rectangle {
    id:     root
    color: fontColorWhite   

    //Color Property
    property color defaultTextColor: "white"
    property color transparent: "transparent"
    property color fontColorWhite: "white"
    property color fontColorlightGray: "#a7a7a7"
    property color defaultBackGroundColor: "#3b3737"
    property color fontColorRed: "red"

    //Size Property
    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize

    implicitWidth: Screen.width
    implicitHeight: Screen.height

    Column {
        anchors.fill: parent

        Item {
            width: 1
            height: parent.height / 32
        }

        Row {
            width: parent.width
            height: parent.height / 24

            Item {
                width: parent.width / 1.06
                height: 1
            }
            Button {
                background: Rectangle {
                    color: transparent
                    Image {
                        source: "qrc:/res/CloseLightgray.svg"
                    }
                }
            }
        }

        Item {
            width: 1
            height: parent.height / 32
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: defaultFontSize * 4
            text: "connection wizard"
            font.bold: true
        }

        Item {
            width: 1
            height: parent.height / 12
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: defaultFontSize * 3
            text: "power on the remote control, unfold the remote control handle and connect the smartphone"
            color: fontColorlightGray
        }

        Item {
            width: 1
            height: parent.height / 12
        }

        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            source: "qrc:/res/Controller.png"
            width: parent.width / 3.05
            height: parent.height / 3
        }

        Item {
            width: 1
            height: parent.height / 13.17
        }

        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            source: "qrc:/res/CancelIcon.svg"
            width: parent.width / 27.42
            height: width
        }

        Item {
            width: 1
            height: parent.height / 22.5
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: defaultFontSize * 3
            text: "remote control and moblie phone disconnected"
            color: fontColorRed
        }
    }
}