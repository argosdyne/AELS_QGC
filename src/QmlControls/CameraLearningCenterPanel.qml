import QtQuick          2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts  1.11
import QtQuick.Dialogs  1.3
import QtQuick.Window 2.15

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.Palette               1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Controllers           1.0
import QtGraphicalEffects                   1.12

Rectangle {
    id: root
    color: darkgray
    z: 3

    //Color Property
    property color defaultTextColor: "white"
    property color transparent: "transparent"
    property color darkgray: "#3c3434"
    property color lightgray: "#848282"

    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize

    implicitWidth: Screen.width / 2.2
    implicitHeight: Screen.height / 1.9

    Rectangle {
        width: parent.width
        height: 2
        color: lightgray
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: parent.height / 7.2
    }

    Rectangle {
        width: parent.width
        height: 2
        color: lightgray
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height / 6.4
    }
    //Title Text
    Rectangle {
        width: parent.width
        height: parent.height / 7.2
        anchors.top: parent.top
        color: transparent

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            text: "Learning Center"
            font.pixelSize: defaultFontSize * 4
            color: defaultTextColor
        }
    }

    Column {
        width: parent.width
        height: parent.height / 1.4
        anchors.top: parent.top
        anchors.topMargin: parent.height / 7.2

        Item {
            width: 1
            height: parent.height / 8.5
        }

        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            source:"qrc:/res/LearningCenter.svg"
        }

        Item {
            width: 1
            height: parent.height / 17
        }
        Text {
            text: "Combination stick command to start the motors"
            color: defaultTextColor
            font.pixelSize: defaultFontSize * 3
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Item {
            width: 1
            height: parent.height / 12.3
        }

        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            source: "qrc:/res/DragRight.svg"
        }
    }

    Button {
        width: parent.width
        height: parent.height / 6.4
        anchors.bottom: parent.bottom
        background: Rectangle{
            color: transparent
            anchors.fill: parent
        }

        Text {
            text: "Next"
            color: defaultTextColor
            font.pixelSize: defaultFontSize * 3
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
