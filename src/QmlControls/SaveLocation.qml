import QtQuick          2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts  1.11
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
    color: black

    implicitWidth: Screen.width / 3.24
    implicitHeight: Screen.height
    property string white: '#ffffff'
    property string black: '#000000'
    property string blue: '#3D71D7'

    property int hItemDelegate: Screen.height / 20;

    //Size Property
    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize

    Text {
        id: saveLocationText
        color: white
        text: qsTr("Save Location")
        font.pixelSize: ScreenTools.mediumFontPointSize * 2.5
        font.bold: true
        font.family: 'Arial'
        anchors.top: root.top
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.topMargin: 20
    }

    Text{
        id: backtext
        text: qsTr('Back')
        color: blue
        font.pixelSize: ScreenTools.mediumFontPointSize * 2
        font.family: 'Arial'
        anchors.top: root.top
        anchors.right: parent.right
        anchors.rightMargin: 30
        anchors.topMargin: 20
    }

    Flickable {
        id: videoEncodingFlickable
        anchors {
            top: saveLocationText.bottom
            topMargin: 20
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        contentWidth: parent.width
        contentHeight: column.height

        Column {
            id: column
            width: videoEncodingFlickable.width
            spacing: 5

            ItemDelegate {
                width: parent.width
                height: hItemDelegate
                Text {
                    text: 'SD Card'
                    font.pixelSize: ScreenTools.mediumFontPointSize * 2.5
                    font.family: 'Arial'
                    color: white
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            ItemDelegate {
                width: parent.width
                height: hItemDelegate

                Text {
                    color: white
                    text: qsTr("Flash Card")
                    font.family: 'Arial'
                    font.pixelSize: ScreenTools.mediumFontPointSize * 2.5
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }
        }
    }
}
