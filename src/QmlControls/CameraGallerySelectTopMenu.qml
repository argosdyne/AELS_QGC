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

    //Color Property
    property color defaultTextColor: "white"
    property color transparent: "transparent"
    property color blue: "#3d71d7"
    property color defaultBackGroundColor: "#3b3737"

    //Size Property
    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize

    implicitWidth: Screen.width
    implicitHeight: defaultFontSize * 9

    Row {
        id:                     viewButtonRow
        anchors.top:            parent.top
        anchors.bottom:         parent.bottom
        width: parent.width
        anchors.fill: parent

        Item {
            width: defaultFontSize * 3.4
            height: 1
        }

        Row {
            width: parent.width / 10.1
            height: parent.height / 2.1
            anchors.verticalCenter: parent.verticalCenter

            spacing: defaultFontSize * 4

            Image {
                source: "/res/GalleryShareButton.svg"
                width: defaultFontSize * 3.5
                height: width
            }

            Image {
                source: "/res/GalleryDownloadButton.svg"
                width: defaultFontSize * 3.5
                height: width
            }
            Image {
                source: "/res/GalleryDeleteButton.svg"
                width: defaultFontSize * 3.5
                height: width
            }
        }

        Item {
            width: parent.width / 27.4
            height: 1
        }

        Button {
            width: parent.width / 16
            height: parent.height / 1.9
            anchors.verticalCenter: parent.verticalCenter
            background: Rectangle { color: transparent }

            Text {
                text: "Select All"
                font.pixelSize: defaultFontSize * 3
                color: defaultTextColor
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Item {
            width: parent.width / 4.5
            height: 1
        }

        Button {
            width: parent.width / 8.2
            height: parent.height / 1.9
            anchors.verticalCenter: parent.verticalCenter
            background: Rectangle { color: transparent }

            Text {
                text: "Select Items"
                font.pixelSize: defaultFontSize * 3
                color: defaultTextColor
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Item {
            width: parent.width / 3.2
            height: 1
        }

        Button {
            width: parent.width / 8.2
            height: parent.height / 1.9
            anchors.verticalCenter: parent.verticalCenter
            background: Rectangle { color: transparent }

            Text {
                text: "Cancel"
                font.pixelSize: defaultFontSize * 3
                color: defaultTextColor
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
