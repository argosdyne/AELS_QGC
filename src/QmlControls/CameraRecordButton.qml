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

Button {
    id:     root
    z : 3
    property var rootWidth: null;
    property var rootHeight: null;
    property bool isRecording: false;

    background: Rectangle {
        color: "transparent"
    }
    width: rootWidth / 15.5
    height: width

    Image {
        anchors.fill: parent
        source: isRecording ? "/res/Record.svg" : "/res/NoSDcard(Red).svg"
    }

    onClicked: {

        if(isRecording == false) {
            isRecording = true
        }else {
            isRecording = false
            _root.visible = false
        }
    }
}

