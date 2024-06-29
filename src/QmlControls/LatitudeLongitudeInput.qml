import QtQuick          2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts  1.11
import QtQuick.Dialogs  1.3
import QtQuick.Window 2.0

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.Palette               1.0
import QGroundControl.ScreenTools           1.0

Rectangle {
    id: root
    height: 200
    width: 350
    visible: true
    color: "#4d4d4c"
    property string textColor: "white"

    RowLayout{
        anchors.fill: parent
        anchors.margins: 10
        spacing: 20
        ColumnLayout {
            Label{
                text:  "Latitude"
                color: 25
                font.pointSize: ScreenTools.defaultFontPointSize/16*25
            }

            TextField{
                text: "9.8173902"
                color: textColor
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                font.pointSize: ScreenTools.defaultFontPointSize/16*25
                background: Rectangle {
                    radius: 5
                    color: "transparent"
                    border.color: "#8a8a8a"
                }
            }

            Label{
                text:  "Longitude"
                color: "white"
                font.pointSize: ScreenTools.defaultFontPointSize/16*25
            }

            TextField{
                text: "9.8173902"
                color: textColor
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                Layout.fillWidth: true
                Layout.preferredHeight: 50
                font.pointSize: ScreenTools.defaultFontPointSize/16*25
                background: Rectangle {
                    radius: 5
                    color: "transparent"
                    border.color: "#8a8a8a"
                }
            }

        }

        Rectangle{
            Layout.fillHeight: true
            Layout.preferredWidth: root.width/2
            color:"transparent"

            Rectangle{
                width: parent.width*0.8
                height: parent.width*0.8
                anchors.centerIn: parent
                border.color: "#616161"
                border.width: 3
                radius: parent.width*0.4
                color: "transparent"

                GridLayout{
                    anchors.fill: parent
                    columns: 3
                    columnSpacing: 0
                    rowSpacing: 0

                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: parent.height/3.1
                    }

                    Button{
                        display: AbstractButton.IconOnly
                        Layout.preferredWidth: parent.width/3.5
                        Layout.preferredHeight: parent.height/3.5
                        background: Rectangle{
                            color:"transparent"
                            Image {
                                anchors.fill: parent
                                source: "qrc://res/ales/waypoint/UpDir.svg"
                                fillMode: Image.PreserveAspectFit
                            }
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: parent.height/3.1
                    }

                    Button{
                        display: AbstractButton.IconOnly
                        Layout.preferredWidth: parent.width/3.1
                        Layout.preferredHeight: parent.height/3.1
                        background: Rectangle{
                            color:"transparent"
                            Image {
                                anchors.fill: parent
                                source: "qrc://res/ales/waypoint/LeftDir.svg"
                                fillMode: Image.PreserveAspectFit
                            }
                        }
                    }


                    Button{
                        display: AbstractButton.IconOnly
                        Layout.preferredWidth: parent.width/3.1
                        Layout.preferredHeight: parent.height/3.1
                        background: Rectangle{
                            color:"transparent"
                            Image {
                                anchors.fill: parent
                                source: "qrc://res/ales/waypoint/CenterDir.svg"
                                fillMode: Image.PreserveAspectFit

                            }
                        }
                    }

                    Button{
                        display: AbstractButton.IconOnly
                        Layout.preferredWidth: parent.width/3.1
                        Layout.preferredHeight: parent.height/3.1
                        background: Rectangle{
                            color:"transparent"
                            Image {
                                anchors.fill: parent
                                source: "qrc://res/ales/waypoint/RightDir.svg"
                                fillMode: Image.PreserveAspectFit
                            }
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: parent.height/3.1
                    }

                    Button{
                        display: AbstractButton.IconOnly
                        Layout.preferredWidth: parent.width/3.5
                        Layout.preferredHeight: parent.height/3.5
                        background: Rectangle{
                            color:"transparent"
                            Image {
                                anchors.fill: parent
                                source: "qrc://res/ales/waypoint/DownDir.svg"
                                fillMode: Image.PreserveAspectFit
                            }
                        }
                    }

                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: parent.height/3.1
                    }
                }
            }

        }
    }

}
