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


    implicitWidth: Screen.width * 0.7
    implicitHeight: Screen.height
    property color white : "#ffffff"
    property color black : "#000000"
    property color blue : "#3D71D7"
    property color red: "red"
    property color lightGray : "#4a4a4a"
    property color transparent : "transparent"
    property int hItemDelegate: Screen.height / 15;
    property int hToolSeparator: defaultFontSize + 3;

    //Size Property
    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize


    property alias listModel : listModel
    property alias flickable : flickable

    z : 4

    Column {
        anchors.fill: parent

        Rectangle {
            id: currentWarningMessage
            width: parent.width
            height: parent.height / 13.5
            color: transparent
            Text {
                color: white
                anchors.verticalCenter: parent.verticalCenter
                text: "Current Warning Message"
                font.pixelSize: defaultFontSize * 3
                anchors.left: parent.left
                anchors.leftMargin: defaultFontSize
            }
        }

        //Flickable
        Rectangle {
            width: parent.width
            height: parent.height - currentWarningMessage.height
            color: transparent
            clip: true
            Flickable {
                id: flickable
                anchors.fill: parent
                contentWidth: parent.width
                contentHeight: listView.height

                Column{
                    width: parent.width
                    height: parent.height

                    Item {
                        width: 1
                        height: defaultFontSize * 2
                    }

                    ListModel {
                        id: listModel
                    }
                    ListView {
                        id: listView
                        width: flickable.width
                        height:  listView.contentHeight
                        model: listModel

                        delegate: Item {
                            width: listView.width
                            height: defaultFontSize * 8

                            Rectangle {
                                width: parent.width
                                height: parent.height
                                color: transparent

                                Column {
                                    anchors.fill: parent

                                    Rectangle {
                                        width: parent.width
                                        height: parent.height / 2
                                        color: transparent

                                        Image {
                                            id: modelImages
                                            anchors.left: parent.left
                                            anchors.leftMargin: defaultFontSize * 3
                                            source: images
                                            anchors.verticalCenter: parent.verticalCenter
                                            height: parent.height
                                            width: height
                                        }

                                        Text {
                                            anchors.left: modelImages.left
                                            anchors.leftMargin: defaultFontSize * 5
                                            text: titleText
                                            color: white
                                            font.pixelSize: defaultFontSize * 2
                                            anchors.verticalCenter: parent.verticalCenter
                                        }
                                    }
                                    Rectangle{
                                        width: parent.width
                                        height: parent.height / 2
                                        color: transparent
                                        Text {
                                            text: descriptionText
                                            anchors.left: parent.left
                                            color: white
                                            anchors.verticalCenter: parent.verticalCenter
                                            font.pixelSize: defaultFontSize * 2
                                            anchors.leftMargin: defaultFontSize * 3
                                        }
                                    }
                                }
                            }
                        }
                        onContentHeightChanged: {
                            flickable.contentHeight = listView.contentHeight + currentWarningMessage.height + defaultFontSize * 2
                        }
                    }
                }
            }
        }
    }


}


