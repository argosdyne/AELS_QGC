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
    color: black

    property string white: '#ffffff'
    property string black: '#1f1f1f'
    property string blue: '#3D71D7'
    property color lightGray: "#4a4a4a"
    property color transparent: "transparent"
    property int hItemDelegate: Screen.height / 5;
    property int hSwitchDelegate: Screen.height / 15;
    property int hToolSeparator: defaultFontSize + 3;
    property int leftMargin: 20;

    //Size Property
    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize
    z: 3
    property var parentQML : null

    signal openVisualObstaclePopup()
    signal openDownwardVisionPopup()
    property alias visualObstaclecontrol: visualObstaclecontrol
    property alias downwardVisioncontrol: downwardVisioncontrol

    //Advanced Settings
    Rectangle {
        id: advancedSettingsPage
        anchors.fill: parent
        z: 4
        color: black
        visible: false
        MouseArea {
            anchors.fill: parent
        }
        Column {
            anchors.fill: parent

            Item {
                width: 1
                height: parent.height / 30
            }

            //Downward vision positioning
            ItemDelegate {
                width: parent.width
                height: parent.height / 4.5

                Text {
                    anchors.left: parent.left
                    text: "Downward Vision Positioning\n\nThe Downward Vision System helps the drone hover when the\nGPS signal is weak, provides support for accurate landing, landing\nprotection and other functions."
                    font.pixelSize: defaultFontSize * 3
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: parent.width / 24
                    color: white
                }

                Switch{
                    id: downwardVisioncontrol
                    anchors.right: parent.right
                    anchors.top: parent.top
                    checked: true
                    indicator: Rectangle {
                        implicitWidth: defaultFontSize * 6
                        implicitHeight: defaultFontSize * 3
                        x: downwardVisioncontrol.width - width - downwardVisioncontrol.rightPadding
                        y: parent.height / 2 - height / 2
                        radius: 13
                        color: downwardVisioncontrol.checked ? blue : lightGray
                        border.color: black

                        Rectangle {
                            x: downwardVisioncontrol.checked ? parent.width - width : 0
                            width: defaultFontSize * 3
                            height: defaultFontSize * 3
                            radius: 50
                            border.color: black
                        }
                    }

                    onCheckedChanged:
                    {
                        if(!downwardVisioncontrol.checked){
                            openDownwardVisionPopup();
                            parentQML.currentVisualControl = "openDownward"
                        }
                    }
                }
                background: Rectangle {
                    color : transparent
                }
            }
            ToolSeparator {
                width: parent.width
                height: hToolSeparator
                orientation: Qt.Horizontal
            }

            // Landing Protection
            ItemDelegate {
                width: parent.width
                height: parent.height / 4.5

                Column {
                    anchors.fill: parent

                    Item {
                        width: 1
                        height: parent.height / 5
                    }

                    Row {
                        width: parent.width
                        height: parent.height / 22.5

                        Item {
                            width: parent.width / 24
                            height: 1
                        }

                        Text {
                            text: "Landing Protection"
                            font.pixelSize: defaultFontSize * 3
                            color: white
                        }

                        Item {
                            width: parent.width / 1.44
                            height: 1
                        }

                        Switch{
                            id: landingProtectioncontrol
                            checked: true
                            indicator: Rectangle {
                                implicitWidth: defaultFontSize * 6
                                implicitHeight: defaultFontSize * 3
                                x: landingProtectioncontrol.width - width - landingProtectioncontrol.rightPadding
                                y: parent.height / 2 - height / 2
                                radius: 13
                                color: landingProtectioncontrol.checked ? blue : lightGray
                                border.color: black

                                Rectangle {
                                    x: landingProtectioncontrol.checked ? parent.width - width : 0
                                    width: defaultFontSize * 3
                                    height: defaultFontSize * 3
                                    radius: 50
                                    border.color: black
                                }
                            }
                            onCheckedChanged:
                            {

                            }
                        }
                    }
                    Item {
                        width: 1
                        height: parent.height / 3.3
                    }
                    Row {
                        width: parent.width
                        height: parent.height / 3.3

                        Item {
                            width: parent.width / 24
                            height: 1
                        }

                        Image {
                            source : "qrc:/res/LandingProtection.svg"
                            height: parent.height
                        }

                        Item {
                            width: parent.width / 36
                            height: 1
                        }
                        Text {
                            text: "When enabled, landing protection allows the drone to detect\nground conditions as it lands."
                            color: white
                            font.pixelSize: defaultFontSize * 3
                        }
                    }
                }


                background: Rectangle {
                    color : transparent
                }
            }

            ToolSeparator {
                width: parent.width
                height: hToolSeparator
                orientation: Qt.Horizontal
            }        

            //Accurate Landing
            ItemDelegate {
                width: parent.width
                height: parent.height / 4.5

                Column {
                    anchors.fill: parent

                    Item {
                        width: 1
                        height: parent.height / 5
                    }

                    Row {
                        width: parent.width
                        height: parent.height / 22.5

                        Item {
                            width: parent.width / 24
                            height: 1
                        }

                        Text {
                            text: "Accurate Landing"
                            font.pixelSize: defaultFontSize * 3
                            color: white
                        }

                        Item {
                            width: parent.width / 1.418
                            height: 1
                        }

                        Switch{
                            id: accurateLandingcontrol
                            checked: true
                            indicator: Rectangle {
                                implicitWidth: defaultFontSize * 6
                                implicitHeight: defaultFontSize * 3
                                x: accurateLandingcontrol.width - width - accurateLandingcontrol.rightPadding
                                y: parent.height / 2 - height / 2
                                radius: 13
                                color: accurateLandingcontrol.checked ? blue : lightGray
                                border.color: black

                                Rectangle {
                                    x: accurateLandingcontrol.checked ? parent.width - width : 0
                                    width: defaultFontSize * 3
                                    height: defaultFontSize * 3
                                    radius: 50
                                    border.color: black
                                }
                            }
                            onCheckedChanged:
                            {

                            }
                        }
                    }
                    Item {
                        width: 1
                        height: parent.height / 3.3
                    }
                    Row {
                        width: parent.width
                        height: parent.height / 3.3

                        Item {
                            width: parent.width / 24
                            height: 1
                        }

                        Image {
                            source : "qrc:/res/AccurateLanding.svg"
                            height: parent.height
                        }

                        Item {
                            width: parent.width / 36
                            height: 1
                        }
                        Text {
                            text: "The drone will land as close as possible to the take-off point\nduring Go-Home operation."
                            color: white
                            font.pixelSize: defaultFontSize * 3
                        }
                    }
                }

                background: Rectangle {
                    color : transparent
                }
            }

            ToolSeparator {
                width: parent.width
                height: hToolSeparator
                orientation: Qt.Horizontal
            }
        }
    }

    Column {
        anchors.fill: parent
        width: parent.width
        height: parent.height

        //Flickable
        Rectangle {
            width: parent.width - defaultFontSize * 6
            height: parent.height
            color: transparent
            anchors.horizontalCenter: parent.horizontalCenter
            clip: true
            Flickable {
                anchors.fill: parent
                contentWidth: parent.width
                contentHeight: hItemDelegate * (5/3 + 1/2 + 2.5 + 1/1.5) + (hToolSeparator * 3)

                id: flickAble
                Column {
                    width: parent.width
                    height: parent.height

                    //Visual Obstacle Avoidance Switch
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate / 3

                        Text {
                            anchors.left: parent.left
                            color: white
                            text: "Visual Obstacle Avoidance"
                            font.pixelSize: defaultFontSize * 3
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Switch{
                            id: visualObstaclecontrol
                            checked: false
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            indicator: Rectangle {
                                implicitWidth: defaultFontSize * 6
                                implicitHeight: defaultFontSize * 3
                                x: visualObstaclecontrol.width - width - visualObstaclecontrol.rightPadding
                                y: parent.height / 2 - height / 2
                                radius: 13
                                color: visualObstaclecontrol.checked ? blue : lightGray
                                border.color: white

                                Rectangle {
                                    x: visualObstaclecontrol.checked ? parent.width - width : 0
                                    width: defaultFontSize * 3
                                    height: defaultFontSize * 3
                                    radius: 50
                                    border.color: black
                                }
                            }
                            onCheckedChanged: {
                                if(visualObstaclecontrol.checked){
                                    openVisualObstaclePopup();

                                    avoidanceSwitch.visible = true
                                    flickAble.contentHeight = flickAble.contentHeight + avoidanceSwitch.height
                                }
                                else {
                                    avoidanceSwitch.visible= false
                                    flickAble.contentHeight = flickAble.contentHeight - avoidanceSwitch.height
                                }
                            }
                        }
                        background: Rectangle {
                            color: transparent
                        }
                    }

                    //Visual Obstacle Avoidance Description
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate / 2

                        Image {
                            source: "qrc:/res/VisualNavigationFront.svg"
                            width: parent.width / 22.5
                            height: width
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: parent.width / 72
                        }

                        Text {
                            text: "when the drone detects an obstacle, it will hover automatically.\n(When visual obstacle avoidance system works, the maximum\nflight speed is limited 36km/h)"
                            color: white
                            font.pixelSize: defaultFontSize * 3
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: parent.width / 16
                        }
                        background: Rectangle {
                            color: transparent
                        }
                    }

                    //Visual Obstacle Avoidance Note
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate * 2.5

                        Image {
                            source: "qrc:/res/VisualNavigationLeft.svg"
                            width: parent.width / 22.5
                            height: width
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: parent.width / 72
                        }

                        Text{
                            color: white
                            font.pixelSize: defaultFontSize * 3
                            text:"Note:\n   Omnidirectional obstacle sensing directions include front,\n   back, up,\n•  down, left, right. Howerver, there might exists some blind\n   spots in the four diagonal directions. When manually flying,\n   please pay attention to the surrounding environment and\n   APP tips to ensure safety.\n\n   Please do not fly in an environment with insufficient light,\n•  complex area with small objects (such as small branches,\n   wires, nets), moving objects, transparent surfaces (e.g.\n   windows) or reflective surfaces (e.g. mirrors)\n\n   When following a car or other vehicles, please drive on off-\n•  road or closed routes. Never use on public roads."
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: parent.width / 16
                        }
                        background: Rectangle {
                            color: transparent
                        }
                    }

                    //Avoiance Switch
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate / 1.5
                        id: avoidanceSwitch
                        visible: visualObstaclecontrol.checked ? true : false

                        Column {
                            anchors.fill: parent
                            spacing: defaultFontSize
                            Row {
                                id: firstLineSwitch
                                width: parent.width
                                height: parent.height / 2

                                Item {
                                    width: parent.width / 9.6
                                    height: 1
                                }
                                Text{
                                    color: white
                                    font.pixelSize: defaultFontSize * 2.5
                                    text: "Front/Rear Obstacle\nAvoidance"
                                }
                                Item
                                {
                                    width: parent.width / 72
                                    height: 1
                                }
                                Switch{
                                    id: frontObstaclecontrol
                                    checked: false
                                    indicator: Rectangle {
                                        implicitWidth: defaultFontSize * 6
                                        implicitHeight: defaultFontSize * 3
                                        x: frontObstaclecontrol.width - width - frontObstaclecontrol.rightPadding
                                        y: parent.height / 2 - height / 2
                                        radius: 13
                                        color: frontObstaclecontrol.checked ? blue : lightGray
                                        border.color: white

                                        Rectangle {
                                            x: frontObstaclecontrol.checked ? parent.width - width : 0
                                            width: defaultFontSize * 3
                                            height: defaultFontSize * 3
                                            radius: 50
                                            border.color: black
                                        }
                                    }
                                    onCheckedChanged: {
                                    }
                                }

                                Item
                                {
                                    width: parent.width / 14.4
                                    height: 1
                                }
                                Text {
                                    color: white
                                    font.pixelSize: defaultFontSize * 2.5
                                    text: "Left/Right Obstacle\nAvoidance"
                                }
                                Item
                                {
                                    width: parent.width / 72
                                    height: 1
                                }

                                Switch{
                                    id: leftObstaclecontrol
                                    checked: false
                                    indicator: Rectangle {
                                        implicitWidth: defaultFontSize * 6
                                        implicitHeight: defaultFontSize * 3
                                        x: leftObstaclecontrol.width - width - leftObstaclecontrol.rightPadding
                                        y: parent.height / 2 - height / 2
                                        radius: 13
                                        color: leftObstaclecontrol.checked ? blue : lightGray
                                        border.color: white

                                        Rectangle {
                                            x: leftObstaclecontrol.checked ? parent.width - width : 0
                                            width: defaultFontSize * 3
                                            height: defaultFontSize * 3
                                            radius: 50
                                            border.color: black
                                        }
                                    }
                                    onCheckedChanged: {
                                    }
                                }

                            }

                            Row {
                                id: secondLineSwitch
                                width: parent.width
                                height: parent.height / 2

                                Item {
                                    width: parent.width / 9.6
                                    height: 1
                                }
                                Text{
                                    color: white
                                    font.pixelSize: defaultFontSize * 2.5
                                    text: "Upper Obstacle\nAvoidance"
                                }
                                Item
                                {
                                    width: parent.width / 18
                                    height: 1
                                }
                                Switch{
                                    id: upperObstaclecontrol
                                    checked: false
                                    indicator: Rectangle {
                                        implicitWidth: defaultFontSize * 6
                                        implicitHeight: defaultFontSize * 3
                                        x: upperObstaclecontrol.width - width - upperObstaclecontrol.rightPadding
                                        y: parent.height / 2 - height / 2
                                        radius: 13
                                        color: upperObstaclecontrol.checked ? blue : lightGray
                                        border.color: white

                                        Rectangle {
                                            x: upperObstaclecontrol.checked ? parent.width - width : 0
                                            width: defaultFontSize * 3
                                            height: defaultFontSize * 3
                                            radius: 50
                                            border.color: black
                                        }
                                    }
                                    onCheckedChanged: {
                                    }
                                }
                            }
                        }
                        background: Rectangle {
                            color: transparent
                        }
                    }

                    ToolSeparator {
                        width: parent.width
                        height: hToolSeparator
                        orientation: Qt.Horizontal
                    }

                    //Show Radar Map
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate / 3

                        Text {
                            anchors.left: parent.left
                            color: white
                            text: "Show Radar Map"
                            font.pixelSize: defaultFontSize * 3
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Switch{
                            id: raderMapcontrol
                            checked: true
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            indicator: Rectangle {
                                implicitWidth: defaultFontSize * 6
                                implicitHeight: defaultFontSize * 3
                                x: raderMapcontrol.width - width - raderMapcontrol.rightPadding
                                y: parent.height / 2 - height / 2
                                radius: 13
                                color: raderMapcontrol.checked ? blue : lightGray
                                border.color: white

                                Rectangle {
                                    x: raderMapcontrol.checked ? parent.width - width : 0
                                    width: defaultFontSize * 3
                                    height: defaultFontSize * 3
                                    radius: 50
                                    border.color: black
                                }
                            }
                            onCheckedChanged: {
                                if(checked) {
                                    radarMapDisplayZone.visible = true
                                    flickAble.contentHeight = flickAble.contentHeight + radarMapDisplayZone.height
                                }
                                else {
                                    radarMapDisplayZone.visible = false
                                    flickAble.contentHeight = flickAble.contentHeight - radarMapDisplayZone.height
                                }
                            }
                        }
                        background: Rectangle {
                            color: transparent
                        }
                    }

                    // Show Radar Map Description
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate / 3

                        Image {
                            source: "qrc:/res/VisualNaviagtionRader.svg"
                            width: parent.width / 22.5
                            height: width
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: parent.width / 72
                        }
                        Text {
                            text: "when enabled, a real-time obstacle detection radar map will\nbe displayed on the flight screen."
                            color: white
                            font.pixelSize: defaultFontSize * 3
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.leftMargin: parent.width / 16
                        }

                        background: Rectangle {
                            color: transparent
                        }
                    }

                    //Radar map display zone
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate / 3
                        id: radarMapDisplayZone
                        visible: raderMapcontrol.checked ? true : false

                        Text {
                            anchors.left: parent.left
                            color: white
                            text: "Radar map display zone"
                            font.pixelSize: defaultFontSize * 3
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        ComboBox {
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            id: raderMapDisplayComboBox
                            width: parent.width / 7.5
                            model: ["0~10m", "0~8m", "0~6m", "0~4m"]

                            // 텍스트와 색상 스타일을 지정
                            contentItem: Text {
                                text: raderMapDisplayComboBox.currentText
                                color: blue // 텍스트 색상
                                font.pixelSize: defaultFontSize * 3
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignLeft
                                padding: defaultFontSize
                            }

                            // 오른쪽의 화살표 표시를 커스텀
                            indicator: Item {
                                anchors.fill: parent
                                anchors.right: parent.right
                                width: parent.height / 3
                                height: parent.height / 3
                                anchors.margins: defaultFontSize
                                Image {
                                    source: "qrc:/res/ales/waypoint/DownDir.svg"  // 원하는 화살표 이미지로 변경
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter

                                }
                            }

                            background: Rectangle {
                                color: transparent  // 배경 색상 지정
                                border.color: lightGray
                                radius: 5
                            }
                        }
                        background: Rectangle {
                            color: transparent
                        }
                    }

                    ToolSeparator {
                        width: parent.width
                        height: hToolSeparator
                        orientation: Qt.Horizontal
                    }

                    // Auxiliary Bottom Light
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate / 3                        

                        Text {
                            anchors.left: parent.left
                            color: white
                            text: "Auxiliary Bottom Light"
                            font.pixelSize: defaultFontSize * 3
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        ComboBox {
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            id: auxComboBox
                            width: parent.width / 7.5
                            model: ["On", "Off", "Auto", "Flash 1s", "Flash 2s"]

                            // 텍스트와 색상 스타일을 지정
                            contentItem: Text {
                                text: auxComboBox.currentText
                                color: blue // 텍스트 색상
                                font.pixelSize: defaultFontSize * 3
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignLeft
                                padding: defaultFontSize
                            }

                            // 오른쪽의 화살표 표시를 커스텀
                            indicator: Item {
                                anchors.fill: parent
                                anchors.right: parent.right
                                width: parent.height / 3
                                height: parent.height / 3
                                anchors.margins: defaultFontSize
                                Image {
                                    source: "qrc:/res/ales/waypoint/DownDir.svg"  // 원하는 화살표 이미지로 변경
                                    anchors.right: parent.right
                                    anchors.verticalCenter: parent.verticalCenter

                                }
                            }

                            background: Rectangle {
                                color: transparent  // 배경 색상 지정
                                border.color: lightGray
                                radius: 5
                            }
                        }
                        background: Rectangle {
                            color: transparent
                        }
                    }

                    ToolSeparator {
                        width: parent.width
                        height: hToolSeparator
                        orientation: Qt.Horizontal
                    }

                    //Advanced settings
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate / 3

                        Text {
                            anchors.left: parent.left
                            color: white
                            text: "Advanced settings"
                            font.pixelSize: defaultFontSize * 3
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Image {
                            source : "qrc:/res/ales/waypoint/RightDir.svg"
                            anchors.right: parent.right
                            anchors.rightMargin: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        background: Rectangle {
                            color: transparent
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                console.log("Advanced settings Window Click")
                                advancedSettingsPage.visible = true
                                parentQML.currentPageIndex = 1
                                parentQML.page1 = advancedSettingsPage
                                parentQML.mainTitle = parentQML.settingTitle

                                parentQML.settingTitle = "Advanced Settings"
                            }
                        }
                    }
                }
            }
        }
    }
}
