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
    implicitHeight: Screen.height / 4.8
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

    Text {
        text: "RESOLUTION"
        font.bold: true
        font.pixelSize: 35
        font.styleName: 'Arial'
        color: fontColorWhite
        anchors.top: parent.top
        anchors.topMargin: 25
        anchors.left: parent.left
        anchors.leftMargin: 85
    }

    Text {
        text: "A high resolution will create a high image quality with large file sizes."
        color: fontColorlightGray
        font.styleName: 'Arial'
        font.pixelSize: 28
        anchors.top: parent.top
        anchors.topMargin: 110
        anchors.left: parent.left
        anchors.leftMargin: 85
    }

    Image {
        source: "qrc:/res/close.svg"
        width: parent.width / 35
        height: parent.height / 5
        anchors {
            left: parent.left
            top : parent.top
            topMargin: 20
            leftMargin: 20
        }
    }
}
