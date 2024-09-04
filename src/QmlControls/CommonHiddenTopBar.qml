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
    id: root
    color: defaultBackGroundColor
    z: 3

    //Color Property
    property color defaultTextColor: "white"
    property color transparent: "transparent"
    property color blue: "#3d71d7"
    property color defaultBackGroundColor: Qt.rgba(0, 0, 0, 0.6)

    //Size Property
    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize

    implicitWidth: Screen.width
    implicitHeight: defaultFontSize * 5.8

    Row {
        id:                     viewButtonRow
        anchors.top:            parent.top
        anchors.bottom:         parent.bottom
        width: parent.width
        anchors.fill: parent


        Item {
            height: 1
            width: viewButtonRow.width / 6
        }

        Image {
            source: "/res/TopMenuGpsStatus.svg"
            height: defaultFontSize * 4
            width: height
            anchors.verticalCenter: parent.verticalCenter
        }
        Image {
            source: "/res/TopMenuSignalLevel.svg"
            height: defaultFontSize * 4
            width: height
            anchors.verticalCenter: parent.verticalCenter
        }
        Item {
            width: viewButtonRow.width / 10
            height: 10
        }
        Image {
            source: "/res/TopMenuRemoteControllerConnectionStatus.svg"
            height: defaultFontSize * 4
            width: height
            anchors.verticalCenter: parent.verticalCenter
        }
        Image {
            source: "/res/TopMenuSignalLevel.svg"
            height: defaultFontSize * 4
            width: height
            anchors.verticalCenter: parent.verticalCenter
        }
        Item {
            width: viewButtonRow.width / 10
            height: 10
        }
        Image {
            source: "/res/TopMenuImageTransferStatus.svg"
            height: defaultFontSize * 4
            width: height
            anchors.verticalCenter: parent.verticalCenter
        }
        Image {
            source: "/res/TopMenuSignalLevel.svg"
            height: defaultFontSize * 4
            width: height
            anchors.verticalCenter: parent.verticalCenter
        }
        Item {
            width: viewButtonRow.width / 10
            height: 10
        }
        Image {
            source: "/res/TopMenuBattery2.svg"
            height: defaultFontSize * 4
            width: height
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            height: parent.height - defaultFontSize * 2.4
            font.pixelSize: ScreenTools.defaultFontPixelHeight * 2
            text: qsTr("N/A")
            color: defaultTextColor
            anchors.verticalCenter: parent.verticalCenter
        }
        Item {
            width: viewButtonRow.width / 10
            height: 10
        }
        Image {
            source: "/res/TopMenuBatteryPower.svg"
            height: defaultFontSize * 4
            width: height
            anchors.verticalCenter: parent.verticalCenter
        }
        Text {
            height: parent.height - defaultFontSize * 2.4
            font.pixelSize: ScreenTools.defaultFontPixelHeight * 2
            text: qsTr("N/A")
            color: defaultTextColor
            anchors.verticalCenter: parent.verticalCenter
        }

        Item {
            width: viewButtonRow.width / 10
            height: 10
        }

        Button {
            anchors.verticalCenter: parent.verticalCenter
            height: defaultFontSize * 4
            width: height
            background: Rectangle {
                color: transparent
                Image{
                    source: "qrc:/res/ales/waypoint/UpDir.svg"
                    anchors.fill: parent
                }
            }
            onClicked: {
                root.visible = false;
            }
        }
    }
}
