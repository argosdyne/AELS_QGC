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

    //Battery Details Page
    Rectangle {
        id: batteryDetailsPage
        anchors.fill: parent
        z: 4
        color: black
        visible : false
        MouseArea {
            anchors.fill: parent
        }
        Column {
            anchors.fill: parent

            ItemDelegate {
                width: parent.width
                height: hItemDelegate

                Text{
                    color: white
                    font.pixelSize: defaultFontSize * 3.3
                    text: "Serial Number"
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width / 24
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    color: white
                    font.pixelSize: defaultFontSize * 3.3
                    text: "B54820510523"
                    anchors.right: parent.right
                    anchors.rightMargin: parent.width / 18
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            ToolSeparator {
                width: parent.width
                height: hToolSeparator
                orientation: Qt.Horizontal
            }
        }
    }

    // Main Page
    Column {
        anchors.fill: parent
        width: parent.width
        height: parent.height

        //Total Voltage
        ItemDelegate {
            width: parent.width
            height: parent.height / 6

            Column {
                anchors.fill: parent
                id: rootColumn
                Item {
                    width: 1
                    height: parent.height / 5
                }
                Row {
                    width: parent.width
                    height: parent.height / 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: rootColumn.width / 10

                    Item {
                        width: 1
                        height: 1
                    }

                    Text {
                        color: white
                        font.pixelSize: defaultFontSize * 3.3
                        text: "Total Voltage"
                    }
                    Text {

                        color: white
                        font.pixelSize: defaultFontSize * 3.3
                        text: "4.319V"
                    }
                    Text {

                        color: white
                        font.pixelSize: defaultFontSize * 3.3
                        text: "4.328V"
                    }
                    Text {

                        color: white
                        font.pixelSize: defaultFontSize * 3.3
                        text: "4.325V"
                    }
                }

                Row {
                    width: parent.width
                    height: parent.height / 2
                    anchors.horizontalCenter: parent.horizontalCenter

                    Item {
                        width: rootColumn.width / 8
                        height: 1
                    }
                    Text {
                        color: white
                        font.pixelSize: defaultFontSize * 3.3
                        text: "12.972V"
                    }

                    Item {
                        width: parent.width / 9
                        height: 1
                    }

                    Rectangle {
                        width: parent.width / 7.2
                        height: parent.height / 4
                        color: lightGreen
                    }

                    Item {
                        width: parent.width / 28.8
                        height: 1
                    }

                    Rectangle {
                        width: parent.width / 7.2
                        height: parent.height / 4
                        color: lightGreen
                    }

                    Item {
                        width: parent.width / 18
                        height: 1
                    }
                    Rectangle {
                        width: parent.width / 7.2
                        height: parent.height / 4
                        color: lightGreen
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

        //Temperature
        ItemDelegate {
            width: parent.width
            height: parent.height / 6

            Row {
                anchors.fill: parent

                Item {
                    width: parent.width / 18
                    height: 1
                }

                Column {
                    height: parent.height
                    width: parent.width / 4
                    Item {
                        width: 1
                        height: parent.height / 5
                    }
                    Text {
                        color: white
                        font.pixelSize: defaultFontSize * 3.3
                        text: "Temperature"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Item {
                        width: 1
                        height: parent.height / 5
                    }

                    Text {
                        color: white
                        font.pixelSize: defaultFontSize * 3.3
                        text: "25.1°C"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }

                Item {
                    width: parent.width / 12
                    height: 1
                }

                Column {
                    height: parent.height
                    width: parent.width / 4
                    Item {
                        width: 1
                        height: parent.height / 5
                    }
                    Text {
                        color: white
                        font.pixelSize: defaultFontSize * 3.3
                        text: "Remaining Capacity"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Item {
                        width: 1
                        height: parent.height / 5
                    }
                    Text {
                        color: white
                        font.pixelSize: defaultFontSize * 3.3
                        text: "98%"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                }
                Item {
                    width: parent.width / 12
                    height: 1
                }

                Column {
                    height: parent.height
                    width: parent.width / 4
                    Item {
                        width: 1
                        height: parent.height / 5
                    }
                    Text {
                        color: white
                        font.pixelSize: defaultFontSize * 3.3
                        text: "Discharge Times"
                        anchors.horizontalCenter: parent.horizontalCenter
                    }
                    Item {
                        width: 1
                        height: parent.height / 5
                    }
                    Text {
                        color: white
                        font.pixelSize: defaultFontSize * 3.3
                        text: "14"
                        anchors.horizontalCenter: parent.horizontalCenter
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

        // Battery Slider

        ItemDelegate {
            width: parent.width
            height: parent.height / 4.5

            background: Rectangle {
                color: transparent
            }

            Column {
                anchors.fill: parent

                Item {
                    width: 1
                    height: parent.height / 6
                }

                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    Text {
                        color: white
                        font.pixelSize: defaultFontSize * 3.3
                        text: "Critically Low Battery Warning   "
                    }

                    Text {
                        color: red
                        font.pixelSize: defaultFontSize * 3.3
                        text: rangeSlider.first.value.toFixed(0)
                    }
                    Text {
                        color: red
                        font.pixelSize: defaultFontSize * 3.3
                        text: "%"
                    }

                    Item {
                        height: 1
                        width: parent.width / 28.8
                    }

                    Text {
                        color: white
                        font.pixelSize: defaultFontSize * 3.3
                        text: "Low Battery Warning   "
                    }

                    Text {
                        color: orange
                        font.pixelSize: defaultFontSize * 3.3
                        text: rangeSlider.second.value.toFixed(0)
                    }
                    Text {
                        color: orange
                        font.pixelSize: defaultFontSize * 3.3
                        text: "%"
                    }
                }

                Item {
                    width: 1
                     height: parent.height / 6
                }

                Row {
                    width: parent.width / 2
                    anchors.horizontalCenter: parent.horizontalCenter
                    Text {
                        color: white
                        font.pixelSize: defaultFontSize * 3
                        text: "8"
                    }

                    Item {
                        width: defaultFontSize
                        height: 1
                    }

                    RangeSlider {
                        orientation: Qt.Horizontal

                        width: parent.width
                        id: rangeSlider

                        from: 8
                        to: 50

                        // Initial values
                        first.value: 20
                        second.value: 45

                        // Define custom limits
                        property real firstMin: 8
                        property real firstMax: 25
                        property real secondMin: 15
                        property real secondMax: 50

                        // Minimum gap between the handles
                        property real minGap: 5

                        first.onMoved: {
                            // Limit first value between firstMin and firstMax
                            if (first.value < firstMin) {
                                first.value = firstMin;
                            } else if (first.value > firstMax) {
                                first.value = firstMax;
                            }

                            // Ensure there is a minimum gap between first and second
                            if (first.value > second.value - minGap) {
                                first.value = second.value - minGap;
                            }

                            console.log("first.value = ", first.value);
                        }

                        second.onMoved: {
                            // Limit second value between secondMin and secondMax
                            if (second.value < secondMin) {
                                second.value = secondMin;
                            } else if (second.value > secondMax) {
                                second.value = secondMax;
                            }

                            // Ensure there is a minimum gap between first and second
                            if (second.value < first.value + minGap) {
                                second.value = first.value + minGap;
                            }

                            console.log("second.value = ", second.value);
                        }
                    }

                    Item {
                        width: defaultFontSize
                        height: 1
                    }

                    Text {
                        color: white
                        font.pixelSize: defaultFontSize * 3
                        text: "50%"
                    }
                }
            }
        }

        ToolSeparator {
            width: parent.width
            height: hToolSeparator
            orientation: Qt.Horizontal
        }

        // Time to Discharge
        ItemDelegate {
            width: parent.width
            height: hItemDelegate

            Text {
                color: white
                font.pixelSize: defaultFontSize * 3.3
                text: "Time to Discharge"
                anchors.left: parent.left
                anchors.leftMargin: parent.width / 24
                anchors.verticalCenter: parent.verticalCenter
            }
            ComboBox {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: defaultFontSize
                id: imageTransmissionModeComboBox
                width: parent.width / 4.8
                model: ["1 Day", "2 Day","3 Day","4 Day","5 Day","6 Day","7 Day","8 Day","9 Day","10 Day"]

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

        // Battery Details
        ItemDelegate {
            width: parent.width
            height: hItemDelegate

            Text {
                anchors.left: parent.left
                color: white
                text: "Battery Details"
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
                    batteryDetailsPage.visible = true
                    parentQML.currentPageIndex = 1
                    parentQML.page1 = batteryDetailsPage
                    parentQML.mainTitle = parentQML.settingTitle
                    parentQML.settingTitle = "Battery Details"
                }
            }
        }
    }
}
