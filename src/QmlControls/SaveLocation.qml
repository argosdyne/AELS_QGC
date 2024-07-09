import QtQuick 2.15
import QtQuick.Controls 2.14
import QtPositioning 5.14
import QtQuick.Window 2.10
import QGroundControl.ScreenTools 1.0

Rectangle {
    id: root
    color: black

    implicitWidth: Screen.width / 3.24
    implicitHeight: Screen.height
    property string white: '#ffffff'
    property string black: '#000000'
    property string blue: '#3D71D7'

    property int hItemDelegate: 52;

    Text {
        id: saveLocationText
        color: white
        text: qsTr("Save Location")
        font.pixelSize: ScreenTools.mediumFontPointSize * 2.5
        font.bold: true
        font.family: 'Arial'
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.topMargin: 17
    }

    Text{
        id: backtext
        text: qsTr('Back')
        color: blue
        font.pixelSize: ScreenTools.mediumFontPointSize * 2
        font.family: 'Arial'
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.rightMargin: 30
        anchors.topMargin: 17
    }

    Column {
        anchors.top: saveLocationText.bottom
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

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
