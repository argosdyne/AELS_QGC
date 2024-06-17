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
    color: defaultTextColor
    z : 3

    //Color Property
    property color defaultTextColor: "white"
    property color transparent: "transparent"
    property color lightGray: "#d3d3d3"
    property color blue: "#3d71d7"

    //Size Property
    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize

    implicitWidth: Screen.width / 3.6
    implicitHeight: Screen.height / 4.2

    radius: defaultFontSize * 3

    //Bottom Separator
    Rectangle {
        width: parent.width
        height: 2
        color: lightGray
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height / 3.4
    }

    Rectangle {
        width: 2
        height: parent.height / 3.4
        color: lightGray
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
    }

    //Left Button
    Button {
        width: parent.width / 2
        height: parent.height / 3.4
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        background: Rectangle { color: transparent }
        Text {
            text: "Cancel"
            font.pixelSize: defaultFontSize * 3
            font.bold: true
            color: blue
            anchors.centerIn: parent
        }
        onClicked: {
            console.log("Click Button");
        }
    }

    // Right Button
    Button {
        width: parent.width / 2
        height: parent.height / 3.4
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        background: Rectangle { color: transparent }
        Text {
            text: "Download"
            font.pixelSize: defaultFontSize * 3
            color: blue
            anchors.centerIn: parent
        }
    }

    // Middle Text
    Rectangle {
        width: parent.width
        height: parent.height / 1.4
        anchors.top: parent.top
        color: transparent
        Text{
            width: parent.width / 1.1
            text: "Files must be downloads to your device before sharing. Tap Download to continue, tapCancel to exit"
            wrapMode: Text.WordWrap
            font.pixelSize: defaultFontSize * 3
            anchors.centerIn: parent

        }
    }
}


