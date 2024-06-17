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

        //Spacing
        Item {
            width: parent.width / 54.9
            height: 1 // 최소 높이
        }

        //Back Button
        Button {
            width: parent.width / 16
            height: defaultFontSize * 4
            anchors.verticalCenter: parent.verticalCenter

            background: Rectangle {
                color: transparent
            }
            Row {
                spacing: defaultFontSize * 2.7
                Image { source: "/res/BackArrowButton.svg" }

                Text {
                    text: "Back"
                    color: defaultTextColor
                    font.pixelSize: defaultFontSize * 3
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            onClicked: {
                console.log("Back btn Click");
            }
        }

        Item {
            width: parent.width / 3
            height: 1
        }

        Text {
            text: "2024-06-17 2:30 PM"
            font.pixelSize: defaultFontSize * 3
            anchors.verticalCenter: parent.verticalCenter
            color: defaultTextColor
        }

        Item {
            width: parent.width / 3.5
            height: 1
        }

        Row {
            width: parent.width / 11
            height: parent.height / 2.25
            anchors.verticalCenter: parent.verticalCenter
            spacing: width / 3.3

            Button {
                width: parent.width / 5
                height: parent.height
                background: Rectangle {
                    color: transparent
                }
                Image { source: "/res/GalleryShareButtonWhite.svg" }
            }
            Button {
                width: parent.width /5
                height: parent.height
                background: Rectangle {
                    color: transparent
                }
                Image { source: "/res/GalleryDownloadButtonWhite.svg" }
            }
            Button {
                width: parent.width /5
                height: parent.height
                background: Rectangle {
                    color: transparent
                }
                Image { source: "/res/GalleryDeleteButtonWhite.svg" }
            }
        }
    }
}


