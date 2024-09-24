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
    property color red : "red"
    property color lightGray: "#4a4a4a"
    property color lightGray2: "#CAC8C8"
    property color orange : "#E89F33"
    property color lightGreen: "lightGreen"
    property color transparent: "transparent"
    property int hItemDelegate: Screen.height / 11.25;
    property int hSwitchDelegate: Screen.height / 15;
    property int hToolSeparator: defaultFontSize + 3;
    property int leftMargin: 20;

    //Size Property
    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize
    z: 3
    property var parentQML : null    

    //Restore "Do Not Show Again" Page
    Rectangle {
        id: doNotShowAgainPage
        z: 4
        visible: false
        color: "#3C3C3C"
        width: parent.width / 2.4  // 600
        height: parent.height / 2.4 // 375
        anchors.centerIn: parent
        radius: 5
        MouseArea {
            anchors.fill: parent
        }

        Column {
            anchors.fill: parent
            Rectangle {
                width: parent.width
                height: parent.height / 6
                color: transparent

                Row {
                    anchors.centerIn: parent
                    spacing: parent.width / 25
                    Image {
                        source: "qrc:/res/QuestionMark.svg"
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    Text {
                        text: "Question"
                        color: white
                        font.pixelSize: defaultFontSize * 3
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: white
            }

            Rectangle {
                width: parent.width
                height: parent.height / 1.5
                color: transparent

                Text {
                    color: white
                    font.pixelSize: defaultFontSize * 3
                    text: "Are you sure you want to restore\n\"Do Not Show Again\"?"
                    anchors.centerIn: parent
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: white
            }

            Rectangle {
                width: parent.width
                height: parent.height / 6
                color: transparent

                Row {
                    anchors.fill: parent

                    Button {
                        width: parent.width / 2
                        height: parent.height
                        background: Rectangle {
                            color: transparent
                        }
                        Text {
                            color: blue
                            font.pixelSize: defaultFontSize * 3
                            text: "Cancel"
                            anchors.centerIn: parent
                        }
                        onClicked: {
                            doNotShowAgainPage.visible = false
                        }
                    }
                    Rectangle {
                        width: 1
                        height: parent.height
                        color: white
                    }
                    Button {
                        width: parent.width / 2
                        height: parent.height
                        background: Rectangle{
                            color: transparent
                        }
                        Text{
                            color: blue
                            font.pixelSize: defaultFontSize * 3
                            text: "OK"
                            anchors.centerIn: parent
                        }
                    }
                }
            }
        }
    }

    // Select Language
    Rectangle {
        id: selectLanguagepage
        width: parent.width
        height: parent.height
        z: 4
        color: transparent
        clip: true
        visible: false

        ListView {
            id: listView
            width: selectLanguagepage.width
            height: selectLanguagepage.height
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            // 모델에 텍스트만 추가
            model: ["English\n\nEnglish","简体中文\n\nSimplified Chinese","繁體中文\n\nTraditional Chinese","日本語\n\nJapanese",
                "italiano\n\nItalian","한국어\n\nKorean","ไทย\n\nThai","Español\n\nSpanish"]

            delegate: Rectangle {
                width: selectLanguagepage.width
                height: selectLanguagepage.height / 6
                color: black
                border.color: lightGray

                Row {
                    anchors.fill: parent
                    anchors.margins: defaultFontSize

                    // 텍스트 표시
                    Item {
                        width: parent.width / 14.4
                        height: 1
                    }

                    Text {
                        text: modelData  // 텍스트는 model의 데이터만 사용
                        font.pixelSize: defaultFontSize * 2
                        color: white
                        anchors.verticalCenter: parent.verticalCenter
                        width: parent.width / 1.2
                    }

                    // 공통 이미지 표시 (선택된 아이템에서만 보이게 설정)
                    Image {
                        source: "qrc:/res/Done.svg"  // 공통 이미지 경로
                        visible: listView.currentIndex == index  // 선택된 아이템에서만 보이게 설정
                        width: selectLanguagepage.height / 12  // 이미지 크기 조정
                        height: selectLanguagepage.height / 12
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        listView.currentIndex = index  // 아이템 선택 시 currentIndex 업데이트
                    }
                }
            }
        }
    }

    //About
    Rectangle {
        id: aboutPage
        width: parent.width
        height: parent.height
        z: 4
        color: black
        visible: false
        MouseArea {
            anchors.fill: parent
        }
        Column {
            anchors.fill: parent

            //App Version
            ItemDelegate {
                width: parent.width
                height: hItemDelegate

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width / 24
                    anchors.verticalCenter: parent.verticalCenter
                    color: white
                    font.pixelSize: defaultFontSize * 3
                    text: "App Version"
                }

                Text {
                    anchors.right: parent.right
                    anchors.rightMargin: parent.width / 12
                    anchors.verticalCenter: parent.verticalCenter
                    color: white
                    font.pixelSize: defaultFontSize * 3
                    text: "V2.0.21"
                }
                Image {
                    source: "qrc:/res/ales/waypoint/RightDir.svg"
                    anchors.right: parent.right
                    anchors.rightMargin: parent.width / 24
                    anchors.verticalCenter: parent.verticalCenter
                }

                background: Rectangle {
                    color: transparent
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        appVersionPage.visible = true
                        parentQML.currentPageIndex = 2
                        parentQML.page2 = appVersionPage
                        parentQML.previousTitle = parentQML.settingTitle
                    }
                }
            }
            ToolSeparator {
                width: parent.width
                height: hToolSeparator
                orientation: Qt.Horizontal
            }

            //Firmware Version
            ItemDelegate {
                width: parent.width
                height: hItemDelegate

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width / 24
                    anchors.verticalCenter: parent.verticalCenter
                    color: white
                    text: "Firmware Version"
                    font.pixelSize: defaultFontSize * 3
                }

                Image {
                    source: "qrc:/res/ales/waypoint/RightDir.svg"
                    anchors.right: parent.right
                    anchors.rightMargin: parent.width / 24
                    anchors.verticalCenter: parent.verticalCenter
                }
                background: Rectangle {
                    color: transparent
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        firmwareVersionPage.visible = true
                        parentQML.currentPageIndex = 2
                        parentQML.page2 =firmwareVersionPage
                        parentQML.previousTitle =parentQML.settingTitle
                    }
                }
            }
            ToolSeparator {
                width: parent.width
                height: hToolSeparator
                orientation: Qt.Horizontal
            }

            //Drone S/N
            ItemDelegate {
                width: parent.width
                height: hItemDelegate

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width / 24
                    anchors.verticalCenter: parent.verticalCenter
                    color: white
                    text: "Drone S/N"
                    font.pixelSize: defaultFontSize * 3
                }

                Text {
                    anchors.right: parent.right
                    anchors.rightMargin: parent.width / 24
                    anchors.verticalCenter: parent.verticalCenter
                    color: white
                    font.pixelSize: defaultFontSize * 3
                    text: "HV5920262086"
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

            //Remote Controller S/N
            ItemDelegate {
                width: parent.width
                height: hItemDelegate

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width / 24
                    anchors.verticalCenter: parent.verticalCenter
                    color: white
                    text: "Remote Controller S/N"
                    font.pixelSize: defaultFontSize * 3
                }

                Text {
                    anchors.right: parent.right
                    anchors.rightMargin: parent.width / 24
                    anchors.verticalCenter: parent.verticalCenter
                    color: white
                    font.pixelSize: defaultFontSize * 3
                    text: "RHT9202262513"
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

            //Gimbal S/N
            ItemDelegate {
                width: parent.width
                height: hItemDelegate

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width / 24
                    anchors.verticalCenter: parent.verticalCenter
                    color: white
                    text: "Gimbal S/N"
                    font.pixelSize: defaultFontSize * 3
                }

                Text {
                    anchors.right: parent.right
                    anchors.rightMargin: parent.width / 24
                    anchors.verticalCenter: parent.verticalCenter
                    color: white
                    font.pixelSize: defaultFontSize * 3
                    text: "G8K920281784"
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

    //About -> App Version
    Rectangle {
        id: appVersionPage
        width: parent.width
        height: parent.height
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
                height: parent.height / 9
            }

            Image {
                source: "qrc:/res/ArgosLogo.png"
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Item {
                width: 1
                height: parent.height / 18
            }

            Text {
                text: "ARGOSDYNE ALES QGC V2"
                color: white
                font.pixelSize: defaultFontSize * 3
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Item {
                width: 1
                height: parent.height / 18
            }

            Text {
                text: "V2.0.21"
                color: white
                font.pixelSize: defaultFontSize * 3
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Item {
                width: 1
                height: parent.height / 4.5
            }

            Text {
                text: "https://argosdyne.com"
                color: blue
                font.pixelSize: defaultFontSize * 3
                anchors.horizontalCenter: parent.horizontalCenter

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        Qt.openUrlExternally("https://argosdyne.com")
                    }
                }
            }

            Item {
                width: 1
                height: parent.height / 18
            }

            Text {
                text: "Copyright © 2024 ARGOSDYNE. ALL Rights Reserved."
                color: white
                font.pixelSize: defaultFontSize * 2
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    //About -> Firmware Version
    Rectangle {
        id: firmwareVersionPage
        width: parent.width
        height: parent.height
        z: 4
        color: black
        visible: false
        clip: true
        MouseArea {
            anchors.fill: parent
        }

        Flickable {
            id: flickAble
            anchors.fill: parent
            contentWidth: parent.width
            contentHeight: firmwareVersionPage.height * 1.56 // 14개의 Rectangle이 들어갈 전체 높이
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            Column {
                id: column
                width: flickAble.width
                spacing: 0

                Rectangle {
                    width: parent.width
                    height: firmwareVersionPage.height / 9
                    color: transparent

                    Text {
                        color: white
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width / 24
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: defaultFontSize * 3
                        text: "Flight Control"
                    }

                    Text {
                        color: white
                        anchors.right: parent.right
                        anchors.rightMargin: parent.width / 24
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: defaultFontSize * 3
                        text: "V0.0.4.57"
                    }
                }
                Rectangle {
                    width: parent.width
                    height: firmwareVersionPage.height / 9
                    color: transparent

                    Text {
                        color: white
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width / 24
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: defaultFontSize * 3
                        text: "Camera"
                    }

                    Text {
                        color: white
                        anchors.right: parent.right
                        anchors.rightMargin: parent.width / 24
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: defaultFontSize * 3
                        text: "V0.2.32.32"
                    }
                }
                Rectangle {
                    width: parent.width
                    height: firmwareVersionPage.height / 9
                    color: transparent

                    Text {
                        color: white
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width / 24
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: defaultFontSize * 3
                        text: "Remote Control"
                    }

                    Text {
                        color: white
                        anchors.right: parent.right
                        anchors.rightMargin: parent.width / 24
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: defaultFontSize * 3
                        text: "V0.2.0.4.12"
                    }
                }
                Rectangle {
                    width: parent.width
                    height: firmwareVersionPage.height / 9
                    color: transparent

                    Text {
                        color: white
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width / 24
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: defaultFontSize * 3
                        text: "Remote Control Panel"
                    }

                    Text {
                        color: white
                        anchors.right: parent.right
                        anchors.rightMargin: parent.width / 24
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: defaultFontSize * 3
                        text: "V3.0.13.0"
                    }
                }
                Rectangle {
                    width: parent.width
                    height: firmwareVersionPage.height / 9
                    color: transparent

                    Text {
                        color: white
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width / 24
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: defaultFontSize * 3
                        text: "Image Transmission"
                    }

                    Text {
                        color: white
                        anchors.right: parent.right
                        anchors.rightMargin: parent.width / 24
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: defaultFontSize * 3
                        text: "V1.1.1.47"
                    }
                }
                Rectangle {
                    width: parent.width
                    height: firmwareVersionPage.height / 9
                    color: transparent

                    Text {
                        color: white
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width / 24
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: defaultFontSize * 3
                        text: "Remote Control Image Transmission"
                    }

                    Text {
                        color: white
                        anchors.right: parent.right
                        anchors.rightMargin: parent.width / 24
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: defaultFontSize * 3
                        text: "V1.1.1.47"
                    }
                }
                Rectangle {
                    width: parent.width
                    height: firmwareVersionPage.height / 9
                    color: transparent

                    Text {
                        color: white
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width / 24
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: defaultFontSize * 3
                        text: "Gimbal"
                    }

                    Text {
                        color: white
                        anchors.right: parent.right
                        anchors.rightMargin: parent.width / 24
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: defaultFontSize * 3
                        text: "V0.1.55.0"
                    }
                }
                Rectangle {
                    width: parent.width
                    height: firmwareVersionPage.height / 9
                    color: transparent

                    Text {
                        color: white
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width / 24
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: defaultFontSize * 3
                        text: "Battery"
                    }

                    Text {
                        color: white
                        anchors.right: parent.right
                        anchors.rightMargin: parent.width / 24
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: defaultFontSize * 3
                        text: "V0.0.22.0"
                    }
                }
                Rectangle {
                    width: parent.width
                    height: firmwareVersionPage.height / 9
                    color: transparent

                    Text {
                        color: white
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width / 24
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: defaultFontSize * 3
                        text: "Vision Module"
                    }

                    Text {
                        color: white
                        anchors.right: parent.right
                        anchors.rightMargin: parent.width / 24
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: defaultFontSize * 3
                        text: "V0.2.32.32"
                    }
                }
                Rectangle {
                    width: parent.width
                    height: firmwareVersionPage.height / 9
                    color: transparent

                    Text {
                        color: white
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width / 24
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: defaultFontSize * 3
                        text: "Sonar"
                    }

                    Text {
                        color: white
                        anchors.right: parent.right
                        anchors.rightMargin: parent.width / 24
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: defaultFontSize * 3
                        text: "V1.1.1.1"
                    }
                }
                Rectangle {
                    width: parent.width
                    height: firmwareVersionPage.height / 9
                    color: transparent

                    Text {
                        color: white
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width / 24
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: defaultFontSize * 3
                        text: "ESC1"
                    }

                    Text {
                        color: white
                        anchors.right: parent.right
                        anchors.rightMargin: parent.width / 24
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: defaultFontSize * 3
                        text: "V1.1.1.1"
                    }
                }
                Rectangle {
                    width: parent.width
                    height: firmwareVersionPage.height / 9
                    color: transparent

                    Text {
                        color: white
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width / 24
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: defaultFontSize * 3
                        text: "ESC2"
                    }

                    Text {
                        color: white
                        anchors.right: parent.right
                        anchors.rightMargin: parent.width / 24
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: defaultFontSize * 3
                        text: "V1.1.1.1"
                    }
                }
                Rectangle {
                    width: parent.width
                    height: firmwareVersionPage.height / 9
                    color: transparent

                    Text {
                        color: white
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width / 24
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: defaultFontSize * 3
                        text: "ESC3"
                    }

                    Text {
                        color: white
                        anchors.right: parent.right
                        anchors.rightMargin: parent.width / 24
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: defaultFontSize * 3
                        text: "V1.1.1.1"
                    }
                }
                Rectangle {
                    width: parent.width
                    height: firmwareVersionPage.height / 9
                    color: transparent

                    Text {
                        color: white
                        anchors.left: parent.left
                        anchors.leftMargin: parent.width / 24
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: defaultFontSize * 3
                        text: "ESC4"
                    }

                    Text {
                        color: white
                        anchors.right: parent.right
                        anchors.rightMargin: parent.width / 24
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: defaultFontSize * 3
                        text: "V1.1.1.1"
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

        //Home Point
        ItemDelegate {
            width: parent.width
            height: hItemDelegate

            Row {
                anchors.fill: parent

                Item {
                    width: parent.width / 24
                    height: 1
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    color: white
                    text: "Home Point"
                    font.pixelSize: defaultFontSize * 3
                }

                Item {
                    width: parent.width / 2.88
                    height: 1
                }

                Button {
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width / 9.6
                    height: parent.height / 1.6

                    background: Rectangle {
                        color: transparent
                        border.color: lightGray2
                    }

                    Text {
                        color: white
                        font.pixelSize: defaultFontSize * 3
                        anchors.centerIn: parent
                        text: "Me"
                    }
                }

                Item {
                    width: parent.width / 48
                    height: 1
                }

                Button{
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width / 9.6
                    height: parent.height / 1.6

                    background: Rectangle {
                        color: transparent
                        border.color: lightGray2
                    }

                    Text {
                        color: white
                        font.pixelSize: defaultFontSize * 3
                        anchors.centerIn: parent
                        text: "Drone"
                    }
                }

                Item {
                    width: parent.width / 48
                    height: 1
                }

                Button{
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width / 5.76
                    height: parent.height / 1.6

                    background: Rectangle {
                        color: transparent
                        border.color: lightGray2
                    }

                    Text {
                        color: white
                        font.pixelSize: defaultFontSize * 3
                        anchors.centerIn: parent
                        text: "Customized"
                    }
                }
            }
        }
        ToolSeparator {
            width: parent.width
            height: hToolSeparator
            orientation: Qt.Horizontal
        }

        //Units
        ItemDelegate {
            width: parent.width
            height: hItemDelegate

            Text {
                anchors.left: parent.left
                anchors.leftMargin: parent.width / 24
                font.pixelSize: defaultFontSize * 3
                anchors.verticalCenter: parent.verticalCenter
                text: "Units"
                color: white
            }

            ComboBox {
                anchors.right: parent.right
                anchors.rightMargin: parent.width / 24
                anchors.verticalCenter: parent.verticalCenter
                id: unitComboBox
                width: parent.width / 4.8
                height: parent.height / 1.8
                model: ["Metric (km/h)", "Metric (m/s)", "Imperial (mph)"]

                // 텍스트와 색상 스타일을 지정
                contentItem: Text {
                    text: unitComboBox.currentText
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

        //Show Drone Coordinates
        ItemDelegate {
            width: parent.width
            height: hItemDelegate

            Text {
                anchors.left: parent.left
                anchors.leftMargin: parent.width / 24
                font.pixelSize: defaultFontSize * 3
                anchors.verticalCenter: parent.verticalCenter
                text: "Show Drone Coordinates"
                color: white
            }

            ComboBox {
                anchors.right: parent.right
                anchors.rightMargin: parent.width / 24
                anchors.verticalCenter: parent.verticalCenter
                id: coordinateComboBox
                width: parent.width / 4.8
                height: parent.height / 1.8
                model: ["None", "GPS", "UTM", "DMS"]

                // 텍스트와 색상 스타일을 지정
                contentItem: Text {
                    text: coordinateComboBox.currentText
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

        // Voiceovers
        ItemDelegate {
            width: parent.width
            height: hItemDelegate

            Text {
                anchors.left: parent.left
                color: white
                text: "Voiceovers"
                font.pixelSize: defaultFontSize * 3.3
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: parent.width / 24
            }

            Switch{
                id: voiceOverscontrol
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: parent.width / 24
                checked: false
                indicator: Rectangle {
                    implicitWidth: defaultFontSize * 6
                    implicitHeight: defaultFontSize * 3
                    x: voiceOverscontrol.width - width - voiceOverscontrol.rightPadding
                    y: parent.height / 2 - height / 2
                    radius: 13
                    color: voiceOverscontrol.checked ? blue : lightGray
                    border.color: white

                    Rectangle {
                        x: voiceOverscontrol.checked ? parent.width - width : 0
                        width: defaultFontSize * 3
                        height: defaultFontSize * 3
                        radius: 50
                        border.color: black
                    }
                }
                onCheckedChanged: {

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

        //Obstacle Avoidance notification sound
        ItemDelegate {
            width: parent.width
            height: hItemDelegate

            Text {
                anchors.left: parent.left
                color: white
                text: "Obstacle Avoidance notification sound"
                font.pixelSize: defaultFontSize * 3.3
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: parent.width / 24
            }

            Switch{
                id: obstacleAvoidanceSoundcontrol
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: parent.width / 24
                checked: false
                indicator: Rectangle {
                    implicitWidth: defaultFontSize * 6
                    implicitHeight: defaultFontSize * 3
                    x: obstacleAvoidanceSoundcontrol.width - width - obstacleAvoidanceSoundcontrol.rightPadding
                    y: parent.height / 2 - height / 2
                    radius: 13
                    color: obstacleAvoidanceSoundcontrol.checked ? blue : lightGray
                    border.color: white

                    Rectangle {
                        x: obstacleAvoidanceSoundcontrol.checked ? parent.width - width : 0
                        width: defaultFontSize * 3
                        height: defaultFontSize * 3
                        radius: 50
                        border.color: black
                    }
                }
                onCheckedChanged: {
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

        // Restore "Do Not Show Again"
        ItemDelegate {
            width: parent.width
            height: hItemDelegate

            Text {
                anchors.left: parent.left
                color: white
                text: "Restore \"Do Not Show Again\""
                font.pixelSize: defaultFontSize * 3.3
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: parent.width / 24
            }

            Text {
                anchors.right: parent.right
                anchors.rightMargin: parent.width / 24
                anchors.verticalCenter: parent.verticalCenter
                color: blue
                font.pixelSize: defaultFontSize * 3.3
                text: "Reset"
            }

            background: Rectangle {
                color: transparent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    doNotShowAgainPage.visible = true
                }
            }
        }
        ToolSeparator {
            width: parent.width
            height: hToolSeparator
            orientation: Qt.Horizontal
        }

        //Select Language
        ItemDelegate {
            width: parent.width
            height: hItemDelegate

            Text {
                anchors.left: parent.left
                color: white
                text: "Select Language"
                font.pixelSize: defaultFontSize * 3.3
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: parent.width / 24
            }

            Image {
                source : "qrc:/res/ales/waypoint/RightDir.svg"
                anchors.right: parent.right
                anchors.rightMargin: parent.width / 24
                anchors.verticalCenter: parent.verticalCenter
            }

            background: Rectangle {
                color: transparent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    selectLanguagepage.visible = true
                    parentQML.currentPageIndex = 1
                    parentQML.page1 = selectLanguagepage
                    parentQML.mainTitle = parentQML.settingTitle
                    parentQML.settingTitle = "Select Language"
                }
            }
        }
        ToolSeparator {
            width: parent.width
            height: hToolSeparator
            orientation: Qt.Horizontal
        }

        // About
        ItemDelegate {
            width: parent.width
            height: hItemDelegate

            Text {
                anchors.left: parent.left
                color: white
                text: "About"
                font.pixelSize: defaultFontSize * 3.3
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: parent.width / 24
            }

            Image {
                source : "qrc:/res/ales/waypoint/RightDir.svg"
                anchors.right: parent.right
                anchors.rightMargin: parent.width / 24
                anchors.verticalCenter: parent.verticalCenter
            }

            background: Rectangle {
                color: transparent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    aboutPage.visible = true
                    parentQML.currentPageIndex = 1
                    parentQML.page1 = aboutPage
                    parentQML.mainTitle = parentQML.settingTitle
                    parentQML.settingTitle = "About"
                }
            }
        }
    }
}
