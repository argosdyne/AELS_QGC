﻿import QtQuick          2.12
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
    background: Rectangle {
        color: "transparent"
    }
    width: rootWidth / 50.5
    height: rootHeight / 49.1

    Image {
        anchors.fill: parent
        source: "/res/TopMenu_Up.svg"
    }

    onClicked: {
        _root.visible = false
    }
}
