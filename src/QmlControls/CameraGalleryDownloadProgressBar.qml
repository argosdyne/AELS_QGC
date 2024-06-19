import QtQuick          2.15
import QtQuick.Controls 2.15
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
    property color defaultBackGroundColor: "black"
    property color transparent: "transparent"
    property color blue: "#3d71d7"

    //Size Property
    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize

    implicitWidth: Screen.width
    implicitHeight: defaultFontSize * defaultFontSize


    Row {
        anchors.fill: parent

        Item {
            width: parent.width / 36.2
            height: 1
        }

        Column {
            width: parent.width / 1.26
            height: parent.height / 1.6
            anchors.verticalCenter: parent.verticalCenter
            spacing: defaultFontSize

            Text {
                anchors.leftMargin: 200
                font.pixelSize: defaultFontSize * 3
                color: defaultTextColor
                text: "Downloading..."
            }
            Row {
                width: root.width
                height: parent.height / 3.3
                spacing: defaultFontSize
                ProgressBar {
                    width: parent.width / 1.3
                    height: root.height / 5
                    value: 0.5
                    id: progressBar
                    background: Rectangle {
                        width: parent.width
                        height: parent.height
                        radius: 7
                    }

                    contentItem: Item {
                        Rectangle {
                            width: progressBar.visualPosition * parent.width
                            height: parent.height
                            radius: 7
                            color: blue
                        }
                    }
                }
                Text {
                    font.pixelSize: defaultFontSize * 3
                    color: defaultTextColor
                    text: "1.1MB/s"
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }

        Item {
            width: parent.width / 19
            height: 1
        }
        Button {
            width: parent.width / 9.6
            height: parent.height / 2
            anchors.verticalCenter: parent.verticalCenter

            background: Rectangle {
                color: transparent
            }

            Text {
                font.pixelSize: defaultFontSize * 3
                color: defaultTextColor
                anchors.centerIn: parent
                text: "Cancel"
            }
        }
    }
}


