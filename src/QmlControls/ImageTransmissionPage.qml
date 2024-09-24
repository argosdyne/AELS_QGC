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

    property string white: '#ffffff'
    property string black: '#1f1f1f'
    property string blue: '#3D71D7'
    property color lightGray: "#4a4a4a"
    property color transparent: "transparent"
    property int hItemDelegate: Screen.height / 9;
    property int hSwitchDelegate: Screen.height / 15;
    property int hToolSeparator: defaultFontSize + 3;
    property int leftMargin: 20;

    //Size Property
    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize
    z: 3
    property var parentQML : null

    // Main Page
    Column {
        anchors.fill: parent
        width: parent.width
        height: parent.height

        //Channel Mode
        ItemDelegate {
            width: parent.width
            height: hItemDelegate

            Text {
                anchors.left: parent.left
                color: white
                text: "Channel Mode"
                font.pixelSize: defaultFontSize * 3.3
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: parent.width / 24
            }

            ComboBox {
                id: dBmComboBox
                width: parent.width / 7.2
                anchors.right: parent.right
                anchors.rightMargin: defaultFontSize
                anchors.verticalCenter: parent.verticalCenter
                model: ["2.4G"]

                // 텍스트와 색상 스타일을 지정
                contentItem: Text {
                    text: dBmComboBox.currentText
                    color: blue // 텍스트 색상
                    font.pixelSize: defaultFontSize * 3
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    padding: defaultFontSize
                }

                // 오른쪽의 화살표 표시를 커스텀
                indicator: Item {
                    anchors.fill: parent
                    anchors.right: parent.right
                    width: parent.height / 3
                    height: parent.height / 3
                    anchors.margins: defaultFontSize

                    Image {
                        source: "qrc:/res/ales/waypoint/DownDir.svg"  // 원하는 화살표 이미지로 변경
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter

                    }
                }

                background: Rectangle {
                    color: transparent  // 배경 색상 지정
                    border.color: lightGray
                    radius: 5
                }
            }
            background: Rectangle {
                color : transparent
            }
        }

        ToolSeparator {
            width: parent.width
            height: hToolSeparator
            orientation: Qt.Horizontal
        }

        //dBm/MHz
        ItemDelegate {
            width: parent.width
            height: parent.height / 1.5

            Column {
                anchors.fill: parent

                Row {
                    width: parent.width
                    height: hItemDelegate

                    Item {
                        width: parent.width / 24
                        height: 1
                    }

                    Text {
                        color: blue
                        text: "dBm/MHz"
                        font.pixelSize: defaultFontSize * 3.3
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Item {
                        width: parent.width / 2
                        height: 1
                    }

                    Text {
                        color: white
                        text: "Stable"
                        font.pixelSize: defaultFontSize * 3
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Item {
                        width: parent.width / 36
                        height: 1
                    }

                    Image {
                        source: "qrc:/res/TransmissionDBm.svg"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Item {
                        width: parent.width / 36
                        height: 1
                    }

                    Text{
                        text: "Unstable"
                        color: white
                        font.pixelSize: defaultFontSize * 3
                        anchors.verticalCenter: parent.verticalCenter
                    }

                }

                Image {
                    source: "qrc:/res/ImageTransmissionGraph.png"
                    anchors.horizontalCenter: parent.horizontalCenter

                }
            }

            background: Rectangle {
                color: transparent
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
                color: white
                font.pixelSize: defaultFontSize * 3.3
                text: "Image Transmission Mode"
                anchors.left: parent.left
                anchors.leftMargin: parent.width / 24
                anchors.verticalCenter: parent.verticalCenter
            }
            ComboBox {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: defaultFontSize
                id: imageTransmissionModeComboBox
                width: parent.width / 4.8
                model: ["High Definition", "Smooth"]

                // 텍스트와 색상 스타일을 지정
                contentItem: Text {
                    text: imageTransmissionModeComboBox.currentText
                    color: blue // 텍스트 색상
                    font.pixelSize: defaultFontSize * 3
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    padding: defaultFontSize
                }

                // 오른쪽의 화살표 표시를 커스텀
                indicator: Item {
                    anchors.fill: parent
                    anchors.right: parent.right
                    width: parent.height / 3
                    height: parent.height / 3
                    anchors.margins: defaultFontSize
                    Image {
                        source: "qrc:/res/ales/waypoint/DownDir.svg"  // 원하는 화살표 이미지로 변경
                        anchors.right: parent.right
                        anchors.verticalCenter: parent.verticalCenter

                    }
                }

                background: Rectangle {
                    color: transparent  // 배경 색상 지정
                    border.color: lightGray
                    radius: 5
                }
            }
            background: Rectangle {
                color : transparent
            }
        }
    }
}
