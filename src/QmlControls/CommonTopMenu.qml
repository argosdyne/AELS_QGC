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
    color: Qt.rgba(0, 0, 0, 0.4)

    //Color Property
    property color defaultTextColor: "white"
    property color transparent: "transparent"
    property color blue: "#3d71d7"

    //Size Property
    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize

    implicitWidth: Screen.width

    RowLayout {
        id:  viewButtonRow
        anchors.fill: parent
        spacing: 10

        //Logo Button
        Button {
            Layout.preferredWidth: height*2
            Layout.fillHeight: true
            background: Rectangle {
                color: transparent
                Image {
                    anchors.fill: parent
                    source: "/res/TopMenuHomeButton.svg"
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit

                }
            }
            onClicked: {
                console.log("Logo btn Click");
            }
        }
        //Move to MainPage Button
        Button {
            Layout.preferredWidth: height*4
            Layout.fillHeight: true
            clip: true
            background: Rectangle {
                color: "blue"
                RowLayout {
                    anchors.fill: parent
                    Rectangle {
                        Layout.preferredHeight: parent.height - defaultFontSize * 3.2
                        anchors.verticalCenter: parent.verticalCenter
                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: defaultFontSize * 2.8
                            spacing: defaultFontSize * 1.5
                            Image {
                                source: "/res/TopMenuManualFlight.svg"
                                height: parent.height
                                width: height
                            }
                            Column {
                                spacing: defaultFontSize
                                Text {
                                    font.pixelSize: defaultFontSize * 1.8
                                    text: qsTr("Intelligent Photo")
                                    color: defaultTextColor
                                    opacity: 0.8
                                }
                                Text {
                                    font.pixelSize: defaultFontSize * 2.5
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
        Rectangle {
            Layout.preferredHeight: height*2
            Layout.fillHeight: true
            Row {
                anchors.fill: parent
                anchors.leftMargin: defaultFontSize * 5
                spacing: defaultFontSize
                Image {
                    source: "/res/TopMenuBattery.svg"
                    height: defaultFontSize * 4
                    width: height
                }
                Text {
                    height: parent.height - defaultFontSize * 2.4
                    font.pixelSize: defaultFontSize * 4.1
                    text: qsTr("N/A")
                    color: defaultTextColor
                }
                anchors.bottom: parent.bottom
            }
        }

        Rectangle {
            Layout.preferredHeight: height*2
            Layout.fillHeight: true
            Row {
                anchors.fill: parent
                anchors.leftMargin: defaultFontSize * 26
                spacing: defaultFontSize
                Image {
                    source: "/res/TopMenuAltitude.svg"
                    height: defaultFontSize * 4
                    width: height
                }
                Text {
                    height: parent.height - defaultFontSize * 2.4
                    font.pixelSize: defaultFontSize * 4.1
                    text: qsTr("N/A")
                    color: defaultTextColor
                }
                anchors.bottom: parent.bottom
            }
        }

        Rectangle {
            Layout.preferredHeight: height*2
            Layout.fillHeight: true
            Row {
                anchors.fill: parent
                anchors.leftMargin: defaultFontSize * 46
                spacing: defaultFontSize
                Image {
                    source: "/res/TopMenuDistance.svg"
                    height: defaultFontSize * 4
                    width: height
                }
                Text {
                    height: parent.height - defaultFontSize * 2.4
                    font.pixelSize: defaultFontSize * 4.1
                    text: qsTr("N/A")
                    color: defaultTextColor
                }
                anchors.bottom: parent.bottom
            }
        }
        Rectangle {
            Layout.preferredHeight: height*2
            Layout.fillHeight: true
            Row {
                anchors.fill: parent
                anchors.leftMargin: defaultFontSize * 66
                spacing: defaultFontSize
                Image {
                    source: "/res/TopMenuSpeed.svg"
                    height: defaultFontSize * 4
                    width: height
                }
                Text {
                    height: parent.height - defaultFontSize * 2.4
                    font.pixelSize: defaultFontSize * 4.1
                    text: qsTr("N/A")
                    color: defaultTextColor
                }
                anchors.bottom: parent.bottom
            }
        }

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }

        // Obstacle Status Icon
        Button {
            Layout.preferredHeight: height*2
            Layout.fillHeight: true
            background: Rectangle {
                color: transparent
                Image {
                    source: "/res/TopMenuObstacleSensorOff.svg"
                    anchors.centerIn: parent
                }
            }
            onClicked: {
                console.log("Red btn Click");
            }
        }
        //Show Map Style Button
        Button {
            Layout.preferredHeight: height*2
            Layout.fillHeight: true
            background: Rectangle {
                color: transparent
                Image {
                    source: "/res/TopMenuMapTool.svg"
                    anchors.centerIn: parent
                }
            }
            onClicked: {
                console.log("Red btn Click");
            }
        }
        //Setting Button
        Button {
            Layout.preferredHeight: height*2
            Layout.fillHeight: true
            background: Rectangle {
                color: transparent
                Image {
                    source: "/res/TopMenuSetting.png"
                    anchors.centerIn: parent
                }
            }
            onClicked: {
                console.log("Red btn Click");
            }
        }

    }
}


