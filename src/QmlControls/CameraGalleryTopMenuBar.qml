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
    implicitHeight: defaultFontSize * 11

    Row {
        id:                     viewButtonRow
        anchors.top:            parent.top
        anchors.bottom:         parent.bottom
        width: parent.width
        anchors.fill: parent

        //Spacing
        Item {
            width: defaultFontSize * 3
            height: 1
        }

        //Back Button
        Button {
            width: defaultFontSize * 2.3
            height: defaultFontSize * 4
            anchors.verticalCenter: parent.verticalCenter

            background: Rectangle {
                color: transparent
            }

            Image {
                source: "qrc:/res/BackArrowButton.svg"
                anchors.fill: parent
            }
            onClicked: {
                console.log("Back btn Click");
            }
        }

        Item {
            width: parent.width / 4.4
            height: 1
        }

        Row {
            width: parent.width / 2
            height: parent.height / 1.6
            anchors.verticalCenter: parent.verticalCenter
            Button {
                width: parent.width / 3
                height: parent.height
                background: Rectangle {
                    color: transparent
                }
                Text {
                    text: "SD Card"
                    anchors.centerIn: parent
                    font.pixelSize: defaultFontSize * 3
                    color: defaultTextColor
                    horizontalAlignment: Text.AlignHCenter
                }
            }
            Button {
                width: parent.width / 3
                height: parent.height
                background: Rectangle {
                    color: transparent
                }
                Text {
                    text: "Internal Storage"
                    anchors.centerIn: parent
                    font.pixelSize: defaultFontSize * 3
                    color: defaultTextColor
                    horizontalAlignment: Text.AlignHCenter
                }
            }
            Button {
                width: parent.width / 3
                height: parent.height
                background: Rectangle {
                    color: transparent
                    id: bg
                }
                Text {
                    text: "Device Storage"
                    anchors.centerIn: parent
                    font.pixelSize: defaultFontSize * 3
                    color: defaultTextColor
                    horizontalAlignment: Text.AlignHCenter
                }
            }
        }

        //Spacing
        Item {
            width: parent.width / 5.8
            height: 1
        }

        Button {
            width: parent.width / 22.8
            height: parent.height / 4.6
            anchors.verticalCenter: parent.verticalCenter

            background: Rectangle {
                color: transparent
            }
            Text{
                text: "Select"
                anchors.centerIn: parent
                font.pixelSize: defaultFontSize * 3
                color: defaultTextColor
            }
        }
    }
}


