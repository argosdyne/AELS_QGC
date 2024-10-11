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
    property string red: "red"
    property string green: "green"
    property color lightGray: "#4a4a4a"
    property color transparent: "transparent"
    property int hItemDelegate: Screen.height / 5;
    property int hSwitchDelegate: Screen.height / 15;
    property int hToolSeparator: defaultFontSize + 3;
    property int leftMargin: 20;

    //Size Property
    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize
    z: 3
    property var parentQML : null

    //Values
    property int distanceLimitValue: 0
    property int ascentSpeedLimitValue: 0
    property int descentSpeedLimitValue: 0

    signal openNovicePopup()
    signal openLEDIndicatorPopup()

    property alias frontLEDcontrol: frontLEDcontrol
    property alias backwardLEDcontrol: backwardLEDcontrol

    // IMU Calibration Page
    Rectangle {
        id: imuCalibrationPage
        anchors.fill: parent
        z: 4
        color: black
        visible : false
        MouseArea {
            anchors.fill: parent
        }

        Column {
            anchors.fill: parent
            //Compass
            ItemDelegate {
                width: parent.width
                height: hItemDelegate / 2

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width / 24
                    color: white
                    text: "Compass"
                    font.pixelSize: defaultFontSize * 3
                    anchors.verticalCenter: parent.verticalCenter
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
                        startCompassCalibrationPage.visible = true
                        parentQML.page2 = startCompassCalibrationPage
                        parentQML.currentPageIndex = 2
                        parentQML.previousTitle = parentQML.settingTitle
                        parentQML.settingTitle = "Compass Calibration"
                    }
                }
            }

            ToolSeparator {
                width: parent.width
                height: hToolSeparator
                orientation: Qt.Horizontal
            }
            //Gyroscope
            ItemDelegate {
                width: parent.width
                height: hItemDelegate / 2

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width / 24
                    color: white
                    text: "Gyroscope"
                    font.pixelSize: defaultFontSize * 3
                    anchors.verticalCenter: parent.verticalCenter
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
                        startGyroScopeCalibrationPage.visible = true
                        parentQML.page2 = startGyroScopeCalibrationPage
                        parentQML.currentPageIndex = 2
                        parentQML.previousTitle = parentQML.settingTitle
                        parentQML.settingTitle = "Gyroscope Calibration"
                    }
                }
            }

            ToolSeparator {
                width: parent.width
                height: hToolSeparator
                orientation: Qt.Horizontal
            }
            //Accelerometer
            ItemDelegate {
                width: parent.width
                height: hItemDelegate / 2

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width / 24
                    color: white
                    text: "Accelerometer"
                    font.pixelSize: defaultFontSize * 3
                    anchors.verticalCenter: parent.verticalCenter
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
                        startAccelerometerCalibrationPage.visible = true
                        parentQML.page2 = startAccelerometerCalibrationPage
                        parentQML.currentPageIndex = 2
                        parentQML.previousTitle = parentQML.settingTitle
                        parentQML.settingTitle = "Accelerometer Calibration"
                    }
                }
            }

            ToolSeparator {
                width: parent.width
                height: hToolSeparator
                orientation: Qt.Horizontal
            }

            ItemDelegate {
                width: parent.width
                height: hItemDelegate / 2

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width / 24
                    color: white
                    text: "Level Horizon"
                    font.pixelSize: defaultFontSize * 3
                    anchors.verticalCenter: parent.verticalCenter
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
                        startLevelHorizonCalibrationPage.visible = true
                        parentQML.page2 = startLevelHorizonCalibrationPage
                        parentQML.currentPageIndex = 2
                        parentQML.previousTitle = parentQML.settingTitle
                        parentQML.settingTitle = "Level Horizon"
                    }
                }
            }
        }
    }

    // Start Compass Calibration
    Rectangle{
        id: startCompassCalibrationPage
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
                height: parent.height / 3
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width / 4
                height: parent.height / 10
                Text {
                    text: "Start Calibration"
                    font.pixelSize: defaultFontSize * 4
                    anchors.centerIn: parent
                    color: white
                }
                background: Rectangle {
                    color: blue
                }
                onClicked: {
                    compassCalibrationPage.visible = true
                    parentQML.page3 = compassCalibrationPage
                    parentQML.currentPageIndex = 3
                }
            }

            Item {
                width: 1
                height:hItemDelegate / 3
            }

            Text {
                text: "For Compass calibration you will need to rotate your vehicle through a number of positions."
                color: white
                font.pixelSize: defaultFontSize * 3
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Item {
                width: 1
                height:hItemDelegate / 3
            }

            Text {
                color: white
                font.pixelSize: defaultFontSize * 3
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Click Ok to Start Calibration"
            }
        }
    }

    //Compass Calibration Page
    Rectangle {
        id: compassCalibrationPage
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
                height: hItemDelegate / 3
            }

            Text {
                color: white
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: defaultFontSize * 3
                text: "Place your vehicle into one of the Incomplete orientations shown below and hold it still"
            }

            Item {
                width: 1
                height: hItemDelegate / 3
            }

            Grid {
                width: parent.width / 1.2
                height: parent.height / 1.5
                spacing: defaultFontSize
                columns: 3
                rows: 2
                anchors.horizontalCenter: parent.horizontalCenter

                Rectangle {
                    width: parent.width / 3 - defaultFontSize
                    height: parent.height / 2 - defaultFontSize
                    color: transparent
                    Image {
                        anchors.fill: parent
                        source: "qrc:/res/IncompleteCalibration.png"
                    }
                }
                Rectangle {
                    width: parent.width / 3 - defaultFontSize
                    height: parent.height / 2 - defaultFontSize
                    color: transparent
                    Image {
                        anchors.fill: parent
                        source: "qrc:/res/IncompleteCalibration.png"
                    }
                }
                Rectangle {
                    width: parent.width / 3 - defaultFontSize
                    height: parent.height / 2 - defaultFontSize
                    color: transparent
                    Image {
                        anchors.fill: parent
                        source: "qrc:/res/IncompleteCalibration.png"
                    }
                }
                Rectangle {
                    width: parent.width / 3 - defaultFontSize
                    height: parent.height / 2 - defaultFontSize
                    color: transparent
                    Image {
                        anchors.fill: parent
                        source: "qrc:/res/IncompleteCalibration.png"
                    }
                }
                Rectangle {
                    width: parent.width / 3 - defaultFontSize
                    height: parent.height / 2 - defaultFontSize
                    color: transparent
                    Image {
                        anchors.fill: parent
                        source: "qrc:/res/IncompleteCalibration.png"
                    }
                }
                Rectangle {
                    width: parent.width / 3 - defaultFontSize
                    height: parent.height / 2 - defaultFontSize
                    color: transparent
                    Image {
                        anchors.fill: parent
                        source: "qrc:/res/IncompleteCalibration.png"
                    }
                }
            }
        }
    }

    // Start GyroScope Calibration
    Rectangle {
        id: startGyroScopeCalibrationPage
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
                height: parent.height / 3
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width / 4
                height: parent.height / 10
                Text {
                    text: "Start Calibration"
                    font.pixelSize: defaultFontSize * 4
                    anchors.centerIn: parent
                    color: white
                }
                background: Rectangle {
                    color: blue
                }
                onClicked: {
                    gyroscopeCalibrationPage.visible = true
                    parentQML.page3 = gyroscopeCalibrationPage
                    parentQML.currentPageIndex = 3
                }
            }

            Item {
                width: 1
                height:hItemDelegate / 3
            }

            Text {
                text: "For Gyroscope calibration you will need to place your vehicle on a surface"
                color: white
                font.pixelSize: defaultFontSize * 3
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Item {
                width: 1
                height: defaultFontSize
            }
            Text {
                text: "and leave it still."
                color: white
                font.pixelSize: defaultFontSize * 3
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Item {
                width: 1
                height:hItemDelegate / 3
            }

            Text {
                color: white
                font.pixelSize: defaultFontSize * 3
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Click Ok to Start Calibration"
            }
        }
    }

    //Gyroscope Calibration Page
    Rectangle {
        id: gyroscopeCalibrationPage
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
                height: hItemDelegate / 3
            }

            Text {
                color: white
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: defaultFontSize * 3
                text: "Place your vehicle into one of the Incomplete orientations shown below and hold it still"
            }

            Item {
                width: 1
                height: hItemDelegate / 3
            }

            Image {
                source: "qrc:/res/IncompleteCalibration.png"
                width: parent.width / 2.4
                height: width
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    // Start Accelerometer Calibration
    Rectangle {
        id: startAccelerometerCalibrationPage
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
                height: parent.height / 3
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width / 4
                height: parent.height / 10
                Text {
                    text: "Start Calibration"
                    font.pixelSize: defaultFontSize * 4
                    anchors.centerIn: parent
                    color: white
                }
                background: Rectangle {
                    color: blue
                }
                onClicked: {
                    accelerometerCalibrationPage.visible = true
                    parentQML.page3 = accelerometerCalibrationPage
                    parentQML.currentPageIndex = 3
                }
            }

            Item {
                width: 1
                height:hItemDelegate / 3
            }

            Text {
                text: "For Accelerometer calibration you will need to place your vehicle on all six sides\non a perfectly level surface and hold it still in eash orientation for a few seconds"
                color: white
                font.pixelSize: defaultFontSize * 3
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Item {
                width: 1
                height:hItemDelegate / 3
            }

            Text {
                color: white
                font.pixelSize: defaultFontSize * 3
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Click Ok to Start Calibration"
            }
        }
    }

    // Accelerometer Calibration Page
    Rectangle {
        id: accelerometerCalibrationPage
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
                height: hItemDelegate / 3
            }

            Text {
                color: white
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: defaultFontSize * 3
                text: "Place your vehicle into one of the Incomplete orientations shown below and hold it still"
            }

            Item {
                width: 1
                height: hItemDelegate / 3
            }

            Grid {
                width: parent.width / 1.2
                height: parent.height / 1.5
                spacing: defaultFontSize
                columns: 3
                rows: 2
                anchors.horizontalCenter: parent.horizontalCenter

                Rectangle {
                    width: parent.width / 3 - defaultFontSize
                    height: parent.height / 2 - defaultFontSize
                    color: transparent
                    Image {
                        anchors.fill: parent
                        source: "qrc:/res/IncompleteCalibration.png"
                    }
                }
                Rectangle {
                    width: parent.width / 3 - defaultFontSize
                    height: parent.height / 2 - defaultFontSize
                    color: transparent
                    Image {
                        anchors.fill: parent
                        source: "qrc:/res/IncompleteCalibration.png"
                    }
                }
                Rectangle {
                    width: parent.width / 3 - defaultFontSize
                    height: parent.height / 2 - defaultFontSize
                    color: transparent
                    Image {
                        anchors.fill: parent
                        source: "qrc:/res/IncompleteCalibration.png"
                    }
                }
                Rectangle {
                    width: parent.width / 3 - defaultFontSize
                    height: parent.height / 2 - defaultFontSize
                    color: transparent
                    Image {
                        anchors.fill: parent
                        source: "qrc:/res/IncompleteCalibration.png"
                    }
                }
                Rectangle {
                    width: parent.width / 3 - defaultFontSize
                    height: parent.height / 2 - defaultFontSize
                    color: transparent
                    Image {
                        anchors.fill: parent
                        source: "qrc:/res/IncompleteCalibration.png"
                    }
                }
                Rectangle {
                    width: parent.width / 3 - defaultFontSize
                    height: parent.height / 2 - defaultFontSize
                    color: transparent
                    Image {
                        anchors.fill: parent
                        source: "qrc:/res/IncompleteCalibration.png"
                    }
                }
            }
        }
    }

    // Start Level Horizon Calibration
    Rectangle {
        id: startLevelHorizonCalibrationPage
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
                height: parent.height / 3
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width / 4
                height: parent.height / 10
                Text {
                    text: "Start Calibration"
                    font.pixelSize: defaultFontSize * 4
                    anchors.centerIn: parent
                    color: white
                }
                background: Rectangle {
                    color: blue
                }
                onClicked: {
                    levelHorizonCalibrationPage.visible = true
                    parentQML.page3 = levelHorizonCalibrationPage
                    parentQML.currentPageIndex = 3
                }
            }

            Item {
                width: 1
                height: hItemDelegate / 3
            }

            Text {
                text: "To level the horizon you need to place the vehicle in its level flight position"
                color: white
                font.pixelSize: defaultFontSize * 3
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Item {
                width: 1
                height: defaultFontSize
            }
            Text {
                text: "and leave it still."
                color: white
                font.pixelSize: defaultFontSize * 3
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Item {
                width: 1
                height:hItemDelegate / 3
            }

            Text {
                color: white
                font.pixelSize: defaultFontSize * 3
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Click Ok to Start Calibration"
            }
        }
    }

    //Level Horizon Calibration Page
    Rectangle {
        id: levelHorizonCalibrationPage
        anchors.fill: parent
        z: 4
        visible: false
        color: black
        MouseArea {
            anchors.fill: parent
        }

        Column {
            anchors.fill: parent

            Item {
                width: 1
                height: hItemDelegate / 3
            }

            Text {
                text: "Start the individual calibration steps by clicking one of the buttons to the left"
                color: white
                font.pixelSize: defaultFontSize * 3
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Item {
                width: 1
                height: hItemDelegate / 5
            }

            Text {
                text: "[cal] calibration started: 2 level\n[cal] progress &it;0&gt;\n[cal] progress &it;20&gt;\n[cal] progress &it;40&gt;\n[cal] progress &it;60&gt;\n[cal] progress &it;80&gt;\n[cal] progress &it;100&gt;\n[cal] progress &it;100&gt;\n[cal] calibration done: level"
                color: white
                font.pixelSize: defaultFontSize * 3
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }


    //Advanced Settings
    Rectangle {
        id: advancedSettingsPage
        anchors.fill: parent
        z: 4
        color: black
        visible: false
        MouseArea {
            anchors.fill: parent
        }
        Column {
            anchors.fill: parent

            //Front LED Indicators
            ItemDelegate {
                width: parent.width
                height: parent.height / 9.6
                id: frontLEDDelegate

                Text {
                    anchors.left: parent.left
                    text: "Front LED Indicators"
                    font.pixelSize: defaultFontSize * 3
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: defaultFontSize * 2
                    color: white
                }

                Switch{
                    id: frontLEDcontrol
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    checked: true
                    indicator: Rectangle {
                        implicitWidth: defaultFontSize * 6
                        implicitHeight: defaultFontSize * 3
                        x: frontLEDcontrol.width - width - frontLEDcontrol.rightPadding
                        y: parent.height / 2 - height / 2
                        radius: 13
                        color: frontLEDcontrol.checked ? blue : lightGray
                        border.color: black

                        Rectangle {
                            x: frontLEDcontrol.checked ? parent.width - width : 0
                            width: defaultFontSize * 3
                            height: defaultFontSize * 3
                            radius: 50
                            border.color: black
                        }
                    }

                    onCheckedChanged:
                    {
                        if(!frontLEDcontrol.checked) {
                            openLEDIndicatorPopup();
                            parentQML.currentLED = "Front"
                        }
                    }
                }
                background: Rectangle {
                    color : transparent
                }
            }
            ToolSeparator {
                width: parent.width
                height: hToolSeparator
                orientation: Qt.Horizontal
            }

            // Backward LED Indicators
            ItemDelegate {
                width: parent.width
                height: parent.height / 9.6
                id: backwardLEDDelegate

                Text {
                    anchors.left: parent.left
                    text: "Backward LED Indicators"
                    font.pixelSize: defaultFontSize * 3
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: defaultFontSize * 2
                    color: white
                }

                Switch{
                    id: backwardLEDcontrol
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right : parent.right
                    checked: true
                    indicator: Rectangle {
                        implicitWidth: defaultFontSize * 6
                        implicitHeight: defaultFontSize * 3
                        x: backwardLEDcontrol.width - width - backwardLEDcontrol.rightPadding
                        y: parent.height / 2 - height / 2
                        radius: 13
                        color: backwardLEDcontrol.checked ? blue : lightGray
                        border.color: black

                        Rectangle {
                            x: backwardLEDcontrol.checked ? parent.width - width : 0
                            width: defaultFontSize * 3
                            height: defaultFontSize * 3
                            radius: 50
                            border.color: black
                        }
                    }
                    onCheckedChanged:
                    {
                        if(!backwardLEDcontrol.checked) {
                            openLEDIndicatorPopup();
                            parentQML.currentLED = "Backward"
                        }
                    }
                }
                background: Rectangle {
                    color : transparent
                }
            }

            ToolSeparator {
                width: parent.width
                height: hToolSeparator
                orientation: Qt.Horizontal
            }

            //EXP
            ItemDelegate {
                width: parent.width
                height: parent.height / 9.6

                Text {
                    anchors.left: parent.left
                    color: white
                    text: "EXP"
                    font.pixelSize: defaultFontSize * 3
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: defaultFontSize * 2
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
                        expPage.visible = true
                        parentQML.currentPageIndex = 2
                        parentQML.page2 = expPage

                        parentQML.previousTitle = parentQML.settingTitle

                        parentQML.settingTitle = "EXP"
                    }
                }
            }
            ToolSeparator {
                width: parent.width
                height: hToolSeparator
                orientation: Qt.Horizontal
            }

            //Sensitivity
            ItemDelegate {
                width: parent.width
                height: parent.height / 9.6

                Text {
                    anchors.left: parent.left
                    color: white
                    text: "Sensitivity"
                    font.pixelSize: defaultFontSize * 3
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: defaultFontSize * 2
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
                        sensitivityPage.visible = true
                        parentQML.currentPageIndex = 2
                        parentQML.page2 = sensitivityPage

                        parentQML.previousTitle = parentQML.settingTitle
                        parentQML.settingTitle = "Sensitivity" // 이전꺼 불러오는법 확인
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

    //Advanced Settings -> EXP
    Rectangle {
        id: expPage
        anchors.fill: parent
        z: 4
        color: black
        visible : false
        MouseArea {
            anchors.fill: parent
        }
        Row {
            width: parent.width / 1.2
            height: parent.height / 2.5
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height / 12
            spacing: width / 8            

            Column {
                width: parent.width / 6
                height: parent.height
                spacing: defaultFontSize
                Text {
                    text: "Throttle Up"
                    color: white
                    font.pixelSize: defaultFontSize * 3
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Image {
                    source: "qrc:/res/exp.svg"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: "Throttle Down"
                    color: white
                    font.pixelSize: defaultFontSize * 3
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                TextField {
                    text: "0.50"
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: defaultFontSize * 3
                    color: white
                    inputMethodHints: Qt.ImhDigitsOnly

                    background: Rectangle{
                        color: transparent
                        border.color: lightGray
                    }
                }
            }

            Column {
                width: parent.width / 6
                height: parent.height
                spacing: defaultFontSize
                Text {
                    text: "Rotate Right"
                    color: white
                    font.pixelSize: defaultFontSize * 3
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Image {
                    source: "qrc:/res/exp.svg"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: "Rotate Left"
                    color: white
                    font.pixelSize: defaultFontSize * 3
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                TextField {
                    text: "0.50"
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: defaultFontSize * 3
                    color: white
                    inputMethodHints: Qt.ImhDigitsOnly

                    background: Rectangle{
                        color: transparent
                        border.color: lightGray
                    }
                }
            }

            Column {
                width: parent.width / 6
                height: parent.height
                spacing: defaultFontSize
                Text {
                    text: "Forward"
                    color: white
                    font.pixelSize: defaultFontSize * 3
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Image {
                    source: "qrc:/res/exp.svg"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: "Backward"
                    color: white
                    font.pixelSize: defaultFontSize * 3
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                TextField {
                    text: "0.50"
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: defaultFontSize * 3
                    color: white
                    inputMethodHints: Qt.ImhDigitsOnly

                    background: Rectangle{
                        color: transparent
                        border.color: lightGray
                    }
                }
            }

            Column {
                width: parent.width / 6
                height: parent.height
                spacing: defaultFontSize
                Text {
                    text: "Right"
                    color: white
                    font.pixelSize: defaultFontSize * 3
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Image {
                    source: "qrc:/res/exp.svg"
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: "Left"
                    color: white
                    font.pixelSize: defaultFontSize * 3
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                TextField {
                    text: "0.50"
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: defaultFontSize * 3
                    color: white
                    inputMethodHints: Qt.ImhDigitsOnly

                    background: Rectangle{
                        color: transparent
                        border.color: lightGray
                    }
                }
            }
        }

        Text {
            text: "The X-Axis represents the physical output of the Command Sticks and the Y-Axis iks the\n                        logical outp;ut the Command Sticks. (range: 0-2~0.7)."
            color: white
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: defaultFontSize * 2
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height / 3.2
        }
    }

    //Advanced Settings -> Sensitivity
    Rectangle {
        id: sensitivityPage
        anchors.fill: parent
        z: 4
        color: black
        visible : false
        MouseArea {
            anchors.fill: parent
        }
        Column
        {
            anchors.fill: parent

            // Attitude
            ItemDelegate {
                width: parent.width
                height: parent.height / 9.6
                Text {
                    anchors.left: parent.left
                    color: white
                    text: "Attitude (20%~100%)"
                    font.pixelSize: defaultFontSize * 3
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: defaultFontSize * 2
                }

                TextField {
                    anchors.right: parent.right
                    color: white
                    text: "100%"
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: defaultFontSize * 3
                    anchors.rightMargin: defaultFontSize
                    width: parent.width / 10

                    background: Rectangle {
                        color: transparent
                        border.color: lightGray
                    }
                }
                background: Rectangle {
                    color: transparent
                }
            }

            ToolSeparator {
                width: parent.width
                height: hToolSeparator
                orientation: Qt.Horizontal
            }

            // Brake
            ItemDelegate {
                width: parent.width
                height: parent.height / 9.6
                Text {
                    anchors.left: parent.left
                    color: white
                    text: "Brake (50%~200%)"
                    font.pixelSize: defaultFontSize * 3
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: defaultFontSize * 2
                }

                TextField {
                    anchors.right: parent.right
                    color: white
                    text: "100%"
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: defaultFontSize * 3
                    anchors.rightMargin: defaultFontSize
                    width: parent.width / 10
                    background: Rectangle {
                        color: transparent
                        border.color: lightGray
                    }
                }
                background: Rectangle {
                    color: transparent
                }
            }

            ToolSeparator {
                width: parent.width
                height: hToolSeparator
                orientation: Qt.Horizontal
            }

            // Yaw
            ItemDelegate {
                width: parent.width
                height: parent.height / 9.6
                Text {
                    anchors.left: parent.left
                    color: white
                    text: "Yaw Movement (20%~100%)"
                    font.pixelSize: defaultFontSize * 3
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: defaultFontSize * 2
                }

                TextField {
                    anchors.right: parent.right
                    color: white
                    text: "70%"
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: defaultFontSize * 3
                    anchors.rightMargin: defaultFontSize
                    width: parent.width / 10
                    background: Rectangle {
                        color: transparent
                        border.color: lightGray
                    }
                }
                background: Rectangle {
                    color: transparent
                }
            }
            ToolSeparator {
                width: parent.width
                height: hToolSeparator
                orientation: Qt.Horizontal
            }
        }
    }

    Column {
        anchors.fill: parent
        width: parent.width
        height: parent.height

        //Flickable
        Rectangle {
            width: parent.width - defaultFontSize * 6
            height: parent.height
            color: transparent
            anchors.horizontalCenter: parent.horizontalCenter
            clip: true
            Flickable {
                anchors.fill: parent
                contentWidth: parent.width
                contentHeight: parent.height * 1.7

                id: flickAble
                Column {
                    width: parent.width
                    height: parent.height

                    //Novice Mode
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate

                        property string noviceModeTitle: qsTr("Novice Mode")
                        property string noviceModeDescription: qsTr("When Enabled, the maximum altitude, distance and speed")
                        property string noviceModeDescription2: qsTr("will be limited. Intelligent Flight Modes will be disabled.")

                        Text {
                            anchors.left: parent.left
                            text: parent.noviceModeTitle + "\n\n" + parent.noviceModeDescription + "\n" + parent.noviceModeDescription2
                            font.pixelSize: defaultFontSize * 3
                            anchors.verticalCenter: parent.verticalCenter
                            color: white
                        }
                        // 체크하면 Indoor Mode랑 Speed Mode UI 안보임
                        Switch{
                            id: noviceModecontrol
                            anchors.right: parent.right
                            anchors.top: parent.top
                            checked: false
                            indicator: Rectangle {
                                implicitWidth: defaultFontSize * 6
                                implicitHeight: defaultFontSize * 3
                                x: noviceModecontrol.width - width - noviceModecontrol.rightPadding
                                y: parent.height / 2 - height / 2
                                radius: 13
                                color: noviceModecontrol.checked ? blue : lightGray
                                border.color: white

                                Rectangle {
                                    x: noviceModecontrol.checked ? parent.width - width : 0
                                    width: defaultFontSize * 3
                                    height: defaultFontSize * 3
                                    radius: 50
                                    border.color: black
                                }
                            }
                            onCheckedChanged: {
                                if(noviceModecontrol.checked) {
                                    console.log("noviceModecontrol checked")
                                    indoorDelegate.visible = false
                                    indoorSeparator.visible = false
                                    speedMode.visible = false
                                    flickAble.contentHeight = flickAble.contentHeight - (indoorDelegate.height + indoorSeparator.height + speedMode.height)
                                }
                                else {
                                    console.log("noviceModecontrol unchecked")
                                    indoorDelegate.visible = true
                                    indoorSeparator.visible = true
                                    speedMode.visible = true
                                    flickAble.contentHeight = flickAble.contentHeight + (indoorDelegate.height + indoorSeparator.height + speedMode.height)

                                    openNovicePopup();
                                }
                            }
                        }
                        background: Rectangle {
                            color : transparent
                        }
                    }

                    ToolSeparator {
                        width: parent.width
                        height: hToolSeparator
                        orientation: Qt.Horizontal
                        id: indoorSeparator
                    }

                    //IndoorMode
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate
                        id: indoorDelegate

                        Text {
                            anchors.left: parent.left
                            text: "Indoor Mode\n\nWhen enabled, all flight parameters will be optimized for\nindoor flights (No GPS connection present). When GPS\nconnection is resumed, the indoor mode will be turned off\nautomatically."
                            font.pixelSize: defaultFontSize * 3
                            anchors.verticalCenter: parent.verticalCenter
                            color: white
                        }

                        Switch{
                            id: indoorModecontrol
                            anchors.right: parent.right
                            anchors.top: parent.top
                            checked: false
                            indicator: Rectangle {
                                implicitWidth: defaultFontSize * 6
                                implicitHeight: defaultFontSize * 3
                                x: indoorModecontrol.width - width - indoorModecontrol.rightPadding
                                y: parent.height / 2 - height / 2
                                radius: 13
                                color: indoorModecontrol.checked ? blue : lightGray
                                border.color: black

                                Rectangle {
                                    x: indoorModecontrol.checked ? parent.width - width : 0
                                    width: defaultFontSize * 3
                                    height: defaultFontSize * 3
                                    radius: 50
                                    border.color: black
                                }
                            }
                        }
                        background: Rectangle {
                            color : transparent
                        }
                    }

                    ToolSeparator {
                        width: parent.width
                        height: hToolSeparator
                        orientation: Qt.Horizontal
                    }

                    //Go-Home Altitude
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate

                        Text {
                            anchors.left: parent.left
                            color: white
                            text: "Go-Home Altitude\n\nThe drone will fly home using the set Return to Home Altitude\nor current drone altitude, whichever is greater. If Forward/\nBackward vision system is enabled, the drone may ascend to\navoid obstacles when detected."
                            font.pixelSize: defaultFontSize * 3
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        TextField {
                            anchors.right: parent.right
                            anchors.top: parent.top
                            font.pixelSize: defaultFontSize * 3
                            width: parent.width / 9.6
                            color: white
                            background: Rectangle {
                                color: transparent
                                border.color: white
                            }
                        }

                        background: Rectangle {
                            color: transparent
                        }
                    }
                    ToolSeparator {
                        width: parent.width
                        height: hToolSeparator
                        orientation: Qt.Horizontal
                    }


                    // Speed Mode
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate / 3
                        id: speedMode
                        Text {
                            anchors.left: parent.left
                            color: white
                            text: "Speed Mode"
                            font.pixelSize: defaultFontSize * 3
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        ListView {
                            orientation: Qt.Horizontal
                            model: ["Standard", "Ludicrous"]
                            anchors.left: parent.left
                            anchors.leftMargin:root.width / 1.37
                            width: root.width / 4.48
                            height: parent.height / 2.16
                            id: listView
                            anchors.verticalCenter: parent.verticalCenter
                            interactive: false
                            highlightFollowsCurrentItem: false

                            delegate: Rectangle {
                                width: listView.width / 2
                                height: listView.height
                                color: ListView.isCurrentItem ? blue : lightGray

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData
                                    font.pixelSize: 20
                                    color: white
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        listView.currentIndex = index
                                    }
                                }
                            }
                        }

                        background: Rectangle {
                            color: transparent
                        }
                    }
                    //Speed Limit
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate / 3

                        Text {
                            anchors.left: parent.left
                            font.pixelSize: defaultFontSize * 3
                            anchors.verticalCenter: parent.verticalCenter
                            text: "<font color='white'>Speed Limit</font> <font color='red'>(Obstacle avoidance off)</font>"
                        }

                        ComboBox {
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            id: customComboBox
                            width: root.width / 7.2
                            height: parent.height / 1.8
                            model: ["18km/h", "36km/h"]

                            // 텍스트와 색상 스타일을 지정
                            contentItem: Text {
                                text: customComboBox.currentText
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
                        background: Rectangle {
                            color: transparent
                        }
                    }


                ToolSeparator {
                    width: parent.width
                        height: hToolSeparator
                        orientation: Qt.Horizontal
                    }

                    //Altitude Limit(25m ~ 800m)
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate / 3

                        Text  {
                            anchors.left: parent.left
                            color: white
                            text: "Altitude Limit(25m ~ 800m)"
                            font.pixelSize: defaultFontSize * 3
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        TextField {
                            anchors.right: parent.right
                            anchors.top: parent.top
                            font.pixelSize: defaultFontSize * 3
                            width: parent.width / 9.6
                            anchors.verticalCenter: parent.verticalCenter
                            height: parent.height / 1.8
                            color: white
                            background: Rectangle {
                                color: transparent
                                border.color: white
                            }
                        }

                        background: Rectangle {
                            color : transparent
                        }
                    }
                    ToolSeparator {
                        width: parent.width
                        height: hToolSeparator
                        orientation: Qt.Horizontal
                    }

                    //Distance Limit
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate / 3

                        Text  {
                            anchors.left: parent.left
                            color: white
                            text: "Distance Limit"
                            font.pixelSize: defaultFontSize * 3
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Switch{
                            id: distancecontrol
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            checked: false
                            indicator: Rectangle {
                                implicitWidth: defaultFontSize * 6
                                implicitHeight: defaultFontSize * 3
                                x: distancecontrol.width - width - distancecontrol.rightPadding
                                y: parent.height / 2 - height / 2
                                radius: 13
                                color: distancecontrol.checked ? blue : lightGray
                                border.color: white

                                Rectangle {
                                    x: distancecontrol.checked ? parent.width - width : 0
                                    width: defaultFontSize * 3
                                    height: defaultFontSize * 3
                                    radius: 50
                                    border.color: black
                                }
                            }

                            onCheckedChanged: {
                                if(checked){
                                    distanceSliderBar.visible = true
                                    flickAble.contentHeight = flickAble.contentHeight + distanceSliderBar.height
                                }
                                else {
                                    distanceSliderBar.visible = false
                                    flickAble.contentHeight = flickAble.contentHeight - distanceSliderBar.height
                                }
                            }
                        }

                        background: Rectangle {
                            color : transparent
                        }
                    }

                    //Distance Limit Slider
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate / 3
                        id: distanceSliderBar
                        visible: false

                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: parent.width / 7.2
                            color: white
                            text: "30"
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Slider {
                            orientation: Qt.Horizontal
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            value: 30
                            from: 30
                            to: 5000
                            width: parent.width / 2
                            id: distanceControl

                            onValueChanged: {
                                distanceLimitValue = distanceControl.value.toFixed(0);
                            }
                        }

                        Text {
                            anchors.right: parent.right
                            color: white
                            text: "5000"
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: parent.width / 4.8
                        }

                        TextField {
                            anchors.right: parent.right
                            font.pixelSize: defaultFontSize * 3
                            width: parent.width / 9.6
                            anchors.verticalCenter: parent.verticalCenter
                            height: parent.height / 1.8
                            color: white
                            inputMethodHints: Qt.ImhDigitsOnly

                            validator: IntValidator {bottom: 30; top: 5000;}
                            background: Rectangle {
                                color: transparent
                                border.color: white
                            }
                            text: distanceLimitValue

                            onTextChanged: {
                                distanceControl.value = text
                                distanceLimitValue = text
                            }
                        }

                        background: Rectangle {
                            color: transparent
                        }
                    }

                    ToolSeparator {
                        width: parent.width
                        height: hToolSeparator
                        orientation: Qt.Horizontal
                    }

                    //Ascent Speed Limit
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate / 3

                        Text  {
                            anchors.left: parent.left
                            color: white
                            text: "Ascent Speed Limit"
                            font.pixelSize: defaultFontSize * 3
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Switch{
                            id: ascentcontrol
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            checked: false
                            indicator: Rectangle {
                                implicitWidth: defaultFontSize * 6
                                implicitHeight: defaultFontSize * 3
                                x: ascentcontrol.width - width - ascentcontrol.rightPadding
                                y: parent.height / 2 - height / 2
                                radius: 13
                                color: ascentcontrol.checked ? blue : lightGray
                                border.color: white

                                Rectangle {
                                    x: ascentcontrol.checked ? parent.width - width : 0
                                    width: defaultFontSize * 3
                                    height: defaultFontSize * 3
                                    radius: 50
                                    border.color: black
                                }
                            }

                            onCheckedChanged: {
                                if(checked) {
                                    ascentSpeedSliderBar.visible = true
                                    flickAble.contentHeight = flickAble.contentHeight + ascentSpeedSliderBar.height
                                }
                                else {
                                    ascentSpeedSliderBar.visible = false
                                    flickAble.contentHeight = flickAble.contentHeight - ascentSpeedSliderBar.height
                                }
                            }
                        }

                        background: Rectangle {
                            color : transparent
                        }
                    }

                    // Ascent Speed Limit Slider
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate / 3
                        id: ascentSpeedSliderBar
                        visible: false

                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: parent.width / 7.2
                            color: white
                            text: "7"
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Slider {
                            orientation: Qt.Horizontal
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            value: 7
                            from: 7
                            to: 18
                            width: parent.width / 2
                            id: ascentSpeedLimitControl

                            onValueChanged: {
                                ascentSpeedLimitValue = ascentSpeedLimitControl.value.toFixed(0);
                            }
                        }

                        Text {
                            anchors.right: parent.right
                            color: white
                            text: "18"
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: parent.width / 4.8
                        }

                        TextField {
                            anchors.right: parent.right
                            font.pixelSize: defaultFontSize * 3
                            width: parent.width / 9.6
                            anchors.verticalCenter: parent.verticalCenter
                            height: parent.height / 1.8
                            color: white
                            inputMethodHints: Qt.ImhDigitsOnly

                            validator: IntValidator {bottom: 7; top: 18;}
                            background: Rectangle {
                                color: transparent
                                border.color: white
                            }
                            text: ascentSpeedLimitValue

                            onTextChanged: {
                                ascentSpeedLimitControl.value = text
                                ascentSpeedLimitValue = text
                            }
                        }

                        background: Rectangle {
                            color: transparent
                        }
                    }

                    ToolSeparator {
                        width: parent.width
                        height: hToolSeparator
                        orientation: Qt.Horizontal
                    }

                    //Decent Speed Limit
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate / 3

                        Text  {
                            anchors.left: parent.left
                            color: white
                            text: "Decent Speed Limit"
                            font.pixelSize: defaultFontSize * 3
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Switch{
                            id: decentcontrol
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            checked: false
                            indicator: Rectangle {
                                implicitWidth: defaultFontSize * 6
                                implicitHeight: defaultFontSize * 3
                                x: decentcontrol.width - width - decentcontrol.rightPadding
                                y: parent.height / 2 - height / 2
                                radius: 13
                                color: decentcontrol.checked ? blue : lightGray
                                border.color: white

                                Rectangle {
                                    x: decentcontrol.checked ? parent.width - width : 0
                                    width: defaultFontSize * 3
                                    height: defaultFontSize * 3
                                    radius: 50
                                    border.color: black
                                }
                            }
                            onCheckedChanged: {
                                if(checked){
                                    descentSpeedSliderBar.visible = true
                                    flickAble.contentHeight = flickAble.contentHeight + descentSpeedSliderBar.height
                                }
                                else {
                                    descentSpeedSliderBar.visible = false
                                        flickAble.contentHeight = flickAble.contentHeight - descentSpeedSliderBar.height
                                }
                            }
                        }

                        background: Rectangle {
                            color : transparent
                        }
                    }

                    //Descent Speed Limit Slider
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate / 3
                        id: descentSpeedSliderBar
                        visible: false

                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: parent.width / 7.2
                            color: white
                            text: "7"
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Slider {
                            orientation: Qt.Horizontal
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            value: 7
                            from: 7
                            to: 18
                            width: parent.width / 2
                            id: descentSpeedLimitControl

                            onValueChanged: {
                                descentSpeedLimitValue = descentSpeedLimitControl.value.toFixed(0);
                            }
                        }

                        Text {
                            anchors.right: parent.right
                            color: white
                            text: "18"
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: parent.width / 4.8
                        }

                        TextField {
                            anchors.right: parent.right
                            font.pixelSize: defaultFontSize * 3
                            width: parent.width / 9.6
                            anchors.verticalCenter: parent.verticalCenter
                            height: parent.height / 1.8
                            color: white
                            inputMethodHints: Qt.ImhDigitsOnly

                            validator: IntValidator {bottom: 7; top: 18;}
                            background: Rectangle {
                                color: transparent
                                border.color: white
                            }
                            text: descentSpeedLimitValue

                            onTextChanged: {
                                descentSpeedLimitControl.value = text
                                descentSpeedLimitValue = text
                            }
                        }
                        background: Rectangle {
                            color: transparent
                        }
                    }
                    ToolSeparator {
                        width: parent.width
                        height: hToolSeparator
                        orientation: Qt.Horizontal
                    }

                    //Compass Calibration
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate / 3

                        Text {
                            anchors.left: parent.left
                            color: white
                            text: "Compass Calibration"
                            font.pixelSize: defaultFontSize * 3
                            anchors.verticalCenter: parent.verticalCenter
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
                                console.log("Compass Calibration Window Click")
                                compassCalibrationPage.visible = true
                                parentQML.currentPageIndex = 1
                                parentQML.page1 = compassCalibrationPage
                                parentQML.previousTitle = parentQML.settingTitle

                                parentQML.settingTitle = "Compass Calibration"
                            }
                        }
                    }

                    ToolSeparator {
                        width: parent.width
                        height: hToolSeparator
                        orientation: Qt.Horizontal
                    }

                    //IMU Calibration
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate / 3

                        Text {
                            anchors.left: parent.left
                            color: white
                            text: "IMU Calibration"
                            font.pixelSize: defaultFontSize * 3
                            anchors.verticalCenter: parent.verticalCenter
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
                                console.log("IMU Calibration Window Click")
                                imuCalibrationPage.visible = true
                                parentQML.currentPageIndex = 1
                                parentQML.page1 = imuCalibrationPage
                                parentQML.previousTitle = parentQML.settingTitle

                                parentQML.settingTitle = "IMU Calibration"
                            }
                        }
                    }
                    ToolSeparator {
                        width: parent.width
                        height: hToolSeparator
                        orientation: Qt.Horizontal
                    }

                    //Advanced settings
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate / 3

                        Text {
                            anchors.left: parent.left
                            color: white
                            text: "Advanced settings"
                            font.pixelSize: defaultFontSize * 3
                            anchors.verticalCenter: parent.verticalCenter
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
                                console.log("Advanced settings Window Click")
                                advancedSettingsPage.visible = true
                                parentQML.currentPageIndex = 1
                                parentQML.page1 = advancedSettingsPage
                                parentQML.mainTitle = parentQML.settingTitle

                                parentQML.settingTitle = "Advanced Settings"
                            }
                        }
                    }
                }
            }
        }
    }
}
