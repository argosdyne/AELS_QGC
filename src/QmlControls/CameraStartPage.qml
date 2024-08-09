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
    property int margin: 10

    //Size Property
    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize

    implicitWidth: Screen.width
    implicitHeight: Screen.height    


    FlyViewVideo {
        id: videoControl
        anchors.fill: parent
    }


    Loader {
        source: "qrc:/qml/QGroundControl/Controls/CameraTakePhoto.qml"
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
            rightMargin: defaultFontSize * 6
        }
    }

    Loader {
        id: commonTopMenu
        source: "qrc:/qml/QGroundControl/Controls/CommonTopMenu.qml"
        anchors {
            top: parent.top
        }
        onLoaded: {
            if(commonTopMenu.item){
                commonTopMenu.item.defaultBackgroundColor = "black"
                commonTopMenu.height = 90
                commonTopMenu.item.isCameraWindow = false
            }
        }
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
    Rectangle {
        color: transparent
        width: defaultFontSize * 6
        height: defaultFontSize * 4
        Loader {
            id: underUpBtn
            source: "qrc:/qml/QGroundControl/Controls/CameraMenuUnderUpButton.qml"
            anchors.centerIn: parent
            z: 3
        }
        anchors {
            right: root.right
            bottom: root.bottom
            margins: defaultFontSize * 6
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

            initialItem: (screenLogin.isExit == false) ? Qt.resolvedUrl("qrc:/qml/QGroundControl/Controls/LearningCenterDialog.qml") : null

        }
    }
}
