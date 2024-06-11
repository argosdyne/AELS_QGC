import QtQuick          2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts  1.15
import QtQuick.Dialogs  1.3
import QtQuick.Window 2.0

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.Palette               1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Controllers           1.0
import QtGraphicalEffects                   1.12

Rectangle {
    id: root
    z : 3
    property alias value: control.value

    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize
    property color transparent: "transparent"
    property color fontColorlightGray: "lightGray"

    implicitWidth: defaultFontSize * 6
    implicitHeight:defaultFontSize * 60

    color: transparent
    Column {
        spacing: 0
        z: 5
        Button {
            width: control.availableWidth
            height: width
            background: Rectangle { color: transparent }
            Image {
                source: "/res/CameraGimbal0.svg"
                anchors.fill: parent
            }
        }

        Slider {
            id: control
            orientation: Qt.Vertical
            anchors.horizontalCenter: parent.horizontalCenter
            height: root.height
            width: root.width
            value: 1

            background: Rectangle {
                width: control.availableWidth
                height: control.availableHeight + defaultFontSize
                color: fontColorlightGray
                id: bgRect
            }

            handle: Item {
                width: control.availableWidth
                height: defaultFontSize * 7
                anchors.horizontalCenter: bgRect.horizontalCenter
                y: control.visualPosition * (control.availableHeight - height + defaultFontSize)

                Image {
                    source: "/res/CameraGimbalControl.svg"
                    anchors.fill: parent
                }
            }
        }

        Button {
            width: control.availableWidth
            height: width
            background: Rectangle { color: transparent }

            Image {
                source: "/res/CameraGimbal90.svg"
                anchors.fill: parent
            }
        }
    }
}

