﻿import QtQuick          2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts  1.11
import QtQuick.Dialogs  1.3
import QtQuick.Window 2.0

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.Palette               1.0
import QGroundControl.ScreenTools           1.0



Item {
    id: root
    implicitWidth: 850
    implicitHeight: 550
    property int titleFontSize: 35
    property int contentFontSize: 15
    property string backgroundColor: "#3b3737"
    property string boderColor: "#cecdcd"

    Rectangle {
        anchors.fill: parent
        color: backgroundColor
        radius: 5
        visible: true

        ColumnLayout {
            anchors.fill: parent
            spacing: 0
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: titleFontSize * 2
                color: backgroundColor
                border.color: boderColor
                Text {
                    anchors.centerIn: parent
                    font.pixelSize: titleFontSize
                    color: "#ffffff"
                    text: "Pre-flight security check"
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: backgroundColor
                border.color: "transparent"

                ColumnLayout {
                    anchors.fill: parent
                    Image {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.fillHeight: true
                        source: "qrc:/res/ales/mission/PreFlightSecurity.png"
                        fillMode: Image.Stretch
                    }
                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredHeight: contentFontSize * 5
                        text: qsTr("Before powering on the drone, please make sure the battery is securely\n installed (the battery adge shoulg be tightly attached to the fuselage after\n installation) to avoid battery falling off during flight and flight accident.")
                        font.pixelSize: contentFontSize
                        color: "white"
                    }

                    ButtonGroup {
                        buttons: buttonRow.children
                    }

                    Row {
                        Layout.alignment: Qt.AlignHCenter
                        id: buttonRow
                        Layout.preferredHeight: contentFontSize * 2

                        RadioButton {
                            checked: true

                            indicator: Rectangle {
                                implicitWidth: 20
                                implicitHeight: 20
                                border.color: "white"
                                border.width: 2
                                radius: 10
                                color: "transparent"
                                Item {
                                    anchors.centerIn: parent
                                    width: 10
                                    height: 10
                                    visible: parent.parent.checked
                                    Rectangle {
                                        anchors.fill: parent
                                        color: "white"
                                        radius: 5
                                    }
                                }
                            }
                        }

                        RadioButton {
                            checked: false

                            indicator: Rectangle {
                                implicitWidth: 20
                                implicitHeight: 20
                                border.color: "white"
                                border.width: 2
                                radius: 10
                                color: "transparent"
                                Item {
                                    anchors.centerIn: parent
                                    width: 10
                                    height: 10
                                    visible: parent.parent.checked
                                    Rectangle {
                                        anchors.fill: parent
                                        color: "white"
                                        radius: 5
                                    }
                                }
                            }
                        }
                    }
                }
                MouseArea {
                    id: swipeArea
                    anchors.fill: parent
                    drag.target: null

                    property real startX: 0
                    property real threshold: 100
                    property bool actionTriggered: false

                    onPressed: startX = mouse.x
                    onReleased: {
                        if (!actionTriggered && mouse.x < startX - threshold) {
                            actionTriggered = true;
                            learningCenterGroup.push(Qt.resolvedUrl("qrc:/qml/QGroundControl/Controls/PreflightSecurityCheckV1.qml"))
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: titleFontSize * 2
                color: backgroundColor
                border.color: boderColor


                Button {
                    anchors.fill: parent
                    text: "Next"
                    font.pixelSize: titleFontSize

                    background: Rectangle {
                        color: "transparent"
                        border.color: boderColor
                    }

                    contentItem: Text {
                        text: parent.text
                        font: parent.font
                        opacity: enabled ? 1.0 : 0.3
                        color: parent.down ? "white" : "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }
                    onClicked: {
                        learningCenterGroup.push(Qt.resolvedUrl("qrc:/qml/QGroundControl/Controls/PreflightSecurityCheckV1.qml"))
                    }
                }
            }
        }
    }
}
