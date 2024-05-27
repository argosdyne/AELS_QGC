import QtQuick 2.15
import QtQuick.Controls 2.14
import QtPositioning 5.14

Rectangle {
    id: root
    color: '#000000'   // blacks
    property var rootWidth: null;
    property var rootHeight: null;

    width: rootWidth / 3.24
    height: rootHeight / 1

    Text {
        id: gridText
        color: "#FFFFFF"    // white
        text: qsTr("Grid")
        //font.pixelSize: 25
        font.pixelSize: ScreenTools.defaultFontPixelHeight * 2.5
        font.bold: true
        font.family: 'Arial'
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 12
        anchors.topMargin: 17  // Add margin from top of the parent if needed
    }

    Text{
        id: backtext
        text: qsTr('Back')
        color: '#3D71D7'
        font.pixelSize: ScreenTools.defaultFontPixelHeight * 2
        font.family: 'Arial'
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.rightMargin: 30
        anchors.topMargin: 17
    }

    Column {
        id: column1
        anchors.top: gridText.bottom
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
                source: "qrc:/qmlimages/None_box.svg"
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                anchors.left: parent.left
                anchors.leftMargin: 90
                text: 'None'
                font.pixelSize: ScreenTools.defaultFontPixelHeight * 2
                color: "#FFFFFF"
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        ItemDelegate {
            id: itemDelegate1
            width: parent.width
            height: 52

            Image {
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
                font.pixelSize: ScreenTools.defaultFontPixelHeight * 2
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        ItemDelegate {
            id: itemDelegate2
            width: parent.width
            height: 52

            Image {
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
                font.pixelSize: ScreenTools.defaultFontPixelHeight * 2
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
