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
        anchors.margins: 20
        anchors.topMargin: 70

        Text {
            id: textArea
            height: ScreenTools.defaultFontPixelHeight/16*80
            width: parent.width
            color: txtColor
            text: qsTr("New Mission")
            font.pixelSize: ScreenTools.defaultFontPixelHeight *2
        }

        SwipeView {
            id: swipeView
            height: ScreenTools.defaultFontPixelHeight/16*150
            Layout.fillWidth: true
            antialiasing: true

            Rectangle {
                height: ScreenTools.defaultFontPixelHeight/16*150
                width: colLayoutMain.width
                color: "#00000000"

                RowLayout {
                    id: rowPlanners
                    anchors.fill: parent
                    spacing: 20


                    Rectangle {
                        Layout.preferredHeight: ScreenTools.defaultFontPixelHeight/16*150
                        Layout.preferredWidth: ScreenTools.defaultFontPixelHeight/16*200
                        Layout.fillWidth: true
                        color: "#50C4ED"
                        radius: 10
                        MouseArea{
                            id:btnCorridor
                            anchors.fill: parent
                        }

                        Image {
                            height: parent.height * 0.3
                            width: parent.height * 0.3
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.margins: 10
                            source: "qrc:/ales/missionselection/Corridor.svg"
                            fillMode: Image.PreserveAspectFit
                        }

                        Text {
                            height: parent.height / 3
                            width: parent.width - 20
                            anchors.left: parent.left
                            anchors.bottom: parent.bottom
                            anchors.margins: 10
                            color: "white"
                            font.pixelSize: ScreenTools.defaultFontPixelHeight*2.4
                            text: qsTr("Corridor")
                        }
                    }

                    Rectangle {
                        id: btnPOI
                        Layout.preferredHeight: ScreenTools.defaultFontPixelHeight/16*150
                        Layout.preferredWidth: ScreenTools.defaultFontPixelHeight/16*200

                        Layout.fillWidth: true
                        color: "#387ADF"
                        radius: 10
                        Image {
                            height: parent.height * 0.3
                            width: parent.height * 0.3
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.margins: 10
                            source: "qrc:/ales/missionselection/POI.svg"
                            fillMode: Image.PreserveAspectFit
                        }

                        Text {
                            height: parent.height / 3
                            width: parent.width - 20
                            anchors.left: parent.left
                            anchors.bottom: parent.bottom
                            anchors.margins: 10
                            color: "white"
                            font.pixelSize: ScreenTools.defaultFontPixelHeight*2.4
                            text: qsTr("POI")
                        }
                    }

                    Rectangle {
                        id: btnHoppingPOI
                        Layout.preferredHeight: ScreenTools.defaultFontPixelHeight/16*150
                        Layout.preferredWidth: ScreenTools.defaultFontPixelHeight/16*200
                        Layout.fillWidth: true
                        color: "#333A73"
                        radius: 10
                        Image {
                            height: parent.height * 0.3
                            width: parent.height * 0.3
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.margins: 10
                            source: "qrc:/ales/missionselection/HoppingPOI.svg"
                            fillMode: Image.PreserveAspectFit
                        }

                        Text {
                            height: parent.height / 3
                            width: parent.width - 20
                            anchors.left: parent.left
                            anchors.bottom: parent.bottom
                            anchors.margins: 10
                            color: "white"
                            font.pixelSize: ScreenTools.defaultFontPixelHeight*2.4
                            text: qsTr("Hopping POI")
                        }
                    }

                }
            }
        }

        Row {
            id: missionTool
            height: ScreenTools.defaultFontPixelHeight/16*80
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            width: parent.width
            layoutDirection: Qt.RightToLeft

            Button {
                id: btnFullMission
                Layout.preferredHeight:ScreenTools.defaultFontPixelHeight/16*80
                Layout.preferredWidth: ScreenTools.defaultFontPixelHeight/16*80
                icon.height: ScreenTools.defaultFontPixelHeight/16*80
                icon.width: ScreenTools.defaultFontPixelHeight/16*80
                icon.color: "white"
                display: AbstractButton.IconOnly
                background: Rectangle {
                    color: "black"
                }
                icon.source: "qrc:/ales/missionselection/Entire.svg"
            }

            Button {
                id: btnOpenFile
                Layout.preferredHeight:ScreenTools.defaultFontPixelHeight/16*80
                Layout.preferredWidth: ScreenTools.defaultFontPixelHeight/16*80
                icon.height: ScreenTools.defaultFontPixelHeight/16*80
                icon.width: ScreenTools.defaultFontPixelHeight/16*80
                icon.color: "white"
                display: AbstractButton.IconOnly
                background: Rectangle {
                    color: "black"
                }
                icon.source: "qrc:/ales/missionselection/OpenFolder.svg"
            }

            Button {
                id: btnSearch
                Layout.preferredHeight:ScreenTools.defaultFontPixelHeight/16*80
                Layout.preferredWidth: ScreenTools.defaultFontPixelHeight/16*80
                icon.height: ScreenTools.defaultFontPixelHeight/16*80
                icon.width: ScreenTools.defaultFontPixelHeight/16*80
                icon.color: "white"
                display: AbstractButton.IconOnly
                background: Rectangle {
                    color: "black"
                }
                icon.source: "qrc:/ales/missionselection/Search.svg"
            }
        }

        Text {
            id: txtMissionHistory
            Layout.preferredHeight:ScreenTools.defaultFontPixelHeight/16*80
            Layout.preferredWidth: parent.width
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
