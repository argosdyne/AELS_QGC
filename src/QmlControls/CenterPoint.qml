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
    property int hItemDelegate: Screen.height / 20;

    //Size Property
    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize

    Text {
        id: centerPointText
        color: white
        text: qsTr("Center Point")
        font.pixelSize: ScreenTools.mediumFontPointSize * 2.5
        font.bold: true
        font.family: 'Arial'
        anchors.left: parent.left
        anchors.leftMargin: 13
        anchors.top: root.top
        anchors.topMargin: 20
    }

    Text {
        id: backText
        text: qsTr('Back')
        color: blue
        font.pixelSize: ScreenTools.mediumFontPointSize * 2
        font.family: 'Arial'
        anchors.right: parent.right
        anchors.rightMargin: 30
        anchors.top: root.top
        anchors.topMargin: 20
    }

    Flickable {
        id: flickable
        anchors {
            top: centerPointText.bottom
            topMargin: 20
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        contentWidth: parent.width
        contentHeight: column.height


        Column {
            id: column
            width: flickable.width
            spacing: 5

            ItemDelegate {
                width: parent.width
                height: hItemDelegate

                Image {
                    source: "qrc:/qmlimages/NoneBox.svg"
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 90
                    text: 'None'
                    font.pixelSize: ScreenTools.mediumFontPointSize * 2
                    color: white
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            ItemDelegate {
                width: parent.width
                height: hItemDelegate

                Image {
                    source: "qrc:/qmlimages/Square.svg"
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 80
                    color: white
                    text: qsTr("Square(Without Center Point)")
                    font.pixelSize: ScreenTools.mediumFontPointSize * 2
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            ItemDelegate {
                width: parent.width
                height: hItemDelegate

                Image {
                    source: "qrc:/qmlimages/CenterPointWithSquare.svg"
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 80
                    color: white
                    text: qsTr("Square(With Center Point)")
                    font.pixelSize: ScreenTools.mediumFontPointSize * 2
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            ItemDelegate {
                width: parent.width
                height: hItemDelegate

                Image {
                    source: "qrc:/qmlimages/Cross.svg"
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 80
                    color: white
                    text: qsTr("Cross")
                    font.pixelSize: ScreenTools.mediumFontPointSize * 2
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            ItemDelegate {
                width: parent.width
                height: hItemDelegate

                Image {
                    source: "qrc:/qmlimages/CircleWithoutCenterPoint.svg"
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: 80
                    color: white
                    text: qsTr("Circle(Without Center Point)")
                    font.pixelSize: ScreenTools.mediumFontPointSize * 2
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            ItemDelegate {
                width: parent.width
                height: hItemDelegate

                Image {
                    source: "qrc:/qmlimages/CircleWithCenterPoint.svg"
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: qsTr("Circle(With Center Point)")
                    color: white
                    font.pixelSize: ScreenTools.mediumFontPointSize * 2
                    anchors.left: parent.left
                    anchors.leftMargin: 80
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
        }
    }
}
