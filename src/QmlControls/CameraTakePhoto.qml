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


    Column {
        anchors.fill: parent

        Button {
            width: parent.width / 1.45
            height: width
            anchors.horizontalCenter: parent.horizontalCenter

            background:Rectangle { color: transparent }

            Image {
                anchors.fill: parent
                source: "qrc:/res/GalleryButton.svg"
            }
        }

        Item {
            width: 1
            height: parent.height / 6.4
        }

        Button {
            width: parent.width
            height: width
            anchors.horizontalCenter: parent.horizontalCenter

            background: Rectangle { color: transparent }

            Image {
                anchors.fill: parent
                source: "qrc:/res/PhotoShoot.svg"
            }
        }

        Item {
            width: 1
            height: parent.height / 6.4
        }

        Button {
            width: parent.width / 1.45
            height: width
            anchors.horizontalCenter: parent.horizontalCenter

            background: Rectangle { color: transparent }

            Image {
                anchors.fill: parent
                source: "qrc:/res/ShootRecordSwitch.svg"
            }
        }

    }
}


