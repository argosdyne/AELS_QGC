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

    implicitWidth: Screen.width
    implicitHeight: Screen.height

    property alias listViewModel: mymodel
    property alias listView: listView
    property var parentQML: null    

    property int previousIndex : -1

    property string settingTitle : "Flight Control"
    property string previousTitle : ""
    property string mainTitle : "Flight Control"
    property alias modalBackground: modalBackground
    property alias noviceModeUncheckedLoader: noviceModeUncheckedLoader
    property alias ledIndicatorsLoader: ledIndicatorsLoader
    property alias visualObstacleAvoidanceLoader: visualObstacleAvoidanceLoader
    property alias downwardVisionLoader : downwardVisionLoader

    property int currentPageIndex : 0
    property var page1 : null
    property var page2 : null
    property var page3 : null
    property var page4 : null

    property alias flightControl: flightControl
    property alias visualNavigation: visualNavigation
    property alias gimbalPage : gimbalPage
    property var currentLED: null

    property var currentVisualControl: null
    z : 4

    MouseArea {
        anchors.fill: parent
    }

    ListModel {
        id: mymodel
    }


    //Warning Popup Loader
    Loader {
        z: 5
        id: noviceModeUncheckedLoader
        visible: false
        onLoaded: {
            if(item){
                width = item.width
                height = item.height
                noviceModeUncheckedLoader.item.isWarning = true
                noviceModeUncheckedLoader.item.innerText = "Faster flying and response will\nbe available after closing Novice\n Mode. Pay attention to your\nsafety."
            }
        }
    }

    function handleOpenNoviceWarningPopup() {
        if(noviceModeUncheckedLoader.item == null) {
            console.log("noviceModeUncheckedLoader Show")
            noviceModeUncheckedLoader.source = "qrc:/qml/QGroundControl/Controls/CameraWarningBox.qml"
            noviceModeUncheckedLoader.item.parentQML = root
            noviceModeUncheckedLoader.visible = true
            noviceModeUncheckedLoader.anchors.centerIn = root
            noviceModeUncheckedLoader.item.parentQML = root
            noviceModeUncheckedLoader.z = 6

            //Only OK button
            noviceModeUncheckedLoader.item.cancelButton.visible = false
            noviceModeUncheckedLoader.item.verticalSeparator.visible = false
            noviceModeUncheckedLoader.item.okButton.anchors.horizontalCenter = noviceModeUncheckedLoader.item.root.horizontalCenter

            //Modal Enable
            modalBackground.visible = true
            modalBackground.enabled = true
            modalBackground.z = 3
        }
    }

    //Open LED Indicators Warning message
    Loader {
        z: 5
        id: ledIndicatorsLoader
        visible: false
        onLoaded: {
            if(item){
                width = item.width
                height = item.height
                ledIndicatorsLoader.item.isWarning = true
                ledIndicatorsLoader.item.innerText = "Turning off the indication lights\nmight violate your local law\nunless you obtain an exepmtion,\nstill contuinue?"
            }
        }
    }


    function handleOpenLEDIndicatorsPopup(){
        if(ledIndicatorsLoader.item == null){
            console.log("ledIndicatorsLoader Show")
            ledIndicatorsLoader.source = "qrc:/qml/QGroundControl/Controls/CameraWarningBox.qml"
            ledIndicatorsLoader.item.parentQML = root
            ledIndicatorsLoader.visible = true
            ledIndicatorsLoader.anchors.centerIn = root
            ledIndicatorsLoader.z = 6

            //Modal Enable
            modalBackground.visible = true
            modalBackground.enabled = true
            modalBackground.z = 3
        }
    }

    //Open Visual Obstacle Avoidance
    Loader {
        z: 5
        id: visualObstacleAvoidanceLoader
        visible : false
        onLoaded: {
            if(item){
                width = item.width
                height = item.height
                visualObstacleAvoidanceLoader.item.isWarning = true
                visualObstacleAvoidanceLoader.item.innerText = "The drone will not hover or slow\ndown automatically when detecting\nobstacles with Visual Obstacle\nAvoidance disabled. Are you sure to\ndisable Visual Obstacle Avoidance?"
            }
        }
    }

    function handleOpenvisualObstacleAvoidancePopup(){
        if(visualObstacleAvoidanceLoader.item == null){
            visualObstacleAvoidanceLoader.source = "qrc:/qml/QGroundControl/Controls/CameraWarningBox.qml"
            visualObstacleAvoidanceLoader.item.parentQML = root
            visualObstacleAvoidanceLoader.visible = true
            visualObstacleAvoidanceLoader.anchors.centerIn = root
            visualObstacleAvoidanceLoader.z  = 5

            //Modal Enable
            modalBackground.visible = true
            modalBackground.enabled = true
            modalBackground.z = 3

        }
    }

    //Open Downward vision positioning popup
    Loader {
        z: 5
        id: downwardVisionLoader
        visible : false
        onLoaded: {
            if(item){
                width = item.width
                height = item.height
                downwardVisionLoader.item.isWarning = true
                downwardVisionLoader.item.innerText = "If Downward Vision Positioning is\ndisabled, the drone will be unable to\nhover stably at low altitude indoors\nand use the landing protection\nfunction."
            }
        }
    }

    function handleOpenDownwardVisionPositioningPopup(){
        if(downwardVisionLoader.item == null){
            downwardVisionLoader.source = "qrc:/qml/QGroundControl/Controls/CameraWarningBox.qml"
            downwardVisionLoader.item.parentQML = root
            downwardVisionLoader.visible = true
            downwardVisionLoader.anchors.centerIn = root
            downwardVisionLoader.z = 5

            modalBackground.visible = true
            modalBackground.enabled = true
            modalBackground.z = 3
        }
    }

    function handleCloseAllPages(){
        if (page1 !== null) {
            page1.visible = false
        }
        if (page2 !== null) {
            page2.visible = false
        }
        if (page3 !== null) {
            page3.visible = false
        }
        if (page4 !== null) {
            page4.visible = false
        }
        currentPageIndex = 0
        settingTitle = mainTitle
    }

    //Modal
    Rectangle {
        id: modalBackground
        color: Qt.rgba(0,0,0,0.5)

        visible: false
        width: Screen.width
        height: Screen.height
        z: 1

        MouseArea {
            anchors.fill: parent
        }
        enabled: false
    }

    Column {
        width: parent.width
        height: parent.height
        Row {
            width: parent.width
            height: parent.height / 9
            id: titleRow
            Rectangle {
                width: parent.width * 1/4
                height: parent.height
                color: transparent

                Text {
                    text: "Setting"
                    anchors.centerIn: parent
                    color: fontColorWhite
                    font.pixelSize: defaultFontSize * 4
                }
            }
            Rectangle {
                width: parent.width * 3/4
                height: parent.height
                color: transparent

                Text {
                    text: settingTitle
                    anchors.centerIn: parent
                    color: fontColorWhite
                    font.pixelSize: defaultFontSize * 4
                }

                Image {
                    id: backButton
                    source: "qrc:/res/ales/waypoint/LeftDir.svg"
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: defaultFontSize * 3

                    height: parent.height / 3
                    width: height

                    visible: {
                        if(currentPageIndex == 0){
                            false
                        }
                        else {
                            true
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {                            
                            switch(currentPageIndex){
                            case 1:
                                currentPageIndex = 0
                                page1.visible = false
                                settingTitle = mainTitle
                                break
                            case 2:
                                currentPageIndex = 1
                                page2.visible = false
                                settingTitle = previousTitle
                                break
                            case 3:
                                currentPageIndex = 2
                                page3.visible = false
                                break
                            case 4:
                                currentPageIndex = 3
                                page4.visible = false
                                break;
                            }
                        }
                    }
                }

                Image {
                    source: "qrc:/res/CloseWhite.svg"
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.rightMargin: defaultFontSize * 3

                    height: parent.height / 3
                    width: height

                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            parentQML.systemSetting.visible = false

                            handleCloseAllPages()
                        }
                    }
                }
            }
        }

        Row {
            width: parent.width
            height: parent.height - titleRow.height

            Rectangle {
                id: sideBar
                width: parent.width * 1/4
                height: parent.height
                clip: true
                color: transparent

                ListView {
                    id: listView
                    width: sideBar.width
                    height: sideBar.height
                    model: mymodel
                    clip: true                    

                    delegate: Rectangle {
                        id: innerItem
                        width: listView.width
                        height: sideBar.height / 6
                        color: ListView.isCurrentItem ? blue : transparent

                        Image {
                            id: modelImages
                            source: images
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: parent.width / 24
                        }

                        Text {
                            anchors.left: modelImages.left
                            anchors.leftMargin: parent.width / 5
                            text : texts
                            font.pixelSize: defaultFontSize * 4
                            color: fontColorWhite
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                listView.currentIndex = index
                                stackLayout.currentIndex = index
                                console.log("Current Index : ", index)
                            }
                        }
                    }
                }
            }

            StackLayout {
                id: stackLayout

                width: parent.width - sideBar.width
                height: parent.height

                // flight Control
                Item {
                    visible: stackLayout.currentIndex == 0
                    width: parent.width * 0.7
                    height: parent.height
                    FlightControlPage {
                        id: flightControl
                        parentQML: root
                        width: parent.width
                        height: parent.height
                        onOpenNovicePopup: handleOpenNoviceWarningPopup()
                        onOpenLEDIndicatorPopup: handleOpenLEDIndicatorsPopup()
                    }
                    onVisibleChanged: {
                        if (visible) {
                            mainTitle = "Flight Control"
                            settingTitle = "Flight Control"

                            handleCloseAllPages()
                        }
                    }
                }
                // Visual Navigation
                Item {
                    visible: stackLayout.currentIndex == 1
                    width: parent.width * 0.7
                    height: parent.height
                    VisualNavigationPage {
                        id: visualNavigation
                        parentQML: root
                        width: parent.width
                        height: parent.height
                        onOpenVisualObstaclePopup: handleOpenvisualObstacleAvoidancePopup()
                        onOpenDownwardVisionPopup: handleOpenDownwardVisionPositioningPopup()
                    }
                    onVisibleChanged: {
                        if (visible) {
                            mainTitle = "Visual Navigation"
                            settingTitle = "Visual Navigation"

                            handleCloseAllPages()
                        }
                    }
                }

                //Remote Control
                Item {
                    visible: stackLayout.currentIndex == 2
                    width: parent.width * 0.7
                    height: parent.height
                    RemoteControlPage {
                        id: remoteControl
                        parentQML: root
                        width: parent.width
                        height: parent.height
                    }
                    onVisibleChanged: {
                        if (visible) {
                            mainTitle = "Remote Control"
                            settingTitle = "Remote Control"

                            handleCloseAllPages()
                        }
                    }
                }

                //Image Transmission
                Item {
                    visible: stackLayout.currentIndex == 3
                    width: parent.width * 0.7
                    height: parent.height

                    ImageTransmissionPage{
                        id: imageTransmission
                        parentQML: root
                        width: parent.width
                        height: parent.height
                    }

                    onVisibleChanged: {
                        if (visible) {
                            mainTitle = "Image Transmission"
                            settingTitle = "Image Transmission"

                            handleCloseAllPages()
                        }
                    }
                }

                // Drone Battery Page
                Item {
                    visible: stackLayout.currentIndex == 4
                    width: parent.width * 0.7
                    height: parent.height

                    DroneBatteryPage {
                        id: droneBatteryPage
                        parentQML : root
                        width: parent.width
                        height: parent.height
                    }

                    onVisibleChanged: {
                        if(visible){
                            mainTitle = "Drone Battery"
                            settingTitle = "Drone Battery"

                            handleCloseAllPages()
                        }
                    }
                }

                //Gimbal Setting Page
                Item {
                    visible: stackLayout.currentIndex == 5
                    width: parent.width * 0.7
                    height: parent.height

                    GimbalPage {
                        id: gimbalPage
                        parentQML: root
                        width: parent.width
                        height: parent.height
                    }

                    onVisibleChanged: {
                        if(visible){
                            mainTitle = "Gimbal"
                            settingTitle = "Gimbal"

                            handleCloseAllPages()
                        }
                    }
                }

                //Live Page
                Item {
                    visible: stackLayout.currentIndex == 6
                    width: parent.width * 0.7
                    height: parent.height

                    LivePage {
                        id: livePage
                        parentQML: root
                        width: parent.width
                        height: parent.height
                    }

                    onVisibleChanged: {
                        if(visible) {
                            mainTitle = "Live"
                            settingTitle = "Live"

                            handleCloseAllPages()
                        }
                    }
                }

                //Security Page
                Item {
                    visible: stackLayout.currentIndex == 7
                    width: parent.width * 0.7
                    height: parent.height

                    SecurityPage {
                        id: securityPage
                        parentQML: root
                        width: parent.width
                        height: parent.height
                    }

                    onVisibleChanged: {
                        if(visible){
                            mainTitle = "Security"
                            settingTitle = "Security"

                            handleCloseAllPages()
                        }
                    }
                }

                //General Page
                Item {
                    visible : stackLayout.currentIndex == 8
                    width: parent.width * 0.7
                    height: parent.height

                    GeneralPage{
                        id: generalPage
                        parentQML: root
                        width: parent.width
                        height: parent.height
                    }

                    onVisibleChanged: {
                        if(visible) {
                            mainTitle = "General"
                            settingTitle = "General"

                            handleCloseAllPages()
                        }
                    }
                }
            }
        }
    }
}

