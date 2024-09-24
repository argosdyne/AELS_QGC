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
    property int hItemDelegate: Screen.height / 9;
    property int hSwitchDelegate: Screen.height / 15;
    property int hToolSeparator: defaultFontSize + 3;
    property int leftMargin: 20;

    //Size Property
    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize
    z: 3
    property var parentQML : null    


    // Main Page
    Column {
        anchors.fill: parent
        width: parent.width
        height: parent.height      

        //Live On Off
        ItemDelegate {
            width: parent.width
            height: hItemDelegate

            Text {
                anchors.left: parent.left
                color: white
                text: "Live"
                font.pixelSize: defaultFontSize * 3.3
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: parent.width / 24
            }

            Switch{
                id: liveOnOffcontrol
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: parent.width / 24
                checked: false
                indicator: Rectangle {
                    implicitWidth: defaultFontSize * 6
                    implicitHeight: defaultFontSize * 3
                    x: liveOnOffcontrol.width - width - liveOnOffcontrol.rightPadding
                    y: parent.height / 2 - height / 2
                    radius: 13
                    color: liveOnOffcontrol.checked ? blue : lightGray
                    border.color: white

                    Rectangle {
                        x: liveOnOffcontrol.checked ? parent.width - width : 0
                        width: defaultFontSize * 3
                        height: defaultFontSize * 3
                        radius: 50
                        border.color: black
                    }
                }
                onCheckedChanged: {
                    if(checked){
                        liveOnPage.visible = true
                    }
                    else {
                        liveOnPage.visible = false
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

        //Total
        Column {
            id: liveOnPage
            width: parent.width
            height: (hItemDelegate * 4) + (hToolSeparator * 4)
            visible: false

            //Live Streaming Mode
            ItemDelegate {
                width: parent.width
                height: hItemDelegate

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width / 24
                    anchors.verticalCenter: parent.verticalCenter
                    color: white
                    text: "Live Streaming Mode"
                    font.pixelSize: defaultFontSize * 3
                }

                Row {
                    anchors.right: parent.right
                    anchors.rightMargin: parent.width / 24
                    spacing : defaultFontSize
                    width: parent.width / 4.8
                    anchors.verticalCenter: parent.verticalCenter
                    Rectangle {
                        radius: 5
                        border.color: lightGray2
                        border.width: 1
                        width: parent.width /4
                        height: parent.height
                        color: transparent
                        Text{
                            text: "RTMP"
                            anchors.centerIn: parent
                            color: lightGray2
                            font.pixelSize: defaultFontSize * 2
                        }
                    }

                    Text {
                        text: "RTMP custom live"
                        color: lightGray2
                        font.pixelSize: defaultFontSize * 2
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

            //RTMP Address
            ItemDelegate {
                width: parent.width
                height: hItemDelegate

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width / 24
                    color: white
                    text: "RTMP address"
                    font.pixelSize: defaultFontSize * 3
                    anchors.verticalCenter: parent.verticalCenter
                }

                TextField {
                    width: parent.width / 3.6
                    height: parent.height / 1.8
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.rightMargin: parent.width / 24
                    font.pixelSize: defaultFontSize * 3
                    color: white

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

            //Display Mode
            ItemDelegate {
                width: parent.width
                height: hItemDelegate

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width / 24
                    color: white
                    text: "Display mode"
                    font.pixelSize: defaultFontSize * 3
                    anchors.verticalCenter: parent.verticalCenter
                }

                ListView {
                    orientation: Qt.Horizontal
                    anchors.right: parent.right
                    anchors.rightMargin: parent.width / 24
                    width: parent.width / 3.6
                    height: parent.height / 1.8
                    id: listView
                    anchors.verticalCenter: parent.verticalCenter
                    interactive: false  // 그대로 유지

                    // model 수정 (텍스트와 이미지 경로 추가)
                    model: ListModel {
                        ListElement {
                            name: "Landscape"
                            imageSource: "qrc:/res/LandScapeOff.svg"         // 기본 이미지 경로
                            selectedImageSource: "qrc:/res/LandScapeOn.svg"  // 선택된 이미지 경로
                        }
                        ListElement {
                            name: "Portrait"
                            imageSource: "qrc:/res/PortraitOff.svg"         // 기본 이미지 경로
                            selectedImageSource: "qrc:/res/PortraitOn.svg"  // 선택된 이미지 경로
                        }
                    }

                    delegate: Rectangle {
                        width: listView.width / 2
                        height: listView.height
                        color: listView.currentIndex == index ? blue : lightGray  // 선택 여부에 따른 배경색 변경
                        radius: 5
                        Row {
                            //anchors.verticalCenter: parent.verticalCenter
                            anchors.centerIn: parent
                            spacing: 5
                            Image {
                                // 선택된 아이템이면 선택된 이미지를, 아니면 기본 이미지를 표시
                                source: listView.currentIndex == index ? model.selectedImageSource : model.imageSource
                            }

                            Text {
                                text: model.name  // 텍스트 사용
                                font.pixelSize: defaultFontSize * 2
                                color: white
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                listView.currentIndex = index  // 선택한 항목을 설정
                            }
                        }
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

            //Resolution
            ItemDelegate {
                width: parent.width
                height: hItemDelegate

                Text {
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width / 24
                    font.pixelSize: defaultFontSize * 3
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Resolution"
                    color: white
                }

                ComboBox {
                    anchors.right: parent.right
                    anchors.rightMargin: parent.width / 24
                    anchors.verticalCenter: parent.verticalCenter
                    id: customComboBox
                    width: parent.width / 4.8
                    height: parent.height / 1.8
                    model: ["High Definition", "Smooth"]

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
        }
    }
}





















