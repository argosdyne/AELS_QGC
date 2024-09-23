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
    property int gimbalsensitivityValue : 1

    signal adjustGimbalClicked()

    //Gimbal Calibration
    Rectangle {
        id: gimbalCalibrationPage
        anchors.fill: parent
        z : 4
        color: black
        visible: false
        MouseArea {
            anchors.fill: parent
        }

        Text {
            color: lightGray
            font.pixelSize: defaultFontSize * 4
            text: "place the drone horizontally and keep it still"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height / 4.5
            id: calibrationText
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width / 3.6
            height: parent.height / 11.25
            anchors.top: calibrationText.top
            anchors.topMargin: parent.height / 9
            background: Rectangle {
                color: blue
            }
            Text {
                color: white
                font.pixelSize: defaultFontSize * 4
                anchors.centerIn: parent
                text: "Start Calibration"
            }
        }
    }

    // Main Page
    Column {
        anchors.fill: parent
        width: parent.width
        height: parent.height

        // Gimbal Mode
        ItemDelegate {
            width: parent.width
            height: hItemDelegate

            Text {
                color: white
                font.pixelSize: defaultFontSize * 3.3
                text: "Gimbal Mode"
                anchors.left: parent.left
                anchors.leftMargin: parent.width / 24
                anchors.verticalCenter: parent.verticalCenter
            }

            ComboBox {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: parent.width / 24
                id: imageTransmissionModeComboBox
                width: parent.width / 5.76
                model: ["Stabilized", "FPV"]

                // 텍스트와 색상 스타일을 지정
                contentItem: Text {
                    text: imageTransmissionModeComboBox.currentText
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
                color : transparent
            }
        }

        ToolSeparator {
            width: parent.width
            height: hToolSeparator
            orientation: Qt.Horizontal
        }

        // Adjust Gimbal
        ItemDelegate {
            width: parent.width
            height: hItemDelegate

            Text {
                color: white
                font.pixelSize: defaultFontSize * 3.3
                text: "Adjust Gimbal"
                anchors.left: parent.left
                anchors.leftMargin: parent.width / 24
                anchors.verticalCenter: parent.verticalCenter
            }

            Button {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: parent.width / 24
                width: parent.width / 7.2
                height: parent.height / 1.4

                Text {
                    text: "Start"
                    color: blue
                    anchors.centerIn: parent
                    font.pixelSize: defaultFontSize * 3.3
                }
                background: Rectangle{
                    color: transparent
                    border.color: transparent
                }
                onClicked: {

                    adjustGimbalClicked()
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

        // Gimbal Automatic Calibration
        ItemDelegate {
            width: parent.width
            height: hItemDelegate

            Text {
                anchors.left: parent.left
                color: white
                text: "Gimbal Automatic Calibration"
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
                    gimbalCalibrationPage.visible = true
                    parentQML.currentPageIndex = 1
                    parentQML.page1 = gimbalCalibrationPage
                    parentQML.mainTitle = parentQML.settingTitle
                    parentQML.settingTitle = "Gimbal"
                }
            }
        }

        ToolSeparator {
            width: parent.width
            height: hToolSeparator
            orientation: Qt.Horizontal
        }

        //Gimbal pitch Limit
        ItemDelegate {
            width: parent.width
            height: hItemDelegate

            Text {
                anchors.left: parent.left
                color: white
                text: "<font color='white'>Gimbal Pitch Limit</font> <font color='lightGray'>(30° Extended Upward)</font>"
                font.pixelSize: defaultFontSize * 3.3
                anchors.verticalCenter: parent.verticalCenter
                anchors.leftMargin: parent.width / 24
            }

            Switch{
                id: gimbalpitchLimitcontrol
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: parent.width / 24
                checked: false
                indicator: Rectangle {
                    implicitWidth: defaultFontSize * 6
                    implicitHeight: defaultFontSize * 3
                    x: gimbalpitchLimitcontrol.width - width - gimbalpitchLimitcontrol.rightPadding
                    y: parent.height / 2 - height / 2
                    radius: 13
                    color: gimbalpitchLimitcontrol.checked ? blue : lightGray
                    border.color: white

                    Rectangle {
                        x: gimbalpitchLimitcontrol.checked ? parent.width - width : 0
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

        // Gimbal Automatic EXP Sensitivity
        ItemDelegate {
            width: parent.width
            height: hItemDelegate * 2

            Column {
                anchors.fill: parent

                Row {
                    width: parent.width
                    height: parent.height / 2

                    Item {
                        width: parent.width / 24
                        height: 1
                    }

                    Text {
                        color: white
                        font.pixelSize: defaultFontSize * 3.3
                        text: "Gimbal Automatic EXP Sensitivity"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Item {
                        height: 1
                        width: parent.width / 2.4
                    }

                    TextField {
                        font.pixelSize: defaultFontSize * 3.3
                        width: parent.width / 9.6
                        anchors.verticalCenter: parent.verticalCenter
                        color: white
                        inputMethodHints: Qt.ImhDigitsOnly

                        text: gimbalsensitivityValue

                        validator: IntValidator {bottom: 1; top: 100;}
                        background:Rectangle {
                            color: transparent
                            border.color: lightGray
                        }

                        onTextChanged: {
                            gimbalSensitivityControl.value = text
                            gimbalsensitivityValue = text
                        }
                    }
                }

                Row {
                    width: parent.width
                    height: parent.height / 2

                    Item {
                        width: parent.width / 24
                        height: 1
                    }

                    Text {
                        color: white
                        font.pixelSize: defaultFontSize * 3.3
                        text: "1"
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Item {
                        width: parent.width / 18
                        height: 1
                    }

                    Slider {
                        orientation: Qt.Horizontal
                        anchors.verticalCenter: parent.verticalCenter
                        value: 1
                        from : 1
                        to: 100
                        width: parent.width / 1.44
                        id: gimbalSensitivityControl

                        onValueChanged: {
                            gimbalsensitivityValue = gimbalSensitivityControl.value.toFixed(0);
                        }
                    }

                    Item {
                        width: parent.width / 18
                        height: 1
                    }

                    Text {
                        color: white
                        font.pixelSize: defaultFontSize * 3.3
                        text: "100"
                        anchors.verticalCenter: parent.verticalCenter
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
   }
}
