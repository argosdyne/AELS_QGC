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
    id:     root
    color: defaultBackGroundColor    

    //Color Property
    property color defaultBackGroundColor: "#3b3737"
    property color transparent: "transparent"
    property color fontColorWhite: "white"
    property color fontColorlightGray: "#a7a7a7"
    property color blue : "#3d71d7"

    //Size Property
    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize

    property var buttonType: null
    property var selectedButton: null

    implicitWidth: Screen.width
    implicitHeight: defaultFontSize * 9

    property var parentQML: null
    property var currentResolutionValue: null
    property var currentFrameRateValue: null
    property var currentFormatValue: null
    property var currentExposureValue: null
    property var currentEVValue: null
    property var currentWBValue: null
    property var currentDigitalZoom: null
    property var currentAFValue: null
    property var currentColorValue: null
    property var currentStyleValue: null
    property var currentPivValue: null

    Item {
        anchors.fill: parent

        // Resolution UI
        Item {
            visible: buttonType === "resolution"
            anchors.fill: parent
            Row {
                anchors.fill: parent
                Button {
                    width: parent.width / 5
                    height: parent.height
                    checkable: true
                    checked: false
                    property string resolution1080P: "1080P"
                    background: Rectangle {
                        color: (selectedButton === parent.resolution1080P || currentResolutionValue === parent.resolution1080P) ? blue : transparent
                    }

                    Text {
                        text: "1080P(1920X1080)"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.resolutionText= "1080P"

                        if (selectedButton !== resolution1080P) {
                            selectedButton = resolution1080P
                            currentResolutionValue = resolution1080P
                        } else {
                            selectedButton = null
                        }
                    }
                }

                Button {
                    width: parent.width / 5
                    height: parent.height
                    checkable: true
                    checked: false
                    property string resolution2K: "2.7K"
                    background: Rectangle {
                        color: (selectedButton === parent.resolution2K || currentResolutionValue === parent.resolution2K) ? blue : transparent
                    }

                    Text {
                        text: "2.7K(2720X1528)"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.resolutionText= "2.7K"

                        if (selectedButton !== resolution2K) {
                            selectedButton = resolution2K
                            currentResolutionValue = resolution2K
                        } else {
                            selectedButton = null
                        }
                    }
                }

                Button {
                    width: parent.width / 5
                    height: parent.height
                    checkable: true
                    checked: false
                    property string resolution4K: "4K"
                    background: Rectangle {
                        color: (parent.resolution4K === selectedButton || currentResolutionValue === parent.resolution4K)? blue : transparent
                    }

                    Text {
                        text: "4K(3840X2160)"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.resolutionText= "4K"

                        if (selectedButton !== resolution4K) {
                            selectedButton = resolution4K
                            currentResolutionValue = resolution4K
                        } else {
                            selectedButton = null
                        }
                    }
                }

                Button {
                    width: parent.width / 5
                    height: parent.height
                    checkable: true
                    checked: false
                    property string resolution6K: "6K"
                    background: Rectangle {
                        color:(selectedButton === parent.resolution6K || currentResolutionValue === parent.resolution6K)? blue : transparent
                    }

                    Text {
                        text: "6K(5760X3240)"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.resolutionText= "6K"

                        if (selectedButton !== resolution6K) {
                            selectedButton = resolution6K
                            currentResolutionValue = resolution6K
                        } else {
                            selectedButton = null
                        }
                    }
                }

                Button {
                    width: parent.width / 5
                    height: parent.height
                    checkable: true
                    checked: false
                    property string resolution8K: "8K"
                    background: Rectangle {
                        color: (selectedButton === parent.resolution8K || currentResolutionValue === parent.resolution8K)? blue : transparent
                    }

                    Text {
                        text: "8K(7680X4320)"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.resolutionText= "8K"

                        if (selectedButton !== resolution8K) {
                            selectedButton = resolution8K
                            currentResolutionValue = resolution8K
                        } else {
                            selectedButton = null
                        }
                    }
                }
            }
        }

        // Frame Rate UI
        Flickable {
            anchors.fill: parent
            contentWidth: parent.width * 1.5
            contentHeight: parent.height
            id: flickAbleFrameRate
            visible: buttonType === "frameRate"

            Row {
                anchors.fill: parent

                Button {
                    width: flickAbleFrameRate.width / 4
                    height: flickAbleFrameRate.height
                    checkable: true
                    checked: false
                    property string frameRate60FPS: "60FPS"
                    background: Rectangle {
                        color: (selectedButton === parent.frameRate60FPS || currentFrameRateValue === parent.frameRate60FPS) ? blue : transparent
                    }

                    Text {
                        text: "60FPS"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.frameRateText= "60FPS"

                        if (selectedButton !== frameRate60FPS) {
                            selectedButton = frameRate60FPS
                            currentFrameRateValue = frameRate60FPS
                        } else {
                            selectedButton = null
                        }
                    }
                }

                Button {
                    width: flickAbleFrameRate.width / 4
                    height: flickAbleFrameRate.height
                    checkable: true
                    checked: false
                    property string frameRate50FPS: "50FPS"
                    background: Rectangle {
                        color: (selectedButton === parent.frameRate50FPS || currentFrameRateValue === parent.frameRate50FPS) ? blue : transparent
                    }

                    Text {
                        text: "50FPS"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.frameRateText= "50FPS"

                        if (selectedButton !== frameRate50FPS) {
                            selectedButton = frameRate50FPS
                            currentFrameRateValue = frameRate50FPS
                        } else {
                            selectedButton = null
                        }
                    }
                }

                Button {
                    width: flickAbleFrameRate.width / 4
                    height: flickAbleFrameRate.height
                    checkable: true
                    checked: false
                    property string frameRate48FPS: "48FPS"
                    background: Rectangle {
                        color: (selectedButton === parent.frameRate48FPS || currentFrameRateValue === parent.frameRate48FPS) ? blue : transparent
                    }

                    Text {
                        text: "48FPS"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.frameRateText= "48FPS"

                        if (selectedButton !== frameRate48FPS) {
                            selectedButton = frameRate48FPS
                            currentFrameRateValue = frameRate48FPS
                        } else {
                            selectedButton = null
                        }
                    }
                }

                Button {
                    width: flickAbleFrameRate.width / 4
                    height: flickAbleFrameRate.height
                    checkable: true
                    checked: false
                    property string frameRate30FPS: "30FPS"
                    background: Rectangle {
                        color: (selectedButton === parent.frameRate30FPS || currentFrameRateValue === parent.frameRate30FPS) ? blue : transparent
                    }

                    Text {
                        text: "30FPS"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.frameRateText= "30FPS"

                        if (selectedButton !== frameRate30FPS) {
                            selectedButton = frameRate30FPS
                            currentFrameRateValue = frameRate30FPS
                        } else {
                            selectedButton = null
                        }
                    }
                }

                Button {
                    width: flickAbleFrameRate.width / 4
                    height: flickAbleFrameRate.height
                    checkable: true
                    checked: false
                    property string frameRate25FPS: "25FPS"
                    background: Rectangle {
                        color: (parent.frameRate25FPS === selectedButton || currentFrameRateValue === parent.frameRate25FPS)? blue : transparent
                    }

                    Text {
                        text: "25FPS"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.frameRateText= "25FPS"

                        if (selectedButton !== frameRate25FPS) {
                            selectedButton = frameRate25FPS
                            currentFrameRateValue = frameRate25FPS
                        } else {
                            selectedButton = null
                        }
                    }
                }

                Button {
                    width: flickAbleFrameRate.width / 4
                    height: flickAbleFrameRate.height
                    checkable: true
                    checked: false
                    property string frameRate24FPS: "24FPS"
                    background: Rectangle {
                        color:(selectedButton === parent.frameRate24FPS || currentFrameRateValue === parent.frameRate24FPS)? blue : transparent
                    }

                    Text {
                        text: "24FPS"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.frameRateText= "24FPS"

                        if (selectedButton !== frameRate24FPS) {
                            selectedButton = frameRate24FPS
                            currentFrameRateValue = frameRate24FPS
                        } else {
                            selectedButton = null
                        }
                    }
                }
            }
        }

        // Format UI
        Item {
            visible: buttonType === "format"
            anchors.fill: parent
            Row {
                anchors.fill: parent
                Button {
                    width: parent.width / 2
                    height: parent.height
                    checkable: true
                    checked: false
                    property string formatMOV: "MOV"
                    background: Rectangle {
                        color: (selectedButton === parent.formatMOV || currentFormatValue === parent.formatMOV) ? blue : transparent
                    }

                    Text {
                        text: "MOV"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.formatText= "MOV"

                        if (selectedButton !== formatMOV) {
                            selectedButton = formatMOV
                            currentFormatValue = formatMOV
                        } else {
                            selectedButton = null
                        }
                    }
                }

                Button {
                    width: parent.width / 2
                    height: parent.height
                    checkable: true
                    checked: false
                    property string formatMP4: "MP4"
                    background: Rectangle {
                        color: (selectedButton === parent.formatMP4 || currentFormatValue === parent.formatMP4) ? blue : transparent
                    }

                    Text {
                        text: "MP4"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.formatText= "MP4"

                        if (selectedButton !== formatMP4) {
                            selectedButton = formatMP4
                            currentFormatValue = formatMP4
                        } else {
                            selectedButton = null
                        }
                    }
                }
            }
        }

        // Exposure Mode UI
        Item {
            visible: buttonType === "exposureMode"
            anchors.fill: parent
            Row {
                anchors.fill: parent
                Button {
                    width: parent.width / 3
                    height: parent.height
                    checkable: true
                    checked: false
                    property string exposureAUTO: "AUTO"
                    background: Rectangle {
                        color: (selectedButton === parent.exposureAUTO || currentExposureValue === parent.exposureAUTO) ? blue : transparent
                    }

                    Text {
                        text: "AUTO"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.exposureModeText= "AUTO"

                        if (selectedButton !== exposureAUTO) {
                            selectedButton = exposureAUTO
                            currentExposureValue = exposureAUTO
                        } else {
                            selectedButton = null
                        }
                    }
                }

                Button {
                    width: parent.width / 3
                    height: parent.height
                    checkable: true
                    checked: false
                    property string exposureMANUAL: "MANUAL"
                    background: Rectangle {
                        color: (selectedButton === parent.exposureMANUAL || currentExposureValue === parent.exposureMANUAL) ? blue : transparent
                    }

                    Text {
                        text: "MANUAL"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.exposureModeText= "MANUAL"

                        if (selectedButton !== exposureMANUAL) {
                            selectedButton = exposureMANUAL
                            currentExposureValue = exposureMANUAL
                        } else {
                            selectedButton = null
                        }
                    }
                }

                Button {
                    width: parent.width / 3
                    height: parent.height
                    checkable: true
                    checked: false
                    property string exposureSHUTTEPRIORITY: "SHUTTER PRIORITY"
                    background: Rectangle {
                        color: (selectedButton === parent.exposureSHUTTEPRIORITY || currentExposureValue === parent.exposureSHUTTEPRIORITY) ? blue : transparent
                    }

                    Text {
                        text: "SHUTTER PRIORITY"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.exposureModeText= "SHUTTER PRIORITY"

                        if (selectedButton !== exposureSHUTTEPRIORITY) {
                            selectedButton = exposureSHUTTEPRIORITY
                            currentExposureValue = exposureSHUTTEPRIORITY
                        } else {
                            selectedButton = null
                        }
                    }
                }
            }
        }

        //EV UI
        Item {
            visible: buttonType === "EV"
            anchors.fill: parent
            Row {
                anchors.fill: parent
                Button {
                    width: parent.width / 8
                    height: parent.height
                    checkable: true
                    checked: false
                    property string evPlus3: "+3.0"
                    background: Rectangle {
                        color: (selectedButton === parent.evPlus3 || currentEVValue === parent.evPlus3) ? blue : transparent
                    }

                    Text {
                        text: "+3.0"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.evText= "+3.0"

                        if (selectedButton !== evPlus3) {
                            selectedButton = evPlus3
                            currentEVValue = evPlus3
                        } else {
                            selectedButton = null
                        }
                    }
                }

                Button {
                    width: parent.width / 8
                    height: parent.height
                    checkable: true
                    checked: false
                    property string evPlus27: "+2.7"
                    background: Rectangle {
                        color: (selectedButton === parent.evPlus27 || currentEVValue === parent.evPlus27) ? blue : transparent
                    }

                    Text {
                        text: "+2.7"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.evText= "+2.7"

                        if (selectedButton !== evPlus27) {
                            selectedButton = evPlus27
                            currentEVValue = evPlus27
                        } else {
                            selectedButton = null
                        }
                    }
                }

                Button {
                    width: parent.width / 8
                    height: parent.height
                    checkable: true
                    checked: false
                    property string evPlus23: "+2.3"
                    background: Rectangle {
                        color: (selectedButton === parent.evPlus23 || currentEVValue === parent.evPlus23) ? blue : transparent
                    }

                    Text {
                        text: "+2.3"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.evText= "+2.3"

                        if (selectedButton !== evPlus23) {
                            selectedButton = evPlus23
                            currentEVValue = evPlus23
                        } else {
                            selectedButton = null
                        }
                    }
                }

                Button {
                    width: parent.width / 8
                    height: parent.height
                    checkable: true
                    checked: false
                    property string evPlus2: "+2.0"
                    background: Rectangle {
                        color: (selectedButton === parent.evPlus2 || currentEVValue === parent.evPlus2) ? blue : transparent
                    }

                    Text {
                        text: "+2.0"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.evText= "+2.0"

                        if (selectedButton !== evPlus2) {
                            selectedButton = evPlus2
                            currentEVValue = evPlus2
                        } else {
                            selectedButton = null
                        }
                    }
                }

                Button {
                    width: parent.width / 8
                    height: parent.height
                    checkable: true
                    checked: false
                    property string evPlus17: "+1.7"
                    background: Rectangle {
                        color: (selectedButton === parent.evPlus17 || currentEVValue === parent.evPlus17) ? blue : transparent
                    }

                    Text {
                        text: "+1.7"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.evText= "+1.7"

                        if (selectedButton !== evPlus17) {
                            selectedButton = evPlus17
                            currentEVValue = evPlus17
                        } else {
                            selectedButton = null
                        }
                    }
                }

                Button {
                    width: parent.width / 8
                    height: parent.height
                    checkable: true
                    checked: false
                    property string evPlus13: "+1.3"
                    background: Rectangle {
                        color: (selectedButton === parent.evPlus13 || currentEVValue === parent.evPlus13) ? blue : transparent
                    }

                    Text {
                        text: "+1.3"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.evText= "+1.3"

                        if (selectedButton !== evPlus13) {
                            selectedButton = evPlus13
                            currentEVValue = evPlus13
                        } else {
                            selectedButton = null
                        }
                    }
                }

                Button {
                    width: parent.width / 8
                    height: parent.height
                    checkable: true
                    checked: false
                    property string evPlus1: "+1.0"
                    background: Rectangle {
                        color: (selectedButton === parent.evPlus1 || currentEVValue === parent.evPlus1) ? blue : transparent
                    }

                    Text {
                        text: "+1.0"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.evText= "+1.0"

                        if (selectedButton !== evPlus1) {
                            selectedButton = evPlus1
                            currentEVValue = evPlus1
                        } else {
                            selectedButton = null
                        }
                    }
                }

                Button {
                    width: parent.width / 8
                    height: parent.height
                    checkable: true
                    checked: false
                    property string evPlus07: "+0.7"
                    background: Rectangle {
                        color: (selectedButton === parent.evPlus07 || currentEVValue === parent.evPlus07) ? blue : transparent
                    }

                    Text {
                        text: "+0.7"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.evText= "+0.7"

                        if (selectedButton !== evPlus07) {
                            selectedButton = evPlus07
                            currentEVValue = evPlus07
                        } else {
                            selectedButton = null
                        }
                    }
                }
            }
        }

        //WB UI
        Flickable {
            anchors.fill: parent
            contentWidth: parent.width * 1.5
            contentHeight: parent.height
            id: flickAbleWb
            visible: buttonType === "WB"

            Row {
                anchors.fill: parent
                Button {
                    width: flickAbleWb.width / 4
                    height: flickAbleWb.height
                    checkable: true
                    checked: false
                    id: wbAutoBtn
                    property url wbAUTO: "qrc:/res/CameraBottomMenuAuto.svg"
                    background: Rectangle {
                        color: (selectedButton === parent.wbAUTO || currentWBValue === parent.wbAUTO) ? blue : transparent
                    }

                    Row {
                        width: parent.width / 1.7
                        height: parent.height / 2.2
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: defaultFontSize
                        Image {
                            source: wbAutoBtn.wbAUTO
                        }
                        Text {
                            text: "AUTO"
                            font.pixelSize: defaultFontSize * 3
                            color: fontColorWhite
                        }
                    }
                    onClicked: {
                        parentQML.wBImage= "qrc:/res/CameraBottomMenuAuto.svg"

                        if (selectedButton !== wbAUTO) {
                            selectedButton = wbAUTO
                            currentWBValue = wbAUTO
                        } else {
                            selectedButton = null
                        }
                    }
                }
                Button {
                    width: flickAbleWb.width / 4
                    height: flickAbleWb.height
                    checkable: true
                    checked: false
                    id: wbSunnyBtn
                    property url wbSUNNY: "qrc:/res/CameraBottomMenuWbButton.svg"
                    background: Rectangle {
                        color: (selectedButton === parent.wbSUNNY || currentWBValue === parent.wbSUNNY) ? blue : transparent
                    }

                    Row {
                        width: parent.width / 1.7
                        height: parent.height / 2.2
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: defaultFontSize
                        Image {
                            source: wbSunnyBtn.wbSUNNY
                        }
                        Text {
                            text: "SUNNY"
                            font.pixelSize: defaultFontSize * 3
                            color: fontColorWhite
                        }
                    }
                    onClicked: {
                        parentQML.wBImage= "qrc:/res/CameraBottomMenuWbButton.svg"

                        if (selectedButton !== wbSUNNY) {
                            selectedButton = wbSUNNY
                            currentWBValue = wbSUNNY
                        } else {
                            selectedButton = null
                        }
                    }
                }
                Button {
                    width: flickAbleWb.width / 4
                    height: flickAbleWb.height
                    checkable: true
                    checked: false
                    id: wbCloudyBtn
                    property url wbCLOUDY: "qrc:/res/CameraBottomMenuCloudy.svg"
                    background: Rectangle {
                        color: (selectedButton === parent.wbCLOUDY || currentWBValue === parent.wbCLOUDY) ? blue : transparent
                    }

                    Row {
                        width: parent.width / 1.7
                        height: parent.height / 2.2
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: defaultFontSize
                        Image {
                            source: wbCloudyBtn.wbCLOUDY
                        }
                        Text {
                            text: "CLOUDY"
                            font.pixelSize: defaultFontSize * 3
                            color: fontColorWhite
                        }
                    }
                    onClicked: {
                        parentQML.wBImage= "qrc:/res/CameraBottomMenuCloudy.svg"

                        if (selectedButton !== wbCLOUDY) {
                            selectedButton = wbCLOUDY
                            currentWBValue = wbCLOUDY
                        } else {
                            selectedButton = null
                        }
                    }
                }
                Button {
                    width: flickAbleWb.width / 4
                    height: flickAbleWb.height
                    checkable: true
                    checked: false
                    id: wbIncanBtn
                    property url wbINCAN: "qrc:/res/CameraBottomMenuIncan.svg"
                    background: Rectangle {
                        color: (selectedButton === parent.wbAUTO || currentWBValue === parent.wbINCAN) ? blue : transparent
                    }

                    Row {
                        width: parent.width / 1.7
                        height: parent.height / 2.2
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: defaultFontSize
                        Image {
                            source: wbIncanBtn.wbINCAN
                        }
                        Text {
                            text: "INCAN"
                            font.pixelSize: defaultFontSize * 3
                            color: fontColorWhite
                        }
                    }
                    onClicked: {
                        parentQML.wBImage= "qrc:/res/CameraBottomMenuIncan.svg"

                        if (selectedButton !== wbINCAN) {
                            selectedButton = wbINCAN
                            currentWBValue = wbINCAN
                        } else {
                            selectedButton = null
                        }
                    }
                }
                Button {
                    width: flickAbleWb.width / 4
                    height: flickAbleWb.height
                    checkable: true
                    checked: false
                    id: neonBtn
                    property url wbNeon: "qrc:/res/CameraBottomMenuNeon.svg"
                    background: Rectangle {
                        color: (selectedButton === parent.wbNeon || currentWBValue === parent.wbNeon) ? blue : transparent
                    }

                    Row {
                        width: parent.width / 1.7
                        height: parent.height / 2.2
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: defaultFontSize
                        Image {
                            source: neonBtn.wbNeon
                        }
                        Text {
                            text: "NEON"
                            font.pixelSize: defaultFontSize * 3
                            color: fontColorWhite
                        }
                    }
                    onClicked: {
                        parentQML.wBImage= "qrc:/res/CameraBottomMenuNeon.svg"

                        if (selectedButton !== wbNeon) {
                            selectedButton = wbNeon
                            currentWBValue = wbNeon
                        } else {
                            selectedButton = null
                        }
                    }
                }

                Button {
                    width: flickAbleWb.width / 4
                    height: flickAbleWb.height
                    checkable: true
                    checked: false
                    id: wb5000KBtn
                    property url wb5000K: "qrc:/res/CameraBottomMenu5000K.svg"
                    background: Rectangle {
                        color: (selectedButton === parent.wb5000K || currentWBValue === parent.wb5000K) ? blue : transparent
                    }

                    Row {
                        width: parent.width / 1.7
                        height: parent.height / 2.2
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: defaultFontSize
                        Image {
                            source: wb5000KBtn.wb5000K
                        }
                        Text {
                            text: "5000K"
                            font.pixelSize: defaultFontSize * 3
                            color: fontColorWhite
                        }
                    }
                    onClicked: {
                        parentQML.wBImage= "qrc:/res/CameraBottomMenu5000K.svg"

                        if (selectedButton !== wb5000K) {
                            selectedButton = wb5000K
                            currentWBValue = wb5000K
                        } else {
                            selectedButton = null
                        }
                    }
                }

            }
        }

        //Digital Zoom UI
        Item {
            visible: buttonType === "digitalZoom"
            anchors.fill: parent
            Row {
                anchors.fill: parent
                Button {
                    width: parent.width / 5
                    height: parent.height
                    checkable: true
                    checked: false
                    property string digitalZoom1X: "1.0X"
                    background: Rectangle {
                        color: (selectedButton === parent.digitalZoom1X || currentDigitalZoom === parent.digitalZoom1X) ? blue : transparent
                    }

                    Text {
                        text: "1.0X"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.digitalZoomText= "1.0X"

                        if (selectedButton !== digitalZoom1X) {
                            selectedButton = digitalZoom1X
                            currentDigitalZoom = digitalZoom1X
                        } else {
                            selectedButton = null
                        }
                    }
                }
                Button {
                    width: parent.width / 5
                    height: parent.height
                    checkable: true
                    checked: false
                    property string digitalZoom2X: "2.0X"
                    background: Rectangle {
                        color: (selectedButton === parent.digitalZoom2X || currentDigitalZoom === parent.digitalZoom2X) ? blue : transparent
                    }

                    Text {
                        text: "2.0X"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.digitalZoomText= "2.0X"

                        if (selectedButton !== digitalZoom2X) {
                            selectedButton = digitalZoom2X
                            currentDigitalZoom = digitalZoom2X
                        } else {
                            selectedButton = null
                        }
                    }
                }
                Button {
                    width: parent.width / 5
                    height: parent.height
                    checkable: true
                    checked: false
                    property string digitalZoom3X: "3.0X"
                    background: Rectangle {
                        color: (selectedButton === parent.digitalZoom3X || currentDigitalZoom === parent.digitalZoom3X) ? blue : transparent
                    }

                    Text {
                        text: "3.0X"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.digitalZoomText= "3.0X"

                        if (selectedButton !== digitalZoom3X) {
                            selectedButton = digitalZoom3X
                            currentDigitalZoom = digitalZoom3X
                        } else {
                            selectedButton = null
                        }
                    }
                }
                Button {
                    width: parent.width / 5
                    height: parent.height
                    checkable: true
                    checked: false
                    property string digitalZoom4X: "4.0X"
                    background: Rectangle {
                        color: (selectedButton === parent.digitalZoom4X || currentDigitalZoom === parent.digitalZoom4X) ? blue : transparent
                    }

                    Text {
                        text: "4.0X"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.digitalZoomText= "4.0X"

                        if (selectedButton !== digitalZoom4X) {
                            selectedButton = digitalZoom4X
                            currentDigitalZoom = digitalZoom4X
                        } else {
                            selectedButton = null
                        }
                    }
                }
                Button {
                    width: parent.width / 5
                    height: parent.height
                    checkable: true
                    checked: false
                    property string digitalZoom5X: "5.0X"
                    background: Rectangle {
                        color: (selectedButton === parent.digitalZoom5X || currentDigitalZoom === parent.digitalZoom5X) ? blue : transparent
                    }

                    Text {
                        text: "5.0X"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.digitalZoomText= "5.0X"

                        if (selectedButton !== digitalZoom5X) {
                            selectedButton = digitalZoom5X
                            currentDigitalZoom = digitalZoom5X
                        } else {
                            selectedButton = null
                        }
                    }
                }


            }
        }

        // AF UI
        Item {
            visible: buttonType === "AF"
            anchors.fill: parent
            Row {
                anchors.fill: parent
                Button {
                    width: parent.width / 2
                    height: parent.height
                    checkable: true
                    checked: false
                    property string af: "AF"
                    background: Rectangle {
                        color: (selectedButton === parent.af || currentAFValue === parent.af) ? blue : transparent
                    }

                    Text {
                        text: "AF"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.afText= "AF"

                        if (selectedButton !== af) {
                            selectedButton = af
                            currentAFValue = af
                        } else {
                            selectedButton = null
                        }
                    }
                }

                Button {
                    width: parent.width / 2
                    height: parent.height
                    checkable: true
                    checked: false
                    property string mf: "MF"
                    background: Rectangle {
                        color: (selectedButton === parent.mf || currentAFValue === parent.mf) ? blue : transparent
                    }

                    Text {
                        text: "MF"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.afText= "MF"

                        if (selectedButton !== mf) {
                            selectedButton = mf
                            currentAFValue = mf
                        } else {
                            selectedButton = null
                        }
                    }
                }


            }
        }

        // Color UI
        Item {
            visible: buttonType === "COLOR"
            anchors.fill: parent
            Row {
                anchors.fill: parent
                Button {
                    width: parent.width / 4
                    height: parent.height
                    checkable: true
                    checked: false
                    property string none: "NONE"
                    background: Rectangle {
                        color: (selectedButton === parent.none || currentColorValue === parent.none) ? blue : transparent
                    }

                    Text {
                        text: "NONE"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.colorText= "NONE"

                        if (selectedButton !== none) {
                            selectedButton = none
                            currentColorValue = none
                        } else {
                            selectedButton = null
                        }
                    }
                }
                Button {
                    width: parent.width / 4
                    height: parent.height
                    checkable: true
                    checked: false
                    property string log: "LOG"
                    background: Rectangle {
                        color: (selectedButton === parent.log || currentColorValue === parent.log) ? blue : transparent
                    }

                    Text {
                        text: "LOG"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.colorText= "LOG"

                        if (selectedButton !== log) {
                            selectedButton = log
                            currentColorValue = log
                        } else {
                            selectedButton = null
                        }
                    }
                }
                Button {
                    width: parent.width / 4
                    height: parent.height
                    checkable: true
                    checked: false
                    property string bAndW: "B&W"
                    background: Rectangle {
                        color: (selectedButton === parent.bAndW || currentColorValue === parent.bAndW) ? blue : transparent
                    }

                    Text {
                        text: "B&W"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.colorText= "B&W"

                        if (selectedButton !== bAndW) {
                            selectedButton = bAndW
                            currentColorValue = bAndW
                        } else {
                            selectedButton = null
                        }
                    }
                }
                Button {
                    width: parent.width / 4
                    height: parent.height
                    checkable: true
                    checked: false
                    property string nostalgic: "NOSTALGIC"
                    background: Rectangle {
                        color: (selectedButton === parent.nostalgic || currentColorValue === parent.nostalgic) ? blue : transparent
                    }

                    Text {
                        text: "NOSTALGIC"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.colorText= "NOSTALGIC"

                        if (selectedButton !== nostalgic) {
                            selectedButton = nostalgic
                            currentColorValue = nostalgic
                        } else {
                            selectedButton = null
                        }
                    }
                }




            }
        }

        // Style UI
        Item {
            anchors.fill: parent
            visible: buttonType === "STYLE"
            Row {
                anchors.fill: parent
                Button {
                    width: parent.width / 4
                    height: parent.height
                    checkable: true
                    checked: false
                    id: styleSTDBtn
                    property url styleSTD: "qrc:/res/CameraBottomMenuStyleButton.svg"
                    background: Rectangle {
                        color: (selectedButton === parent.styleSTD || currentStyleValue === parent.styleSTD) ? blue : transparent
                    }

                    Row {
                        width: parent.width / 1.7
                        height: parent.height / 2.2
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: defaultFontSize
                        Image {
                            source: styleSTDBtn.styleSTD
                        }
                        Text {
                            text: "STD. ±0 ±0 ±0"
                            font.pixelSize: defaultFontSize * 3
                            color: fontColorWhite
                        }
                    }
                    onClicked: {
                        parentQML.styleImage= "qrc:/res/CameraBottomMenuStyleButton.svg"

                        if (selectedButton !== styleSTD) {
                            selectedButton = styleSTD
                            currentStyleValue = styleSTD
                        } else {
                            selectedButton = null
                        }
                    }
                }
                Button {
                    width: parent.width / 4
                    height: parent.height
                    checkable: true
                    checked: false
                    id: styleNEUTBtn
                    property url styleNEUT: "qrc:/res/CameraBottomMenuNeut.svg"
                    background: Rectangle {
                        color: (selectedButton === parent.styleNEUT || currentStyleValue === parent.styleNEUT) ? blue : transparent
                    }

                    Row {
                        width: parent.width / 1.7
                        height: parent.height / 2.2
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: defaultFontSize
                        Image {
                            source: styleNEUTBtn.styleNEUT
                        }
                        Text {
                            text: "NEUT. -1 ±0 ±0"
                            font.pixelSize: defaultFontSize * 3
                            color: fontColorWhite
                        }
                    }
                    onClicked: {
                        parentQML.styleImage= "qrc:/res/CameraBottomMenuNeut.svg"

                        if (selectedButton !== styleNEUT) {
                            selectedButton = styleNEUT
                            currentStyleValue = styleNEUT
                        } else {
                            selectedButton = null
                        }
                    }
                }
                Button {
                    width: parent.width / 4
                    height: parent.height
                    checkable: true
                    checked: false
                    id: styleLANDBtn
                    property url styleLAND: "qrc:/res/CameraBottomMenuLand.svg"
                    background: Rectangle {
                        color: (selectedButton === parent.styleLAND || currentStyleValue === parent.styleLAND) ? blue : transparent
                    }

                    Row {
                        width: parent.width / 1.7
                        height: parent.height / 2.2
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: defaultFontSize
                        Image {
                            source: styleLANDBtn.styleLAND
                        }
                        Text {
                            text: "LAND. +1 +1 ±0"
                            font.pixelSize: defaultFontSize * 3
                            color: fontColorWhite
                        }
                    }
                    onClicked: {
                        parentQML.styleImage= "qrc:/res/CameraBottomMenuLand.svg"

                        if (selectedButton !== styleLAND) {
                            selectedButton = styleLAND
                            currentStyleValue = styleLAND
                        } else {
                            selectedButton = null
                        }
                    }
                }
                Button {
                    width: parent.width / 4
                    height: parent.height
                    checkable: true
                    checked: false
                    id: styleDefaultBtn
                    property url styleDefault: "qrc:/res/CameraBottomMenu5000K.svg"
                    background: Rectangle {
                        color: (selectedButton === parent.styleDefault || currentStyleValue === parent.styleDefault) ? blue : transparent
                    }

                    Row {
                        width: parent.width / 1.7
                        height: parent.height / 2.2
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenter: parent.verticalCenter
                        spacing: defaultFontSize
                        Image {
                            source: styleDefaultBtn.styleDefault
                        }
                        Text {
                            text: "+0 +0 ±0"
                            font.pixelSize: defaultFontSize * 3
                            color: fontColorWhite
                        }
                    }
                    onClicked: {
                        parentQML.styleImage= "qrc:/res/CameraBottomMenu5000K.svg"

                        if (selectedButton !== styleDefault) {
                            selectedButton = styleDefault
                            currentStyleValue = styleDefault
                        } else {
                            selectedButton = null
                        }
                    }
                }
            }
        }

        // PIV UI
        Item {
            visible: buttonType === "PIV"
            anchors.fill: parent
            Row {
                anchors.fill: parent
                Button {
                    width: parent.width / 4
                    height: parent.height
                    checkable: true
                    checked: false
                    property string manual: "MANUAL"
                    background: Rectangle {
                        color: (selectedButton === parent.manual || currentPivValue === parent.manual) ? blue : transparent
                    }

                    Text {
                        text: "MANUAL"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.pivText= "MANUAL"

                        if (selectedButton !== manual) {
                            selectedButton = manual
                            currentPivValue = manual
                        } else {
                            selectedButton = null
                        }
                    }
                }
                Button {
                    width: parent.width / 4
                    height: parent.height
                    checkable: true
                    checked: false
                    property string piv5S: "5S"
                    background: Rectangle {
                        color: (selectedButton === parent.piv5S || currentPivValue === parent.piv5S) ? blue : transparent
                    }

                    Text {
                        text: "5S"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.pivText= "5S"

                        if (selectedButton !== piv5S) {
                            selectedButton = piv5S
                            currentPivValue = piv5S
                        } else {
                            selectedButton = null
                        }
                    }
                }
                Button {
                    width: parent.width / 4
                    height: parent.height
                    checkable: true
                    checked: false
                    property string piv10S: "10S"
                    background: Rectangle {
                        color: (selectedButton === parent.piv10S || currentPivValue === parent.piv10S) ? blue : transparent
                    }

                    Text {
                        text: "10S"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.pivText= "10S"

                        if (selectedButton !== piv10S) {
                            selectedButton = piv10S
                            currentPivValue = piv10S
                        } else {
                            selectedButton = null
                        }
                    }
                }
                Button {
                    width: parent.width / 4
                    height: parent.height
                    checkable: true
                    checked: false
                    property string piv30S: "30S"
                    background: Rectangle {
                        color: (selectedButton === parent.piv30S || currentPivValue === parent.piv30S) ? blue : transparent
                    }

                    Text {
                        text: "30S"
                        font.pixelSize: defaultFontSize * 3
                        color: fontColorWhite
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    onClicked: {
                        parentQML.pivText= "30S"

                        if (selectedButton !== piv30S) {
                            selectedButton = piv30S
                            currentPivValue = piv30S
                        } else {
                            selectedButton = null
                        }
                    }
                }
            }
        }
    }

}


