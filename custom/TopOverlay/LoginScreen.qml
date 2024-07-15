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

    Component.onCompleted: {
        console.log("AAAA"+ ScreenTools.defaultFontPixelHeight)
    }

    QGCMapPalette { id: loginPal }

    Rectangle {
        id: rectangle
        anchors.fill: parent
        color: "#000000"

        Rectangle {
            id: recLogo
            width: ScreenTools.defaultFontPixelHeight*15
            height: ScreenTools.defaultFontPixelHeight*15
            color: "black"
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.leftMargin: 10
            anchors.topMargin: 10

            Image {
                id: imgLogo
                anchors.fill: parent
                source: "qrc:/ales/login/MainLogo.png"
                antialiasing: true
                cache: false
                fillMode: Image.PreserveAspectFit
            }

            MouseArea {
                id: mouseLogo
                anchors.fill: parent
            }
        }

        RoundButton {
            id: btnLogin
            width: ScreenTools.defaultFontPixelHeight*15
            height: ScreenTools.defaultFontPixelHeight*15
            text: ""
            anchors.right: parent.right
            anchors.top: parent.top
            icon.height: ScreenTools.defaultFontPixelHeight*8
            icon.width: ScreenTools.defaultFontPixelHeight*8
            icon.source: "qrc:/ales/login/User.svg"
            anchors.rightMargin: 10
            anchors.topMargin: 10
        }

        RowLayout {
            id: btnRow
            width: ScreenTools.defaultFontPixelHeight*50
            height: ScreenTools.defaultFontPixelHeight*10
            spacing: 100
            anchors.verticalCenter: parent.verticalCenter
            anchors.bottomMargin: 100
            anchors.horizontalCenter: parent.horizontalCenter

            ToolButton {
                id: btnCamera
                Layout.preferredHeight: btnRow.height
                Layout.preferredWidth: btnRow.height * 2
                text: "Camera"
                display: AbstractButton.TextBesideIcon
                icon.height: ScreenTools.defaultFontPixelHeight*6
                icon.width: ScreenTools.defaultFontPixelHeight*6
                font.pointSize: ScreenTools.defaultFontPixelHeight*2
                icon.color: "transparent"
                icon.source: "qrc:/ales/login/Camera.svg"
                palette.buttonText: "white"
            }


            ToolButton {
                id: btnMission
                Layout.preferredHeight: btnRow.height
                Layout.preferredWidth: btnRow.height * 2
                text: "Mission"
                display: AbstractButton.TextBesideIcon
                icon.height: ScreenTools.defaultFontPixelHeight*6
                icon.width: ScreenTools.defaultFontPixelHeight*6
                font.pointSize: ScreenTools.defaultFontPixelHeight*2
                icon.color: "transparent"
                icon.source: "qrc:/ales/login/Mission.svg"
                palette.buttonText: "white"
            }
        }

        ComboBox {
            id: comboBox
            width: ScreenTools.defaultFontPixelHeight*20
            height: ScreenTools.defaultFontPixelHeight*8
            anchors.top: parent.top
            model: ["AQUILA 2", "AQUILA 3F", "HUMMER"]
            font.pointSize: ScreenTools.defaultFontPixelHeight * 2
            anchors.topMargin: 30
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
