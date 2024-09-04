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
    implicitWidth: Screen.width
    implicitHeight: Screen.height / 3.7
    color: defaultBackGroundColor
    anchors.bottom: parent.bottom

    //Properties
    property color defaultTextColor: "white"
    property color transparent: "transparent"
    property color fontColorWhite: "white"
    property color fontColorlightGray: "#a7a7a7"
    property color defaultBackGroundColor: "#3b3737"
    property color fontColorRed: "red"
    property color blue: "#3d71d7"
    property int margin: 10

    //Size Property
    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize

    property var parentQML: null
    property var titleText: null

    z: 3

    Text {
        text: titleText
        font.bold: true
        font.pixelSize: defaultFontSize * 4
        font.styleName: 'Arial'
        color: fontColorWhite
        anchors.top: parent.top
        anchors.topMargin: 25
        anchors.left: parent.left
        anchors.leftMargin: 85
    }

    Text {
        //text: "A high resolution will create a high image quality with large file sizes."
        text : {
            if(titleText === "RESOLUTION"){
                "A high resolution will create a high image quality with large file sizes."
            }
            else if(titleText === "FRAMERATE") {
                "Frames Per Second (FPS) will change based on your resolution settings.\nRecording at High frames rates will also allow you to capture slow-motion footage"
            }
            else if(titleText === "FORMAT") {
                "MP4 is a standard format recognized by most media players and editing suites. MP4 is more\ncommon for use on a PC. MOV is an apple standard and works natively with QuickTime and\napples editing suites."
            }
            else if(titleText === "EXPOSUREMODE") {
                "Exposure mode : if manual mode is selected, users can adjust the ISO, shutter speed and aperture value,\nbut the exposure value (EV) cannot be adjusted. if auto mode is selected, the camera will automatically\nadjust the ISO, shutter speed and aperture value. The shutter speed detemines the camera's exposure\ntime, and the aperture value determines how much light enters the camera."
            }
            else if(titleText === "EV"){
                "The Exposure Value (EV) is a combination of both the ISO and Shutter speed. This setting is used when the\ncamera is set to Auto. Increase the EV for a brighter exposure of decrease the EV to darken your exposure."
            }
            else if(titleText === "WB"){
                "White Balance (WB) is used to set the color temperature of your photos and video. Pick the option that\napplies to your scene. You can also set a custom WB for more specific detail."
            }
            else if(titleText === "DIGITALZOOM") {
                "The Digital Zoom effect allows you to crop in on the camera's sensor allowing you to zoom in on your\nsubject. Be mindful that cropping in on the camera's sensor will lower the resolution of the image."
            }
            else if(titleText === "AF"){
                "Auto focus : The camera adjusts the focus accroding to the subject location.\nManual focus : The user manually sets camera settings to acheive desired image."
            }
            else if(titleText === "COLOR"){
                "Color profiles allow to customize the look of your photos or video in-camera with no post-production\nrequired."
            }
            else if(titleText === "STYLE"){
                "Style lets you have more control over your camera. Give your photos or video a unique look by adjusting\nthe Contrast, Satuation, and Sharpness."
            }
            else if(titleText === "PIV"){
                "Picture In Video (PIV) allows you to take still image while recording video at the same time. Drone will\ntake screenshots from your video and save it as a JPEG. RAW image are unavailable in PIV. PIV image will\nbe saved at the resolution of the video being recorded."
            }
            else {
                ""
            }
        }

        color: fontColorlightGray
        font.styleName: 'Arial'
        font.pixelSize: 28
        anchors.top: parent.top
        anchors.topMargin: 110
        anchors.left: parent.left
        anchors.leftMargin: 85
    }

    Button {
        width: parent.width / 35
        height: parent.height / 5
        z: 4
        background: Rectangle { color: transparent }
        anchors {
            left: parent.left
            top: parent.top
            topMargin: 20
            leftMargin: 20
        }
        Image {
            source: "qrc:/res/CloseLightgray.svg"
            anchors.fill: parent
        }

        onClicked: {
            console.log("Close Button Click")
            parentQML.bottomMenuHelpPopupLoader.sourceComponent = null
        }
    }

    MouseArea {
        anchors.fill: parent
        preventStealing: true
    }
    enabled: true
}
