import QtQuick 2.15
import QtQuick.Controls 2.14
import QtPositioning 5.14
import QtQuick.Window 2.10
import QGroundControl.ScreenTools 1.0 

Rectangle {
    id: root
    color: black

    property int rootWidth: Screen.width
    property int rootHeight: Screen.height
    property string white: '#ffffff'
    property string black: '#000000'

    width: rootWidth / 3.24
    height: rootHeight / 1

    Text {
        id: cameraSettingsText
        color: white
        text: qsTr("Camera Settings")
        font.pixelSize: ScreenTools.mediumFontPointSize * 2
        font.bold: true
        font.family: 'Arial'
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.topMargin: 12  // Add margin from top of the parent if needed
    }

    Column {
        anchors.top: cameraSettingsText.bottom
        anchors.topMargin: 15 // Editable margin between text1 and column1
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        spacing: 4

        ItemDelegate {
            width: parent.width
            height: 40

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 15
                text: 'Grid'
                font.pixelSize: ScreenTools.mediumFontPointSize * 2
                color: white
            }
        }

        ToolSeparator {
            width: parent.width
            height: 13
            orientation: Qt.Horizontal
        }

        ItemDelegate {
            width: parent.width
            height: 40

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 15
                color: white
                text: qsTr("Center Point")
                font.pixelSize: ScreenTools.mediumFontPointSize * 2
            }
        }

        ToolSeparator {
            width: parent.width
            height: 13
            orientation: Qt.Horizontal
        }

        SwitchDelegate {
            width: parent.width
            height: 52
            text: qsTr(" ")

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 15
                color: white
                text: qsTr("Histogram")
                font.pixelSize: ScreenTools.mediumFontPointSize * 2
            }
        }

        ToolSeparator {
            width: parent.width
            height: 13
            orientation: Qt.Horizontal
        }

        SwitchDelegate {
            width: parent.width
            height: 52
            text: qsTr(" ")

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 15
                color: white
                text: qsTr("Lock Gimbal While Shooting")
                font.pixelSize: ScreenTools.mediumFontPointSize * 2
            }
        }

        ToolSeparator {
            width: parent.width
            height: 13
            orientation: Qt.Horizontal
        }

        SwitchDelegate {
            width: parent.width
            height: 52
            text: qsTr(" ")

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 15
                color: white
                text: qsTr("DeFog")
                font.pixelSize: ScreenTools.mediumFontPointSize * 2
            }
        }

        ToolSeparator {
            width: parent.width
            height: 13
            orientation: Qt.Horizontal
        }

        SwitchDelegate {
            width: parent.width
            height: 52
            text: qsTr(" ")

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 15
                color: white
                text: qsTr("ROI")
                font.pixelSize: ScreenTools.mediumFontPointSize * 2
            }
        }

        ToolSeparator {
            width: parent.width
            height: 13
            orientation: Qt.Horizontal
        }

        SwitchDelegate {
            width: parent.width
            height: 52
            text: qsTr(" ")

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 15
                color: white
                text: qsTr("Over Exposure Warning")
                font.pixelSize: ScreenTools.mediumFontPointSize * 2
            }
        }

        ToolSeparator {
            width: parent.width
            height: 13
            orientation: Qt.Horizontal
        }

        SwitchDelegate {
            width: parent.width
            height: 52
            text: qsTr(" ")

            Text {
                anchors.left: parent.left
                color: white
                anchors.leftMargin: 15
                text: qsTr("Subtitle.ASS File")
                font.pixelSize: ScreenTools.mediumFontPointSize * 2
            }
        }

        ToolSeparator {
            width: parent.width
            height: 13
            orientation: Qt.Horizontal
        }

        SwitchDelegate {
            width: parent.width
            height: 52
            text: qsTr(" ")

            Text {
                anchors.left: parent.left
                color: white
                anchors.leftMargin: 15
                text: qsTr("Auto Syne HD Photo")
                font.pixelSize: ScreenTools.mediumFontPointSize * 2
            }
        }

        ToolSeparator {
            width: parent.width
            height: 13
            orientation: Qt.Horizontal
        }

        SwitchDelegate {
            width: parent.width
            height: 52
            text: qsTr(" ")

            Text {
                anchors.left: parent.left
                color: white
                anchors.leftMargin: 15
                text: qsTr("Pre-record Photo")
                font.pixelSize: ScreenTools.mediumFontPointSize * 2
            }
        }

        ToolSeparator {
            width: parent.width
            height: 13
            orientation: Qt.Horizontal
        }

        ItemDelegate {
            width: parent.width
            height: 40

            Text {
                anchors.left: parent.left
                color: white
                anchors.leftMargin: 15
                text: qsTr("Video Encoding Format")
                font.pixelSize: ScreenTools.mediumFontPointSize * 2
            }
        }

        ToolSeparator {
            width: parent.width
            height: 13
            orientation: Qt.Horizontal
        }

        ItemDelegate {
            width: parent.width
            height: 40

            Text {
                anchors.left: parent.left
                color: white
                anchors.leftMargin: 15
                text: qsTr("Anti-Flicker")
                font.pixelSize: ScreenTools.mediumFontPointSize * 2
            }
        }

        ToolSeparator {
            width: parent.width
            height: 13
            orientation: Qt.Horizontal
        }

        ItemDelegate {
            width: parent.width
            height: 40

            Text {
                anchors.right: parent.right
                anchors.rightMargin: 20
                color: "blue"
                text: qsTr("Reset Camera")
                font.pixelSize: ScreenTools.mediumFontPointSize * 2.1
            }
        }

        ToolSeparator {
            width: parent.width
            height: 13
            orientation: Qt.Horizontal
        }

        ItemDelegate {
            width: parent.width
            height: 40

            Text {
                anchors.left: parent.left
                color: white
                anchors.leftMargin: 15
                text: qsTr("Save Location")
                font.pixelSize: ScreenTools.mediumFontPointSize * 2
            }
        }
    }
}
