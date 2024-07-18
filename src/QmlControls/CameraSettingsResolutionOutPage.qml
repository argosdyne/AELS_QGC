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

    Loader {
        source: "qrc:/qml/QGroundControl/Controls/CameraTakePhoto.qml"
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
            margins: margin
        }
    }

    Loader {
        id: commonTopMenu
        source: "qrc:/qml/QGroundControl/Controls/CommonTopMenu.qml"
        anchors {
            top: parent.top
        }
    }

    Loader {
        id: alertBox
        source: "qrc:/qml/QGroundControl/Controls/AlertBox.qml"
        anchors {
            left: parent.left
            top: commonTopMenu.bottom
            margins: margin
        }
        onLoaded: {
            alertBox.item.isRed = true
        }
    }

    Loader {
        id: cameraLiveButton
        source: "qrc:/qml/QGroundControl/Controls/CameraLiveButton.qml"
        anchors {
            left: parent.left
            top: alertBox.bottom
            margins: margin
        }
    }

    Loader {
        id: cameraBottomMenu
        source: "qrc:/qml/QGroundControl/Controls/CameraBottomMenu.qml"
        anchors {
            bottom: parent.bottom
        }
    }
}
