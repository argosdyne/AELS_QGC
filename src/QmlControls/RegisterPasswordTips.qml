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

    //Color Property
    property color defaultTextColor: "white"
    property color transparent: "transparent"
    property color darkgray: "#3c3434"
    property color lightgray: "#848282"    
    property color blue: "#3d71d7"

    //Size Property
       property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize

    implicitWidth: Screen.width / 4.08  //466
    implicitHeight: Screen.height / 3.44 // 314

    radius: defaultFontSize

    Rectangle {
        width: parent.width
        height: 2 
        color: lightgray
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: parent.height / 7
    }

    Rectangle {
        width: parent.width
        height: 2
        color: lightgray
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height / 8
    }

    Rectangle {
        color: transparent
        width: parent.width
        height: parent.height / 7
        anchors.top: parent.top

        Text {
            text: "Tips"
            color: defaultTextColor
            font.pixelSize: defaultFontSize * 2
            anchors.centerIn: parent
        }
    }

    Rectangle {
        width: parent.width
        height: parent.height / 1.38
         anchors.top: parent.top
        anchors.topMargin: parent.height / 7
        color: transparent

        Text {
            text: " 1. Your password must be \n     6-20 characters long. \n 2. Your password must \n     contain at least 1 letter and \n     1 number"
            anchors.centerIn: parent
            font.pixelSize: defaultFontSize * 2.5
            color: defaultTextColor
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
            text: "OK"
            color: blue
            anchors.centerIn: parent
            font.pixelSize: defaultFontSize * 2
        }
    }
}
