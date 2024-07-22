import QtQuick          2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts  1.11
import QtQuick.Dialogs  1.3
import QtQuick.Window 2.0

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.Palette               1.0
import QGroundControl.ScreenTools           1.0



Button {
    id: root
    checked: true
    implicitWidth: 100
    implicitHeight: 100
    checkable: true

    background: Rectangle {
        width: root.width
        height: root.height
        color: "transparent"
        Image {
            anchors.fill: parent
            anchors.margins: 10
            source: root.checked ? "/res/ales/waypoint/BlueCheckOn.svg" : "/res/ales/waypoint/BlueCheckOff.svg"
            fillMode: Image.PreserveAspectFit
        }
    }
}
