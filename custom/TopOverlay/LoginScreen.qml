import QtQuick          2.3
import QtQuick.Controls 2.15
import QtQuick.Dialogs  1.2
import QtLocation       5.3
import QtPositioning    5.3
import QtQuick.Layouts  1.2
import QtQuick.Window   2.2

import QGroundControl.ScreenTools       1.0
import QGroundControl.Palette           1.0
import QtQuick.Controls.Material 2.12

Item {
    id: _root

    implicitHeight: Screen.height
    implicitWidth:  Screen.width

    property alias mouseLogo: mouseLogo
    property alias btnLogin: btnLogin
    property alias btnMission: btnMission
    property alias btnCamera: btnCamera
    property alias comboBox: comboBox

    QGCMapPalette { id: loginPal }

    Rectangle {
        id: rectangle
        anchors.fill: parent
        color: "#000000"

        Rectangle {
            id: recLogo
            width: ScreenTools.defaultFontPixelHeight/16*100
            height: ScreenTools.defaultFontPixelHeight/16*100
            color: "black"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 20
            anchors.topMargin: 20

            Image {
                id: imgLogo
                anchors.fill: parent
                source: "qrc:/ales/login/MainLogo.png"
                fillMode: Image.PreserveAspectFit
            }

            MouseArea {
                id: mouseLogo
                anchors.fill: parent
            }
        }

        RoundButton {
            id: btnLogin
            width: ScreenTools.defaultFontPixelHeight/16*100
            height: ScreenTools.defaultFontPixelHeight/16*100
            text: ""
            anchors.right: parent.right
            anchors.top: parent.top
            icon.height: ScreenTools.defaultFontPixelHeight/16*30
            icon.width: ScreenTools.defaultFontPixelHeight/16*30
            icon.source: "qrc:/ales/login/User.svg"
            anchors.rightMargin: 20
            anchors.topMargin: 20
        }

        RowLayout {
            id: btnRow
            spacing: 40
            
            anchors.bottomMargin: 100
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            

            
            Button {
                id: btnCamera
                Layout.preferredHeight: ScreenTools.defaultFontPixelHeight/16*80
                Layout.preferredWidth: ScreenTools.defaultFontPixelHeight/16*80*3.5
                
                background: Rectangle {
                    color: Qt.rgba(255, 255, 255, 0.5)
                    radius: 10
                    RowLayout {
                        anchors.fill: parent
                        spacing: 10
                        anchors.margins: 10
                        Image {
                            Layout.fillHeight: true
                            Layout.preferredWidth: height
                            source: "qrc:/ales/login/Camera.svg"
                            fillMode: Image.PreserveAspectFit
                        }

                        Text {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            font.pointSize: ScreenTools.defaultFontPixelHeight*2
                            text: "Camera"
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            color: "white"
                        }
                    }
                }
            }

            Button {
                id: btnMission
                Layout.preferredHeight: ScreenTools.defaultFontPixelHeight/16*80
                Layout.preferredWidth: ScreenTools.defaultFontPixelHeight/16*80*3.5
                
                background: Rectangle {
                    color: Qt.rgba(255, 255, 255, 0.5)
                    radius: 10
                    RowLayout {
                        anchors.fill: parent
                        spacing: 10
                        anchors.margins: 10
                        Image {
                            Layout.fillHeight: true
                            Layout.preferredWidth: height
                            source: "qrc:/ales/login/Mission.svg"
                            sourceSize.width: height
                            sourceSize.height: height
                            fillMode: Image.PreserveAspectFit
                        }
                        Text {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            font.pointSize: ScreenTools.defaultFontPixelHeight*2
                            text: "Mission"
                            verticalAlignment: Text.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            color: "white"
                        }
                    }
                }
            }
        }

        ComboBox {
            id: comboBox
            width: ScreenTools.defaultFontPixelHeight/16*200
            height: ScreenTools.defaultFontPixelHeight/16*100
            anchors.top: parent.top
            model: ["AQUILA 2", "AQUILA 3F", "HUMMER"]
            font.pointSize: ScreenTools.defaultFontPixelHeight * 2
            anchors.topMargin: 20
            anchors.horizontalCenter: parent.horizontalCenter
            palette.buttonText: "gray"
            Material.accent: "black"
            Material.foreground: "white"
            Material.background: "black"
        }

        RowLayout {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 20
            anchors.rightMargin: 20
            spacing: 10

            Image {
                Layout.preferredWidth: height
                Layout.fillHeight: true
                horizontalAlignment: Image.AlignHCenter
                verticalAlignment: Image.AlignVCenter
                source: "qrc:/ales/login/Link.svg"
                fillMode: Image.Stretch
                sourceSize.height: parent.height
                sourceSize.width: parent.height
            }
            Label {
                color: "#ddffffff"
                Layout.fillHeight: true
                Layout.fillWidth: true
                font.pointSize: ScreenTools.defaultFontPixelHeight*1.6
                text: "How to Connect"
                verticalAlignment: Text.AlignVCenter
            }
        }
    }




}
