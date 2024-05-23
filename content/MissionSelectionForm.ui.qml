

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick 6.5
import QtQuick.Controls 6.5
import Flydynamics2uidesigner
import QtQuick.Layouts

Rectangle {
    id: rootMission
    width: Constants.width
    height: Constants.height

    color: Constants.backgroundColor
    property alias btnHoppingPOI: btnHoppingPOI
    property alias btnPOI: btnPOI
    property alias btnCorridor: btnCorridor

    Row {
        id: rowTitle
        width: 250
        height: 50

        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.horizontalCenter: parent.horizontalCenter

        spacing: 20
        Image {
            id: imgLabel
            width: height
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter
            source: "ales_icons/waypoint/MainPage/Mission.svg"
            fillMode: Image.PreserveAspectFit
        }

        Text {
            id: txtLabel
            height: parent.height
            color: Constants.btnTextColor
            text: qsTr("Mission")
            anchors.verticalCenter: parent.verticalCenter
            verticalAlignment: Text.AlignVCenter
            font: Constants.superLargeFont
        }
    }

    ColumnLayout {
        id: colLayoutMain
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: rowTitle.bottom
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.rightMargin: 20
        anchors.leftMargin: 20
        anchors.topMargin: 50

        Text {
            id: textArea
            height: 80
            width: parent.width
            color: Constants.btnTextColor
            text: qsTr("New Mission")
            font: Constants.superLargeFont
        }

        SwipeView {
            id: swipeView
            height: 150
            Layout.fillWidth: true
            antialiasing: true
            Rectangle {
                height: 150
                width: colLayoutMain.width
                color: "#00000000"

                RowLayout {
                    id: rowPlanners
                    anchors.fill: parent
                    spacing: 20

                    BigButton {
                        id: btnCorridor
                        height: 150
                        Layout.fillWidth: true
                        backgroundColor: "#50C4ED"
                        btnLabelText: "Corridor"
                        btnImageSource: "ales_icons/waypoint/MainPage/Corridor.svg"
                    }

                    BigButton {
                        id: btnPOI
                        height: 150
                        Layout.fillWidth: true
                        btnLabelText: "POI"
                        btnImageSource: "ales_icons/waypoint/MainPage/POI.svg"
                        backgroundColor: "#387ADF"
                    }

                    BigButton {
                        id: btnHoppingPOI
                        height: 150
                        Layout.fillWidth: true
                        btnLabelText: "Hopping POI"
                        btnImageSource: "ales_icons/waypoint/MainPage/HoppingPOI.svg"
                        backgroundColor: "#333A73"
                    }
                }
            }
        }

        Row {
            id: missionTool
            height: 100
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            width: parent.width
            layoutDirection: Qt.RightToLeft

            Button {
                id: btnFullMission
                height: 100
                icon.height: height
                icon.width: height
                icon.color: "white"
                width: 100
                display: AbstractButton.IconOnly
                background: Rectangle {
                    color: "black"
                }
                icon.source: "ales_icons/waypoint/MainPage/entire.png"
            }

            Button {
                id: btnOpenFile
                height: 100
                icon.height: height
                icon.width: height
                icon.color: "white"
                width: 100
                display: AbstractButton.IconOnly
                background: Rectangle {
                    color: "black"
                }
                icon.source: "ales_icons/waypoint/MainPage/openafolder.png"
            }

            Button {
                id: btnSearch
                height: 100
                icon.height: height
                icon.width: height
                icon.color: "white"
                width: 100
                display: AbstractButton.IconOnly
                background: Rectangle {
                    color: "black"
                }
                icon.source: "ales_icons/waypoint/MainPage/Search.png"
            }
        }
        Text {
            id: txtMissionHistory
            height: 80
            width: parent.width
            color: Constants.btnTextColor
            text: qsTr("Mission History")
            font: Constants.superLargeFont
        }

        ScrollView {
            id: scvHistory
            height: 400
            width: parent.width
            Layout.fillHeight: true
        }
    }
}
