import QtQuick          2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts  1.11
import QtQuick.Dialogs  1.3
import QtQuick.Window 2.0

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.Palette               1.0
import QGroundControl.ScreenTools           1.0

Rectangle {
    id: root
    height: 80
    width: 800
    visible: true
    color: "#5c5c5c"



    RowLayout{
        anchors.fill: parent
        anchors.margins: 10

        TextField{
            text: slider.value+"km/h"
            color: "white"
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
            Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*50
            background: Rectangle {
                radius: 5
                color: "transparent"
                border.color: "#8a8a8a"
            }
        }

        Label{
            text: slider.from
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*80
            color:   "#797979"
            font.pointSize: ScreenTools.defaultFontPointSize/16*15
        }

        Slider {
            id: slider
            live: true
            spacing: 0
            stepSize: 1
            value: 10
            to: 800
            from: 10
            Layout.fillHeight: true
            Layout.fillWidth: true
            background: Rectangle {
                x: parent.leftPadding
                y: parent.topPadding
                   + parent.availableHeight / 2 - height / 2
                implicitHeight: 5
                implicitWidth: 200
                height: implicitHeight
                width: parent.availableWidth
            }

            handle: Rectangle {
                    x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
                    y: parent.topPadding + parent.availableHeight / 2 - height / 2
                    implicitWidth: 26
                    implicitHeight: 26
                    radius: height/2
                    color: parent.pressed ? "#f0f0f0" : "#4c6fda"
                    border.color: "#4c6fda"
                }
        }

        Label{
            text: slider.to
            Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*80
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: ScreenTools.defaultFontPointSize/16*15
            color:   "#797979"

        }

    }
}