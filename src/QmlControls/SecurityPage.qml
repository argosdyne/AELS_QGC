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
    property color red : "red"
    property color lightGray: "#4a4a4a"
    property color lightGray2: "#CAC8C8"
    property color orange : "#E89F33"
    property color lightGreen: "lightGreen"
    property color transparent: "transparent"
    property int hItemDelegate: Screen.height / 9;
    property int hSwitchDelegate: Screen.height / 15;
    property int hToolSeparator: defaultFontSize + 3;
    property int leftMargin: 20;

    //Size Property
    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize
    z: 3
    property var parentQML : null

    //Enable Media Encryption Page
    Rectangle {
        id: enableMediaEncryptionPage
        z : 4
        visible: false
        color: "#3C3C3C"
        width: parent.width / 2 // 720
        height: parent.height / 1.5 //600
        anchors.centerIn: parent
        MouseArea {
            anchors.fill: parent
        }

        Column {
            anchors.fill: parent
            Rectangle {
                width: parent.width
                height: parent.height / 6
                color: transparent

                Text {
                    color: white
                    font.pixelSize: defaultFontSize * 3
                    text: "Enable Media Encryption"
                    anchors.centerIn: parent
                }

                Button {
                    width: parent.width / 8
                    height: width
                    anchors.right: parent.right
                    anchors.rightMargin: parent.width / 20
                    anchors.verticalCenter: parent.verticalCenter

                    Image {
                        anchors.fill: parent
                        source: "qrc:/res/CloseWhite.svg"
                    }
                    background: Rectangle {
                        color: transparent
                    }

                    onClicked: {
                        enableMediaEncryptionPage.visible = false
                    }
                }
            }
            Rectangle {
                width: parent.width
                height: 1
                color: white
            }

            Rectangle {
                width: parent.width
                height: parent.height / 1.5
                color: transparent

                Column {
                    anchors.fill: parent

                    Item {
                        width: 1
                        height: parent.height / 16
                    }

                    Text {
                        color: "#B7B6B6"
                        font.pixelSize: defaultFontSize * 2.5
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "Passwords must be 12 or more characters with a\nmix of uppercase and lowercase letters, numbers\nand symbols"
                    }

                    Item {
                        width: 1
                        height: parent.height / 16
                    }

                    TextField {
                        width: parent.width / 1.2
                        height: parent.height / 5
                        placeholderText: "Please enter the password"
                        font.pixelSize: defaultFontSize * 2
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: white
                        background: Rectangle {
                            color: transparent
                            border.color: "#B7B6B6"
                            radius: 5
                        }
                    }

                    Item {
                        width: 1
                        height: parent.height / 8
                    }

                    TextField {
                        width: parent.width / 1.2
                        height: parent.height / 5
                        placeholderText: "Please Confirm the password"
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: defaultFontSize * 2
                        color: white
                        background: Rectangle {
                            color: transparent
                            border.color: "#B7B6B6"
                            radius: 5
                        }
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: white
            }
            Rectangle{
                width: parent.width
                height: parent.height / 6
                color: transparent
                Row {
                    anchors.fill: parent

                    Button {
                        width: parent.width / 2
                        height: parent.height
                        background: Rectangle {
                            color: transparent
                        }
                        Text {
                            color: white
                            font.pixelSize: defaultFontSize * 3
                            text: "Cancel"
                            anchors.centerIn: parent
                        }
                        onClicked: {
                            enableMediaEncryptionPage.visible = false
                        }
                    }
                    Rectangle {
                        width: 1
                        height: parent.height
                        color: white
                    }
                    Button {
                        width: parent.width / 2
                        height: parent.height
                        background: Rectangle {
                            color: transparent
                        }
                        Text {
                            color: white
                            font.pixelSize: defaultFontSize * 3
                            text: "OK"
                            anchors.centerIn: parent
                        }
                    }
                }
            }
        }
    }

    // Main Page
    Column {
        anchors.fill: parent
        width: parent.width
        height: parent.height

        //Media Encryption
        ItemDelegate {
            width: parent.width
            height: hItemDelegate

            Text {
                anchors.left: parent.left
                color: white
                text: "Media Encryption"
                font.pixelSize: defaultFontSize * 3.3
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: parent.width / 24
            }

            Switch{
                id: mediaEncryptioncontrol
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: parent.width / 24
                checked: false
                indicator: Rectangle {
                    implicitWidth: defaultFontSize * 6
                    implicitHeight: defaultFontSize * 3
                    x: mediaEncryptioncontrol.width - width - mediaEncryptioncontrol.rightPadding
                    y: parent.height / 2 - height / 2
                    radius: 13
                    color: mediaEncryptioncontrol.checked ? blue : lightGray
                    border.color: white

                    Rectangle {
                        x: mediaEncryptioncontrol.checked ? parent.width - width : 0
                        width: defaultFontSize * 3
                        height: defaultFontSize * 3
                        radius: 50
                        border.color: black
                    }
                }
                onCheckedChanged: {
                    if(checked){
                        enableMediaEncryptionPage.visible = true
                    }
                    else {

                    }
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
    }
}
