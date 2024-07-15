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
    color: fontColorlightGray    

    //Color Property
    property color defaultTextColor: "white"
    property color transparent: "transparent"
    property color fontColorlightGray: "#e4e4e4"
    property color defaultBackGroundColor: "black"
    property color darkGray: "#3b3737"
    property color blue: "#3d71d7"

    //Size Property
    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize

    implicitWidth: Screen.width
    implicitHeight: Screen.height


    Column {
        anchors.fill: parent

        Rectangle {
            color: defaultBackGroundColor
            width: parent.width
            height: parent.height / defaultFontSize

            Row {
                width: parent.width
                height: parent.height / 2

                anchors.verticalCenter: parent.verticalCenter

                Item {
                    width: defaultFontSize * 4
                    height: 1
                }

                Button {
                    background: Rectangle { color: transparent }
                    Image {
                        source: "qrc:/res/BackArrowButton.svg"
                    }
                }
            }
            Text {
                text: "Retrieve password"
                color: defaultTextColor
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: defaultFontSize * 2
            }
        }

        Rectangle {
            color: defaultTextColor
            width: parent.width
            height: parent.height / (defaultFontSize / 2)

            TextField {
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width / 2.2
                height: parent.height / 2
                font.pixelSize: defaultFontSize * 3
            }
        }

        Item {
            width: 1
            height: parent.height / (defaultFontSize * 2.4)
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width / 3
            height: parent.height / defaultFontSize
            background: Rectangle { color: blue; radius: defaultFontSize }

            Text {
                text: "Send a Verification Email"
                anchors.centerIn: parent
                color: defaultTextColor
                font.pixelSize: defaultFontSize * 2
            }

        }

    }
}


