import QtQuick          2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts  1.11
import QtQuick.Dialogs  1.3
import QtQuick.Window 2.0

import QGroundControl                       1.0
import QGroundControl.Controllers           1.0
import QGroundControl.Controls              1.0
import QGroundControl.FactControls          1.0
import QGroundControl.FactSystem            1.0
import QGroundControl.Palette               1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.SettingsManager       1.0
import QGroundControl.MultiVehicleManager   1.0
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

    property var  _ntripSource: QGroundControl.corePlugin.codevRTCMManager.rtcmSource


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

            Text {
                text: "Before calibrating you should zero all your trims and subtrims."
                color: white
                font.pixelSize: defaultFontSize * 3
            }

            Text {
                text: "Click \"Start Calibration\" to start Calibration"
                color: white
                font.pixelSize: defaultFontSize * 3
            }
        }
    }

    //Remote Control Calibration Page -> Start Calibrating
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
            anchors.fill: parent

            Item {
                width: 1
                height: parent.height / 30
            }

            ListView {
                orientation: Qt.Horizontal
                model: ["Mode 1", "Mode 2"]
                width: root.width / 4.48
                height: parent.height / 15
                id: listView
                anchors.horizontalCenter: parent.horizontalCenter
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

            Item {
                width: 1
                height: parent.height / 30
            }

            //Attitude Controls
            Text {
                text: "Attitude Controls"
                color: white
                font.pixelSize: defaultFontSize * 3
                anchors.left: parent.left
                anchors.leftMargin: parent.width / 20
            }

            Item {
                width: 1
                height: parent.height / 30
            }

            Row {
                width: parent.width
                Item {
                    width: parent.width / 7.2
                    height: 1
                }

                Text {
                    width: parent.width / 12
                    text: "Roll"
                    color: white
                    font.pixelSize: defaultFontSize * 3
                }

                Item {
                    width: parent.width / 18
                    height: 1
                }

                Slider {
                    orientation: Qt.Horizontal
                    value: 50
                    from: 0
                    to: 100
                    width: parent.width / 2
                }
            }

            Item {
                width: 1
                height: defaultFontSize
            }

            Row {
                width: parent.width
                Item {
                    width: parent.width / 7.2
                    height: 1
                }
                Text {
                    width: parent.width / 12
                    text: "Pitch"
                    color: white
                    font.pixelSize: defaultFontSize * 3
                }
                Item {
                    width: parent.width / 18
                    height: 1
                }

                Slider {
                    orientation: Qt.Horizontal
                    value: 50
                    from: 0
                    to: 100
                    width: parent.width / 2
                }

            }

            Item {
                width: 1
                height: defaultFontSize
            }

            Row {
                width: parent.width
                Item {
                    width: parent.width / 7.2
                    height: 1
                }

                Text {
                    width: parent.width / 12
                    text: "Yaw"
                    color: white
                    font.pixelSize: defaultFontSize * 3
                }

                Item {
                    width: parent.width / 18
                    height: 1
                }
                Slider {
                    orientation: Qt.Horizontal
                    value: 50
                    from: 0
                    to: 100
                    width: parent.width / 2
                }
            }

            Item {
                width: 1
                height: defaultFontSize
            }

            Row {
                width: parent.width
                Item {
                    width: parent.width / 7.2
                    height: 1
                }
                Text {
                    width: parent.width / 12
                    text: "Throttle"
                    color: white
                    font.pixelSize: defaultFontSize * 3
                }
                Item {
                    width: parent.width / 18
                    height: 1
                }

                Slider {
                    orientation: Qt.Horizontal
                    value: 50
                    from: 0
                    to: 100
                    width: parent.width / 2
                }
            }

            Item {
                width: 1
                height: parent.height / 18
            }

            //Channel Monitor
            Text {
                text: "Channel Monitor"
                color: white
                font.pixelSize: defaultFontSize * 3
                anchors.left: parent.left
                anchors.leftMargin: parent.width / 20
            }

            Item {
                width: 1
                height: parent.height / 30
            }

            Row {
                width: parent.width
                Item {
                    width: parent.width / 9.6
                    height: 1
                }

                Text {
                    width: parent.width / 48
                    text: "1"
                    color: white
                    font.pixelSize: defaultFontSize * 3
                }

                Item {
                    width: parent.width / 48
                    height: 1
                }

                Slider {
                    orientation: Qt.Horizontal
                    value: 50
                    from: 0
                    to: 100
                    width: parent.width / 2.88
                }
                Item {
                    width: parent.width / 48
                    height: 1
                }

                Text {
                    width: parent.width / 48
                    text: "2"
                    color: white
                    font.pixelSize: defaultFontSize * 3
                }
                Item {
                    width: parent.width / 48
                    height: 1
                }

                Slider {
                    orientation: Qt.Horizontal
                    value: 50
                    from: 0
                    to: 100
                    width: parent.width / 2.88
                }
            }

            Row {
                width: parent.width
                Item {
                    width: parent.width / 9.6
                    height: 1
                }
                Text {
                    width: parent.width / 48
                    text: "3"
                    color: white
                    font.pixelSize: defaultFontSize * 3
                }
                Item {
                    width: parent.width / 48
                    height: 1
                }
                Slider {
                    orientation: Qt.Horizontal
                    value: 50
                    from: 0
                    to: 100
                    width: parent.width / 2.88
                }
                Item {
                    width: parent.width / 48
                    height: 1
                }

                Text {
                    width: parent.width / 48
                    text: "4"
                    color: white
                    font.pixelSize: defaultFontSize * 3
                }
                Item {
                    width: parent.width / 48
                    height: 1
                }

                Slider {
                    orientation: Qt.Horizontal
                    value: 50
                    from: 0
                    to: 100
                    width: parent.width / 2.88
                }
            }

            Row {
                width: parent.width
                Item {
                    width: parent.width / 9.6
                    height: 1
                }
                Text {
                    width: parent.width / 48
                    text: "5"
                    color: white
                    font.pixelSize: defaultFontSize * 3
                }
                Item {
                    width: parent.width / 48
                    height: 1
                }

                Slider {
                    orientation: Qt.Horizontal
                    value: 50
                    from: 0
                    to: 100
                    width: parent.width / 2.88
                }
                Item {
                    width: parent.width / 48
                    height: 1
                }
                Text {
                    width: parent.width / 48
                    text: "6"
                    color: white
                    font.pixelSize: defaultFontSize * 3
                }

                Item {
                    width: parent.width / 48
                    height: 1
                }
                Slider {
                    orientation: Qt.Horizontal

                    value: 50
                    from: 0
                    to: 100
                    width: parent.width / 2.88
                }
            }

            Row {
                width: parent.width
                Item {
                    width: parent.width / 9.6
                    height: 1
                }
                Text {
                    width: parent.width / 48
                    text: "7"
                    color: white
                    font.pixelSize: defaultFontSize * 3
                }
                Item {
                    width: parent.width / 48
                    height: 1
                }

                Slider {
                    orientation: Qt.Horizontal
                    value: 50
                    from: 0
                    to: 100
                    width: parent.width / 2.88
                }
                Item {
                    width: parent.width / 48
                    height: 1
                }
                Text {
                    width: parent.width / 48
                    text: "8"
                    color: white
                    font.pixelSize: defaultFontSize * 3
                }

                Item {
                    width: parent.width / 48
                    height: 1
                }
                Slider {
                    orientation: Qt.Horizontal

                    value: 50
                    from: 0
                    to: 100
                    width: parent.width / 2.88
                }
            }

            Row {
                width: parent.width
                Item {
                    width: parent.width / 9.6
                    height: 1
                }
                Text {
                    width: parent.width / 48
                    text: "9"
                    color: white
                    font.pixelSize: defaultFontSize * 3
                }
                Item {
                    width: parent.width / 48
                    height: 1
                }

                Slider {
                    orientation: Qt.Horizontal

                    value: 50
                    from: 0
                    to: 100
                    width: parent.width / 2.88
                }
                Item {
                    width: parent.width / 48
                    height: 1
                }

                Text {
                    width: parent.width / 48
                    text: "10"
                    color: white
                    font.pixelSize: defaultFontSize * 3
                }
                Item {
                    width: parent.width / 48
                    height: 1
                }


                Slider {
                    orientation: Qt.Horizontal

                    value: 50
                    from: 0
                    to: 100
                    width: parent.width / 2.88
                }
            }

            Row {
                width: parent.width
                Item {
                    width: parent.width / 9.6
                    height: 1
                }
                Text {
                    width: parent.width / 48
                    text: "11"
                    color: white
                    font.pixelSize: defaultFontSize * 3
                }
                Item {
                    width: parent.width / 48
                    height: 1
                }

                Slider {
                    orientation: Qt.Horizontal

                    value: 50
                    from: 0
                    to: 100
                    width: parent.width / 2.88
                }
                Item {
                    width: parent.width / 48
                    height: 1
                }
                Text {
                    width: parent.width / 48
                    text: "12"
                    color: white
                    font.pixelSize: defaultFontSize * 3
                }
                Item {
                    width: parent.width / 48
                    height: 1
                }

                Slider {
                    orientation: Qt.Horizontal

                    value: 50
                    from: 0
                    to: 100
                    width: parent.width / 2.88
                }
            }

            Row {
                width: parent.width
                Item {
                    width: parent.width / 9.6
                    height: 1
                }
                Text {
                    width: parent.width / 48
                    text: "13"
                    color: white
                    font.pixelSize: defaultFontSize * 3
                }
                Item {
                    width: parent.width / 48
                    height: 1
                }

                Slider {
                    orientation: Qt.Horizontal

                    value: 50
                    from: 0
                    to: 100
                    width: parent.width / 2.88
                }
                Item {
                    width: parent.width / 48
                    height: 1
                }
                Text {
                    width: parent.width / 48
                    text: "14"
                    color: white
                    font.pixelSize: defaultFontSize * 3
                }

                Item {
                    width: parent.width / 48
                    height: 1
                }
                Slider {
                    orientation: Qt.Horizontal

                    value: 50
                    from: 0
                    to: 100
                    width: parent.width / 2.88
                }
            }

            Row {
                width: parent.width
                Item {
                    width: parent.width / 9.6
                    height: 1
                }
                Text {
                    width: parent.width / 48
                    text: "15"
                    color: white
                    font.pixelSize: defaultFontSize * 3
                }
                Item {
                    width: parent.width / 48
                    height: 1
                }
                Slider {
                    orientation: Qt.Horizontal
                    value: 50
                    from: 0
                    to: 100
                    width: parent.width / 2.88

                }
                Item {
                    width: parent.width / 48
                    height: 1
                }
                Text {
                    width: parent.width / 48
                    text: "16"
                    color: white
                    font.pixelSize: defaultFontSize * 3
                }

                Item {
                    width: parent.width / 48
                    height: 1
                }
                Slider {
                    orientation: Qt.Horizontal

                    value: 50
                    from: 0
                    to: 100
                    width: parent.width / 2.88
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
        Row {
            width: parent.width
            height: parent.height / 3
            property int selectedMode: 0
            id: rootGrid            

            // Mode 1 Button
            Button {
                width: parent.width / 2
                height: parent.height
                background: Rectangle {
                    color: transparent
                }

                contentItem: Column {
                    anchors.centerIn: parent

                    Text {
                        text: "Mode 1"
                        font.pixelSize: defaultFontSize * 4
                        color: rootGrid.selectedMode == 0 ? blue : white  // Mode 1이 선택되면 텍스트 색상 변경
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width / 72
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

            Rectangle {
                width: 1
                height: parent.height * 1.1
                color: white
                id: middleLine
            }

            // Mode 2 Button
            Button {
                width: parent.width / 2
                height: parent.height
                background: Rectangle {
                    color: transparent
                }

                contentItem: Column {
                    anchors.centerIn: parent

                    Text {
                        text: "Mode 2"
                        font.pixelSize: defaultFontSize * 4
                        color: rootGrid.selectedMode == 1 ? blue : white  // Mode 2이 선택되면 텍스트 색상 변경
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width / 72
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

            Rectangle {
                width: parent.width
                height: 1
                color: white
                anchors.top: parent.top
                anchors.topMargin: rootGrid.height * 1.1
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
                height: parent.height / 1.5
                width: height
            }

//            Row {
//                anchors.horizontalCenter: parent.horizontalCenter
//                Text {
//                    text: "When the remote control is off, Press the power button "
//                    color: white
//                    font.pixelSize: defaultFontSize * 3
//                }
//                Image {
//                    source: "qrc:/res/StartButton.svg"
//                    width: parent.width / 20
//                    height: width / 2
//                    anchors.verticalCenter: parent.verticalCenter
//                }
//                Text {
//                    text: " 6 times"
//                    color: white
//                    font.pixelSize: defaultFontSize * 3
//                }
//            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "1. Press the power button on the top of the drone briefly to turn on the drone.\n\n2. When the drone is powered on, a green light will turn on."
                color: white
                font.pixelSize: defaultFontSize * 3
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
                    id: rtcmMaxHzComboBox
                    width: root.width / 7.2
                    height: root.height / 22.5
                    model:["4Hz", "5Hz", "10Hz", "20Hz", "50Hz"]

                    // contentItem: ComboBox에서 보여줄 값
                    contentItem: Text {
                        // currentIndex의 model 데이터에 접근하여 text 속성을 가져옴
                        text: rtcmMaxHzComboBox.currentText
                        color: blue
                        font.pixelSize: defaultFontSize * 3
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignLeft
                        padding: defaultFontSize
                    }

                    // 오른쪽의 화살표 표시를 커스텀
                    indicator: Item {
                        anchors.fill: parent
                        Image {
                            source: "qrc:/res/ales/waypoint/DownDir.svg"
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    // 아이템 선택 시 실제 내제된 값에 접근
                    onCurrentIndexChanged: {
                        var selectedValue = 250;

                        switch(currentIndex) {
                        case 0:
                            selectedValue = 250
                            break;
                        case 1:
                            selectedValue = 200
                            break;
                        case 2:
                            selectedValue = 100
                            break;
                        case 3:
                            selectedValue = 50
                            break;
                        case 4:
                            selectedValue = 20
                            break;
                        default:
                            selectedValue = 250
                            break;
                        }

                        if(_ntripSource !== null && _ntripSource !== undefined){
                            if(_ntripSource.sendMaxRTCMHz !== null && _ntripSource.sendMaxRTCMHz !== undefined) {
                                _ntripSource.sendMaxRTCMHz.rawValue = selectedValue;
                                console.log("NTRIP sendMaxRTCMHz : ", _ntripSource.sendMaxRTCMHz.rawValue);
                            }
                            else {
                                console.log("Error _ntripSource.sendMaxRTCMHz is null or undefined");
                            }
                        }
                        else {
                            console.log("Error : _ntripSource is null or undefined");
                        }
                    }

                    background: Rectangle {
                        color: transparent
                        border.color: lightGray
                        radius: 5
                    }
                }

//                FactComboBox {
//                    fact : _ntripSource ? _ntripSource.sendMaxRTCMHz : null
//                    indexModel: false
//                    width: root.width / 7.2
//                    height: root.height / 22.5
//                }
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

                    onTextChanged: {
                        if(_ntripSource !== null && _ntripSource !== undefined){
                            if(_ntripSource.host !== null && _ntripSource.host !== undefined) {
                                _ntripSource.host.rawValue = text;
                                console.log("NTRIP Host : ", _ntripSource.host.rawValue);
                            }
                            else {
                                console.log("Error _ntripSource.host is null or undefined");
                            }
                        }
                        else {
                            console.log("Error : _ntripSource is null or undefined");
                        }
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

                    onTextChanged: {
                        if(_ntripSource !== null && _ntripSource !== undefined){
                            if(_ntripSource.port !== null && _ntripSource.port !== undefined) {
                                _ntripSource.port.rawValue = text;
                                console.log("NTRIP port : ", _ntripSource.port.rawValue);
                            }
                            else {
                                console.log("Error _ntripSource.port is null or undefined");
                            }
                        }
                        else {
                            console.log("Error : _ntripSource is null or undefined");
                        }
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

                    onTextChanged: {
                        if(_ntripSource !== null && _ntripSource !== undefined){
                            if(_ntripSource.mountpoint !== null && _ntripSource.mountpoint !== undefined) {
                                _ntripSource.mountpoint.rawValue = text;
                                console.log("NTRIP mountpoint : ", _ntripSource.mountpoint.rawValue);
                            }
                            else {
                                console.log("Error _ntripSource.mountpoint is null or undefined");
                            }
                        }
                        else {
                            console.log("Error : _ntripSource is null or undefined");
                        }
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
                    onTextChanged: {
                        if(_ntripSource !== null && _ntripSource !== undefined){
                            if(_ntripSource.user !== null && _ntripSource.user !== undefined) {
                                _ntripSource.user.rawValue = text;
                                console.log("NTRIP user : ", _ntripSource.user.rawValue);
                            }
                            else {
                                console.log("Error _ntripSource.user is null or undefined");
                            }
                        }
                        else {
                            console.log("Error : _ntripSource is null or undefined");
                        }
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

                    onTextChanged: {
                        if(_ntripSource !== null && _ntripSource !== undefined){
                            if(_ntripSource.passwd !== null && _ntripSource.passwd !== undefined) {
                                _ntripSource.passwd.rawValue = text;
                                console.log("NTRIP passwd : ", _ntripSource.passwd.rawValue);
                            }
                            else {
                                console.log("Error _ntripSource.passwd is null or undefined");
                            }
                        }
                        else {
                            console.log("Error : _ntripSource is null or undefined");
                        }
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
                    //text: _ntripSource.isLogIn ? qsTr("Log out") : qsTr("Log in")
                    text: _ntripSource && _ntripSource.isLogIn ? qsTr("Log out") : qsTr("Log in")
                    anchors.centerIn: parent
                }
                background: Rectangle {
                    color: lightGray
                }

                onClicked: {
                    onTextChanged: {
                        if(_ntripSource !== null && _ntripSource !== undefined){
                            if(_ntripSource.isLogIn !== null && _ntripSource.isLogIn !== undefined) {
                                if(!_ntripSource.isLogIn)
                                    _ntripSource.logIn()
                                else _ntripSource.logOut()
                                console.log("NTRIP isLogIn : ", _ntripSource.isLogIn.rawValue);
                            }
                            else {
                                console.log("Error _ntripSource.isLogIn is null or undefined");
                            }
                        }
                        else {
                            console.log("Error : _ntripSource is null or undefined");
                        }
                    }
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
            visible: false
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

                    QGroundControl.corePlugin.codevSettings.rtcmSource.rawValue = 1
                }
            }
        }
        ToolSeparator {
            width: parent.width
            height: hToolSeparator
            orientation: Qt.Horizontal
            visible: false
        }
    }
}
