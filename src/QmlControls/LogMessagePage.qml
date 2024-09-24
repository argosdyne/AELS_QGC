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
    property color defaultBackGroundColor: "black"
    property color blue: "#3d71d7"

    //Size Property
    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize

    implicitWidth: Screen.width / 3.24
    implicitHeight: Screen.height

    property alias listViewModel: mymodel
    property alias listView: listView
    property var parentQML: null
    property alias warningMessageLoader : warningMessageLoader

    property int previousIndex : -1

    z : 10

    ListModel {
        id: mymodel
    }

    Row {
        width: parent.width
        height: parent.height
        Rectangle {
            id: sideBar
            width: parent.width / 8.1
            height: parent.height
            color: transparent

            Column {
                anchors.fill: parent

                ListView {
                    id: listView
                    width: parent.width
                    height: parent.height
                    interactive: false

                    model: mymodel

                    delegate: Rectangle {
                        width: parent.width
                        height: defaultFontSize * 8
                        color: ListView.isCurrentItem ? blue : transparent

                        Image {
                            anchors.centerIn: parent
                            source: images
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                listView.currentIndex = index
                                stackLayout.currentIndex = index
                                console.log("Current Index : ", index)

                                if(previousIndex === index){
                                    parentQML.logMessageLoader.visible = false
                                }
                                previousIndex = index
                            }
                        }

                    }
                }
            }
        }

        StackLayout {
            id: stackLayout
            width: parent.width - sideBar.width
            height: parent.height

            currentIndex: 0 // Show first tab by default

            Loader {
                id: droneStatusLoader
                width: parent.width * 0.7
                height: parent.height
                source: "qrc:/qml/QGroundControl/Controls/DroneStatusPage.qml"
                active: stackLayout.currentIndex == 0
            }

            Loader {
                id: warningMessageLoader
                width: parent.width * 0.7
                height: parent.height
                source: "qrc:/qml/QGroundControl/Controls/CurrentWarningMessagePage.qml"

                onLoaded: {
                    warningMessageLoader.item.listModel.append({"titleText": "Warning","descriptionText": "Formatting", "images": "qrc:/res/Warning.svg"})
                    warningMessageLoader.item.flickable.contentY = warningMessageLoader.item.flickable.contentHeight

                    warningMessageLoader.item.listModel.append({"titleText": "Success","descriptionText": "Format Successful", "images": "qrc:/res/Success.svg"})
                    warningMessageLoader.item.flickable.contentY = warningMessageLoader.item.flickable.contentHeight

                }
            }

            Loader {
                id: flightLogLoader
                width: parent.width * 0.7
                height: parent.height
                source: "qrc:/qml/QGroundControl/Controls/FlightLogPage.qml"
                active: stackLayout.currentIndex == 2
            }
        }
    }
}


