import QtQuick          2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts  1.11
import QtQuick.Dialogs  1.3

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.Palette               1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Controllers           1.0
import QtGraphicalEffects                   1.12

Rectangle {
    id:     root
    color: Qt.rgba(0, 0, 0, 0.4)
    z : 3    

    property string defaultTextColor: "white"

    property var rootWidth: null;
    property var rootHeight: null;

    Row {
        id:                     viewButtonRow
        anchors.top:            parent.top
        anchors.bottom:         parent.bottom
        width: parent.width
        anchors.fill: parent

        //Logo Button
        Button {
            width: viewButtonRow.width * 0.115
            height: parent.height
            background: Rectangle {
                color: "transparent"
                Image {
                    source: "/res/TopMenu_homebutton.svg"
                    anchors.centerIn: parent
                    width: 80
                    height: parent.height - 10
                }
            }
            onClicked: {
                console.log("Logo btn Click");
            }
        }
        //Move to MainPage Button
        Button {
            width: viewButtonRow.width * 0.19
            height: parent.height
            clip: true
            background: Rectangle {
                color: "#3d71d7"
                Row {
                    anchors.fill: parent
                    Rectangle {
                        height: parent.height - 32
                        anchors.verticalCenter: parent.verticalCenter
                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: 28
                            spacing: 15
                            Image {
                                source: "/res/TopMenu_ManualFlight.svg"
                                height: parent.height
                                width: height
                            }
                            Column {
                                spacing: 10
                                Text {                                    
                                    font.pixelSize: ScreenTools.defaultFontPixelHeight * 1.8
                                    text: qsTr("Intelligent Photo")
                                    color: defaultTextColor
                                    opacity: 0.8
                                }
                                Text {                                    
                                    font.pixelSize: ScreenTools.defaultFontPixelHeight * 2.5
                                    text: qsTr("Manual Flight")
                                    font.bold: true
                                    color: defaultTextColor
                                }
                            }
                            anchors.bottom: parent.bottom
                        }
                    }
                }
            }
            onClicked: {
                console.log("MainPage btn Click");
            }
        }
        //Drone Status Show Button
        Button {
            width: viewButtonRow.width * 0.5
            height: parent.height
            background: Rectangle {
                color: "transparent"
                Row {
                    Rectangle {
                        height: parent.height - 48
                        anchors.verticalCenter: parent.verticalCenter
                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: 50
                            spacing: 10
                            Image {
                                source: "/res/TopMenu_battery.svg"
                                height: 40
                                width: height
                            }
                            Text {
                                height: parent.height - 24                                
                                font.pixelSize: ScreenTools.defaultFontPixelHeight * 4.1
                                text: qsTr("N/A")
                                color: defaultTextColor
                            }
                            anchors.bottom: parent.bottom
                        }
                    }

                    Rectangle {
                        height: parent.height - 48
                        anchors.verticalCenter: parent.verticalCenter
                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: 260
                            spacing: 10
                            Image {
                                source: "/res/TopMenu_Altitude.svg"
                                height: 40
                                width: height
                            }
                            Text {
                                height: parent.height - 24                                
                                font.pixelSize: ScreenTools.defaultFontPixelHeight * 4.1
                                text: qsTr("N/A")
                                color: defaultTextColor
                            }
                            anchors.bottom: parent.bottom
                        }
                    }

                    Rectangle {
                        height: parent.height - 48
                        anchors.verticalCenter: parent.verticalCenter
                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: 460
                            spacing: 10
                            Image {
                                source: "/res/TopMenu_distance.svg"
                                height: 40
                                width: height
                            }
                            Text {
                                height: parent.height - 24                                
                                font.pixelSize: ScreenTools.defaultFontPixelHeight * 4.1
                                text: qsTr("N/A")
                                color: defaultTextColor
                            }
                            anchors.bottom: parent.bottom
                        }
                    }
                    Rectangle {
                        height: parent.height - 48
                        anchors.verticalCenter: parent.verticalCenter
                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: 660
                            spacing: 10
                            Image {
                                source: "/res/TopMenu_speed.svg"
                                height: 40
                                width: height
                            }
                            Text {
                                height: parent.height - 24                                
                                font.pixelSize: ScreenTools.defaultFontPixelHeight * 4.1
                                text: qsTr("N/A")
                                color: defaultTextColor
                            }
                            anchors.bottom: parent.bottom
                        }
                    }
                }
            }
            onClicked: {
                console.log("Drone Status btn Click");
                cameraTopBarClicked()
            }
        }
        // Obstacle Status Icon
        Button {
            width: viewButtonRow.width * 0.062
            height: parent.height
            background: Rectangle {
                color: "transparent"
                Image {
                    source: "/res/TopMenu_obstacle_sensor(off).svg"
                    anchors.centerIn: parent
                }
            }
            onClicked: {
                console.log("Red btn Click");
            }
        }
        //Show Map Style Button
        Button {
            width: viewButtonRow.width * 0.062
            height: parent.height
            background: Rectangle {
                color: "transparent"
                Image {
                    source: "/res/TopMenu_maptool.svg"
                    anchors.centerIn: parent
                }
            }
            onClicked: {
                console.log("Red btn Click");
            }
        }
        //Setting Button
        Button {
            width: viewButtonRow.width * 0.07
            height: parent.height
            background: Rectangle {
                color: "transparent"
                Image {
                    source: "/res/TopMenu_setting.png"
                    anchors.centerIn: parent
                }
            }
            onClicked: {
                console.log("Red btn Click");
            }
        }

    }
}


