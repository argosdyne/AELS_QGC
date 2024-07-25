import QtQuick          2.15
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
    radius: 10
    property alias btnAltitude: btnAltitude
    property alias btnSpeed: btnSpeed
    property alias btnAction: btnAction
    property alias btnLinkto: btnLinkto
    property alias btnLongLat: btnLongLat
    property alias btnTurningRadius: btnTurningRadius
    property alias btnStop: btnStop
    property alias btnExit: btnExit

    property string textColor: "white"

    property int sizeText: ScreenTools.defaultFontPointSize/16*20

    property int altitude: 60
    property int speed: 18 //km/h
    property int numAction: 0
    property string linkTo: "None"
    property int turningRadius: 0
    property string longlat: "37.-,-127.-"


            // Function to handle button clicks
    function handleButtonClick(button) { 
        // uncheck all other buttons
        for (var i = 0; i < btnLayout.children.length; i++) {
            // check is the children i type is Button or not
            if (btnLayout.children[i].hasOwnProperty("checkable") && btnLayout.children[i].checkable) {    
                if (btnLayout.children[i] !== button) {
                    btnLayout.children[i].checked = false;
                }
            }
        }
    }

    function uncheckAllButtons() {
        for (var i = 0; i < btnLayout.children.length; i++) {
            if (btnLayout.children[i].hasOwnProperty("checkable") && btnLayout.children[i].checkable) {
                btnLayout.children[i].checked = false;
            }
        }
    }

    RowLayout {
        id: btnLayout
        anchors.fill: parent
        anchors.margins: 5
        spacing: 5


        Rectangle {
            Layout.fillHeight: true
            Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*140
            color: "#393838"
            Text {
                color: "#ffffff"
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pointSize: sizeText
                text: "02\n Waypoint"
            }
        }

        Button {
            id: btnAltitude
            Layout.fillHeight: true
            Layout.preferredWidth: height
            checkable: true
            checked: false
            onClicked: handleButtonClick(this)
            background: Rectangle {
                color: !parent.checked? "transparent": "#4c6fda"
                ColumnLayout {
                    anchors.centerIn: parent
                    Text {
                        id: text1
                        color: "#fffefe"
                        text: altitude + "m"
                        font.pointSize: sizeText
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }
                    Text {
                        color: "#ffffff"
                        text: qsTr("Altitude")
                        font.pointSize: sizeText
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }
                }
            }
        }

        Button {
            id:btnSpeed
            Layout.fillHeight: true
            Layout.preferredWidth: height
            checkable: true
            checked: false
            onClicked: handleButtonClick(this)
            background: Rectangle {
                color: !parent.checked? "transparent": "#4c6fda"
                ColumnLayout {
                    anchors.centerIn: parent
                    Text {
                        color: "#fffefe"
                        text: speed + "km/h"
                        font.pointSize: sizeText
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }
                    Text {
                        color: "#ffffff"
                        text: qsTr("Speed")
                        font.pointSize: sizeText
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }
                }
            }
        }

        Button {
            id:btnAction
            Layout.fillHeight: true
            Layout.preferredWidth: height
            checkable: true
            checked: false
            onClicked: handleButtonClick(this)
            background: Rectangle {
                color: !parent.checked? "transparent": "#4c6fda"
                ColumnLayout {
                    anchors.centerIn: parent
                    Text {
                        color: "#fffefe"
                        text: numAction + " Action"
                        font.pointSize: sizeText
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }
                    Text {
                        color: "#ffffff"
                        text: qsTr("Action")
                        font.pointSize: sizeText
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }
                }
            }
        }

        Button {
            id:btnLinkto
            Layout.fillHeight: true
            Layout.preferredWidth: height
            checkable: true
            checked: false
            onClicked: handleButtonClick(this)
            background: Rectangle {
                color: !parent.checked? "transparent": "#4c6fda"
                ColumnLayout {
                    anchors.centerIn: parent
                    Text {
                        color: "#fffefe"
                        text: linkTo
                        font.pointSize: sizeText
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }
                    Text {
                        color: "#ffffff"
                        text: qsTr("Link To")
                        font.pointSize: sizeText
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }
                }
            }
        }



        Button {
            id:btnLongLat
            Layout.fillHeight: true
            Layout.preferredWidth: height*2
            checkable: true
            checked: false
            onClicked: handleButtonClick(this)
            background: Rectangle {
                color: !parent.checked? "transparent": "#4c6fda"
                ColumnLayout {
                    anchors.centerIn: parent
                    Text {
                        color: "#fffefe"
                        text: longlat
                        font.pointSize: sizeText
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }
                    Text {
                        color: "#ffffff"
                        text: qsTr("Latitude Longtitude")
                        font.pointSize: sizeText
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }
                }
            }
        }

        Button {
            id:btnTurningRadius
            Layout.fillHeight: true
            Layout.preferredWidth: height*1.5
            checkable: true
            checked: false
            onClicked: handleButtonClick(this)
            background: Rectangle {
                color: !parent.checked? "transparent": "#4c6fda"
                ColumnLayout {
                    anchors.centerIn: parent
                    Text {
                        color: "#fffefe"
                        text: turningRadius
                        font.pointSize: sizeText
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }
                    Text {
                        color: "#ffffff"
                        text: qsTr("Turning Radius")
                        font.pointSize: sizeText
                        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    }
                }
            }
        }

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            color:"transparent"
        }

        ToolSeparator {}


        Button {
            id: btnStop
            Layout.fillHeight: true
            Layout.preferredWidth: height
            onClicked: {
                uncheckAllButtons()
            }
            background: Rectangle {
                color: parent.visualFocus? "#4c6fda": "transparent"
                Image{
                    anchors.fill: parent
                    source: "/res/ales/waypoint/StopButton.svg"
                    fillMode: Image.PreserveAspectFit
                }
            }
        }

        Button {
            id: btnExit
            Layout.fillHeight: true
            Layout.preferredWidth: height
            onClicked: {
                uncheckAllButtons()
            }
            background: Rectangle {
                color: parent.visualFocus? "#4c6fda": "transparent"
                Image{
                    anchors.fill: parent
                    source: "/res/ales/waypoint/ExitButton.svg"
                    fillMode: Image.PreserveAspectFit
                }
            }
        }
        
    }
}
