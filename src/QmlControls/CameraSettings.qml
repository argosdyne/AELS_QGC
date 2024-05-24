import QtQuick 2.15
import QtQuick.Controls 2.14
import QtPositioning 5.14

Rectangle {
    id: root
    color: '#000000'   // black

    property var rootWidth: null;
    property var rootHeight: null;

    width: rootWidth / 3.24
    height: rootHeight / 1

    Text {
        id: cameraSettingsText
        color: "#FFFFFF"    // white
        text: qsTr("Camera Settings")
        font.pixelSize: 25
        font.bold: true
        font.family: 'Arial'
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.topMargin: 12  // Add margin from top of the parent if needed
    }

    Column {
        id: column1
        anchors.top: text1.bottom
        anchors.topMargin: 15 // Editable margin between text1 and column1
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        spacing: 4


        ItemDelegate {
            id: itemDelegate
            width: parent.width
            height: 40

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 15
                text: 'Grid'
                font.pixelSize: 20
                color: "#FFFFFF"
                // verticalAlignment: Text.AlignVCenter
            }
        }

        ToolSeparator {
            width: parent.width
            height: 13
            orientation: Qt.Horizontal
        }

        ItemDelegate {
            id: itemDelegate1
            width: parent.width
            height: 40
            enabled: true
            hoverEnabled: true

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 15
                color: "#ffffff"
                text: qsTr("Center Point")
                font.pixelSize: 20
            }
        }

        ToolSeparator {
            width: parent.width
            height: 13
            orientation: Qt.Horizontal
        }

        SwitchDelegate {
            id: switchDelegate
            width: parent.width
            height: 52
            text: qsTr(" ")

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 15
                color: "#ffffff"
                text: qsTr("Histogram")
                font.pixelSize: 20
            }
        }

        ToolSeparator {
            width: parent.width
            height: 13
            orientation: Qt.Horizontal
        }

        SwitchDelegate {
            id: switchDelegate0
            width: parent.width
            height: 52
            text: qsTr(" ")

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 15
                color: "#ffffff"
                text: qsTr("Lock Gimbal While Shooting")
                font.pixelSize: 20
            }
        }

        ToolSeparator {
            width: parent.width
            height: 13
            orientation: Qt.Horizontal
        }

        SwitchDelegate {
            id: switchDelegate1
            width: parent.width
            height: 52
            text: qsTr(" ")

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 15
                color: "#ffffff"
                text: qsTr("DeFog")
                font.pixelSize: 20
            }
        }

        ToolSeparator {
            width: parent.width
            height: 13
            orientation: Qt.Horizontal
        }

        SwitchDelegate {
            id: switchDelegate2
            width: parent.width
            height: 52
            text: qsTr(" ")

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 15
                color: "#ffffff"
                text: qsTr("ROI")
                font.pixelSize: 20
            }
        }

        ToolSeparator {
            width: parent.width
            height: 13
            orientation: Qt.Horizontal
        }

        SwitchDelegate {
            id: switchDelegate3
            width: parent.width
            height: 52
            text: qsTr(" ")

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 15
                color: "#ffffff"
                text: qsTr("Over Exposure Warning")
                font.pixelSize: 20
            }
        }

        ToolSeparator {
            width: parent.width
            height: 13
            orientation: Qt.Horizontal
        }

        SwitchDelegate {
            id: switchDelegate4
            width: parent.width
            height: 52
            text: qsTr(" ")

            Text {
                anchors.left: parent.left
                color: "#ffffff"
                anchors.leftMargin: 15
                text: qsTr("Subtitle.ASS File")
                font.pixelSize: 20
            }
        }

        ToolSeparator {
            width: parent.width
            height: 13
            orientation: Qt.Horizontal
        }

        SwitchDelegate {
            id: switchDelegate5
            width: parent.width
            height: 52
            text: qsTr(" ")

            Text {
                anchors.left: parent.left
                color: "#ffffff"
                anchors.leftMargin: 15
                text: qsTr("Auto Syne HD Photo")
                font.pixelSize: 20
            }
        }

        ToolSeparator {
            width: parent.width
            height: 13
            orientation: Qt.Horizontal
        }

        SwitchDelegate {
            id: switchDelegate6
            width: parent.width
            height: 52
            text: qsTr(" ")

            Text {
                anchors.left: parent.left
                color: "#ffffff"
                anchors.leftMargin: 15
                text: qsTr("Pre-record Photo")
                font.pixelSize: 20
            }
        }

        ToolSeparator {
            width: parent.width
            height: 13
            orientation: Qt.Horizontal
        }

        ItemDelegate {
            id: itemDelegate3
            width: parent.width
            height: 40

            Text {
                anchors.left: parent.left
                color: "#ffffff"
                anchors.leftMargin: 15
                text: qsTr("Video Encoding Format")
                font.pixelSize: 20
            }
        }

        ToolSeparator {
            width: parent.width
            height: 13
            orientation: Qt.Horizontal
        }

        ItemDelegate {
            id: itemDelegate4
            width: parent.width
            height: 40

            Text {
                anchors.left: parent.left
                color: "#ffffff"
                anchors.leftMargin: 15
                text: qsTr("Anti-Flicker")
                font.pixelSize: 20
            }
        }

        ToolSeparator {
            width: parent.width
            height: 13
            orientation: Qt.Horizontal
        }

        ItemDelegate {
            id: itemDelegate5
            width: parent.width
            height: 40

            Text {
                anchors.right: parent.right
                anchors.rightMargin: 20
                color: "blue"
                text: qsTr("Reset Camera")
                font.pixelSize: 21
            }
        }

        ToolSeparator {
            width: parent.width
            height: 13
            orientation: Qt.Horizontal
        }

        ItemDelegate {
            id: itemDelegate6
            width: parent.width
            height: 40

            Text {
                anchors.left: parent.left
                color: "#ffffff"
                anchors.leftMargin: 15
                text: qsTr("Save Location")
                font.pixelSize: 20
            }
        }
    }
}
