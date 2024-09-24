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
    color: defaultBackgroundColor

    //Color Property
    property color defaultTextColor: "white"
    property color moveToMainPageBtnBackgroundColor: "blue"
    property color defaultBackgroundColor: "#6e474141"
    property bool isCameraWindow: false

    //Size Property
    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.mediumFontPointSize : ScreenTools.mediumFontPointSize

    implicitWidth: Screen.width

    property var parentQML: null
    property alias commonHiddenTopBar: commonHiddenTopBar
    property alias systemSetting: systemSetting
    z: 2

    Loader {
        id: commonHiddenTopBar
        visible: false
        anchors.left: parent.left
        z: 4
        onLoaded: {
            if(item){
                width = item.width;
                height = item.height;
            }
        }
    }

    Loader {
        id:systemSetting
        z: 4
        visible: false
        onLoaded: {
            if(item){
                width = item.width
                height = item.height
                item.listViewModel.append({'images': "qrc:/res/FlightControl.png", 'texts': "Flight Control"})
                item.listViewModel.append({'images': "qrc:/res/VisualNavigation.svg", 'texts': "Visual Navigation"})
                item.listViewModel.append({'images': "qrc:/res/RemoteControl.svg", 'texts': "Remote Control"})
                item.listViewModel.append({'images': "qrc:/res/ImageTransmission.svg", 'texts': "Image\nTransmission"})
                item.listViewModel.append({'images': "qrc:/res/DroneBattery.svg", 'texts': "Drone Battery"})
                item.listViewModel.append({'images': "qrc:/res/Gimbal.svg", 'texts': "Gimbal"})
                item.listViewModel.append({'images': "qrc:/res/Live.svg", 'texts': "Live"})
                item.listViewModel.append({'images': "qrc:/res/Security.svg", 'texts': "Security"})
                item.listViewModel.append({'images': "qrc:/res/General.svg", 'texts': "General"})
                item.parentQML = root

                systemSetting.item.gimbalPage.adjustGimbalClicked.connect(handleAdjustGimbalClicked)
            }
        }
    }

    //Adjust Gimbal - System Setting
    function handleAdjustGimbalClicked(){
        console.log("AdjustGimbal Click")

        //1. Close system setting.
        systemSetting.item.handleCloseAllPages()
        systemSetting.visible = false

        //2. Show Adjust Gimbal Window
        parentQML.videoControl.z = 3
        parentQML.adjustWindow.visible = true
        parentQML.adjustdoneButton.visible = true
        parentQML.adjustdoneText.visible = true
    }

    RowLayout {
        id:  viewButtonRow
        anchors.fill: parent
        //spacing: 10

        //Logo Button
        Button {
            Layout.preferredWidth: height*2
            Layout.fillHeight: true
            background: Rectangle {
                color: "transparent"
                Image {
                    anchors.fill: parent
                    source: "/res/TopMenuHomeButton.svg"
                    fillMode: Image.PreserveAspectFit
                }
            }
            onClicked: {
                console.log("Logo btn Click");
                //Move to Start Page
                screenLogin.visible = true
                topOverLay.visible = true                
                cameraOverLay.visible = false
                toolbar.visible = !toolbar.waypointMissionToolbar

            }
        }
        //Move to MainPage Button
        Button {
            Layout.fillHeight: true
            Layout.preferredWidth: height*4.5
            background: Rectangle {
                color: moveToMainPageBtnBackgroundColor
                RowLayout {
                    anchors.fill: parent
                    spacing: defaultFontSize * 1.5
                    anchors.margins: 5
                    Image {
                        Layout.fillHeight: true
                        Layout.preferredWidth: height
                        source: "/res/TopMenuManualFlight.svg"
                        fillMode: Image.PreserveAspectFit

                    }
                    Rectangle {
                        color:"transparent"
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Column {
                            anchors.fill: parent
                            spacing: 5
                            Text {
                                Layout.fillHeight:true
                                Layout.fillWidth: true
                                font.pixelSize: defaultFontSize * 2
                                text: qsTr("Intelligent Photo")
                                color: defaultTextColor
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                            Text {
                                Layout.fillHeight:true
                                Layout.fillWidth: true
                                font.pixelSize: defaultFontSize* 3
                                text: qsTr("Manual Flight")
                                font.bold: true
                                color: defaultTextColor
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }
                        }
                    }
                }
            }
            onClicked: {
                console.log("MainPage btn Click");
            }
        }

        //Drone Status Show Button

        Rectangle {
            Layout.fillHeight: true
            Layout.fillWidth: true
            color: "transparent"
            RowLayout {
                anchors.fill: parent
                anchors.margins: 5

                Rectangle {
                    Layout.preferredWidth: height*3
                    Layout.fillHeight: true
                    color: "transparent"
                    RowLayout {
                        anchors.fill: parent
                        Image {
                            Layout.fillHeight: true
                            source: "/res/TopMenuBattery.svg"
                            fillMode: Image.PreserveAspectFit
                        }

                        Text {
                            Layout.fillHeight: true
                            font.pixelSize: defaultFontSize * 2
                            text: qsTr("N/A")
                            color: defaultTextColor
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }

                Rectangle {
                    Layout.preferredWidth: height*3
                    Layout.fillHeight: true
                    color: "transparent"
                    RowLayout {
                        anchors.fill: parent
                        Image {
                            Layout.fillHeight: true
                            source: "/res/TopMenuAltitude.svg"
                            fillMode: Image.PreserveAspectFit
                        }

                        Text {
                            Layout.fillHeight: true
                            font.pixelSize: defaultFontSize * 2
                            text: qsTr("N/A")
                            color: defaultTextColor
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }

                Rectangle {

                    Layout.preferredWidth: height*3
                    Layout.fillHeight: true
                    color: "transparent"
                    RowLayout {
                        anchors.fill: parent
                        Image {
                            Layout.fillHeight: true
                            source: "/res/TopMenuDistance.svg"
                            fillMode: Image.PreserveAspectFit
                        }

                        Text {
                            Layout.fillHeight: true
                            font.pixelSize: defaultFontSize * 2
                            text: qsTr("N/A")
                            color: defaultTextColor
                            verticalAlignment: Text.AlignVCenter
                        }
                    }

                }

                Rectangle {

                    Layout.preferredWidth: height*3
                    Layout.fillHeight: true
                    color: "transparent"
                    RowLayout {
                        anchors.fill: parent
                        Image {
                            Layout.fillHeight: true
                            source: "/res/TopMenuSpeed.svg"
                            fillMode: Image.PreserveAspectFit
                        }
                        Text {
                            Layout.fillHeight: true
                            font.pixelSize: defaultFontSize * 2
                            text: qsTr("N/A")
                            color: defaultTextColor
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }

                Rectangle {
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    color: "transparent"
                }

            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    console.log("Drone Status Area Clicked");
                    // Component 생성하기
                    if(commonHiddenTopBar.item == null) {
                    commonHiddenTopBar.source = "qrc:/qml/QGroundControl/Controls/CommonHiddenTopBar.qml"
                    commonHiddenTopBar.visible = true
                    commonHiddenTopBar.x = viewButtonRow.x
                    commonHiddenTopBar.y = viewButtonRow.y + viewButtonRow.height
                    }
                    else {
                        commonHiddenTopBar.item.visible = true
                    }
                }
            }
        }


        // Obstacle Status Icon
        Button {
            Layout.fillHeight: true
            Layout.preferredWidth: height
            background: Rectangle { color: "transparent" }
            id: obstacleBtn

            property bool isObstacleOn: false

            Image {
                //source: "/res/TopMenuObstacleSensorOff.svg"
                source: (obstacleBtn.isObstacleOn === true) ? "qrc:/res/TopMenuObstacleSensorOff.svg" : "qrc:/res/TopMenuObstacleSensorOn.svg"
                anchors.fill: parent
                anchors.margins: 5
                fillMode: Image.PreserveAspectFit
            }

            onClicked: {
                if(isObstacleOn === true){
                    isObstacleOn = false;
                }
                else {
                    isObstacleOn = true;
                }
            }
        }
        //Show Map Style Button
        Button {
            visible: isCameraWindow == false ? true : false
            Layout.preferredWidth: height
            Layout.fillHeight: true
            background: Rectangle { color: "transparent" }
            Image {                
                anchors.fill: parent
                anchors.margins: 5
                source: "/res/TopMenuMapTool.svg"
                fillMode: Image.PreserveAspectFit
            }

            onClicked: {
                console.log("Red btn Click");
            }
        }
        //Setting Button
        Button {
            Layout.preferredWidth: height
            Layout.fillHeight: true
            background: Rectangle {
                color: "transparent"
            }
            Image {                
                anchors.fill: parent
                anchors.margins: 5
                    source: "qrc:/res/TopMenuSetting.png"
                    fillMode: Image.PreserveAspectFit
                }
            onClicked: {
                console.log("Setting btn Click");

                // Add System SettingPage
                if(systemSetting.item == null) {
                    systemSetting.source= "qrc:/qml/QGroundControl/Controls/SystemSettingPage.qml"
                    systemSetting.visible = true
                    systemSetting.x = 0
                    systemSetting.y = 0
                }
                else {
                    systemSetting.visible = true
                }
            }
        }

    }
}


