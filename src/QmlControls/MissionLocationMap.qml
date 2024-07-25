import QtQuick          2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts  1.11
import QtQuick.Dialogs  1.3
import QtQuick.Window 2.0

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.Palette               1.0
import QGroundControl.ScreenTools           1.0



Rectangle{
    id:root
    implicitHeight: 400
    implicitWidth: 400

    color: "black"

    ColumnLayout{
        spacing: 20

        Rectangle{
            color:"transparent"
            radius: 10
            Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*320
            Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100

            RowLayout {
                anchors.centerIn: parent
                Button{
                    checkable: true
                    checked: false
                    Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100
                    Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
                    background: Rectangle{
                        color: parent.checked? "#3d71d7": "transparent"
                        radius: 5
                        Image {
                            anchors.fill: parent
                            anchors.margins: 10
                            source: "/res/ales/mission/Location.svg"
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }

                Button{
                    checkable: true
                    checked: false
                    Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100
                    Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
                    background: Rectangle{
                        color: parent.checked? "#3d71d7": "transparent"
                        radius: 5
                        Image {
                            anchors.fill: parent
                            anchors.margins: 10
                            source: "/res/ales/mission/Maptype.svg"
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }
            }
        }

        Rectangle{
            color:"#484639"
            radius: 10
            Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*320
            Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100

            RowLayout {
                anchors.fill: parent
                Button{
                    id: position
                    checkable: true
                    checked: false
                    Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100
                    Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
                    background: Rectangle{
                        color: parent.checked? "#3d71d7": "transparent"
                        radius: 5
                        Image {
                            anchors.fill: parent
                            anchors.margins: 10
                            source: "/res/ales/waypoint/PositionType.svg"
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }

                Button{
                    id: centerObject
                    checkable: true
                    checked: false
                    Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100
                    Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
                    background: Rectangle{
                        color: parent.checked? "#3d71d7": "transparent"
                        radius: 5
                        Image {
                            anchors.fill: parent
                            anchors.margins: 10
                            source: "/res/ales/waypoint/CenterIn.svg"
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }

                Button{
                    id: mapType
                    checkable: true
                    checked: false
                    Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100
                    Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
                    background: Rectangle{
                        color: parent.checked? "#3d71d7": "transparent"
                        radius: 5
                        Image {
                            anchors.fill: parent
                            anchors.margins: 10
                            source: "/res/ales/waypoint/MapType.svg"
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }
            }
        }

        Rectangle{
            Layout.preferredWidth:ScreenTools.defaultFontPointSize/16*220
            Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100
            color: "white"
            anchors.margins: 20
            RowLayout{
                anchors.centerIn: parent
                spacing: 10

                Button{
                    Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100
                    Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
                    background: Rectangle{
                        color:"transparent"
                        implicitWidth:ScreenTools.defaultFontPointSize/16*100
                        implicitHeight:ScreenTools.defaultFontPointSize/16*100
                        Image {
                            anchors.fill: parent
                            source: "/res/ales/waypoint/NormalMap.png"
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }

                Button{
                    Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100
                    Layout.preferredWidth:ScreenTools.defaultFontPointSize/16*100
                    background: Rectangle{
                        color:"transparent"
                        implicitWidth:ScreenTools.defaultFontPointSize/16*100
                        implicitHeight:ScreenTools.defaultFontPointSize/16*100
                        Image {
                            anchors.fill: parent
                            source: "/res/ales/waypoint/HybridMap.png"
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }

            }
        }


        Rectangle{
            Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*220
            Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100
            color: "white"
            RowLayout{
                anchors.centerIn: parent
                spacing: 10

                Button{
                    Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100
                    Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
                    background: Rectangle{
                        color:"transparent"
                        implicitWidth: ScreenTools.defaultFontPointSize/16*100
                        implicitHeight: ScreenTools.defaultFontPointSize/16*100
                        Image {
                            anchors.fill: parent
                            source: "/res/ales/waypoint/MeLocation.svg"
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }

                Button{
                    Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100
                    Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
                    background: Rectangle{
                        color:"transparent"
                        implicitWidth: ScreenTools.defaultFontPointSize/16*100
                        implicitHeight: ScreenTools.defaultFontPointSize/16*100
                        Image {
                            anchors.fill: parent
                            source: "/res/ales/waypoint/DroneLocation.png"
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }

            }
        }

    }



}

