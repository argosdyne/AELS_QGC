import QtQuick 2.15
import QtQuick.Controls 2.14
import QtPositioning 5.14

Rectangle {
    id: root
    color: '#000000'   // black

    property var rootWidth: null;
    property var rootHeight: null;

    width: rootWidth / 3.24
    height: rootHeight / 1
    Text {
        id: centerPointText
        color: "#FFFFFF"    // white
        text: qsTr("Center Point")
        font.pixelSize: ScreenTools.defaultFontPixelHeight * 2.5
        font.bold: true
        font.family: 'Arial'
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.leftMargin: 13
        anchors.topMargin: 17  // Add margin from top of the parent if needed
    }

    Text{
        id: backText
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
        anchors.top: centerPointText.bottom
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
                // verticalAlignment: Text.AlignVCenter
            }
        }

        ItemDelegate {
            id: itemDelegate1
            width: parent.width
            height: 52

            Image {
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
                font.pixelSize: ScreenTools.defaultFontPixelHeight * 2
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        ItemDelegate {
            id: itemDelegate2
            width: parent.width
            height: 52

            Image {
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
                font.pixelSize: ScreenTools.defaultFontPixelHeight * 2
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        ItemDelegate {
            id: itemDelegate3
            width: parent.width
            height: 52

            Image {
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
                font.pixelSize: ScreenTools.defaultFontPixelHeight * 2
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        ItemDelegate {
            id: itemDelegate4
            width: parent.width
            height: 52

            Image {
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
                font.pixelSize: ScreenTools.defaultFontPixelHeight * 2
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        ItemDelegate {
            id: itemDelegate5
            width: parent.width
            height: 52

            Image {
                source: "qrc:/qmlimages/Circle_WithCenter.svg"
                anchors.left: parent.left
                anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
            }

            Text {
                text: qsTr("Circle(With Center Point)")
                color: "#ffffff"
                font.pixelSize: ScreenTools.defaultFontPixelHeight * 2
                anchors.left: parent.left
                anchors.leftMargin: 80
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
}
