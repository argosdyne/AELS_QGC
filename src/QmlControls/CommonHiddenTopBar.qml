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
    id: _root
    color: Qt.rgba(0, 0, 0, 0.6)
    z: 3

    Row {
        id:                     viewButtonRow
        anchors.top:            parent.top
        anchors.bottom:         parent.bottom
        width: parent.width
        anchors.fill: parent

        Button {
            width: viewButtonRow.width
            height: parent.height
            background: Rectangle {
                color: "transparent"
                Row {
                    Rectangle {
                        height: parent.height - 20
                        anchors.verticalCenter: parent.verticalCenter
                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: viewButtonRow.width / 6 - 80
                            spacing: 10
                            Image {
                                source: "/res/TopMenu_gps_status.svg"
                                height: 40
                                width: height
                            }
                            Image {
                                source: "/res/TopMenu_signalLevel.svg"
                                height: 40
                                width: height
                            }
                            anchors.bottom: parent.bottom
                        }
                    }

                    Rectangle {
                        height: parent.height - 20
                        anchors.verticalCenter: parent.verticalCenter
                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: viewButtonRow.width / 6 * 2 - 80
                            spacing: 10
                            Image {
                                source: "/res/TopMenu_Remote_controller_connection_status.svg"
                                height: 40
                                width: height
                            }
                            Image {
                                source: "/res/TopMenu_signalLevel.svg"
                                height: 40
                                width: height
                            }
                            anchors.bottom: parent.bottom
                        }
                    }
                    Rectangle {
                        height: parent.height - 20
                        anchors.verticalCenter: parent.verticalCenter
                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: viewButtonRow.width / 6 * 3 - 80
                            spacing: 10
                            Image {
                                source: "/res/TopMenu_Image_transfer_status.svg"
                                height: 40
                                width: height
                            }
                            Image {
                                source: "/res/TopMenu_signalLevel.svg"
                                height: 40
                                width: height
                            }
                            anchors.bottom: parent.bottom
                        }
                    }
                    Rectangle {
                        height: parent.height - 20
                        anchors.verticalCenter: parent.verticalCenter
                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: viewButtonRow.width / 6 * 4 - 80
                            spacing: 10
                            Image {
                                source: "/res/TopMenu_battery2.svg"
                                height: 40
                                width: height
                            }
                            Text {
                                height: parent.height - 24
                                font.pixelSize: 41
                                text: qsTr("N/A")
                                color: "white"
                            }
                            anchors.bottom: parent.bottom
                        }
                    }

                    Rectangle {
                        height: parent.height - 20
                        anchors.verticalCenter: parent.verticalCenter
                        Row {
                            anchors.fill: parent
                            anchors.leftMargin: viewButtonRow.width / 6 * 5 - 80
                            spacing: 10
                            Image {
                                source: "/res/TopMenu_battery_power.svg"
                                height: 40
                                width: height
                            }
                            Text {
                                height: parent.height - 24
                                font.pixelSize: 41
                                text: qsTr("N/A")
                                color: "white"
                            }
                            anchors.bottom: parent.bottom
                        }
                    }

                    Rectangle {
                        height : parent.height - 20
                        anchors.verticalCenter: parent.verticalCenter
                        Row {
                            anchors.leftMargin: viewButtonRow.width - 100
                            anchors.fill: parent
                            Image {
                                source: "/res/TopMenu_Up.svg"
                                height: 40
                                width: height
                            }
                              anchors.bottom: parent.bottom
                        }
                    }
                }
            }
            onClicked: {
                console.log("btn Click");
                toggleVisibility()
            }
        }
    }

    function toggleVisibility(){
        _root.visible = !_root.visible
    }
}
