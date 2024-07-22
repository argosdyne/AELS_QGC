import QtQuick          2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts  1.11
import QtQuick.Dialogs  1.3
import QtQuick.Window 2.0

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.Palette               1.0
import QGroundControl.ScreenTools           1.0

Rectangle {
    id: root
    height: 80
    width: 1000
    visible: true
    color: "#5c5c5c"
    property string textColor: "white"

    property int altitude: 60
    property int speed: 18 //km/h
    property int numAction: 0
    property string linkTo: "None"
    property int turningRadius: 0
    property string longlat: "37.-,-127.-"

    ButtonGroup{
        buttons: btnLayout.children
    }

    RowLayout {
        id: btnLayout
        anchors.fill: parent
        spacing: 5


        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*130
            color: "#393838"
            Text {
                color: "#ffffff"
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: ScreenTools.defaultFontPointSize/16*15
                text: "02\n Waypoint"
            }
        }

        Button {
            Layout.fillHeight: true
            Layout.preferredWidth: 100
            checkable: true
            checked: false
            background: Rectangle {
                color: !parent.checked? "transparent": "#4c6fda"
                ColumnLayout {
                    anchors.centerIn: parent
                    Text {
                        id: text1
                        color: "#fffefe"
                        text: altitude + "m"
                        font.pointSize: ScreenTools.defaultFontPointSize/16*15
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }
                    Text {
                        color: "#ffffff"
                        text: qsTr("Altitude")
                        font.pointSize: ScreenTools.defaultFontPointSize/16*10
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }
                }
            }
        }

        Button {
            Layout.fillHeight: true
            Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
            checkable: true
            checked: false
            background: Rectangle {
                color: !parent.checked? "transparent": "#4c6fda"
                ColumnLayout {
                    anchors.centerIn: parent
                    Text {
                        color: "#fffefe"
                        text: speed + "km/h"
                        font.pointSize: ScreenTools.defaultFontPointSize/16*15
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }
                    Text {
                        color: "#ffffff"
                        text: qsTr("Speed")
                        font.pointSize: ScreenTools.defaultFontPointSize/16*10
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }
                }
            }
        }

        Button {
            Layout.fillHeight: true
            Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
            checkable: true
            checked: false
            background: Rectangle {
                color: !parent.checked? "transparent": "#4c6fda"
                ColumnLayout {
                    anchors.centerIn: parent
                    Text {
                        color: "#fffefe"
                        text: numAction + "Action"
                        font.pointSize: ScreenTools.defaultFontPointSize/16*15
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }
                    Text {
                        color: "#ffffff"
                        text: qsTr("Action")
                        font.pointSize: 10
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }
                }
            }
        }

        Button {
            Layout.fillHeight: true
            Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
            checkable: true
            checked: false
            background: Rectangle {
                color: !parent.checked? "transparent": "#4c6fda"
                ColumnLayout {
                    anchors.centerIn: parent
                    Text {
                        color: "#fffefe"
                        text: linkTo
                        font.pointSize: ScreenTools.defaultFontPointSize/16*15
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }
                    Text {
                        color: "#ffffff"
                        text: qsTr("Link To")
                        font.pointSize: ScreenTools.defaultFontPointSize/16*10
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }
                }
            }
        }



        Button {
            Layout.fillHeight: true
            Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
            checkable: true
            checked: false
            background: Rectangle {
                color: !parent.checked? "transparent": "#4c6fda"
                ColumnLayout {
                    anchors.centerIn: parent
                    Text {
                        color: "#fffefe"
                        text: longlat
                        font.pointSize: ScreenTools.defaultFontPointSize/16*15
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }
                    Text {
                        color: "#ffffff"
                        text: qsTr("Latitude Longtitude")
                        font.pointSize: ScreenTools.defaultFontPointSize/16*10
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }
                }
            }
        }

        Button {
            Layout.fillHeight: true
            Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
            checkable: true
            checked: false
            background: Rectangle {
                color: !parent.checked? "transparent": "#4c6fda"
                ColumnLayout {
                    anchors.centerIn: parent
                    Text {
                        color: "#fffefe"
                        text: turningRadius
                        font.pointSize: ScreenTools.defaultFontPointSize/16*15
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }
                    Text {
                        color: "#ffffff"
                        text: qsTr("Turning Radius")
                        font.pointSize: ScreenTools.defaultFontPointSize/16*10
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }
                }
            }
        }

        ToolSeparator {}

        ToolButton {
            id: btnStop
            visible: true
            icon.height: ScreenTools.defaultFontPointSize/16*70
            icon.width: ScreenTools.defaultFontPointSize/16*70
            Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*80
            Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*80
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            display: AbstractButton.IconOnly
            font.pointSize: ScreenTools.defaultFontPointSize/16*20
            icon.color: "#00000000"
            icon.source: "qrc://res/ales/waypoint/StopButton.svg"
            Material.foreground: textColor
        }

        ToolButton {
            id: btnExit
            visible: true
            icon.height: ScreenTools.defaultFontPointSize/16*70
            icon.width: ScreenTools.defaultFontPointSize/16*70
            Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*80
            Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*80
            Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
            display: AbstractButton.IconOnly
            font.pointSize: ScreenTools.defaultFontPointSize/16*20
            icon.color: "#00000000"
            icon.source: "qrc://res/ales/waypoint/ExitButton.svg"
            Material.foreground: textColor
        }
    }
}