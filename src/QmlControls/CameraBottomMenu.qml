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
    property color defaultTextColor: "white"
    property color transparent: "transparent"
    property color fontColorWhite: "white"
    property color fontColorlightGray: "#a7a7a7"
    property color defaultBackGroundColor: "#3b3737"
    property color blue: "#3d71d7"

    //Size Property
    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize

    implicitWidth: Screen.width
    implicitHeight: defaultFontSize * 9

    property string resolutionText: "8K"
    property string frameRateText: "60FPS"
    property string formatText: "MP4"
    property string exposureModeText: "MANUAL"
    property string evText: "+2.3"
    property url wBImage: "qrc:/res/CameraBottomMenuWbButton.svg"
    property string digitalZoomText: "2.0X"
    property string afText: "MF"
    property string colorText: "LOG"
    property url styleImage: "qrc:/res/CameraBottomMenuStyleButton.svg"
    property string pivText: "5S"
    property var selectedButton: null

    property alias camGimbalSliderBar: cameraGimbalSliderBar
    property var parentQML: null
    property var parentQMLRoot: null

    z : 1

    signal settingClicked()

    //BottomMenu Popup
    Loader {
        id: popupLoader
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
        }
        width: parent.width
        height: parent.height
        sourceComponent: null

        z : 2
    }

    //Camera Gimbal Loader
    Loader {
        id: cameraGimbalSliderBar
        visible : false
        onLoaded: {
            if(item){
                width = item.width
                height = item.height
            }
        }
    }

    //Camera Gimbal Value Setting button Loader
    Loader {
        id: cameraGimbalValueButton
        visible: false
        onLoaded: {
            if(item){
                width = item.width
                height = item.height
            }
        }
    }



    //Camera Gimbal Value Text
    Text {
        id: gimbalValueText
        visible: false
        text: (cameraGimbalSliderBar.item != null) ? cameraGimbalSliderBar.item.currentPitch + "°" : "0°"
        color: defaultTextColor
        font.pixelSize: defaultFontSize * 20
        anchors.right: root.right
        anchors.rightMargin: root.width / 2.4
        anchors.bottom: root.bottom
        anchors.bottomMargin: Screen.height / 2.5
    }


    Row {
        anchors.fill: parent
        width: parent.width
        id: viewButtonRow
        spacing: 0
        Button {
            width: viewButtonRow.width * 0.107
            height: viewButtonRow.height
            background: Rectangle { color: transparent }

            property bool isGimbalMenuShow: false

            Image {
                width: parent.width / 3.7
                height: parent.height / 1.5
                source: "qrc:/res/CameraBottomMenuAngleButton.svg"
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Image {
                width: parent.width / 12
                height: parent.height / 7.5
                source: "qrc:/res/CameraBottomMenuAngleDotButton.svg"
                x: parent.width / 2.6
                y: parent.height / 5.3
            }

            Text {
                text: (cameraGimbalSliderBar.item != null) ? cameraGimbalSliderBar.item.currentPitch + " °" : "0 °"
                color: "white"
                x: parent.width / 1.7
                y: parent.height / 8
                font.pixelSize: defaultFontSize * 2
            }

            onClicked: {

                if(isGimbalMenuShow == false){
                    gimbalValueText.visible = true
                    cameraGimbalSliderBar.visible = true
                    if(cameraGimbalSliderBar.item == null){
                        cameraGimbalSliderBar.source = "qrc:/qml/QGroundControl/Controls/CameraGimbalSliderBar.qml"
                        cameraGimbalSliderBar.visible = true
                        cameraGimbalSliderBar.anchors.right = root.right
                        cameraGimbalSliderBar.anchors.rightMargin = root.width / 6
                        cameraGimbalSliderBar.anchors.bottom = root.bottom
                        cameraGimbalSliderBar.anchors.bottomMargin = Screen.height / 3

                        console.log("currentPitch", cameraGimbalSliderBar.item.currentPitch)
                    }
                    if(cameraGimbalValueButton.item == null) {
                        cameraGimbalValueButton.source = "qrc:/qml/QGroundControl/Controls/CameraGimbalAngleButton.qml"
                        cameraGimbalValueButton.visible = true
                        cameraGimbalValueButton.anchors.right = root.right
                        cameraGimbalValueButton.anchors.rightMargin = root.width / 4.5

                        cameraGimbalValueButton.anchors.bottom = cameraGimbalSliderBar.bottom
                        cameraGimbalValueButton.item.parentQML = root

                    }
                    isGimbalMenuShow = true
                }
                else {
                    gimbalValueText.visible = false
                    cameraGimbalSliderBar.visible = false
                    //cameraGimbalSliderBar.sourceComponent = null
                    cameraGimbalValueButton.sourceComponent = null
                    isGimbalMenuShow = false
                }
            }
        }


        Button {
            width: viewButtonRow.width * 0.024
            height: viewButtonRow.height
            background: Rectangle { color: transparent }

            Image {
                source: "qrc:/res/BackArrowButton.svg"
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width /1.8
                height: parent.height / 2.1
            }
            onClicked: {
                flickAble.contentX = Math.max(0, flickAble.contentX - flickAble.width)
            }
        }

        //Flickable
        Rectangle {
            width: viewButtonRow.width * 0.755
            height: viewButtonRow.height
            color: transparent
            clip: true
            Flickable {
                anchors.fill: parent
                contentWidth: parent.width * 2.6
                contentHeight: parent.height
                id: flickAble
                Row {
                    Button {
                        width: flickAble.width / 5
                        height: flickAble.height
                        id: resolution
                        property string resolutionId: "resolution"

                        background: Rectangle {
                            color: transparent
                            Column {
                                anchors.centerIn: parent
                                spacing: defaultFontSize
                                Text {
                                    text: resolutionText
                                    color: fontColorWhite
                                    horizontalAlignment: Text.AlignHCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    font.pixelSize: defaultFontSize * 2.4
                                }
                                Text {
                                    text: "RESOLUTION"
                                    color: fontColorlightGray
                                    horizontalAlignment: Text.AlignHCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    font.pixelSize: defaultFontSize * 2
                                }
                                Rectangle {
                                    width: parent.width
                                    height: defaultFontSize / 2
                                    color: selectedButton === resolution.resolutionId? blue : transparent
                                }
                            }
                        }
                        onClicked:  {
                            if (!popupLoader.item) {
                                popupLoader.setSource("qrc:/qml/QGroundControl/Controls/CameraBottomMenuPopup.qml", {
                                                          "buttonType": "resolution",
                                                          "x": "0",
                                                          "y": -popupLoader.height,
                                                          "parentQML":  root,
                                                          "currentResolutionValue": resolutionText })
                                parentQML.visible = false
                            } else if(popupLoader.item.buttonType !== resolutionId){
                                popupLoader.sourceComponent = null
                                popupLoader.setSource("qrc:/qml/QGroundControl/Controls/CameraBottomMenuPopup.qml", {
                                                          "buttonType": "resolution",
                                                          "x": "0",
                                                          "y": -popupLoader.height,
                                                          "parentQML":  root,
                                                          "currentResolutionValue": resolutionText })
                                parentQML.visible = false
                            }else {
                                popupLoader.sourceComponent = null
                                parentQML.visible = true
                            }
                            if (selectedButton !== resolutionId) {
                                selectedButton = resolutionId
                            } else {
                                selectedButton = null
                            }
                        }
                    }

                    Button {
                        width: flickAble.width / 5
                        height: flickAble.height
                        id: frameRate
                        property string frameButtonId: "frameRate"

                        background: Rectangle {
                            color: transparent
                            Column {
                                anchors.centerIn: parent
                                spacing: defaultFontSize
                                Text {
                                    text: frameRateText
                                    color: fontColorWhite
                                    horizontalAlignment: Text.AlignHCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    font.pixelSize: defaultFontSize * 2.4
                                }
                                Text {
                                    text: "FRAME RATE"
                                    color: fontColorlightGray
                                    horizontalAlignment: Text.AlignHCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    font.pixelSize: defaultFontSize * 2
                                }
                                Rectangle {
                                    width: parent.width
                                    height: defaultFontSize / 2
                                    color: selectedButton === frameRate.frameButtonId? blue : transparent
                                }
                            }
                        }
                        onClicked:  {
                            if (!popupLoader.item) {
                                popupLoader.setSource("qrc:/qml/QGroundControl/Controls/CameraBottomMenuPopup.qml", {
                                                          "buttonType": "frameRate",
                                                          "x": "0",
                                                          "y": -popupLoader.height,
                                                          "parentQML":  root,
                                                          "currentFrameRateValue": frameRateText })
                                parentQML.visible = false
                            } else if(popupLoader.item.buttonType !== frameButtonId){
                                popupLoader.sourceComponent = null
                                popupLoader.setSource("qrc:/qml/QGroundControl/Controls/CameraBottomMenuPopup.qml", {
                                                          "buttonType": "frameRate",
                                                          "x": "0",
                                                          "y": -popupLoader.height,
                                                          "parentQML":  root,
                                                          "currentFrameRateValue": frameRateText })
                                parentQML.visible = false
                            }else {
                                popupLoader.sourceComponent = null
                                parentQML.visible = true
                            }

                            if (selectedButton !== frameButtonId) {
                                selectedButton = frameButtonId
                            } else {
                                selectedButton = null
                            }
                        }
                    }

                    Button {
                        width: flickAble.width / 5
                        height: flickAble.height
                        id: format
                        property string formatButtonId: "format"

                        background: Rectangle {
                            color: transparent
                            Column {
                                anchors.centerIn: parent
                                spacing: defaultFontSize
                                Text {
                                    text: formatText
                                    color: fontColorWhite
                                    horizontalAlignment: Text.AlignHCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    font.pixelSize: defaultFontSize * 2.4
                                }
                                Text {
                                    text: "FORMAT"
                                    color: fontColorlightGray
                                    horizontalAlignment: Text.AlignHCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    font.pixelSize: defaultFontSize * 2
                                }
                                Rectangle {
                                    width: parent.width
                                    height: defaultFontSize / 2
                                    color: selectedButton === format.formatButtonId ? blue : transparent
                                }
                            }
                        }
                        onClicked:  {
                            if (!popupLoader.item) {
                                popupLoader.setSource("qrc:/qml/QGroundControl/Controls/CameraBottomMenuPopup.qml", {
                                                          "buttonType": "format",
                                                          "x": "0",
                                                          "y": -popupLoader.height,
                                                          "parentQML":  root,
                                                          "currentFormatValue": formatText })
                                parentQML.visible = false
                            } else if(popupLoader.item.buttonType !== formatButtonId){
                                popupLoader.sourceComponent = null
                                popupLoader.setSource("qrc:/qml/QGroundControl/Controls/CameraBottomMenuPopup.qml", {
                                                          "buttonType": "format",
                                                          "x": "0",
                                                          "y": -popupLoader.height,
                                                          "parentQML":  root,
                                                          "currentFormatValue": formatText })
                                parentQML.visible = false
                            }else {
                                popupLoader.sourceComponent = null
                                parentQML.visible = true
                            }

                            if (selectedButton !== formatButtonId) {
                                selectedButton = formatButtonId
                            } else {
                                selectedButton = null
                            }
                        }
                    }

                    Button {
                        width: flickAble.width / 5
                        height: flickAble.height
                        id: exposure
                        property string exposureButtonId: "exposureMode"

                        background: Rectangle {
                            color: transparent
                            Column {
                                anchors.centerIn: parent
                                spacing: defaultFontSize
                                Text {
                                    text: exposureModeText
                                    color: fontColorWhite
                                    horizontalAlignment: Text.AlignHCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    font.pixelSize: defaultFontSize * 2.4
                                }
                                Text {
                                    text: "EXPOSURE MODE"
                                    color: fontColorlightGray
                                    horizontalAlignment: Text.AlignHCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    font.pixelSize: defaultFontSize * 2
                                }
                                Rectangle {
                                    width: parent.width
                                    height: defaultFontSize / 2
                                    color: selectedButton === exposure.exposureButtonId ? blue : transparent
                                }
                            }
                        }
                        onClicked:  {
                            if (!popupLoader.item) {
                                popupLoader.setSource("qrc:/qml/QGroundControl/Controls/CameraBottomMenuPopup.qml", {
                                                          "buttonType": "exposureMode",
                                                          "x": "0",
                                                          "y": -popupLoader.height,
                                                          "parentQML":  root,
                                                          "currentExposureValue": exposureModeText })
                                parentQML.visible = false
                            } else if(popupLoader.item.buttonType !== exposureButtonId){
                                popupLoader.sourceComponent = null
                                popupLoader.setSource("qrc:/qml/QGroundControl/Controls/CameraBottomMenuPopup.qml", {
                                                          "buttonType": "exposureMode",
                                                          "x": "0",
                                                          "y": -popupLoader.height,
                                                          "parentQML":  root,
                                                          "currentExposureValue": exposureModeText })
                                parentQML.visible = false
                            }else {
                                popupLoader.sourceComponent = null
                                parentQML.visible = true
                            }

                            if (selectedButton !== exposureButtonId) {
                                selectedButton = exposureButtonId
                            } else {
                                selectedButton = null
                            }
                        }
                    }

                    Button {
                        width: flickAble.width / 5
                        height: flickAble.height
                        background: Rectangle { color: transparent }

                        Column {
                            anchors.centerIn: parent
                            spacing: defaultFontSize
                            Text {
                                text: "1/60"
                                color: fontColorlightGray
                                horizontalAlignment: Text.AlignHCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                font.pixelSize: defaultFontSize * 2.4
                            }
                            Text {
                                text: "SHUTTER"
                                color: fontColorlightGray
                                horizontalAlignment: Text.AlignHCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                font.pixelSize: defaultFontSize * 2
                            }
                        }
                    }

                    Button {
                        width: flickAble.width / 5
                        height: flickAble.height
                        background: Rectangle { color: transparent }

                        Column {
                            anchors.centerIn: parent
                            spacing: defaultFontSize
                            Text {
                                text: "100"
                                color: fontColorWhite
                                horizontalAlignment: Text.AlignHCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                font.pixelSize: defaultFontSize * 2.4
                            }
                            Text {
                                text: "ISO"
                                color: fontColorlightGray
                                horizontalAlignment: Text.AlignHCenter
                                anchors.horizontalCenter: parent.horizontalCenter
                                font.pixelSize: defaultFontSize * 2
                            }
                        }
                    }

                    Button {
                        width: flickAble.width / 5
                        height: flickAble.height
                        id: ev
                        property string evButtonId: "EV"

                        background: Rectangle {
                            color: transparent
                            Column {
                                anchors.centerIn: parent
                                spacing: defaultFontSize
                                Text {
                                    text: evText
                                    color: fontColorWhite
                                    horizontalAlignment: Text.AlignHCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    font.pixelSize: defaultFontSize * 2.4
                                }
                                Text {
                                    text: "EV"
                                    color: fontColorlightGray
                                    horizontalAlignment: Text.AlignHCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    font.pixelSize: defaultFontSize * 2
                                }
                                Rectangle {
                                    width: parent.width
                                    height: defaultFontSize / 2
                                    color: selectedButton === ev.evButtonId ? blue : transparent
                                }
                            }
                        }
                        onClicked:  {
                            if (!popupLoader.item) {
                                popupLoader.setSource("qrc:/qml/QGroundControl/Controls/CameraBottomMenuPopup.qml", {
                                                          "buttonType": "EV",
                                                          "x": "0",
                                                          "y": -popupLoader.height,
                                                          "parentQML":  root,
                                                          "currentEVValue": evText })
                                parentQML.visible = false
                            } else if(popupLoader.item.buttonType !== evButtonId){
                                popupLoader.sourceComponent = null
                                popupLoader.setSource("qrc:/qml/QGroundControl/Controls/CameraBottomMenuPopup.qml", {
                                                          "buttonType": "EV",
                                                          "x": "0",
                                                          "y": -popupLoader.height,
                                                          "parentQML":  root,
                                                          "currentEVValue": evText })
                                parentQML.visible = false
                            }else {
                                popupLoader.sourceComponent = null
                                parentQML.visible = true
                            }

                            if (selectedButton !== evButtonId) {
                                selectedButton = evButtonId
                            } else {
                                selectedButton = null
                            }
                        }
                    }

                    Button {
                        width: flickAble.width / 5
                        height: flickAble.height
                        id: wb
                        property string wbButtonId: "WB"

                        background: Rectangle {
                            color: transparent
                            Column {
                                anchors.centerIn: parent
                                spacing: defaultFontSize
                                Image {
                                    source: wBImage
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                                Text {
                                    text: "WB"
                                    color: fontColorlightGray
                                    horizontalAlignment: Text.AlignHCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    font.pixelSize: defaultFontSize * 2
                                }
                                Rectangle {
                                    width: parent.width
                                    height: defaultFontSize / 2
                                    color: selectedButton === wb.wbButtonId ? blue : transparent
                                }
                            }
                        }
                        onClicked:  {
                            if (!popupLoader.item) {
                                popupLoader.setSource("qrc:/qml/QGroundControl/Controls/CameraBottomMenuPopup.qml", {
                                                          "buttonType": "WB",
                                                          "x": "0",
                                                          "y": -popupLoader.height,
                                                          "parentQML":  root,
                                                          "currentWBValue": wBImage })
                                parentQML.visible = false
                            } else if(popupLoader.item.buttonType !== wbButtonId){
                                popupLoader.sourceComponent = null
                                popupLoader.setSource("qrc:/qml/QGroundControl/Controls/CameraBottomMenuPopup.qml", {
                                                          "buttonType": "WB",
                                                          "x": "0",
                                                          "y": -popupLoader.height,
                                                          "parentQML":  root,
                                                          "currentWBValue": wBImage })
                                parentQML.visible = false
                            }else {
                                popupLoader.sourceComponent = null
                                parentQML.visible = true
                            }

                            if (selectedButton !== wbButtonId) {
                                selectedButton = wbButtonId
                            } else {
                                selectedButton = null
                            }
                        }
                    }

                    Button {
                        width: flickAble.width / 5
                        height: flickAble.height
                        id: digitalZoom
                        property string digitalZoomButtonId: "digitalZoom"

                        background: Rectangle {
                            color: transparent
                            Column {
                                anchors.centerIn: parent
                                spacing: defaultFontSize
                                Text {
                                    text: digitalZoomText
                                    color: fontColorWhite
                                    horizontalAlignment: Text.AlignHCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    font.pixelSize: defaultFontSize * 2.4
                                }
                                Text {
                                    text: "DIGITAL ZOOM"
                                    color: fontColorlightGray
                                    horizontalAlignment: Text.AlignHCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    font.pixelSize: defaultFontSize * 2
                                }
                                Rectangle {
                                    width: parent.width
                                    height: defaultFontSize / 2
                                    color: selectedButton === digitalZoom.digitalZoomButtonId ? blue : transparent
                                }
                            }
                        }
                        onClicked:  {
                            if (!popupLoader.item) {
                                popupLoader.setSource("qrc:/qml/QGroundControl/Controls/CameraBottomMenuPopup.qml", {
                                                          "buttonType": "digitalZoom",
                                                          "x": "0",
                                                          "y": -popupLoader.height,
                                                          "parentQML":  root,
                                                          "currentDigitalZoom": digitalZoomText })
                                parentQML.visible = false
                            } else if(popupLoader.item.buttonType !== digitalZoomButtonId){
                                popupLoader.sourceComponent = null
                                popupLoader.setSource("qrc:/qml/QGroundControl/Controls/CameraBottomMenuPopup.qml", {
                                                          "buttonType": "digitalZoom",
                                                          "x": "0",
                                                          "y": -popupLoader.height,
                                                          "parentQML":  root,
                                                          "currentDigitalZoom": digitalZoomText })
                                parentQML.visible = false
                            }else {
                                popupLoader.sourceComponent = null
                                parentQML.visible = true
                            }

                            if (selectedButton !== digitalZoomButtonId) {
                                selectedButton = digitalZoomButtonId
                            } else {
                                selectedButton = null
                            }
                        }
                    }

                    Button {
                        width: flickAble.width / 5
                        height: flickAble.height
                        id: af
                        property string afButtonId: "AF"

                        background: Rectangle {
                            color: transparent
                            Column {
                                anchors.centerIn: parent
                                spacing: defaultFontSize
                                Text {
                                    text: afText
                                    color: fontColorWhite
                                    horizontalAlignment: Text.AlignHCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    font.pixelSize: defaultFontSize * 2.4
                                }
                                Text {
                                    text: "AF"
                                    color: fontColorlightGray
                                    horizontalAlignment: Text.AlignHCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    font.pixelSize: defaultFontSize * 2
                                }
                                Rectangle {
                                    width: parent.width
                                    height: defaultFontSize / 2
                                    color: selectedButton === af.afButtonId ? blue : transparent
                                }
                            }
                        }
                        onClicked:  {
                            if (!popupLoader.item) {
                                popupLoader.setSource("qrc:/qml/QGroundControl/Controls/CameraBottomMenuPopup.qml", {
                                                          "buttonType": "AF",
                                                          "x": "0",
                                                          "y": -popupLoader.height,
                                                          "parentQML":  root,
                                                          "currentAFValue": afText })
                                parentQML.visible = false
                            } else if(popupLoader.item.buttonType !== afButtonId){
                                popupLoader.sourceComponent = null
                                popupLoader.setSource("qrc:/qml/QGroundControl/Controls/CameraBottomMenuPopup.qml", {
                                                          "buttonType": "AF",
                                                          "x": "0",
                                                          "y": -popupLoader.height,
                                                          "parentQML":  root,
                                                          "currentAFValue": afText })
                                parentQML.visible = false
                            }else {
                                popupLoader.sourceComponent = null
                                parentQML.visible = true
                            }

                            if (selectedButton !== afButtonId) {
                                selectedButton = afButtonId
                            } else {
                                selectedButton = null
                            }
                        }
                    }

                    Button {
                        width: flickAble.width / 5
                        height: flickAble.height
                        id: color
                        property string colorButtonId: "COLOR"

                        background: Rectangle {
                            color: transparent
                            Column {
                                anchors.centerIn: parent
                                spacing: defaultFontSize
                                Text {
                                    text: colorText
                                    color: fontColorWhite
                                    horizontalAlignment: Text.AlignHCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    font.pixelSize: defaultFontSize * 2.4
                                }
                                Text {
                                    text: "COLOR"
                                    color: fontColorlightGray
                                    horizontalAlignment: Text.AlignHCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    font.pixelSize: defaultFontSize * 2
                                }
                                Rectangle {
                                    width: parent.width
                                    height: defaultFontSize / 2
                                    color: selectedButton === color.colorButtonId ? blue : transparent
                                }
                            }
                        }
                        onClicked:  {
                            if (!popupLoader.item) {
                                popupLoader.setSource("qrc:/qml/QGroundControl/Controls/CameraBottomMenuPopup.qml", {
                                                          "buttonType": "COLOR",
                                                          "x": "0",
                                                          "y": -popupLoader.height,
                                                          "parentQML":  root,
                                                          "currentColorValue": colorText })
                                parentQML.visible = false
                            } else if(popupLoader.item.buttonType !== colorButtonId){
                                popupLoader.sourceComponent = null
                                popupLoader.setSource("qrc:/qml/QGroundControl/Controls/CameraBottomMenuPopup.qml", {
                                                          "buttonType": "COLOR",
                                                          "x": "0",
                                                          "y": -popupLoader.height,
                                                          "parentQML":  root,
                                                          "currentColorValue": colorText })
                                parentQML.visible = false
                            }else {
                                popupLoader.sourceComponent = null
                                parentQML.visible = true
                            }

                            if (selectedButton !== colorButtonId) {
                                selectedButton = colorButtonId
                            } else {
                                selectedButton = null
                            }
                        }
                    }

                    Button {
                        width: flickAble.width / 5
                        height: flickAble.height
                        id: style
                        property string styleButtonId: "STYLE"

                        background: Rectangle {
                            color: transparent
                            Column {
                                anchors.centerIn: parent
                                spacing: defaultFontSize
                                Image {
                                    source: styleImage
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                                Text {
                                    text: "STYLE"
                                    color: fontColorlightGray
                                    horizontalAlignment: Text.AlignHCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    font.pixelSize: defaultFontSize * 2
                                }
                                Rectangle {
                                    width: parent.width
                                    height: defaultFontSize / 2
                                    color: selectedButton === style.styleButtonId ? blue : transparent
                                }
                            }
                        }
                        onClicked:  {
                            if (!popupLoader.item) {
                                popupLoader.setSource("qrc:/qml/QGroundControl/Controls/CameraBottomMenuPopup.qml", {
                                                          "buttonType": "STYLE",
                                                          "x": "0",
                                                          "y": -popupLoader.height,
                                                          "parentQML":  root,
                                                          "currentStyleValue": styleImage })
                                parentQML.visible = false
                            } else if(popupLoader.item.buttonType !== styleButtonId){
                                popupLoader.sourceComponent = null
                                popupLoader.setSource("qrc:/qml/QGroundControl/Controls/CameraBottomMenuPopup.qml", {
                                                          "buttonType": "STYLE",
                                                          "x": "0",
                                                          "y": -popupLoader.height,
                                                          "parentQML":  root,
                                                          "currentStyleValue": styleImage })
                                parentQML.visible = false
                            }else {
                                popupLoader.sourceComponent = null
                                parentQML.visible = true
                            }

                            if (selectedButton !== styleButtonId) {
                                selectedButton = styleButtonId
                            } else {
                                selectedButton = null
                            }
                        }
                    }

                    Button {
                        width: flickAble.width / 5
                        height: flickAble.height
                        id: piv
                        property string pivButtonId: "PIV"

                        background: Rectangle {
                            color: transparent
                            Column {
                                anchors.centerIn: parent
                                spacing: defaultFontSize
                                Text {
                                    text: pivText
                                    color: fontColorWhite
                                    horizontalAlignment: Text.AlignHCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    font.pixelSize: defaultFontSize * 2.4
                                }
                                Text {
                                    text: "PIV"
                                    color: fontColorlightGray
                                    horizontalAlignment: Text.AlignHCenter
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    font.pixelSize: defaultFontSize * 2
                                }
                                Rectangle {
                                    width: parent.width
                                    height: defaultFontSize / 2
                                    color: selectedButton === piv.pivButtonId ? blue : transparent
                                }
                            }
                        }
                        onClicked:  {
                            if (!popupLoader.item) {
                                popupLoader.setSource("qrc:/qml/QGroundControl/Controls/CameraBottomMenuPopup.qml", {
                                                          "buttonType": "PIV",
                                                          "x": "0",
                                                          "y": -popupLoader.height,
                                                          "parentQML":  root,
                                                          "currentPivValue": pivText })
                                parentQML.visible = false
                            } else if(popupLoader.item.buttonType !== pivButtonId){
                                popupLoader.sourceComponent = null
                                popupLoader.setSource("qrc:/qml/QGroundControl/Controls/CameraBottomMenuPopup.qml", {
                                                          "buttonType": "PIV",
                                                          "x": "0",
                                                          "y": -popupLoader.height,
                                                          "parentQML":  root,
                                                          "currentPivValue": pivText })
                                parentQML.visible = false
                            }else {
                                popupLoader.sourceComponent = null
                                parentQML.visible = true
                            }

                            if (selectedButton !== pivButtonId) {
                                selectedButton = pivButtonId
                            } else {
                                selectedButton = null
                            }
                        }
                    }
                }

                //Smooth Moving Animation
                Behavior on contentX {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.InOutQuad
                    }
                }
            }
        }

        Button {
            width: viewButtonRow.width * 0.024
            height: viewButtonRow.height
            background: Rectangle { color: transparent }

            Image {
                source: "qrc:/res/FrontArrowButton.svg"
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width /1.8
                height: parent.height / 2.1
            }

            onClicked: {
                flickAble.contentX = Math.min(flickAble.contentWidth - flickAble.width, flickAble.contentX + flickAble.width)
            }
        }
        Button {
            width: viewButtonRow.width * 0.09
            height: viewButtonRow.height
            background: Rectangle { color: transparent }

            Image {
                source: "qrc:/res/CameraBottomMenuSettingButton.svg"
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width / 3
                height: parent.height / 2
            }
            onClicked: {
                console.log("Camera Setting Button Click");

                settingClicked()
            }
        }
    }


}


