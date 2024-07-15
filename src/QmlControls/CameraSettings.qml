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
    property int hItemDelegate: Screen.height / 25;
    property int hSwitchDelegate: Screen.height / 24;
    property int hToolSeparator: 13;
    property int leftMargin: 20;

    //Size Property
    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize

    Text {
        id: cameraSettingsText
        color: white
        text: qsTr("Camera Settings")
        font.pixelSize: ScreenTools.mediumFontPointSize * 2.5
        font.bold: true
        font.family: 'Arial'
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.topMargin: 20  // Add margin from top of the parent if needed
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
            height: hItemDelegate

            Text {
                anchors.left: parent.left
                anchors.leftMargin: leftMargin
                text: 'Grid'
                font.pixelSize: ScreenTools.mediumFontPointSize * 2
                anchors.verticalCenter: parent.verticalCenter
                color: white
            }
        }

        ToolSeparator {
            width: parent.width
            height: hToolSeparator
            orientation: Qt.Horizontal
        }

        ItemDelegate {
            width: parent.width
            height: hItemDelegate

            Text {
                anchors.left: parent.left
                anchors.leftMargin: leftMargin
                color: white
                text: qsTr("Center Point")
                font.pixelSize: ScreenTools.mediumFontPointSize * 2
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        ToolSeparator {
            width: parent.width
            height: hToolSeparator
            orientation: Qt.Horizontal
        }

        SwitchDelegate {
            width: parent.width
            height: hSwitchDelegate
            text: qsTr(" ")

            Text {
                anchors.left: parent.left
                anchors.leftMargin: leftMargin
                color: white
                text: qsTr("Histogram")
                font.pixelSize: ScreenTools.mediumFontPointSize * 2
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        ToolSeparator {
            width: parent.width
            height: hToolSeparator
            orientation: Qt.Horizontal
        }

        SwitchDelegate {
            width: parent.width
            height: hSwitchDelegate
            text: qsTr(" ")

            Text {
                anchors.left: parent.left
                anchors.leftMargin: leftMargin
                color: white
                text: qsTr("Lock Gimbal While Shooting")
                font.pixelSize: ScreenTools.mediumFontPointSize * 2
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        ToolSeparator {
            width: parent.width
            height: hToolSeparator
            orientation: Qt.Horizontal
        }

        SwitchDelegate {
            width: parent.width
            height: hSwitchDelegate
            text: qsTr(" ")

            Text {
                anchors.left: parent.left
                anchors.leftMargin: leftMargin
                color: white
                text: qsTr("DeFog")
                font.pixelSize: ScreenTools.mediumFontPointSize * 2
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        ToolSeparator {
            width: parent.width
            height: hToolSeparator
            orientation: Qt.Horizontal
        }

        SwitchDelegate {
            width: parent.width
            height: hSwitchDelegate
            text: qsTr(" ")

            Text {
                anchors.left: parent.left
                anchors.leftMargin: leftMargin
                color: white
                text: qsTr("ROI")
                font.pixelSize: ScreenTools.mediumFontPointSize * 2
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        ToolSeparator {
            width: parent.width
            height: hToolSeparator
            orientation: Qt.Horizontal
        }

        SwitchDelegate {
            width: parent.width
            height: hSwitchDelegate
            text: qsTr(" ")

            Text {
                anchors.left: parent.left
                anchors.leftMargin: leftMargin
                color: white
                text: qsTr("Over Exposure Warning")
                font.pixelSize: ScreenTools.mediumFontPointSize * 2
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        ToolSeparator {
            width: parent.width
            height: hToolSeparator
            orientation: Qt.Horizontal
        }

        SwitchDelegate {
            width: parent.width
            height: hSwitchDelegate
            text: qsTr(" ")

            Text {
                anchors.left: parent.left
                color: white
                anchors.leftMargin: leftMargin
                text: qsTr("Subtitle.ASS File")
                font.pixelSize: ScreenTools.mediumFontPointSize * 2
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        ToolSeparator {
            width: parent.width
            height: hToolSeparator
            orientation: Qt.Horizontal
        }

        SwitchDelegate {
            width: parent.width
            height: hSwitchDelegate
            text: qsTr(" ")

            Text {
                anchors.left: parent.left
                color: white
                anchors.leftMargin: leftMargin
                text: qsTr("Auto Syne HD Photo")
                font.pixelSize: ScreenTools.mediumFontPointSize * 2
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        ToolSeparator {
            width: parent.width
            height: hToolSeparator
            orientation: Qt.Horizontal
        }

        SwitchDelegate {
            width: parent.width
            height: hSwitchDelegate
            text: qsTr(" ")

            Text {
                anchors.left: parent.left
                color: white
                anchors.leftMargin: leftMargin
                text: qsTr("Pre-record Photo")
                font.pixelSize: ScreenTools.mediumFontPointSize * 2
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        ToolSeparator {
            width: parent.width
            height: hToolSeparator
            orientation: Qt.Horizontal
        }

        ItemDelegate {
            width: parent.width
            height: hItemDelegate

            Text {
                anchors.left: parent.left
                color: white
                anchors.leftMargin: leftMargin
                text: qsTr("Video Encoding Format")
                font.pixelSize: ScreenTools.mediumFontPointSize * 2
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        ToolSeparator {
            width: parent.width
            height: hToolSeparator
            orientation: Qt.Horizontal
        }

        ItemDelegate {
            width: parent.width
            height: hItemDelegate

            Text {
                anchors.left: parent.left
                color: white
                anchors.leftMargin: leftMargin
                text: qsTr("Anti-Flicker")
                font.pixelSize: ScreenTools.mediumFontPointSize * 2
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        ToolSeparator {
            width: parent.width
            height: hToolSeparator
            orientation: Qt.Horizontal
        }

        ItemDelegate {
            width: parent.width
            height: hItemDelegate

            Text {
                anchors.right: parent.right
                anchors.rightMargin: 20
                color: "blue"
                text: qsTr("Reset Camera")
                font.pixelSize: ScreenTools.mediumFontPointSize * 2.1
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        ToolSeparator {
            width: parent.width
            height: hToolSeparator
            orientation: Qt.Horizontal
        }

        ItemDelegate {
            width: parent.width
            height: hItemDelegate

            Text {
                anchors.left: parent.left
                color: white
                anchors.leftMargin: leftMargin
                text: qsTr("Save Location")
                font.pixelSize: ScreenTools.mediumFontPointSize * 2
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
