import QtQuick          2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts  1.11
import QtQuick.Dialogs  1.3
import QtQuick.Window 2.0
import QtQuick.Controls.Styles 1.4

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.Palette               1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Controllers           1.0
import QtGraphicalEffects                   1.12

Rectangle {
    id:     root
    color: transparent    

    //Color Property
    property color defaultTextColor: "white"
    property color defaultBackGroundColor: "black"
    property color transparent: "transparent"
    property color blue: "#3d71d7"

    //Size Property
    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize

    implicitWidth: Screen.width / 15.5
    implicitHeight: Screen.height / 2.5
    property var parentQML: null

    property bool isRecord: false

    Column {
        anchors.fill: parent

        Button {
            width: parent.width / 1.5
            height: width
            anchors.horizontalCenter: parent.horizontalCenter

            background:Rectangle { color: transparent }

            Image {
                anchors.fill: parent
                source:(isRecord) ? "qrc:/res/PhotoShoot.svg" : "qrc:/res/GalleryButton.svg"
            }
            onClicked: {
            }
        }

        Item {
            width: 1
            height: parent.height / 10
        }

        Button {
            width: parent.width
            height: width
            anchors.horizontalCenter: parent.horizontalCenter

            background: Rectangle { color: transparent }

            Image {
                anchors.fill: parent
                source:(isRecord) ? "qrc:/res/Recording.svg" : "qrc:/res/Record.svg"
            }
            onClicked: {
                if(isRecord){
                    isRecord = false
                }
                else {
                    isRecord = true
                }
            }
        }

        Item {
            width: 1
            height: parent.height / 7.5
        }

        Row {
            visible : isRecord
            width: parent.width - defaultFontSize
            height: parent.height / 10.24
            spacing: parent.width / 6.2
            anchors.horizontalCenter: parent.horizontalCenter
            Image {
                anchors.bottom: parent.bottom
                source: "qrc:/res/RecordingTime.svg"
            }

            Text {
                anchors.bottom: parent.bottom

                font.pixelSize: defaultFontSize * 2
                color: defaultTextColor
                text: "00:04"
            }
        }

        Row {
            visible : isRecord
            width: parent.width - defaultFontSize
            height: parent.height / 10.24
            spacing: parent.width / 6.2
            anchors.horizontalCenter: parent.horizontalCenter
            Image {
                anchors.bottom: parent.bottom
                source: "qrc:/res/SdCard.svg"
            }

            Text {
                font.pixelSize: defaultFontSize * 2
                color: defaultTextColor
                text: "638:24"
                anchors.bottom: parent.bottom
            }
        }
        Button {
            visible: !isRecord
            width: parent.width / 1.45
            height: width
            anchors.horizontalCenter: parent.horizontalCenter

            background: Rectangle { color: transparent }

            Image {
                anchors.fill: parent
                source: "qrc:/res/ShootSwitch.svg"
            }

            onClicked: {
                root.visible = !parentQML.isPhotoPage
                parentQML.isPhotoPage = true
            }
        }
    }
}


