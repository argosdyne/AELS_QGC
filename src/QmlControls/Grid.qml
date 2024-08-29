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
    property string blue: '#3D71D7'
    property color lightGray: "#4a4a4a"
    property color transparent : "transparent"
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
                text: qsTr("Grid")
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
                    parentQML.gridLoader.sourceComponent = null
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
            model : mymodel

            delegate: Rectangle {
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
                        switch(index) {
                        case 0:
                            parentQML.gridImage = "qrc:/qmlimages/NoneBox.svg"
                            break;
                        case 1:
                            parentQML.gridImage = "qrc:/qmlimages/Grid.svg"
                            break;
                        case 2:
                            parentQML.gridImage = "qrc:/qmlimages/gridLine.svg"
                            break;
                        default:
                            parentQML.gridImage = "qrc:/qmlimages/NoneBox.svg"
                            break;
                        }

                    }
                }
            }
        }
    }
}
