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
    property color lightGray: "#4a4a4a"
    property color transparent: "transparent"

    property int hItemDelegate: Screen.height / 20;

    //Size Property
    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize

    //Value
    property var parentQML: null
    property alias listViewModel: mymodel
    property alias listView: listView
    z: 4

    Column {
        anchors.fill: parent
        height: defaultFontSize * 10

        ItemDelegate {
            width: parent.width
            height: defaultFontSize * 10

            Text {
                anchors.left: parent.left
                anchors.leftMargin: defaultFontSize * 2
                color: white
                text: qsTr("Video Encoding Format")
                font.pixelSize: defaultFontSize * 2
                anchors.verticalCenter: parent.verticalCenter
            }
            Text {
                anchors.right: parent.right
                color: blue
                text: qsTr("Back")
                font.pixelSize: defaultFontSize * 2
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: defaultFontSize * 2
            }
            background: Rectangle { color: transparent }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    parentQML.videoEncodingLoader.sourceComponent = null
                }
            }
        }

        ListModel {
            id: mymodel
        }

        ListView {
            id: listView
            width: parent.width
            height: parent.height
            interactive: false

            //Item Model
            model: mymodel

            delegate: Rectangle {
                width: parent.width
                height: defaultFontSize * 6
                color: ListView.isCurrentItem ? lightGray : transparent

                Text {
                    text: texts
                    anchors.centerIn: parent
                    font.pixelSize: defaultFontSize * 2
                    color: white
                }

               MouseArea {
                   anchors.fill: parent
                   onClicked: {
                       listView.currentIndex = index
                       switch(index) {
                       case 0:
                           parentQML.videoEncodingText = "H.264"
                           break;
                       case 1:
                           parentQML.videoEncodingText = "H.265"
                           break;
                       default:
                           parentQML.videoEncodingText = "H.264"
                           break;
                       }
                   }
               }

            }
        }
    }
}
