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
    property color transparent : "transparent"
    property int hItemDelegate: Screen.height / 20;

    //Size Property
    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize

    //Value
    property var parentQML: null
    property var currentCenterPointValue: null
    property alias listViewModel : mymodel
    property alias listView : listView
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
                text: qsTr("Center Point")
                font.pixelSize: ScreenTools.mediumFontPointSize * 2
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

            background: Rectangle {
                color : transparent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("back button Mouse Area Clicked")
                    parentQML.centerPointLoader.sourceComponent = null
                }
            }
        }

        ListModel{
            id: mymodel
        }

        ListView {
            id: listView
            width: parent.width
            height: parent.height
            interactive: false

            // 아이템 모델
            model: mymodel

            delegate: Rectangle{
                width: parent.width
                height: defaultFontSize * 6
                color: ListView.isCurrentItem ? lightGray : transparent

                Image {
                    id: modelImages
                    anchors.left: parent.left
                    anchors.leftMargin: defaultFontSize * 3
                    anchors.verticalCenter: parent.verticalCenter
                    source: images
                }
                Text {
                    anchors.left: modelImages.left
                    anchors.leftMargin: defaultFontSize * 9
                    text: texts
                    color: white
                    font.pixelSize: defaultFontSize * 2
                    anchors.verticalCenter: parent.verticalCenter
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        listView.currentIndex = index
                        console.log("current Select index = ", index);
                        switch(index) {
                        case 0:
                            console.log("current Select index = ", index);
                            parentQML.centerPointImage = "qrc:/qmlimages/NoneBox.svg"
                            break;
                        case 1:
                            console.log("current Select index = ", index);
                            parentQML.centerPointImage = "qrc:/qmlimages/Square.svg"
                            break;
                        case 2:
                            console.log("current Select index = ", index);
                            parentQML.centerPointImage = "qrc:/qmlimages/CenterPointWithSquare.svg"
                            break;
                        case 3:
                            console.log("current Select index = ", index);
                            parentQML.centerPointImage = "qrc:/qmlimages/Cross.svg"
                            break;
                        case 4:
                            console.log("current Select index = ", index);
                            parentQML.centerPointImage = "qrc:/qmlimages/CircleWithoutCenterPoint.svg"
                            break;
                        case 5:
                            console.log("current Select index = ", index);
                            parentQML.centerPointImage = "qrc:/qmlimages/CircleWithCenterPoint.svg"
                            break;
                        default:
                            console.log("current Select index = ", index);
                            parentQML.centerPointImage = "qrc:/qmlimages/NoneBox.svg"
                            break;
                        }
                    }
                }
            }
        }
    }
}
