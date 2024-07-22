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
    color: defaultBackgroundColor

    //Color Property
    property color defaultTextColor: "white"
    property color blue: "#3d71d7"
    property color defaultBackgroundColor: "#6e474141"
    property bool isCameraWindow: false

    //Size Property
    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize

    implicitWidth: Screen.width

    RowLayout {
        id:  viewButtonRow
        anchors.fill: parent
        //spacing: 10

        //Logo Button
        Button {
            Layout.preferredWidth: height*2
            Layout.fillHeight: true
            background: Rectangle {
                color: "transparent"
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
            background: Rectangle {
                color: "blue"
                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: defaultFontSize
                    spacing: defaultFontSize * 1.5
                    anchors.margins: 5
                    Image {
                        Layout.fillHeight: true
                        Layout.preferredWidth: height
                        source: "/res/TopMenuManualFlight.svg"
                        fillMode: Image.PreserveAspectFit

                    }
                    Column {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        spacing: defaultFontSize*1.2
                        Text {
                            font.pixelSize: defaultFontSize * 2
                            text: qsTr("Intelligent Photo")
                            color: defaultTextColor
                            opacity: 0.8
                            horizontalAlignment: Text.AlignHCenter
                        }
                        Text {
                            font.pixelSize: defaultFontSize * 2.5
                            text: qsTr("Manual Flight")
                            font.bold: true
                            color: defaultTextColor
                            horizontalAlignment: Text.AlignHCenter
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
            Layout.fillHeight: true
            Layout.preferredWidth: height * 8
            background: Rectangle {
                color: "transparent"

                RowLayout {
                    anchors.fill: parent

                    Rectangle {
                        Layout.preferredWidth: height*2
                        Layout.fillHeight: true
                        color: "transparent"
                        RowLayout {
                            anchors.fill: parent
                            Image {
                                Layout.fillHeight: true
                                source: "/res/TopMenuBattery.svg"
                                fillMode: Image.PreserveAspectFit
                            }

                            Text {
                                Layout.fillHeight: true
                                font.pixelSize: defaultFontSize * 4
                                text: qsTr("N/A")
                                color: defaultTextColor
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }

                    Rectangle {
                        Layout.preferredWidth: height*2
                        Layout.fillHeight: true
                        color: "transparent"
                        RowLayout {
                            anchors.fill: parent
                            Image {
                                Layout.fillHeight: true
                                source: "/res/TopMenuAltitude.svg"
                                fillMode: Image.PreserveAspectFit
                            }

                            Text {
                                Layout.fillHeight: true
                                font.pixelSize: defaultFontSize * 4
                                text: qsTr("N/A")
                                color: defaultTextColor
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }

                    Rectangle {

                        Layout.preferredWidth: height*2
                        Layout.fillHeight: true
                        color: "transparent"
                        RowLayout {
                            anchors.fill: parent
                            Image {
                                Layout.fillHeight: true
                                source: "/res/TopMenuDistance.svg"
                                fillMode: Image.PreserveAspectFit
                            }

                            Text {
                                Layout.fillHeight: true
                                font.pixelSize: defaultFontSize * 4
                                text: qsTr("N/A")
                                color: defaultTextColor
                                verticalAlignment: Text.AlignVCenter
                            }
                        }

                    }

                    Rectangle {

                        Layout.preferredWidth: height*2
                        Layout.fillHeight: true
                        color: "transparent"
                        RowLayout {
                            anchors.fill: parent
                            Image {
                                Layout.fillHeight: true
                                source: "/res/TopMenuSpeed.svg"
                                fillMode: Image.PreserveAspectFit
                            }
                            Text {
                                Layout.fillHeight: true
                                font.pixelSize: defaultFontSize * 4
                                text: qsTr("N/A")
                                color: defaultTextColor
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }

                }
            }
        }


        // Obstacle Status Icon
        Button {
            Layout.preferredWidth: height
            Layout.fillHeight: true
            background: Rectangle { color: "transparent" }
            Image {
                source: "/res/TopMenuObstacleSensorOff.svg"
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit
            }

            onClicked: {
                console.log("Red btn Click");
            }
        }
        //Show Map Style Button
        Button {
            visible: isCameraWindow == false ? false : true
            Layout.preferredWidth: height
            Layout.fillHeight: true
            background: Rectangle { color: "transparent" }
            Image {
                anchors.centerIn: parent
                source: "/res/TopMenuMapTool.svg"
                fillMode: Image.PreserveAspectFit
            }

            onClicked: {
                console.log("Red btn Click");
            }
        }
        //Setting Button
        Button {
            Layout.preferredWidth: height
            Layout.fillHeight: true
            background: Rectangle {
                color: "transparent"
            }
            Image {
                    anchors.centerIn: parent
                    source: "/res/TopMenuSetting.png"
                    fillMode: Image.PreserveAspectFit
                }
            onClicked: {
                console.log("Red btn Click");
            }
        }

    }
}


