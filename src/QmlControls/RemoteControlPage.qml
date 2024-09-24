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

    property string white: '#ffffff'
    property string black: '#1f1f1f'
    property string blue: '#3D71D7'
    property color lightGray: "#4a4a4a"
    property color transparent: "transparent"
    property int hItemDelegate: Screen.height / 9;
    property int hSwitchDelegate: Screen.height / 15;
    property int hToolSeparator: defaultFontSize + 3;
    property int leftMargin: 20;

    //Size Property
    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize
    z: 3
    property var parentQML : null


    //Remote Control Calibration Page
    Rectangle {
        id: remoteControlCalibrationPage
        anchors.fill: parent
        z: 4
        color: black
        visible: false
        MouseArea {
            anchors.fill: parent
        }
        Button {
            background: Rectangle {
                color: blue
                radius: 5
            }
            width: parent.width / 3.6
            height: parent.height / 9
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.width / 7.2

            Text {
                color: white
                text: "Start Calibration"
                font.pixelSize: defaultFontSize * 4
                anchors.centerIn: parent
            }

            onClicked: {
                startCalibrationPage.visible = true
                parentQML.currentPageIndex = 2
                parentQML.page2 = startCalibrationPage
                parentQML.previousTitle = parentQML.settingTitle
            }
        }

        Column {
            anchors.centerIn: parent
            spacing: defaultFontSize
            Row {
                spacing: 5

                Text {
                    text: "With the remote control powered off, long press"
                    color: white
                    font.pixelSize: defaultFontSize * 3
                }

                Image {
                    source: "qrc:/res/StartButton.svg"  // 첫 번째 아이콘 이미지 경로
                    width: parent.width / 24
                    height: parent.width / 36
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    text: "and"
                    color: white
                    font.pixelSize: defaultFontSize * 3
                }

                Image {
                    source: "qrc:/res/SimultaneouslyButton.svg"  // 두 번째 아이콘 이미지 경로
                    width: parent.width / 24
                    height: width
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            Text {
                text: "simultaneously on the remote control to enter the calibration page"
                color: white
                font.pixelSize: defaultFontSize * 3
            }
        }
    }

    //Start Calibrating
    Rectangle {
        id: startCalibrationPage
        anchors.fill: parent
        z: 4
        color: black
        visible : false
        MouseArea {
            anchors.fill: parent
        }
        Column {
            anchors.horizontalCenter: parent.horizontalCenter

            Item {
                width: 1
                height: parent.width / 4.8
            }

            Text {
                color: white
                font.pixelSize: defaultFontSize * 3.5
                text: "Calibrating Remote Control..."
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Item {
                width: 1
                height: parent.width / 14.4
            }

            Text {
                color: lightGray
                font.pixelSize: defaultFontSize * 3
                text: "Finish Calibration referring to the remote control panel"
            }

            Item {
                width: 1
                height: parent.width / 9.6
            }

            Row {
                width: parent.width
                spacing: 5
                Text {
                    color: lightGray
                    font.pixelSize: defaultFontSize * 3
                    text: "Press"
                }

                Image {
                    anchors.verticalCenter: parent.verticalCenter
                    source: "qrc:/res/DISP.svg"
                    width: parent.width / 24
                    height: width
                }

                Text {
                    color: lightGray
                    font.pixelSize: defaultFontSize * 3
                    text: "button on the remote control to cancel calibration"
                }
            }
        }
    }

    //Command Stick Mode Page
    Rectangle {
        id: commandStickModePage
        anchors.fill: parent
        z: 4
        color: black
        visible : false
        MouseArea {
            anchors.fill: parent
        }
        Grid {
            anchors.fill: parent
            columns: 2
            rows: 2
            id: rootGrid
            property int selectedMode: 0  // 현재 선택된 모드를 추적 (0: Mode1, 1: Mode2, 2: Mode3)

            // Mode 1 Button
            Button {
                width: parent.width / 2
                height: parent.height / 3
                background: Rectangle {
                    color: transparent
                }

                contentItem: Column {
                    anchors.centerIn: parent

                    Text {
                        text: "Mode 1"
                        font.pixelSize: defaultFontSize * 4
                        color: rootGrid.selectedMode == 0 ? blue : white  // Mode 1이 선택되면 텍스트 색상 변경
                        anchors.left: mode1Image.left
                        anchors.leftMargin: parent.width / 14.4
                        id: mode1Text
                    }
                    Item {
                        width: 1
                        height: 40
                    }

                    Image {
                        id: mode1Image
                        source: rootGrid.selectedMode == 0 ? "qrc:/res/Mode1On.png" : "qrc:/res/Mode1Off.png"  // Mode 1이 선택되면 이미지 변경
                        width: parent.width / 1.5
                        height: parent.height / 1.3
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                onClicked: {
                    rootGrid.selectedMode = 0  // Mode 1을 선택
                }
            }

            // Mode 2 Button
            Button {
                width: parent.width / 2
                height: parent.height / 3
                background: Rectangle {
                    color: transparent
                }

                contentItem: Column {
                    anchors.centerIn: parent

                    Text {
                        text: "Mode 2"
                        font.pixelSize: defaultFontSize * 4
                        color: rootGrid.selectedMode == 1 ? blue : white  // Mode 2이 선택되면 텍스트 색상 변경
                        anchors.left: mode2Image.left
                        anchors.leftMargin: parent.width / 14.4
                    }

                    Image {
                        id: mode2Image
                        source: rootGrid.selectedMode == 1 ? "qrc:/res/Mode2On.png" : "qrc:/res/Mode2Off.png"  // Mode 2이 선택되면 이미지 변경
                        width: parent.width / 1.5
                        height: parent.height
                        anchors.horizontalCenter: parent.horizontalCenter

                    }
                }

                onClicked: {
                    rootGrid.selectedMode = 1  // Mode 2을 선택
                }
            }

            // Mode 3 Button
            Button {
                width: parent.width / 2
                height: parent.height / 3
                background: Rectangle {
                    color: transparent
                }

                contentItem: Column {
                    anchors.centerIn: parent

                    Text {
                        text: "Mode 3"
                        font.pixelSize: defaultFontSize * 4
                        color: rootGrid.selectedMode == 2 ? blue : white  // Mode 3이 선택되면 텍스트 색상 변경
                        anchors.left: mode3Image.left
                        anchors.leftMargin: parent.width / 14.4
                    }
                    Image {
                        id: mode3Image
                        source: rootGrid.selectedMode == 2 ? "qrc:/res/Mode3On.png" : "qrc:/res/Mode3Off.png"  // Mode 3이 선택되면 이미지 변경
                        width: parent.width / 1.5
                        height: parent.height * 1.1
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                onClicked: {
                    rootGrid.selectedMode = 2  // Mode 3을 선택
                }
            }
        }
    }

    //Remote Control Matching Page
    Rectangle {
        id: remoteControlMatchingPage
        anchors.fill: parent
        z: 4
        color: black
        visible : false
        MouseArea {
            anchors.fill: parent
        }
        Column {
            anchors.fill: parent

            Image {
                source: "qrc:/res/DroneDetails.png"
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width
                height: parent.height / 1.5
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    text: "When the remote control is off, Press the power button "
                    color: white
                    font.pixelSize: defaultFontSize * 3
                }
                Image {
                    source: "qrc:/res/StartButton.svg"
                    width: parent.width / 20
                    height: width / 2
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    text: " 6 times"
                    color: white
                    font.pixelSize: defaultFontSize * 3
                }
            }
        }
    }

    //Remote Control Customizable Buttons Page
    Rectangle {
        id: remoteControlcustomizablePage
        anchors.fill: parent
        z: 4
        color: black
        visible: false
        MouseArea {
            anchors.fill: parent
        }
        Column {
            anchors.fill: parent

            Image {
                source: "qrc:/res/AviatorBack.png"
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width / 2.4
                height: parent.height / 3
            }

            Item {
                width: 1
                height: parent.height /18
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                color: white
                font.pixelSize: defaultFontSize * 3
                text: "You can customize the A and B buttons on the back of remote control to\n                        personalise your flight experience"
            }

            Item {
                width: 1
                height: parent.height / 9
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    text: "A "
                    color: white
                    font.pixelSize: defaultFontSize * 3
                    anchors.verticalCenter: parent.verticalCenter
                }

                ComboBox {
                    id: aComboBox
                    width: remoteControlcustomizablePage.width / 3.6
                    model: ["Undefined","OA on / off", "AE lock / unlock", "Pitch set to 0° / 90°", "Map view / Camera view"]

                    // 텍스트와 색상 스타일을 지정
                    contentItem: Text {
                        text: aComboBox.currentText
                        color: blue // 텍스트 색상
                        font.pixelSize: defaultFontSize * 3
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        padding: defaultFontSize
                    }

                    // 오른쪽의 화살표 표시를 커스텀
                    indicator: Item {
                        anchors.fill: parent
                        anchors.right: parent.right
                        width: parent.height / 3
                        height: parent.height / 3
                        anchors.margins: defaultFontSize
                    }

                    background: Rectangle {
                        color: transparent  // 배경 색상 지정
                        border.color: blue
                        radius: 5
                    }
                }

                Item {
                    height: 1
                    width: remoteControlcustomizablePage.width / 14.4
                }

                Text {
                    text: "B "
                    color: white
                    font.pixelSize: defaultFontSize * 3
                    anchors.verticalCenter: parent.verticalCenter
                }
                ComboBox {
                    id: bComboBox
                    width: remoteControlcustomizablePage.width / 3.6
                    model: ["Undefined","OA on / off", "AE lock / unlock", "Pitch set to 0° / 90°", "Map view / Camera view"]

                    // 텍스트와 색상 스타일을 지정
                    contentItem: Text {
                        text: bComboBox.currentText
                        color: blue // 텍스트 색상
                        font.pixelSize: defaultFontSize * 3
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        padding: defaultFontSize
                    }

                    // 오른쪽의 화살표 표시를 커스텀
                    indicator: Item {
                        anchors.fill: parent
                        anchors.right: parent.right
                        width: parent.height / 3
                        height: parent.height / 3
                        anchors.margins: defaultFontSize
                    }

                    background: Rectangle {
                        color: transparent  // 배경 색상 지정
                        border.color: blue
                        radius: 5
                    }
                }
            }

            Item {
                width: 1
                height: parent.height /18
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    text: "* Press and hold for 1s to trigger"
                    color: lightGray
                    font.pixelSize: defaultFontSize * 2
                }

                Item {
                    height: 1
                    width: remoteControlcustomizablePage.width / 14.4
                }

                Text {
                    text : "* Press and hold for 1s to trigger\n* Customization is unavailable\nwhen the app is not connected"
                    color: lightGray
                    font.pixelSize: defaultFontSize * 2
                }
            }
        }
    }

    //RTCM Page
    Rectangle {
        id: rtcmPage
        anchors.fill: parent
        z: 4
        color: black
        visible: false

        MouseArea {
            anchors.fill: parent
        }

        Column {
            anchors.fill: parent

            Item {
                width: 1
                height: parent.height / 30
            }

            Text {
                color: white
                font.pixelSize: defaultFontSize * 3
                text: "General"
                anchors.left: parent.left
                anchors.leftMargin: parent.width / 14.4
            }

            Row {
                width: parent.width

                Item {
                    width: parent.width / 6
                    height: 1
                }

                Text {
                    width: parent.width / 5.76
                    color: white
                    font.pixelSize: defaultFontSize * 3.5
                    text: "RTCM Source:"
                }

                Item {
                    width: parent.width / 2.88
                    height: 1
                }

                ComboBox {
                    anchors.verticalCenter: parent.verticalCenter
                    id: rtcmSourceComboBox
                    width: root.width / 7.2
                    height: root.height / 22.5
                    model: ["NTRIP", "WIFI", "SerialPort"]

                    // 텍스트와 색상 스타일을 지정
                    contentItem: Text {
                        text: rtcmSourceComboBox.currentText
                        color: blue // 텍스트 색상
                        font.pixelSize: defaultFontSize * 3
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        padding: defaultFontSize
                    }

                    // 오른쪽의 화살표 표시를 커스텀
                    indicator: Item {
                        anchors.fill: parent
                        anchors.right: parent.right
                        width: parent.height / 3
                        height: parent.height / 3
                        anchors.margins: defaultFontSize
                        Image {
                            source: "qrc:/res/ales/waypoint/DownDir.svg"  // 원하는 화살표 이미지로 변경
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    background: Rectangle {
                        color: transparent  // 배경 색상 지정
                        border.color: lightGray
                        radius: 5
                    }
                }
            }

            Item {
                width: 1
                height: parent.height / 22.5
            }

            Row {
                width: parent.width

                Item {
                    width: parent.width / 6
                    height: 1
                }

                Text {
                    width: parent.width / 5.76
                    color: white
                    font.pixelSize: defaultFontSize * 3.5
                    text: "RTCM Max Hz:"
                }

                Item {
                    width: parent.width / 2.88
                    height: 1
                }

                ComboBox {
                    anchors.verticalCenter: parent.verticalCenter
                    id: rtcmMaxHzComboBox
                    width: root.width / 7.2
                    height: root.height / 22.5
                    model: ["4Hz", "5Hz", "10Hz", "20Hz", "50Hz"]

                    // 텍스트와 색상 스타일을 지정
                    contentItem: Text {
                        text: rtcmMaxHzComboBox.currentText
                        color: blue // 텍스트 색상
                        font.pixelSize: defaultFontSize * 3
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        padding: defaultFontSize
                    }

                    // 오른쪽의 화살표 표시를 커스텀
                    indicator: Item {
                        anchors.fill: parent
                        anchors.right: parent.right
                        width: parent.height / 3
                        height: parent.height / 3
                        anchors.margins: defaultFontSize
                        Image {
                            source: "qrc:/res/ales/waypoint/DownDir.svg"  // 원하는 화살표 이미지로 변경
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter

                        }
                    }

                    background: Rectangle {
                        color: transparent  // 배경 색상 지정
                        border.color: lightGray
                        radius: 5
                    }
                }
            }

            Item {
                width: 1
                height: parent.height / 15
            }

            Text {
                color: white
                font.pixelSize: defaultFontSize * 3
                text: "NTRIP RTCM Source"
                anchors.left: parent.left
                anchors.leftMargin: parent.width / 14.4
            }

            Item {
                width: 1
                height: parent.height / 15
            }

            Row {
                width: parent.width

                Item {
                    width: parent.width / 6
                    height: 1
                }

                Text {
                    width: parent.width / 5.76
                    color: white
                    font.pixelSize: defaultFontSize * 3.5
                    text: "Host:"
                }

                Item {
                    width: parent.width / 2.88
                    height: 1
                }

                TextField {
                    width: root.width / 4.8
                    height: root.height / 18
                    font.pixelSize: defaultFontSize * 3
                    color: white
                    background: Rectangle {
                        color: transparent
                        border.color: lightGray
                    }
                }
            }

            Item {
                width: 1
                height: parent.height / 22.5
            }

            Row {
                width: parent.width

                Item {
                    width: parent.width / 6
                    height: 1
                }

                Text {
                    width: parent.width / 5.76
                    color: white
                    font.pixelSize: defaultFontSize * 3.5
                    text: "Port:"
                }

                Item {
                    width: parent.width / 2.88
                    height: 1
                }

                TextField {
                    width: root.width / 4.8
                    height: root.height / 18
                    font.pixelSize: defaultFontSize * 3
                    color: white
                    background: Rectangle {
                        color: transparent
                        border.color: lightGray
                    }
                }
            }
            Item {
                width: 1
                height: parent.height / 22.5
            }
            Row {
                width: parent.width

                Item {
                    width: parent.width / 6
                    height: 1
                }

                Text {
                    width: parent.width / 5.76
                    color: white
                    font.pixelSize: defaultFontSize * 3.5
                    text: "MountPoint:"
                }

                Item {
                    width: parent.width / 2.88
                    height: 1
                }

                TextField {
                    width: root.width / 4.8
                    height: root.height / 18
                    font.pixelSize: defaultFontSize * 3
                    color: white
                    background: Rectangle {
                        color: transparent
                        border.color: lightGray
                    }
                }
            }
            Item {
                width: 1
                height: parent.height / 22.5
            }
            Row {
                width: parent.width

                Item {
                    width: parent.width / 6
                    height: 1
                }

                Text {
                    width: parent.width / 5.76
                    color: white
                    font.pixelSize: defaultFontSize * 3.5
                    text: "User:"
                }

                Item {
                    width: parent.width / 2.88
                    height: 1
                }

                TextField {
                    width: root.width / 4.8
                    height: root.height / 18
                    font.pixelSize: defaultFontSize * 3
                    color: white
                    background: Rectangle {
                        color: transparent
                        border.color: lightGray
                    }
                }
            }
            Item {
                width: 1
                height: parent.height / 22.5
            }
            Row {
                width: parent.width

                Item {
                    width: parent.width / 6
                    height: 1
                }

                Text {
                    width: parent.width / 5.76
                    color: white
                    font.pixelSize: defaultFontSize * 3.5
                    text: "Password:"
                }

                Item {
                    width: parent.width / 2.88
                    height: 1
                }

                TextField {
                    width: root.width / 4.8
                    height: root.height / 18
                    font.pixelSize: defaultFontSize * 3
                    color: white
                    background: Rectangle {
                        color: transparent
                        border.color: lightGray
                    }
                }
            }

            Item {
                width: 1
                height: parent.height / 30
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width / 1.8
                height: parent.height / 15
                Text {
                    color: white
                    font.pixelSize: defaultFontSize * 3.5
                    text: "Log in"
                    anchors.centerIn: parent
                }
                background: Rectangle {
                    color: lightGray
                }

                onClicked: {
                    console.log( "log in btn Click")
                }
            }
        }
    }

    // Main Page
    Column {
        anchors.fill: parent
        width: parent.width
        height: parent.height

        //Remote Control Calibration
        ItemDelegate {
            width: parent.width
            height: hItemDelegate

            Text {
                anchors.left: parent.left
                color: white
                text: "Remote Control Calibration"
                font.pixelSize: defaultFontSize * 3
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: parent.width / 24
            }

            Image {
                source : "qrc:/res/ales/waypoint/RightDir.svg"
                anchors.right: parent.right
                anchors.rightMargin: defaultFontSize * 2
                anchors.verticalCenter: parent.verticalCenter
            }

            background: Rectangle {
                color: transparent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    remoteControlCalibrationPage.visible = true
                    parentQML.currentPageIndex = 1
                    parentQML.page1 = remoteControlCalibrationPage
                    parentQML.mainTitle = parentQML.settingTitle

                    parentQML.settingTitle = "Remote Control Calibration"
                }
            }
        }
        ToolSeparator {
            width: parent.width
            height: hToolSeparator
            orientation: Qt.Horizontal
        }
        // Command Stick Mode
        ItemDelegate {
            width: parent.width
            height: hItemDelegate

            Text {
                anchors.left: parent.left
                color: white
                text: "Command Stick Mode"
                font.pixelSize: defaultFontSize * 3
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: parent.width / 24
            }

            Image {
                source : "qrc:/res/ales/waypoint/RightDir.svg"
                anchors.right: parent.right
                anchors.rightMargin: defaultFontSize * 2
                anchors.verticalCenter: parent.verticalCenter
            }

            background: Rectangle {
                color: transparent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    commandStickModePage.visible = true
                    parentQML.currentPageIndex = 1
                    parentQML.page1 = commandStickModePage
                    parentQML.mainTitle = parentQML.settingTitle
                    parentQML.settingTitle = "Command Stick Mode"
                }
            }
        }
        ToolSeparator {
            width: parent.width
            height: hToolSeparator
            orientation: Qt.Horizontal
        }

        // Remote Control Matching
        ItemDelegate {
            width: parent.width
            height: hItemDelegate

            Text {
                anchors.left: parent.left
                color: white
                text: "Remote Control Matching"
                font.pixelSize: defaultFontSize * 3
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: parent.width / 24
            }

            Image {
                source : "qrc:/res/ales/waypoint/RightDir.svg"
                anchors.right: parent.right
                anchors.rightMargin: defaultFontSize * 2
                anchors.verticalCenter: parent.verticalCenter
            }

            background: Rectangle {
                color: transparent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    remoteControlMatchingPage.visible = true
                    parentQML.currentPageIndex = 1
                    parentQML.page1 = remoteControlMatchingPage
                    parentQML.mainTitle = parentQML.settingTitle
                    parentQML.settingTitle = "Remote Control Matching"
                }
            }
        }
        ToolSeparator {
            width: parent.width
            height: hToolSeparator
            orientation: Qt.Horizontal
        }

        // Remote Control customizeable buttons
        ItemDelegate {
            width: parent.width
            height: hItemDelegate

            Text {
                anchors.left: parent.left
                color: white
                text: "Remote Control customizable buttons"
                font.pixelSize: defaultFontSize * 3
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: parent.width / 24
            }

            Image {
                source : "qrc:/res/ales/waypoint/RightDir.svg"
                anchors.right: parent.right
                anchors.rightMargin: defaultFontSize * 2
                anchors.verticalCenter: parent.verticalCenter
            }

            background: Rectangle {
                color: transparent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    remoteControlcustomizablePage.visible = true
                    parentQML.currentPageIndex = 1
                    parentQML.page1 = remoteControlcustomizablePage
                    parentQML.mainTitle = parentQML.settingTitle
                    parentQML.settingTitle = "Remote Control Customizable Buttons"
                }
            }
        }
        ToolSeparator {
            width: parent.width
            height: hToolSeparator
            orientation: Qt.Horizontal
        }

        // RTCM
        ItemDelegate {
            width: parent.width
            height: hItemDelegate

            Text {
                anchors.left: parent.left
                color: white
                text: "RTCM"
                font.pixelSize: defaultFontSize * 3
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: parent.width / 24
            }

            Image {
                source : "qrc:/res/ales/waypoint/RightDir.svg"
                anchors.right: parent.right
                anchors.rightMargin: defaultFontSize * 2
                anchors.verticalCenter: parent.verticalCenter
            }

            background: Rectangle {
                color: transparent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    rtcmPage.visible = true
                    parentQML.currentPageIndex = 1
                    parentQML.page1 = rtcmPage
                    parentQML.mainTitle = parentQML.settingTitle
                    parentQML.settingTitle = "RTCM"
                }
            }
        }
        ToolSeparator {
            width: parent.width
            height: hToolSeparator
            orientation: Qt.Horizontal
        }
    }
}
