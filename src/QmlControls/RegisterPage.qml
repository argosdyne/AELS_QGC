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
    id:     root
    color: defaultBackGroundColor        

    //Color Property
    property color defaultTextColor: "white"
    property color transparent: "transparent"
    property color fontColorWhite: "white"
    property color fontColorlightGray: "#a7a7a7"
    property color defaultBackGroundColor: "black"
    property color darkGray: "#3b3737"

    //Size Property
    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize

    implicitWidth: Screen.width
    implicitHeight: Screen.height


    Column {
        anchors.fill: parent

        Item {
            width: 1
            height: parent.height / 18
        }

        Row {
            width: parent.width
            height: parent.height / 24

            Item {
                width: parent.width / 1.07
                height: 1
            }

            Button {
                background:Rectangle { color: transparent }
                Image {
                    source: "qrc:/res/CloseLightgray.svg"
                }
            }
        }

        Item {
            width: 1
            height: parent.height / 33.75
        }

        Image{
            source:"qrc:/res/LoginLogo.png"
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width / 5.9
            height: parent.height / 27
        }

        Item {
            width: 1
            height: parent.height / 8
        }

        Text {
            text: "Email"
            anchors.horizontalCenter: parent.horizontalCenter
            color: fontColorlightGray
            font.pixelSize: defaultFontSize * 3
        }


        TextField {
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width / 3.9
            height: parent.height / 13.5
            font.pixelSize: defaultFontSize * 3
            color: defaultTextColor

            background: Rectangle {
                color: transparent
                border.color: transparent
                anchors.fill: parent

                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 1
                    color: fontColorlightGray
                }
            }
        }

        Item {
            width: 1
            height: parent.height / 15.4
        }


        Row {
            width: parent.width

            Item {
                height: 1
                width: parent.width / 2.14
            }

            Text {
                text: "Password"
                color: fontColorlightGray
                font.pixelSize: defaultFontSize * 3
            }

            Item {
                height: 1
                width: parent.width / 10.05
            }

            Button {
                background: Rectangle { color: transparent }
                height: parent.height
                width: defaultFontSize * 2.8
                Image {
                    source: "qrc:/res/QuestionMark.svg"
                    anchors.fill: parent
                }
            }
        }




        TextField {
            id: textField
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width / 3.9
            height: parent.height / 13.5
            font.pixelSize: defaultFontSize * 3
            color: defaultTextColor
            echoMode: TextInput.Password

            background: Rectangle {
                color: transparent
                border.color: transparent
                anchors.fill: parent

                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 1
                    color: fontColorlightGray
                }
            }
        }

        Item {
            width: 1
            height: parent.height / 21.6
        }

        Text {
            text: "Confirm Password"
            anchors.horizontalCenter: parent.horizontalCenter
            color: fontColorlightGray
            font.pixelSize: defaultFontSize * 3
        }

        TextField {
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width / 3.9
            height: parent.height / 13.5
            font.pixelSize: defaultFontSize * 3
            color: defaultTextColor
            echoMode: TextInput.Password

            background: Rectangle {
                color: transparent
                border.color: transparent
                anchors.fill: parent

                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 1
                    color: fontColorlightGray
                }
            }
        }

        Item {
            width: 1
            height: parent.height / 21.6
        }
        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width / 3.9
            height: parent.height / 13.5
            background: Rectangle { color: darkGray }

            Text {
                text: "Login"
                anchors.centerIn: parent
                color: defaultTextColor
                font.pixelSize: defaultFontSize * 3
            }
        }

        Item {
            width: 1
            height: parent.height / 21.6
        }


            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width / 4.24
                height: parent.height / 25.7
                //spacing: defaultFontSize

                Button {
                    background: Rectangle { color: transparent }
                    width: parent.width / 1.37
                    height: parent.height
                    Text{
                        text: "Already have an account"
                        anchors.centerIn: parent
                        color: defaultTextColor
                        font.pixelSize: defaultFontSize * 2
                    }
                }

                Rectangle {
                    width: 1
                    height: parent.height
                }
                Button {
                    background: Rectangle { color: transparent }
                    width: parent.width / 4.47
                    height: parent.height
                    Text {
                        text: "Login"
                        anchors.centerIn: parent
                        color: defaultTextColor
                        font.pixelSize: defaultFontSize * 2
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
        }
    }
}


