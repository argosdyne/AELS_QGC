import QtQuick 2.15
import QtQuick.Controls 2.14
import QtPositioning 5.14

Rectangle {
    width: parent ? parent.width * 0.3 : 590
    height: parent ? parent.height * 0.99 : 1070
    color: '#000000'   // blacks
    anchors.right: parent ? parent.right : undefined

    Text {
        id: text1
        color: "#FFFFFF"    // white
        text: qsTr("Grid")
        font.pixelSize: 25
        font.bold: true
        font.family: 'Arial'
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 12
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
                source: "qrc:/qmlimages/Grid.svg"
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 80
                color: "#ffffff"
                text: qsTr("Grid")
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
                source: "qrc:/qmlimages/grid+line.svg"
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 80
                color: "#ffffff"
                text: qsTr("Grid + Line")
                font.pixelSize: 20
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
