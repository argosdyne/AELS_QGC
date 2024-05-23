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
    color: "#222020"
    z: 3

    radius: 12
    property var rootWidth: null;
    property var rootHeight: null;

    width: rootWidth / 4.1
    height: rootHeight / 3.4

    Rectangle {
        width: parent.width
        height: 2 // 분리선의 두께
        color: "#848282"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: parent.height / 4.7 // 분리선의 위치
    }

    Rectangle {
        width: parent.width
        height: 2 // 분리선의 두께
        color: "#848282"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height / 5.3 // 분리선의 위치
    }

    //Left button
    Button {
        width: parent.width / 2
        height: parent.height / 5.3
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        background: Rectangle{
            color: "transparent"
            anchors.fill: parent
        }

        Text {
            text: qsTr("CANCEL")
            color: "#276BF0"
            anchors.centerIn: parent
            font.pixelSize: parent.width / 7.7
            font.bold: true
        }
        onClicked: {
            console.log("Left btn Click");
        }
    }

    //Right button
    Button {
        width: parent.width / 2
        height: parent.height / 5.3
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        background: Rectangle{
            color: "transparent"
            anchors.fill: parent
        }

        Text {
            text: qsTr("OK")
            color: "#276BF0"
            anchors.centerIn: parent
            font.pixelSize: parent.width / 7.7
            font.bold: true
        }

        onClicked: {
            console.log("Right btn Click");
            _root.visible = false //테스트용
        }
    }

    //Vertical Separator

    Rectangle {
        width: 2
        height: parent.height / 5.3
        color: "#848282"        
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
    }


    // 위쪽 부분 영역
    Rectangle {
        width: parent.width
        height: parent.height / 4.7
        anchors.top: parent.top
        color: "transparent"
        id: topRect

        //내부 사각형
        Rectangle {
            anchors.centerIn: parent
            color: "transparent"
            width: parent.width / 2.8
            height: parent.height / 1.4
            id: rect

            Row {
                id: row
                spacing: parent.width / 14
                Image {
                    id: img
                    source: "/res/Warning.svg"
                    width: topRect.height / 1.2
                    height: topRect.height / 1.2
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    id: txt
                    text: qsTr("Warning")
                    font.pixelSize: rect.width / 5.6
                    anchors.verticalCenter: parent.verticalCenter
                    color: "white"
                }
            }
        }
    }
}
