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
    z: 5
    //Color Picker
    property color black: "#222020"
    property color gray: "#848282"
    property color blue: "#276BF0"
    property color white: "white"
    property color transparent: "transparent"

    //Size Property
    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize

    //values
    property var parentQML: null
    property bool isWarning: true
    property string innerText: ""

    property alias cancelButton: cancelButton
    property alias okButton: okButton
    property alias verticalSeparator: verticalSeparator
    property alias root: root

    radius: defaultFontSize * 1.2     
    implicitWidth: Screen.width / 4.1
    implicitHeight: Screen.height / 3.4

    Rectangle {
        visible: isWarning
        width: parent.width
        height: 2 
        color: gray
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: parent.height / 4.7
    }

    Rectangle {
        width: parent.width
        height: 2 
        color: gray
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height / 5.3 
    }

    //Left button
    Button {
        id: cancelButton
        width: parent.width / 2
        height: parent.height / 5.3
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        background: Rectangle{
            color: transparent
            anchors.fill: parent
        }

        Text {
            text: qsTr("CANCEL")
            color: blue
            anchors.centerIn: parent
            font.pixelSize: parent.width / 7.7
            font.bold: true
        }
        onClicked: {
            console.log("Left btn Click");

            if (parentQML.resetCameraLoader !== null && typeof parentQML.resetCameraLoader !== "undefined") {
                if (typeof parentQML.resetCameraLoader.sourceComponent !== "undefined" && parentQML.resetCameraLoader.sourceComponent !== null) {
                    parentQML.resetCameraLoader.sourceComponent = null
                }
            }

            if (parentQML.ledIndicatorsLoader !== null && typeof parentQML.ledIndicatorsLoader !== "undefined") {
                if (typeof parentQML.ledIndicatorsLoader.sourceComponent !== "undefined" && parentQML.ledIndicatorsLoader.sourceComponent !== null) {
                    parentQML.ledIndicatorsLoader.sourceComponent = null
                    console.log("ledIndicatorsLoader null")
                }
            }

            if (parentQML.visualObstacleAvoidanceLoader !== null && typeof parentQML.visualObstacleAvoidanceLoader !== "undefined") {
                if (typeof parentQML.visualObstacleAvoidanceLoader.sourceComponent !== "undefined" && parentQML.visualObstacleAvoidanceLoader.sourceComponent !== null) {
                    parentQML.visualObstacleAvoidanceLoader.sourceComponent = null
                }
            }

            if (parentQML.downwardVisionLoader !== null && typeof parentQML.downwardVisionLoader !== "undefined") {
                if (typeof parentQML.downwardVisionLoader.sourceComponent !== "undefined" && parentQML.downwardVisionLoader.sourceComponent !== null) {
                    parentQML.downwardVisionLoader.sourceComponent = null
                }
            }

            parentQML.modalBackground.visible = false
            parentQML.modalBackground.enabled = false
            parentQML.modalBackground.z = 1

            if(parentQML.currentLED === "Front"){
                parentQML.flightControl.frontLEDcontrol.checked = true
            }
            else {
                parentQML.flightControl.backwardLEDcontrol.checked = true
            }

            if(parentQML.currentVisualControl === "openDownward"){
                parentQML.visualNavigation.downwardVisioncontrol.checked = true
            }
            else {
                parentQML.visualNavigation.visualObstaclecontrol.checked = false
            }
        }
    }

    //Right button
    Button {
        id: okButton
        width: parent.width / 2
        height: parent.height / 5.3
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        background: Rectangle{
            color: transparent
            anchors.fill: parent
        }

        Text {
            text: qsTr("OK")
            color: blue
            anchors.centerIn: parent
            font.pixelSize: defaultFontSize * 3
            font.bold: true
        }

        onClicked: {
            console.log("Right btn Click");
            if(!isWarning){
                if (parentQML.resetCameraLoader !== null && typeof parentQML.resetCameraLoader !== "undefined") {
                    if (typeof parentQML.resetCameraLoader.sourceComponent !== "undefined" && parentQML.resetCameraLoader.sourceComponent !== null) {
                        {
                            parentQML.resetCameraLoader.sourceComponent = null
                            parentQML.cameraSettingLoader.visible = false
                            parentQML.videoControl.z = 0

                            //Show Reset Complete Rect
                            parentQML.popupRect.showPopup()
                        }
                    }
                }
            }
            else {
                if (parentQML.resetCameraLoader !== null && typeof parentQML.resetCameraLoader !== "undefined") {
                    if (typeof parentQML.resetCameraLoader.sourceComponent !== "undefined" && parentQML.resetCameraLoader.sourceComponent !== null) {
                        parentQML.resetCameraLoader.sourceComponent = null;
                        // Show Log Window Button
                        parentQML.logWindowButton.visible = true;
                    }
                }

                if (parentQML.ledIndicatorsLoader !== null && typeof parentQML.ledIndicatorsLoader !== "undefined") {
                    if (typeof parentQML.ledIndicatorsLoader.sourceComponent !== "undefined" && parentQML.ledIndicatorsLoader.sourceComponent !== null) {
                        parentQML.ledIndicatorsLoader.sourceComponent = null
                        console.log("ledIndicatorsLoader null")
                    }
                }

                if (parentQML.noviceModeUncheckedLoader !== null && typeof parentQML.noviceModeUncheckedLoader !== "undefined") {
                    if (typeof parentQML.noviceModeUncheckedLoader.sourceComponent !== "undefined" && parentQML.noviceModeUncheckedLoader.sourceComponent !== null) {
                        parentQML.noviceModeUncheckedLoader.sourceComponent = null
                    }
                }


                if (parentQML.visualObstacleAvoidanceLoader !== null && typeof parentQML.visualObstacleAvoidanceLoader !== "undefined") {
                    if (typeof parentQML.visualObstacleAvoidanceLoader.sourceComponent !== "undefined" && parentQML.visualObstacleAvoidanceLoader.sourceComponent !== null) {
                        parentQML.visualObstacleAvoidanceLoader.sourceComponent = null
                    }
                }

                if (parentQML.downwardVisionLoader !== null && typeof parentQML.downwardVisionLoader !== "undefined") {
                    if (typeof parentQML.downwardVisionLoader.sourceComponent !== "undefined" && parentQML.downwardVisionLoader.sourceComponent !== null) {
                        parentQML.downwardVisionLoader.sourceComponent = null
                    }
                }
            }
            parentQML.modalBackground.visible = false
            parentQML.modalBackground.enabled = false
            parentQML.modalBackground.z = 1
        }
    }

    //Vertical Separator

    Rectangle {
        width: 2
        height: parent.height / 5.3
        color: gray        
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        id: verticalSeparator
    }

    Rectangle {
        visible : isWarning
        width: parent.width
        height: parent.height / 4.7
        anchors.top: parent.top
        color: transparent
        id: topRect

        Rectangle {
            anchors.centerIn: parent
            color: transparent
            width: parent.width / 2.8
            height: parent.height / 1.4
            id: rect

            Row {
                id: row
                spacing: parent.width / 14
                Image {
                    id: img
                    source: "/res/Warning.svg"
                    width: topRect.height / 1.2
                    height: topRect.height / 1.2
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    id: txt
                    text: qsTr("Warning")
                    font.pixelSize: rect.width / 5.6
                    anchors.verticalCenter: parent.verticalCenter
                    color: white
                }
            }
        }
    }

    //Inner Text Field

//    Rectangle {
//        width: parent.width
//        height: parent.height - topRect.height - parent.height / 5.3
//        anchors.verticalCenter: parent.verticalCenter
//        color: transparent
//        Text {
//            text: innerText
//            color: white
//            font.pixelSize: defaultFontSize * 2
//            anchors.centerIn: parent
//            wrapMode: Text.WordWrap
//        }
//    }

    Rectangle {
        width: parent.width
        height: parent.height - topRect.height - parent.height / 5.3
        anchors.verticalCenter: parent.verticalCenter
        color: transparent

        Text {
            text: innerText
            color: white
            font.pixelSize: defaultFontSize * 2
            anchors.centerIn: parent  // parent를 기준으로 중앙 정렬
            wrapMode: Text.WordWrap  // 텍스트 줄바꿈
            width: parent.width * 0.9  // 너비를 약간 줄여서 여백을 추가
        }
    }
}
