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
    implicitWidth: 500
    implicitHeight: 100
    color:"#474141"
    radius: 10
    property string textColor: "white"
    property string checkedColor: "#3d71d7"

    RowLayout {
        anchors.centerIn:parent
        spacing: 50
        Item {
            Layout.fillHeight: true
            Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100
            Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
            RowLayout{
                anchors.fill: parent
                Button{
                    checkable: true
                    checked: false
                    Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100
                    Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
                    background: Rectangle{
                        color: parent.checked? checkedColor: "transparent"
                        radius: 5
                        Image {
                            anchors.fill: parent
                            anchors.margins: 10
                            source: "qrc://res/ales/waypoint/MissionTime.svg"
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }
                Text {
                    color: textColor
                    text: "0s"
                    font.pointSize: ScreenTools.defaultFontPointSize/16*24
                }
            }
        }

        Item {
            Layout.fillHeight: true
            Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100
            Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
            RowLayout{
                anchors.fill: parent
                Button{
                    checkable: true
                    checked: false
                    Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100
                    Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
                    background: Rectangle{
                        color: parent.checked? checkedColor: "transparent"
                        radius: 5
                        Image {
                            anchors.fill: parent
                            anchors.margins: 10
                            source: "qrc://res/ales/waypoint/LandingDistance.svg"
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }
                Text {
                    color: textColor
                    text: "0s"
                    font.pointSize: ScreenTools.defaultFontPointSize/16*24
                }
            }
        }


        Item {
            Layout.fillHeight: true
            Layout.preferredHeight: 100
            Layout.preferredWidth: 100
            RowLayout{
                anchors.fill: parent
                Button{
                    checkable: true
                    checked: false
                    Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100
                    Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
                    background: Rectangle{
                        color: parent.checked? checkedColor: "transparent"
                        radius: 5
                        Image {
                            anchors.fill: parent
                            anchors.margins: 10
                            source: "qrc://res/ales/waypoint/MissionPoint.svg"
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }
                Text {
                    color: textColor
                    text: "0s"
                    font.pointSize: ScreenTools.defaultFontPointSize/16*24
                }
            }
        }

        Item {
            Layout.fillHeight: true
            Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100
            Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
            RowLayout{
                anchors.fill: parent
                Button{
                    checkable: true
                    checked: false
                    Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100
                    Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
                    background: Rectangle{
                        color: parent.checked? checkedColor: "transparent"
                        radius: 5
                        Image {
                            anchors.fill: parent
                            anchors.margins: 10
                            source: "qrc://res/ales/waypoint/MissionPicture.svg"
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }
                Text {
                    color: textColor
                    text: "0s"
                    font.pointSize: ScreenTools.defaultFontPointSize/16*24
                }
            }
        }


    }
}