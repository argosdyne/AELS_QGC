import QtQuick          2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts  1.11
import QtQuick.Dialogs  1.3
import QtQuick.Window 2.15

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.Palette               1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Controllers           1.0
import QtGraphicalEffects                   1.12

Rectangle {
    id: root
    color: defaultBackGroundColor

    property color defaultTextColor: "white"
    property color transparent: "transparent"
    property color fontColorWhite: "white"
    property color fontColorlightGray: "#848282"
    property color defaultBackGroundColor: "#3c3434" 
    property color yellow: "#fca600"

    //Size Property
    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize

    implicitWidth: Screen.width /  2.2
    implicitHeight: Screen.height / 1.9


    Rectangle {
        width: parent.width
        height: 2 
        color: fontColorlightGray
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: parent.height / 7.2 
    }

    Rectangle {
        width: parent.width
        height: 2 
        color: fontColorlightGray
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height / 6.4 
    }

    //Title Text

    Rectangle {
        width: parent.width
        height: parent.height / 7.2
        anchors.top: parent.top
        color: transparent

        Text {
            color: defaultTextColor
            font.pixelSize: defaultFontSize * 4
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Remote Control Instruction"
        }
    }

    Column {
        width: parent.width
        height: parent.height / 1.4
        anchors.top: parent.top
        anchors.topMargin: parent.height / 7.2        

        Item {
            width: 1
            height: parent.height / 10.7
        }

        Rectangle {
            width: parent.width / 1.3
            height: root.height / 19.2
            anchors.horizontalCenter: parent.horizontalCenter
            color: transparent

            Text {
                text: "Left Command Stick"
                color: yellow
                font.pixelSize: defaultFontSize * 2
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
            }
            Text {
                text: "Right Command Stick"
                color: yellow
                font.pixelSize: defaultFontSize * 2
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
            }
        }

        Item {
            width: 1
            height: parent.height / 20.35
        }

        Rectangle {
            width: parent.width / 1.2
            height: root.height / 3
            color: transparent
            anchors.horizontalCenter: parent.horizontalCenter

            Image {
                source: "qrc:/res/LeftCommandStick.svg"
                anchors.left: parent.left
                width: defaultFontSize * 27
                height: defaultFontSize * 19
            }

            Image {
                source:"qrc:/res/RightCommandStick.svg"
                anchors.right: parent.right
            }
        }

        Item {
            width: 1
            height: parent.height / 14.5
        }

        Text {
            text: "Remote controller mode : Mode 2"
            color: defaultTextColor
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: defaultFontSize * 3
        }

        Item {
            width: 1
            height:parent.height / 16.28
        }

        Image {
            source: "qrc:/res/DragLeft.svg"
            anchors.horizontalCenter: parent.horizontalCenter
        }


    }

    //Left button
    Button {
        width: parent.width / 2
        height: parent.height / 6.4
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        background: Rectangle{
            color: transparent
            anchors.fill: parent
        }

        Text {
            text: "DO NOT SHOW AGAIN"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            color: defaultTextColor
            font.pixelSize: defaultFontSize * 3
        }
    }

    //Right button
    Button {
        width: parent.width / 2
        height: parent.height / 6.4
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        background: Rectangle{
            color: transparent
            anchors.fill: parent
        }
        Text {
            text: "FINISH"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            color: defaultTextColor
            font.pixelSize: defaultFontSize * 3
        }
    }

    //Vertical Separator

    Rectangle {
        width: 2
        height: parent.height / 6.4
        color: fontColorlightGray
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
    }

}
