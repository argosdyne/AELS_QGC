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
    property int sizeButton: ScreenTools.defaultFontPointSize/16*100
    property int sizeText: ScreenTools.defaultFontPointSize/16*20
    property int sizeTextWidth: sizeButton*0.5

    RowLayout {
        anchors.centerIn:parent
        spacing: 10
        Rectangle {
            color: "transparent"
            Layout.preferredHeight:sizeButton*1.5
            Layout.preferredWidth: sizeButton*1.5
            RowLayout{
                anchors.fill: parent
                Button{
                    checkable: false
                    checked: false
                    Layout.preferredHeight: sizeButton
                    Layout.preferredWidth: sizeButton
                    background: Rectangle{
                        color: parent.checked? checkedColor: "transparent"
                        radius: 5
                        Image {
                            anchors.fill: parent
                            anchors.margins: 10
                            source: "/res/ales/waypoint/MissionTime.svg"
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }
                Text {
                    Layout.preferredHeight: sizeTextWidth
                    Layout.preferredWidth: sizeTextWidth
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: textColor
                    text: "0s"
                    font.pointSize: sizeText
                }
            }
        }

        Rectangle {
            color: "transparent"
            Layout.preferredHeight:sizeButton*1.5
            Layout.preferredWidth: sizeButton*1.5
            RowLayout{
                anchors.fill: parent
                Button{
                    checkable: false
                    checked: false
                    Layout.preferredHeight: sizeButton
                    Layout.preferredWidth: sizeButton
                    background: Rectangle{
                        color: parent.checked? checkedColor: "transparent"
                        radius: 5
                        Image {
                            anchors.fill: parent
                            anchors.margins: 10
                            source: "/res/ales/waypoint/LandingDistance.svg"
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }
                Text {
                    Layout.preferredHeight: sizeTextWidth
                    Layout.preferredWidth: sizeTextWidth
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: textColor
                    text: "0s"
                    font.pointSize: sizeText
                }
            }
        }


        Rectangle {
            color: "transparent"
            Layout.preferredHeight: sizeButton*1.5
            Layout.preferredWidth: sizeButton*1.5
            RowLayout{
                anchors.fill: parent
                Button{
                    checkable: false
                    checked: false
                    Layout.preferredHeight: sizeButton
                    Layout.preferredWidth: sizeButton
                    background: Rectangle{
                        color: parent.checked? checkedColor: "transparent"
                        radius: 5
                        Image {
                            anchors.fill: parent
                            anchors.margins: 10
                            source: "/res/ales/waypoint/MissionPoint.svg"
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }
                Text {
                    Layout.preferredHeight: sizeTextWidth
                    Layout.preferredWidth: sizeTextWidth
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: textColor
                    text: "0s"
                    font.pointSize: sizeText
                }
            }
        }

        Rectangle {
            color: "transparent"
            Layout.preferredHeight: sizeButton*1.5
            Layout.preferredWidth: sizeButton*1.5
            RowLayout{
                anchors.fill: parent
                Button{
                    checkable: false
                    checked: false
                    Layout.preferredHeight: sizeButton
                    Layout.preferredWidth: sizeButton
                    background: Rectangle{
                        color: parent.checked? checkedColor: "transparent"
                        radius: 5
                        Image {
                            anchors.fill: parent
                            anchors.margins: 10
                            source: "/res/ales/waypoint/MissionPicture.svg"
                            fillMode: Image.PreserveAspectFit
                        }
                    }
                }
                Text {
                    Layout.preferredHeight: sizeTextWidth
                    Layout.preferredWidth: sizeTextWidth
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    color: textColor
                    text: "0s"
                    font.pointSize: sizeText
                }
            }
        }


    }
}
