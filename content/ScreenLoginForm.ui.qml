

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
    id: rectangle
    width: 1920
    height: 1080
    color: Constants.backgroundColor
    property alias mouseLogo: mouseLogo
    property alias btnLogin: btnLogin
    property alias btnMission: btnMission
    property alias btnCamera: btnCamera
    property alias comboBox: comboBox

    Rectangle {
        id: recLogo
        width: 150
        height: 150
        color: "black"
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 10
        anchors.topMargin: 10

        Image {
            id: imgLogo
            anchors.fill: parent
            source: "ales_icons/FirstPage/main_logo_v1.png"
            antialiasing: true
            cache: false
            fillMode: Image.PreserveAspectFit
        }

        MouseArea {
            id: mouseLogo
            anchors.fill: parent
        }
    }

    RoundButton {
        id: btnLogin
        width: 150
        height: 150
        text: ""
        anchors.right: parent.right
        anchors.top: parent.top
        icon.height: 80
        icon.width: 80
        icon.source: "ales_icons/waypoint/MainPage/User.svg"
        anchors.rightMargin: 10
        anchors.topMargin: 10
    }

    RowLayout {
        id: btnRow
        width: 500
        height: 100
        spacing: 100
        anchors.verticalCenter: parent.verticalCenter
        anchors.bottomMargin: 100
        anchors.horizontalCenter: parent.horizontalCenter

        ImageButton {
            id: btnCamera
            Layout.preferredHeight: btnRow.height
            Layout.preferredWidth: btnRow.height * 2
            btnLabelText: "Camera"
            btnImageSource: "ales_icons/waypoint/MainPage/Camera.svg"
        }
        ImageButton {
            id: btnMission
            Layout.preferredHeight: btnRow.height
            Layout.preferredWidth: btnRow.height * 2
            btnLabelText: "Mission"
            btnImageSource: "ales_icons/waypoint/MainPage/Mission.svg"
        }
    }

    ComboBox {
        id: comboBox
        width: 365
        height: 94
        anchors.top: parent.top
        model: ["AQUILA 2", "AQUILA 3F", "HUMMER"]
        font: Constants.superLargeFont
        anchors.topMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter
        popup.Material.foreground: "gray"
        Material.accent: Constants.backgroundColor
        Material.foreground: "white"
    }

    RowLayout {
        width: 200
        height: 40
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
        anchors.rightMargin: 20
        spacing: 10

        Image {
            Layout.preferredWidth: parent.height
            Layout.fillHeight: true
            horizontalAlignment: Image.AlignHCenter
            verticalAlignment: Image.AlignVCenter
            source: "ales_icons/FirstPage/link.svg"
            fillMode: Image.Stretch
            sourceSize.height: parent.height
            sourceSize.width: parent.height
        }
        Label {
            color: "#ddffffff"
            Layout.fillHeight: true
            Layout.fillWidth: true
            font: Constants.largeFont
            text: "How to Connect"
            verticalAlignment: Text.AlignVCenter
        }
    }
}
