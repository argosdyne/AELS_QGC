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
    id:     root
    color: isRed ? "#DF3712" : "#FCA600"
    z : 3  
    property var rootWidth: null;
    property var rootHeight: null;

    property bool isRed: false

    width: rootWidth / 6.6
    height: rootHeight / 14.4

    x :  parent.width / 147.7

//    Text {
//        text: qsTr("Remote control and the drone disconnected")
//        anchors.centerIn: parent
//        color: "white"
//        wrapMode: Text.WordWrap
//        width: parent.width /1.3
//    }

    Button {
        width: parent.width / 7.4
        height: parent.height / 1.9
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        background: Rectangle {
            color: "transparent"
            Image {
                source: isRed ? "/res/Close(white).svg" : "/res/Close(lightgray).svg"  // IsRed에 따라 이미지 소스 변경
                anchors.fill: parent
            }
        }
        onClicked: {
            console.log("btn Clicked")
        }
    }
}


