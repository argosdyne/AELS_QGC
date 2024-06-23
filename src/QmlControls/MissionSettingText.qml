import QtQuick          2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts  1.11
import QtQuick.Dialogs  1.3
import QtQuick.Window 2.0

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.Palette               1.0
import QGroundControl.ScreenTools           1.0



TextField{
    implicitWidth: 400
    implicitHeight: 200
    property string backgroundColor: "#3b3737"
    property string borderColor: "#cecdcd"
    property string borderColorFocus: "#7f7f7f"
    text: "60m"
    horizontalAlignment: Text.AlignHCenter
    verticalAlignment: Text.AlignVCenter
    color: "white"
    background: Rectangle {
        color:backgroundColor
        border.color: control.pressed ? borderColor : borderColorFocus
        border.width: control.visualFocus ? 5 : 2
        radius: 5
    }
}

