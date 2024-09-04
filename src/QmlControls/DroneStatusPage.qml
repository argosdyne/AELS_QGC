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
    color: black


    implicitWidth: Screen.width * 0.7
    implicitHeight: Screen.height
    property color white : "#ffffff"
    property color black : "#000000"
    property color blue : "#3D71D7"
    property color red: "red"
    property color lightGray : "#4a4a4a"
    property color transparent : "transparent"
    property int hItemDelegate: Screen.height / 15;
    property int hToolSeparator: defaultFontSize + 3;

    //Size Property
    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize

    z : 4

    Column {
        anchors.fill: parent

        Rectangle {
            id: droneStatus
            width: parent.width
            height: parent.height / 13.5
            color: lightGray
            Text {
                color: white
                anchors.verticalCenter: parent.verticalCenter
                text: "Drone Status"
                font.pixelSize: defaultFontSize * 3
                anchors.left: parent.left
                anchors.leftMargin: defaultFontSize
            }
        }

        Rectangle {
            id:droneConnect
            width: parent.width
            height: parent.height / 13.5
            color: transparent

            Text {
                color: red
                anchors.centerIn: parent
                text: "Remote control and mobile phone disconnected"
                font.pixelSize: defaultFontSize * 2
            }
            Rectangle {
                width: parent.width
                height: 1
                color: lightGray
                anchors.bottom: parent.bottom
            }
        }


        //Flickable
        Rectangle {
            width: parent.width - defaultFontSize * 6
            height: parent.height - droneStatus.height - droneConnect.height - 1
            color: transparent
            anchors.horizontalCenter: parent.horizontalCenter
            clip: true
            Flickable {
                anchors.fill: parent
                contentWidth: parent.width
                contentHeight: parent.height * 1.2
                id: flickable
                Column {
                    width: parent.width
                    height: parent.height

                    Item {
                        width: 1
                        height: defaultFontSize * 2
                    }

                    //Compass
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate

                        Text {
                            text: "Compass"
                            color: white
                            anchors.left: parent.left
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text: "N/A"
                            color: white
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: defaultFontSize * 2
                            anchors.right: parent.right
                        }
                        enabled: false
                    }
                    ToolSeparator {
                        width: parent.width
                        height: hToolSeparator
                        orientation: Qt.Horizontal
                    }

                    // Flight Mode
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate

                        Text {
                            text: "Flight Mode"
                            color: white
                            anchors.left: parent.left
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text: "N/A"
                            color: white
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: defaultFontSize * 2
                            anchors.right: parent.right
                        }
                        enabled: false
                    }
                    ToolSeparator {
                        width: parent.width
                        height: hToolSeparator
                        orientation: Qt.Horizontal
                    }
                    // IMU
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate

                        Text {
                            text: "IMU"
                            color: white
                            anchors.left: parent.left
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text: "N/A"
                            color: white
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: defaultFontSize * 2
                            anchors.right: parent.right
                        }
                        enabled: false
                    }
                    ToolSeparator {
                        width: parent.width
                        height: hToolSeparator
                        orientation: Qt.Horizontal
                    }
                    // Vision Sensors
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate

                        Text {
                            text: "Vision Sensors"
                            color: white
                            anchors.left: parent.left
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text: "N/A"
                            color: white
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: defaultFontSize * 2
                            anchors.right: parent.right
                        }
                        enabled: false
                    }
                    ToolSeparator {
                        width: parent.width
                        height: hToolSeparator
                        orientation: Qt.Horizontal
                    }
                    // Command Stick Mode
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate

                        Text {
                            text: "Command Stick Mode"
                            color: white
                            anchors.left: parent.left
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text: "N/A"
                            color: white
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: defaultFontSize * 2
                            anchors.right: parent.right
                        }
                        enabled: false
                    }
                    ToolSeparator {
                        width: parent.width
                        height: hToolSeparator
                        orientation: Qt.Horizontal
                    }
                    // Remote Control Battery
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate

                        Text {
                            text: "Remote Control Battery"
                            color: white
                            anchors.left: parent.left
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text: "N/A"
                            color: white
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: defaultFontSize * 2
                            anchors.right: parent.right
                        }
                        enabled: false
                    }
                    ToolSeparator {
                        width: parent.width
                        height: hToolSeparator
                        orientation: Qt.Horizontal
                    }
                    // Drone Battery
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate

                        Text {
                            text: "Drone Battery"
                            color: white
                            anchors.left: parent.left
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text: "N/A"
                            color: white
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: defaultFontSize * 2
                            anchors.right: parent.right
                        }
                        enabled: false
                    }
                    ToolSeparator {
                        width: parent.width
                        height: hToolSeparator
                        orientation: Qt.Horizontal
                    }
                    // Drone Battery Temperature
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate

                        Text {
                            text: "Drone Battery Temperature"
                            color: white
                            anchors.left: parent.left
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text: "N/A"
                            color: white
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: defaultFontSize * 2
                            anchors.right: parent.right
                        }
                        enabled: false
                    }
                    ToolSeparator {
                        width: parent.width
                        height: hToolSeparator
                        orientation: Qt.Horizontal
                    }
                    // Image Transmission Signal
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate

                        Text {
                            text: "Image Transmission Signal"
                            color: white
                            anchors.left: parent.left
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text: "N/A"
                            color: white
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: defaultFontSize * 2
                            anchors.right: parent.right
                        }
                        enabled: false
                    }
                    ToolSeparator {
                        width: parent.width
                        height: hToolSeparator
                        orientation: Qt.Horizontal
                    }
                    // Gimbal Status
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate

                        Text {
                            text: "Gimbal Status"
                            color: white
                            anchors.left: parent.left
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text: "N/A"
                            color: white
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: defaultFontSize * 2
                            anchors.right: parent.right
                        }
                        enabled: false
                    }
                    ToolSeparator {
                        width: parent.width
                        height: hToolSeparator
                        orientation: Qt.Horizontal
                    }
                    // SD Card
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate

                        Text {
                            text: "SD Card"
                            color: white
                            anchors.left: parent.left
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text: "N/A"
                            color: white
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: defaultFontSize * 2
                            anchors.right: parent.right
                        }
                        enabled: false
                    }
                    ToolSeparator {
                        width: parent.width
                        height: hToolSeparator
                        orientation: Qt.Horizontal
                    }
                    // Flash Card
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate

                        Text {
                            text: "Flash Card"
                            color: white
                            anchors.left: parent.left
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Text {
                            text: "N/A"
                            color: white
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: defaultFontSize * 2
                            anchors.right: parent.right
                        }
                        enabled: false
                    }

                }
            }
        }
    }
}


