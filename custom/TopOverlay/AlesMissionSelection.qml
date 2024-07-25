import QtQuick          2.3
import QtQuick.Controls 2.15
import QtQuick.Dialogs  1.2
import QtLocation       5.3
import QtPositioning    5.3
import QtQuick.Layouts  1.2
import QtQuick.Window   2.2

import QGroundControl.ScreenTools       1.0
import QGroundControl.Palette           1.0
import QtQuick.Controls.Material 2.12


Rectangle {
    id: rootMission
    implicitHeight: Screen.height
    implicitWidth: Screen.width
    color: "black"
    property color txtColor: "white"
    property alias btnHoppingPOI: btnHoppingPOI
    property alias btnPOI: btnPOI
    property alias btnCorridor: btnCorridor
    property alias btnWaypoint: btnWaypoint
    property alias btnRectangular: btnRectangular
    property alias btnPolygon: btnPolygon
    Row {
        id: rowTitle
        width: ScreenTools.defaultFontPixelHeight/16*250
        height: ScreenTools.defaultFontPixelHeight/16*50
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 20

        Image {
            id: imgLabel
            width: height
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/ales/login/Mission.svg"
            fillMode: Image.PreserveAspectFit
        }

        Text {
            id: txtLabel
            height: parent.height
            color: txtColor
            text: qsTr("Mission")
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: ScreenTools.defaultFontPixelHeight *2
        }
    }

    ColumnLayout {
        id: colLayoutMain
        anchors.fill: parent
        anchors.topMargin: 70
        anchors.leftMargin: 20
        anchors.rightMargin:  20
        anchors.bottomMargin: 20
        spacing: 10

        Text {
            id: textArea
            Layout.preferredHeight: ScreenTools.defaultFontPixelHeight/16*50
            Layout.fillWidth: true
            color: txtColor
            text: qsTr("New Mission")
            font.pixelSize: ScreenTools.defaultFontPixelHeight *2
        }

        SwipeView {
            id: swipeView
            Layout.preferredHeight: ScreenTools.defaultFontPixelHeight/16*100
            Layout.fillWidth: true
            clip: true

            // First Page

            Rectangle {
                color: "transparent"

                RowLayout {
                    id: rowPlanners
                    anchors.fill: parent
                    spacing: 40

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        color: "#9AD0C2"
                        radius: 10
                        MouseArea{
                            id:btnWaypoint
                            anchors.fill: parent
                        }

                        Image {
                            height: parent.height * 0.3
                            width: parent.height * 0.3
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.margins: 15
                            source: "qrc:/res/ales/mission/WayPoint.svg"
                            fillMode: Image.PreserveAspectFit
                        }

                        Text {
                            height: parent.height / 3
                            width: parent.width - 20
                            anchors.left: parent.left
                            anchors.bottom: parent.bottom
                            anchors.margins: 15
                            color: "white"
                            font.pixelSize: ScreenTools.defaultFontPixelHeight*2
                            text: qsTr("Waypoint")
                        }
                    }

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        color: "#2D9596"
                        radius: 10
                        MouseArea{
                            id:btnRectangular
                            anchors.fill: parent
                        }

                        Image {
                            height: parent.height * 0.3
                            width: parent.height * 0.3
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.margins: 15
                            source: "qrc:/res/ales/mission/Rectangular.svg"
                            fillMode: Image.PreserveAspectFit
                        }

                        Text {
                            height: parent.height / 3
                            width: parent.width - 20
                            anchors.left: parent.left
                            anchors.bottom: parent.bottom
                            anchors.margins: 15
                            color: "white"
                            font.pixelSize: ScreenTools.defaultFontPixelHeight*2
                            text: qsTr("Rectangular")
                        }
                    }

                    Rectangle {
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        color: "#265073"
                        radius: 10
                        MouseArea{
                            id:btnPolygon
                            anchors.fill: parent
                        }

                        Image {
                            height: parent.height * 0.3
                            width: parent.height * 0.3
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.margins: 15
                            source: "qrc:/res/ales/mission/Polygon.svg"
                            fillMode: Image.PreserveAspectFit
                        }

                        Text {
                            height: parent.height / 3
                            width: parent.width - 20
                            anchors.left: parent.left
                            anchors.bottom: parent.bottom
                            anchors.margins: 15
                            color: "white"
                            font.pixelSize: ScreenTools.defaultFontPixelHeight*2
                            text: qsTr("Polygon")
                        }
                    }
                }
            }

            // Second Page

            Rectangle {
                color: "transparent"

                RowLayout {
                    anchors.fill: parent
                    spacing: 40


                    Rectangle {
                        color: "#50C4ED"
                        radius: 10
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        MouseArea{
                            id:btnCorridor
                            anchors.fill: parent
                        }

                        Image {
                            height: parent.height * 0.3
                            width: parent.height * 0.3
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.margins: 15
                            source: "qrc:/res/ales/mission/Corridor.svg"
                            fillMode: Image.PreserveAspectFit
                        }

                        Text {
                            height: parent.height / 3
                            width: parent.width - 20
                            anchors.left: parent.left
                            anchors.bottom: parent.bottom
                            anchors.margins: 15
                            color: "white"
                            font.pixelSize: ScreenTools.defaultFontPixelHeight*2
                            text: qsTr("Corridor")
                        }
                    }

                    Rectangle {
                        id: btnPOI
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        color: "#387ADF"
                        radius: 10
                        Image {
                            height: parent.height * 0.3
                            width: parent.height * 0.3
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.margins: 15
                            source: "qrc:/res/ales/mission/POI.svg"
                            fillMode: Image.PreserveAspectFit
                        }

                        Text {
                            height: parent.height / 3
                            width: parent.width - 20
                            anchors.left: parent.left
                            anchors.bottom: parent.bottom
                            anchors.margins: 15
                            color: "white"
                            font.pixelSize: ScreenTools.defaultFontPixelHeight*2
                            text: qsTr("POI")
                        }
                    }

                    Rectangle {
                        id: btnHoppingPOI
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        color: "#333A73"
                        radius: 10
                        Image {
                            height: parent.height * 0.3
                            width: parent.height * 0.3
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.margins: 15
                            source: "qrc:/res/ales/mission/HoppingPOI.svg"
                            fillMode: Image.PreserveAspectFit
                        }

                        Text {
                            height: parent.height / 3
                            width: parent.width - 20
                            anchors.left: parent.left
                            anchors.bottom: parent.bottom
                            anchors.margins: 15
                            color: "white"
                            font.pixelSize: ScreenTools.defaultFontPixelHeight*2
                            text: qsTr("Hopping POI")
                        }
                    }

                }
            }
        }

        Rectangle {
            Layout.preferredHeight: ScreenTools.defaultFontPixelHeight/16*60
            Layout.fillWidth: true
            color: "transparent"
            RowLayout {
                id: missionTool
                anchors.fill: parent
                spacing: 10
                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    color: "transparent"
                }

                Button {
                    id: btnFullMission
                    Layout.fillHeight: true
                    Layout.preferredWidth: height
                    icon.color: "white"
                    display: AbstractButton.IconOnly
                    background: Rectangle {
                        color: "black"
                    }
                    icon.source: "qrc:/ales/missionselection/Entire.svg"
                }

                Button {
                    id: btnOpenFile
                    Layout.fillHeight: true
                    Layout.preferredWidth: height
                    icon.color: "white"
                    display: AbstractButton.IconOnly
                    background: Rectangle {
                        color: "black"
                    }
                    icon.source: "qrc:/ales/missionselection/OpenFolder.svg"
                }

                Button {
                    id: btnSearch
                    Layout.fillHeight: true
                    Layout.preferredWidth: height
                    icon.color: "white"
                    display: AbstractButton.IconOnly
                    background: Rectangle {
                        color: "black"
                    }
                    icon.source: "qrc:/ales/missionselection/Search.svg"
                }

            }
        }

        Text {
            id: txtMissionHistory
            Layout.preferredHeight:ScreenTools.defaultFontPixelHeight/16*60
            Layout.fillWidth: true
            color: txtColor
            text: qsTr("Mission History")
            font.pixelSize: ScreenTools.defaultFontPixelHeight *2
        }

        ScrollView {
            id: scvHistory
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
