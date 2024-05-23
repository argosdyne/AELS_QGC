import QtQuick 2.15
import QtQuick.Controls 2.14
import QtPositioning 5.14

Rectangle {
    id: _root
    color: '#000000'   // black

    property var rootWidth: null;
    property var rootHeight: null;

    width: rootWidth / 3.24
    height: rootHeight / 1
    Text {
        id: text1
        color: "#FFFFFF"    // white
        text: qsTr("Center Point")
        font.pixelSize: 25
        font.bold: true
        font.family: 'Arial'
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 13
        anchors.topMargin: 17  // Add margin from top of the parent if needed
    }

    Text{
        id: text2
        text: qsTr('Back')
        color: '#3D71D7'
        font.pixelSize: 20
        font.family: 'Arial'
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.rightMargin: 30
        anchors.topMargin: 17
    }

    Column {
        id: column1
        anchors.top: text1.bottom
        anchors.topMargin: 20 // Editable margin between text1 and column1
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        spacing: 5

        ItemDelegate {
            id: itemDelegate
            width: parent.width
            height: 52

            Image {
                id: name
                source: "qrc:/qmlimages/None_box.svg"
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 90
                text: 'None'
                font.pixelSize: 20
                color: "#FFFFFF"
                anchors.verticalCenter: parent.verticalCenter
                // verticalAlignment: Text.AlignVCenter
            }
        }

        ItemDelegate {
            id: itemDelegate1
            width: parent.width
            height: 52
            enabled: true
            hoverEnabled: true

            Image {
                id: name1
                source: "qrc:/qmlimages/Square.svg"
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 80
                color: "#ffffff"
                text: qsTr("Square(Without Center Point)")
                font.pixelSize: 20
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        ItemDelegate {
            id: itemDelegate2
            width: parent.width
            height: 52
            text: qsTr(" ")

            Image {
                id: name2
                source: "qrc:/qmlimages/CenterPoint_Square.svg"
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 80
                color: "#ffffff"
                text: qsTr("Square(With Center Point)")
                font.pixelSize: 20
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        ItemDelegate {
            id: itemDelegate3
            width: parent.width
            height: 52
            text: qsTr(" ")

            Image {
                id: name3
                source: "qrc:/qmlimages/Cross.svg"
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 80
                color: "#ffffff"
                text: qsTr("Cross")
                font.pixelSize: 20
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        ItemDelegate {
            id: itemDelegate4
            width: parent.width
            height: 52
            text: qsTr(" ")

            Image {
                id: name4
                source: "qrc:/qmlimages/Circle_WC.svg"
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 80
                color: "#ffffff"
                text: qsTr("Circle(Without Center Point)")
                font.pixelSize: 20
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        ItemDelegate {
            id: itemDelegate5
            width: parent.width
            height: 52
            text: qsTr(" ")

            Image {
                id: name5
                source: "qrc:/qmlimages/Circle_WithCenter.svg"
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: qsTr("Circle(With Center Point)")
                color: "#ffffff"
                font.pixelSize: 20
                anchors.left: parent.left
                anchors.leftMargin: 80
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
