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
    color: defaultBackGroundColor
    z : 3    

    //Color Property
    property color defaultTextColor: "white"
    property color transparent: "transparent"
    property color lightGray: "lightgray"
    property color defaultBackGroundColor: "#3b3737"

    //Size Property
    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize

    implicitWidth: Screen.width
    implicitHeight: defaultFontSize * 6

    Row {
        id:                     viewButtonRow
        anchors.top:            parent.top
        anchors.bottom:         parent.bottom
        width: parent.width
        anchors.fill: parent

        Item {
            width: defaultFontSize * 2.5
            height: 1
        }

        Rectangle {
            width: parent.width / 8.8
            height: parent.height / 1.4
            color: transparent
            anchors.verticalCenter: parent.verticalCenter
            Text {
                text: "2024-06-13"
                font.pixelSize: defaultFontSize * 3
                anchors.centerIn: parent
                color: defaultTextColor
            }
        }

        Item {
            width: parent.width / 1.7
            height: 1
        }

        Row {
            width: parent.width / 16.8
            height: parent.height
            spacing: defaultFontSize * 2.1
            Text {
                text: "1"
                font.pixelSize: defaultFontSize * 2
                anchors.verticalCenter: parent.verticalCenter
                color: lightGray
            }
            Image {
                source: "/res/GalleryVideo.svg"
                anchors.verticalCenter: parent.verticalCenter

            }
        }

        Item {
            width: parent.width / 14.8
            height: 1
        }
        Row {
            width: parent.width / 16.8
            height: parent.height
            spacing: defaultFontSize * 2.1
            Text {
                text: "1"
                font.pixelSize: defaultFontSize * 2
                anchors.verticalCenter: parent.verticalCenter
                color: lightGray
            }
            Image {
                source: "/res/GalleryPicture.svg"
                anchors.verticalCenter: parent.verticalCenter
            }
        }



    }
}


