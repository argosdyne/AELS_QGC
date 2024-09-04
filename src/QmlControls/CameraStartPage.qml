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
import QGroundControl.FlightDisplay 1.0

Rectangle {
    id:     root
    color: transparent

    //Properties
    property color defaultTextColor: "white"
    property color transparent: "transparent"
    property color fontColorWhite: "white"
    property color fontColorlightGray: "#a7a7a7"
    property color defaultBackGroundColor: "#3b3737"
    property color fontColorRed: "red"
    property color blue: "#3d71d7"
    property color lightgray: "#a7a7a7"
    property color black : "#000000"
    property int margin: 10

    //Size Property
    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize

    implicitWidth: Screen.width
    implicitHeight: Screen.height    

    property bool isPhotoPage: true
    property alias cameraSettingLoader : cameraSettingLoader
    property alias videoControl : videoControl
    property alias resetCameraLoader : resetCameraLoader
    property alias modalBackground: modalBackground
    property bool isWarning: true
    property string innerText: ""
    property alias popupRect : popupRect
    property alias logWindowButton : logWindowButton
    property alias logMessageLoader: logMessageLoader

    z : 1

    FlyViewVideo {
        id: videoControl
        anchors.fill: parent
    }


    Loader {
        visible: isPhotoPage
        source: "qrc:/qml/QGroundControl/Controls/CameraTakePhoto.qml"
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
            rightMargin: defaultFontSize * 6
        }
        onLoaded: {
            if(item){
                item.parentQML = root
            }
        }
    }

    Loader {
        visible: !isPhotoPage
        source: "qrc:/qml/QGroundControl/Controls/CameraRecording.qml"
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
            rightMargin: defaultFontSize * 6
        }
        onLoaded: {
            if(item){
                item.parentQML = root
            }
        }
    }


    CommonTopMenu {
        id: commonTopMenu
        visible: true
        anchors.top: parent.top
        height: defaultFontSize * 8
        defaultBackgroundColor: "black"
        isCameraWindow: false
        moveToMainPageBtnBackgroundColor: "#3d71d7"
    }


    Column {
        anchors {
            left: parent.left
            top: commonTopMenu.bottom
            topMargin: defaultFontSize * 6
            leftMargin: defaultFontSize
        }
        Image {
            source: "qrc:/res/MiniMap.png"
            width: root.width / 6.4
            height: root.height / 6
        }

        Item {
           width: 1
           height: defaultFontSize
        }

        Loader {
            id: alertBox
            source: "qrc:/qml/QGroundControl/Controls/AlertBox.qml"
            onLoaded: {
                alertBox.item.isRed = true
            }
        }

        Item {
            width: 1
            height: defaultFontSize * 6
        }

        Loader {
            id: cameraLiveButton
            source: "qrc:/qml/QGroundControl/Controls/CameraLiveButton.qml"
        }
    }

    //Bottom Menu Loader
    Loader {
        id: bottomMenu
        visible: false
        z : 1
        onLoaded: {
            if(item){
                width = item.width;
                height = item.height;

                bottomMenu.item.settingClicked.connect(handleSettingClicked)
            }
        }
    }

    function handleSettingClicked() {
        console.log("connect success")

        if(cameraSettingLoader.item === null){
            cameraSettingLoader.source = "qrc:/qml/QGroundControl/Controls/CameraSettings.qml"
            cameraSettingLoader.item.parentQML = root
            cameraSettingLoader.visible = true
            cameraSettingLoader.anchors.right = root.right
            cameraSettingLoader.y = 0

            videoControl.z = 3
        }
        else {
            cameraSettingLoader.visible = true
            videoControl.z = 3
        }
    }

    //Camera Setting Loader
    Loader {
        z: 3
        id:cameraSettingLoader
        visible: false
        onLoaded: {
            if(item){
                width = item.width
                height = item.height

                cameraSettingLoader.item.resetCamera.connect(handleOpenResetCamera)
            }
        }
    }

    Loader{
        z: 4
        id: resetCameraLoader
        visible: false
        onLoaded: {
            if(item){
                width = item.width
                height = item.height
                resetCameraLoader.item.isWarning = isWarning
                resetCameraLoader.item.innerText = innerText
            }
        }
    }


    function handleOpenResetCamera() {
        if(resetCameraLoader.item == null){
            resetCameraLoader.source = "qrc:/qml/QGroundControl/Controls/CameraWarningBox.qml"
            resetCameraLoader.item.parentQML = root
            resetCameraLoader.visible = true
            resetCameraLoader.anchors.centerIn = root
            resetCameraLoader.item.parentQML = root

            // Modal Enable
            modalBackground.visible = true
            modalBackground.enabled = true
            modalBackground.z = 3

        }
    }

    //Reset Success Window
    Rectangle {
        id: popupRect
        width: parent.width / 3
        height: parent.height / 15
        color: defaultBackGroundColor
        radius: 10
        anchors.bottom : parent.bottom
        anchors.bottomMargin: parent.height / 8
        anchors.horizontalCenter:  parent.horizontalCenter
        visible: false

        Text {
            text : "Reset camera parameters successfully"
            color: fontColorWhite
            anchors.centerIn: parent
            font.pixelSize: defaultFontSize * 3
        }

        // Timer : Disappear after 3 sec
        Timer {
            id: hideTimer
            interval: 3000 // 3초 대기
            running: false
            repeat: false
            onTriggered: {
                popupRect.visible = false // 3초 뒤에 사라짐
            }
        }

        function showPopup() {
            visible = true
            hideTimer.start()
        }
    }

    Loader {
        id:logMessageLoader
        z: 4
        anchors.left: parent.left
        onLoaded: {
            if(item) {
                width = item.width
                height = item.height

                item.listViewModel.append({'images': "qrc:/res/DroneStatus.svg"})
                item.listViewModel.append({'images': "qrc:/res/WarningNotice.svg"})
                item.listViewModel.append({'images': "qrc:/res/WarningWindow.svg"})
            }
        }
    }

    //Move to Log Window Button
    Rectangle {
        id: logWindowButton
        z: 3
        width: parent.width / 8.3
        height: parent.height / 7.3
        anchors.left: parent.left
        anchors.leftMargin: defaultFontSize * 2
        anchors.verticalCenter: parent.verticalCenter
        color: transparent
        visible : false

        Column {
            anchors.fill: parent
            spacing: defaultFontSize
            Image {
                source:"qrc:/res/Alarm.svg"
                anchors.left: parent.left
                width: parent.width / 3.65
                height: width

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("Alarm image Click")
                        logWindowButton.visible = false
                        if(logMessageLoader.item == null){
                            logMessageLoader.setSource("qrc:/qml/QGroundControl/Controls/LogMessagePage.qml",{"parentQML": root})
                        }
                        else {
                            logMessageLoader.visible = true
                        }
                    }
                }
            }
            Rectangle {
                color: black
                width: parent.width
                height: parent.height / 2

                Column {
                    width: parent.width
                    height: parent.height
                    Row {
                        width: parent.width
                        height: parent.height / 2

                        Item {
                            width: defaultFontSize
                            height: 1
                        }

                        Image {
                            source: "qrc:/res/Warning.svg"
                            width: parent.width /7.6
                            height: width
                        }
                        Text {
                            color: defaultTextColor
                            text: "Warning"
                            font.pixelSize: defaultFontSize * 2
                        }
                    }

                    Row {
                        width: parent.width
                        height: parent.height / 2

                        Item {
                            width: defaultFontSize
                            height: 1
                        }

                        Text {
                            color: defaultTextColor
                            text: "Formatting"
                            font.pixelSize: defaultFontSize * 2
                        }
                    }
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        console.log("Formatting Rectangle Clicked")
                        logWindowButton.visible = false
                        if(logMessageLoader.item == null){
                            logMessageLoader.setSource("qrc:/qml/QGroundControl/Controls/LogMessagePage.qml",{"parentQML": root})
                        }
                        else {
                            logMessageLoader.visible = true
                        }
                    }
                }
            }
        }
    }


    //Bottom Menu Show btn
    Button {
        z: 1
        id: underUpBtn
        background: Rectangle { color: lightgray }
        width: defaultFontSize * 6
        height: defaultFontSize * 4

        property bool isBottomMenuShow: false

        Image {
            source: (parent.isBottomMenuShow === false) ? "qrc:/res/UnderUp.svg" : "qrc:/res/UnderDown.svg"
            anchors.fill: parent
        }
        anchors {
            right: root.right
            bottom: root.bottom
            margins:(isBottomMenuShow === false) ? defaultFontSize * 6 : defaultFontSize * 9
        }
        onClicked: {
            if(bottomMenu.item == null) {
                console.log("bottomMenu is null");
                bottomMenu.source = "qrc:/qml/QGroundControl/Controls/CameraBottomMenu.qml"
                bottomMenu.visible = true
                bottomMenu.x = root.x
                bottomMenu.anchors.bottom = root.bottom
                bottomMenu.item.parentQML = underUpBtn
                bottomMenu.item.parentQMLRoot = root
                isBottomMenuShow = true;
            }
            else {
                bottomMenu.item.visible = !isBottomMenuShow
                isBottomMenuShow = !isBottomMenuShow
            }
        }
    }

    //Modal
    Rectangle {
        id: modalBackground
        color: Qt.rgba(0,0,0,0.5)

        visible: !screenLogin.isExit
        width: Screen.width
        height: Screen.height
        z: 1

        MouseArea {
            anchors.fill: parent
        }
        enabled: !screenLogin.isExit
    }

    Rectangle {
        id: cameraStartPopup
        anchors.centerIn: parent
        width: 850
        height: 550
        color: transparent
        z: 2

        StackView {
            anchors.fill: parent
            clip: true
            id: learningCenterGroup

            //push animation (left > right)
            pushEnter: Transition {
                NumberAnimation { properties: "x"; from: learningCenterGroup.width; to: 0; duration: 250 }
            }
            pushExit: Transition {
                NumberAnimation { properties: "x"; from: 0; to: -learningCenterGroup.width; duration: 250 }
            }

            // replace animation (right > left)
            replaceEnter: Transition {
                NumberAnimation { properties: "x"; from: -learningCenterGroup.width; to: 0; duration: 250 }
            }
            replaceExit: Transition {
                NumberAnimation { properties: "x"; from: 0; to: learningCenterGroup.width; duration: 250 }
            }

            initialItem: (screenLogin.isExit == false) ? Qt.resolvedUrl("qrc:/qml/QGroundControl/Controls/LearningCenterDialog.qml") : null

        }
    }
}
