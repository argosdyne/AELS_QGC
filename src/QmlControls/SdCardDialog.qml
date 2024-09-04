import QtQuick          2.12
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
    property int titleFontSize: 40
    property int contentFontSize: 30
    property string backgroundColor: "#3b3737"

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
                border.color: "white"
                Text {
                    anchors.centerIn: parent
                    font.pixelSize: titleFontSize
                    color: "#ffffff"
                    text: "SD Card"
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: backgroundColor
                border.color: "white"

                ColumnLayout {
                    anchors.fill: parent
                    Image {
                        Layout.alignment: Qt.AlignHCenter
                        source: "qrc:/res/ales/mission/NoSDcard.svg"
                    }
                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.preferredHeight: contentFontSize * 2
                        text: qsTr("Please insert SD Card or switch storage location to Flash Card")
                        font.pixelSize: contentFontSize - 5
                        color: "white"
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: titleFontSize * 2
                color: backgroundColor
                border.color: "white"

                Button {
                    id: control
                    anchors.fill: parent
                    text: "Switch to Flash Card"
                    font.pixelSize: titleFontSize

                    background: Rectangle {
                        color: "transparent"
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
                        var componentUrl = Qt.resolvedUrl("qrc:/qml/QGroundControl/Controls/PreflightSecurityCheck.qml");

                        // 컴포넌트를 생성하기 위한 Component 객체 생성
                        var component = Qt.createComponent(componentUrl);

                        if (component.status === Component.Ready) {
                            // 애니메이션이 없는 Transition을 설정하여 페이지를 푸시
                            var newPage = component.createObject(learningCenterGroup);
                        } else {
                            console.log("Error loading component:", component.errorString());
                        }
                    }
                }
            }
        }
    }
}

