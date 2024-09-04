import QtQuick 2.15
import QtQuick.Controls 2.14
import QtPositioning 5.14
import QtQuick.Window 2.10
import QtQuick.Dialogs  1.3
import QGroundControl.ScreenTools 1.0 

Rectangle {
    id: root
    color: black

    implicitWidth: Screen.width / 3.24
    implicitHeight: Screen.height
    property string white: '#ffffff'
    property string black: '#000000'
    property string blue: '#3D71D7'
    property color lightGray: "#4a4a4a"
    property color transparent: "transparent"
    property int hItemDelegate: Screen.height / 15;
    property int hSwitchDelegate: Screen.height / 15;
    property int hToolSeparator: defaultFontSize + 3;
    property int leftMargin: 20;

    //Size Property
    property int defaultFontSize: Qt.platform.os === "android" ? ScreenTools.smallFontPointSize : ScreenTools.mediumFontPointSize
    z: 3
    property var parentQML : null

    //Values
    property url gridImage: "qrc:/qmlimages/NoneBox.svg"
    property url centerPointImage: "qrc:/qmlimages/NoneBox.svg"
    property string videoEncodingText: "H.264"
    property string saveLocationText : "Sd Card"
    property string antiFlickerText: "Turn off"

    property alias centerPointLoader : centerPointLoader
    property alias gridLoader: gridLoader
    property alias videoEncodingLoader: videoEncodingLoader
    property alias saveLocationLoader : saveLocationLoader
    property alias antiFlickerLoader: antiFlickerLoader

    signal resetCamera()

    //Center Point Loader
    Loader {
        id: centerPointLoader
        z: 4
        anchors.right: parent.right
        onLoaded: {
            if(item){
                width = item.width
                height = item.height
                // Add Item to List Model
                item.listViewModel.append({'texts': "None"                          , 'images' : "qrc:/qmlimages/NoneBox.svg"});
                item.listViewModel.append({'texts': "Square(Without Center Point)"  , 'images' : "qrc:/qmlimages/Square.svg"});
                item.listViewModel.append({'texts': "Square(With Center Point)"     , 'images' : "qrc:/qmlimages/CenterPointWithSquare.svg"});
                item.listViewModel.append({'texts': "Cross"                         , 'images' : "qrc:/qmlimages/Cross.svg"});
                item.listViewModel.append({'texts': "Circle(Without Center Point)"  , 'images' : "qrc:/qmlimages/CircleWithoutCenterPoint.svg"});
                item.listViewModel.append({'texts': "Circle(With Center Point)"     , 'images' : "qrc:/qmlimages/CircleWithCenterPoint.svg"});

                //When Start CenterPoint Window, Find last Clicked index
                for (var i = 0; i < item.listView.model.count; i++) {
                    console.log(item.listView.model.get(i).images.toString())
                    console.log(centerPointImage.toString())
                    if (item.listView.model.get(i).images.toString() === centerPointImage.toString()) {
                        item.listView.currentIndex = i;
                        console.log("match")
                        break;
                    }
                    else {
                        console.log("not match")
                    }
                }
            }
        }
    }

    //Grid Loader
    Loader {
        id: gridLoader
        z: 4
        anchors.right: parent.right
        onLoaded: {
            if(item){
                width = item.width
                height = item.height

                //Add Item to List Model
                item.listViewModel.append({'texts': "None"         , 'images' : "qrc:/qmlimages/NoneBox.svg"});
                item.listViewModel.append({'texts': "Grid"         , 'images' : "qrc:/qmlimages/Grid.svg"});
                item.listViewModel.append({'texts': "Grid + Line"  , 'images' : "qrc:/qmlimages/gridLine.svg"});

                //When Start Grid Window, Find last Clicked index
                for (var i = 0; i < item.listView.model.count; i++) {
                    console.log(item.listView.model.get(i).images.toString())
                    console.log(gridImage.toString())
                    if (item.listView.model.get(i).images.toString() === gridImage.toString()) {
                        item.listView.currentIndex = i;
                        console.log("match")
                        break;
                    }
                    else {
                        console.log("not match")
                    }
                }
            }
        }
    }

    //Video Encoding Loader
    Loader {
        id: videoEncodingLoader
        z: 4
        anchors.right: parent.right
        onLoaded: {
            if(item){
                width = item.width
                height = item.height

                //Add Item to List Model
                item.listViewModel.append({'texts': "H.264"});
                item.listViewModel.append({'texts': "H.265"});

                // When Start Video Encoding Window, Find last Clicked index
                for(var i = 0; i < item.listView.model.count; i++){
                    if(item.listView.model.get(i).texts === videoEncodingText) {
                        item.listView.currentIndex = i;
                        break;
                    }
                }
            }
        }
    }

    //Save Location Loader
    Loader {
        id: saveLocationLoader
        z : 4
        anchors.right: parent.right
        onLoaded: {
            if(item){
                width = item.width
                height = item.height

                //Add item to List Model
                item.listViewModel.append({'texts': "Sd Card"});
                item.listViewModel.append({'texts': "Flash Card"});

                //When Start Save Location Window, FInd last Clicked index
                for(var i = 0; i < item.listView.model.count; i++){
                    if(item.listView.model.get(i).texts === saveLocationText){
                        item.listView.currentIndex = i;
                        break;
                    }
                }
            }
        }
    }

    //Anti Flicker Loader
    Loader {
        id: antiFlickerLoader
        z : 4
        anchors.right: parent.right
        onLoaded: {
            if(item){
                width = item.width
                height = item.height

                //Add item to List Model
                item.listViewModel.append({'texts': "Turn off"});
                item.listViewModel.append({'texts': "50Hz"});
                item.listViewModel.append({'texts': "60Hz"});

                //When Start Save Location Window, FInd last Clicked index
                for(var i = 0; i < item.listView.model.count; i++){
                    if(item.listView.model.get(i).texts === antiFlickerText){
                        item.listView.currentIndex = i;
                        break;
                    }
                }
            }
        }
    }




    Column {
        anchors.fill: parent
        width: parent.width
        height: parent.height

        // exit button & Camera setting text
        ItemDelegate{
            width: parent.width
            height: defaultFontSize * 10

            Row{
                id: exitbtnRow
                anchors.fill: parent
                spacing: defaultFontSize * 2
                Item {
                    width: defaultFontSize
                    height: 1
                }

                Image {
                    source: "qrc:/res/ales/waypoint/LeftDir.svg"
                    width: defaultFontSize * 2.5
                    height: width
                    anchors.verticalCenter: parent.verticalCenter
                }

                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text : "Camera Settings"
                    color: white
                    font.pixelSize: defaultFontSize * 3
                }

                enabled: true
            }

            background: Rectangle {
                color : transparent
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    parentQML.cameraSettingLoader.visible = false
                    parentQML.videoControl.z = 0

                    parentQML.logMessageLoader.visible = false
                }
            }
        }

        //Flickable
        Rectangle {
            width: parent.width - defaultFontSize * 6
            height: parent.height - exitbtnRow.height
            color: transparent
            anchors.horizontalCenter: parent.horizontalCenter
            clip: true
            Flickable {
                anchors.fill: parent
                contentWidth: parent.width
                contentHeight: parent.height * 1.7
                id: flickAble
                Column {
                    width: parent.width
                    height: parent.height

                    Item {
                        width: 1
                        height: defaultFontSize * 2
                    }

                    //Grid
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate

                        Text {
                            anchors.left: parent.left
                            text: 'Grid'
                            font.pixelSize: ScreenTools.mediumFontPointSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                            color: white
                        }

                        Image {
                            source:gridImage
                            anchors.right: parent.right
                            anchors.rightMargin: defaultFontSize * 5
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Image {
                            source: "qrc:/res/ales/waypoint/RightDir.svg"
                            anchors.right: parent.right
                            anchors.rightMargin: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        background: Rectangle {
                            color : transparent
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                console.log("Grid Window Click")

                                if(!gridLoader.item) {
                                    gridLoader.setSource("qrc:/qml/QGroundControl/Controls/Grid.qml",
                                                         { "parentQML":root })
                                }
                            }
                        }
                    }

                    ToolSeparator {
                        width: parent.width
                        height: hToolSeparator
                        orientation: Qt.Horizontal
                    }

                    //Center Point
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate

                        Text {
                            anchors.left: parent.left
                            color: white
                            text: qsTr("Center Point")
                            font.pixelSize: ScreenTools.mediumFontPointSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Image {
                            source: centerPointImage
                            anchors.right: parent.right
                            anchors.rightMargin: defaultFontSize * 5
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Image {
                            source: "qrc:/res/ales/waypoint/RightDir.svg"
                            anchors.right: parent.right
                            anchors.rightMargin: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        background: Rectangle {
                            color : transparent
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                console.log("Center Point Click")

                                if(!centerPointLoader.item) {
                                    centerPointLoader.setSource("qrc:/qml/QGroundControl/Controls/CenterPoint.qml", {
                                                                  "parentQML": root,
                                                                  "currentCenterPointValue": centerPointImage
                                                                })
                                }
                            }
                        }
                    }

                    ToolSeparator {
                        width: parent.width
                        height: hToolSeparator
                        orientation: Qt.Horizontal
                    }

                    // Histogram
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate

                        Text {
                            anchors.left: parent.left
                            color: white
                            text: qsTr("Histogram")
                            font.pixelSize: ScreenTools.mediumFontPointSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Switch{
                            id: histogramcontrol
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            checked: false
                            indicator: Rectangle {
                                implicitWidth: defaultFontSize * 6
                                implicitHeight: defaultFontSize * 3
                                x: histogramcontrol.width - width - histogramcontrol.rightPadding
                                y: parent.height / 2 - height / 2
                                radius: 13
                                color: histogramcontrol.checked ? blue : lightGray
                                border.color: black

                                Rectangle {
                                    x: histogramcontrol.checked ? parent.width - width : 0
                                    width: defaultFontSize * 3
                                    height: defaultFontSize * 3
                                    radius: 50
                                    border.color: black
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

                    // Lock Gimbal
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate

                        Text {
                            anchors.left: parent.left
                            color: white
                            text: qsTr("Lock Gimbal While Shooting")
                            font.pixelSize: ScreenTools.mediumFontPointSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Switch{
                            id: lockcontrol
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            checked: false
                            indicator: Rectangle {
                                implicitWidth: defaultFontSize * 6
                                implicitHeight: defaultFontSize * 3
                                x: lockcontrol.width - width - lockcontrol.rightPadding
                                y: parent.height / 2 - height / 2
                                radius: 13
                                color: lockcontrol.checked ? blue : lightGray
                                border.color: black

                                Rectangle {
                                    x: lockcontrol.checked ? parent.width - width : 0
                                    width: defaultFontSize * 3
                                    height: defaultFontSize * 3
                                    radius: 50
                                    border.color: black
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

                    //Defog
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate

                        Text {
                            anchors.left: parent.left
                            color: white
                            text: qsTr("Defog")
                            font.pixelSize: ScreenTools.mediumFontPointSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Switch{
                            id: defogcontrol
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            checked: false
                            indicator: Rectangle {
                                implicitWidth: defaultFontSize * 6
                                implicitHeight: defaultFontSize * 3
                                x: defogcontrol.width - width - defogcontrol.rightPadding
                                y: parent.height / 2 - height / 2
                                radius: 13
                                color: defogcontrol.checked ? blue : lightGray
                                border.color: black

                                Rectangle {
                                    x: defogcontrol.checked ? parent.width - width : 0
                                    width: defaultFontSize * 3
                                    height: defaultFontSize * 3
                                    radius: 50
                                    border.color: black
                                }
                            }
                            onCheckedChanged: {
                                if(checked){
                                    defogSliderBar.visible = true
                                    flickAble.contentHeight  = flickAble.contentHeight + defogSliderBar.height
                                }
                                else {
                                    defogSliderBar.visible = false
                                    flickAble.contentHeight  = flickAble.contentHeight - defogSliderBar.height
                                }
                            }
                        }

                        background: Rectangle {
                            color : transparent
                        }
                    }
                    //Defog Slider
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate
                        id: defogSliderBar
                        visible: false

                        Text {
                            anchors.left: parent.left
                            color: white
                            text: qsTr("1")
                            font.pixelSize: ScreenTools.mediumFontPointSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Slider {
                            orientation: Qt.Horizontal
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            value: 0
                            from: 1
                            to : 10
                            width: parent.width - defaultFontSize * 4
                        }

                        Text {
                            anchors.right: parent.right
                            color: white
                            text: qsTr("10")
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
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

                    //ROI
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate

                        Text {
                            anchors.left: parent.left
                            color: white
                            text: qsTr("ROI")
                            font.pixelSize: ScreenTools.mediumFontPointSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Switch{
                            id: roicontrol
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            checked: false
                            indicator: Rectangle {
                                implicitWidth: defaultFontSize * 6
                                implicitHeight: defaultFontSize * 3
                                x: roicontrol.width - width - roicontrol.rightPadding
                                y: parent.height / 2 - height / 2
                                radius: 13
                                color: roicontrol.checked ? blue : lightGray
                                border.color: black

                                Rectangle {
                                    x: roicontrol.checked ? parent.width - width : 0
                                    width: defaultFontSize * 3
                                    height: defaultFontSize * 3
                                    radius: 50
                                    border.color: black
                                }
                            }
                            onCheckedChanged: {
                                if(checked){
                                    roiSliderBar.visible = true
                                    flickAble.contentHeight  = flickAble.contentHeight + roiSliderBar.height
                                }
                                else {
                                    roiSliderBar.visible = false
                                    flickAble.contentHeight  = flickAble.contentHeight - roiSliderBar.height
                                }
                            }
                        }

                        background: Rectangle {
                            color : transparent
                        }
                    }
                    //ROI Slider
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate
                        id: roiSliderBar
                        visible : false

                        Text {
                            anchors.left: parent.left
                            color: white
                            text: qsTr("1")
                            font.pixelSize: ScreenTools.mediumFontPointSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                        }

                        Slider {
                            orientation: Qt.Horizontal
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.horizontalCenter
                            value: 0
                            from: 1
                            to : 10
                            width: parent.width - defaultFontSize * 4
                        }

                        Text {
                            anchors.right: parent.right
                            color: white
                            text: qsTr("10")
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
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

                    //Over Exposure
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate

                        Text {
                            anchors.left: parent.left
                            color: white
                            text: qsTr("Over Exposure Warning")
                            font.pixelSize: ScreenTools.mediumFontPointSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Switch{
                            id: overcontrol
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            checked: false
                            indicator: Rectangle {
                                implicitWidth: defaultFontSize * 6
                                implicitHeight: defaultFontSize * 3
                                x: overcontrol.width - width - overcontrol.rightPadding
                                y: parent.height / 2 - height / 2
                                radius: 13
                                color: overcontrol.checked ? blue : lightGray
                                border.color: black

                                Rectangle {
                                    x: overcontrol.checked ? parent.width - width : 0
                                    width: defaultFontSize * 3
                                    height: defaultFontSize * 3
                                    radius: 50
                                    border.color: black
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

                    //Subtitle
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate

                        Text {
                            anchors.left: parent.left
                            color: white
                            text: qsTr("Subtitle.ASS File")
                            font.pixelSize: ScreenTools.mediumFontPointSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Switch{
                            id: subtitlecontrol
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            checked: false
                            indicator: Rectangle {
                                implicitWidth: defaultFontSize * 6
                                implicitHeight: defaultFontSize * 3
                                x: subtitlecontrol.width - width - subtitlecontrol.rightPadding
                                y: parent.height / 2 - height / 2
                                radius: 13
                                color: subtitlecontrol.checked ? blue : lightGray
                                border.color: black

                                Rectangle {
                                    x: subtitlecontrol.checked ? parent.width - width : 0
                                    width: defaultFontSize * 3
                                    height: defaultFontSize * 3
                                    radius: 50
                                    border.color: black
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

                    // Auto Syne
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate

                        Text {
                            anchors.left: parent.left
                            color: white
                            text: qsTr("Auto Syne HD Photo")
                            font.pixelSize: ScreenTools.mediumFontPointSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Switch{
                            id: autosynecontrol
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            checked: false
                            indicator: Rectangle {
                                implicitWidth: defaultFontSize * 6
                                implicitHeight: defaultFontSize * 3
                                x: autosynecontrol.width - width - autosynecontrol.rightPadding
                                y: parent.height / 2 - height / 2
                                radius: 13
                                color: autosynecontrol.checked ? blue : lightGray
                                border.color: black

                                Rectangle {
                                    x: autosynecontrol.checked ? parent.width - width : 0
                                    width: defaultFontSize * 3
                                    height: defaultFontSize * 3
                                    radius: 50
                                    border.color: black
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

                    //Pre-Record
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate

                        Text {
                            anchors.left: parent.left
                            color: white
                            text: qsTr("Pre-record Photo")
                            font.pixelSize: ScreenTools.mediumFontPointSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Switch{
                            id: preRecordcontrol
                            anchors.right: parent.right
                            anchors.verticalCenter: parent.verticalCenter
                            checked: false
                            indicator: Rectangle {
                                implicitWidth: defaultFontSize * 6
                                implicitHeight: defaultFontSize * 3
                                x: preRecordcontrol.width - width - preRecordcontrol.rightPadding
                                y: parent.height / 2 - height / 2
                                radius: 13
                                color: preRecordcontrol.checked ? blue : lightGray
                                border.color: black

                                Rectangle {
                                    x: preRecordcontrol.checked ? parent.width - width : 0
                                    width: defaultFontSize * 3
                                    height: defaultFontSize * 3
                                    radius: 50
                                    border.color: black
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

                    //Video Encoding
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate

                        Text {
                            anchors.left: parent.left
                            color: white
                            text: qsTr("Video Encoding Format")
                            font.pixelSize: ScreenTools.mediumFontPointSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            anchors.right: parent.right
                            color: blue
                            text: videoEncodingText
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: defaultFontSize * 2

                        }

                        background: Rectangle {
                            color : transparent
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if(!videoEncodingLoader.item){
                                    videoEncodingLoader.setSource("qrc:/qml/QGroundControl/Controls/VideoEncodingFormat.qml",
                                                                  { "parentQML": root })
                                }
                            }
                        }
                    }

                    ToolSeparator {
                        width: parent.width
                        height: hToolSeparator
                        orientation: Qt.Horizontal
                    }

                    //Anti flicker
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate

                        Text {
                            anchors.left: parent.left
                            color: white
                            text: qsTr("Anti-Flicker")
                            font.pixelSize: ScreenTools.mediumFontPointSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            anchors.right: parent.right
                            color: blue
                            text: antiFlickerText
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: defaultFontSize * 2

                        }
                        background: Rectangle {
                            color : transparent
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if(!antiFlickerLoader.item){
                                    antiFlickerLoader.setSource("qrc:/qml/QGroundControl/Controls/AntiFlicker.qml", {"parentQML": root})
                                }
                            }
                        }
                    }

                    ToolSeparator {
                        width: parent.width
                        height: hToolSeparator
                        orientation: Qt.Horizontal
                    }

                    //Reset Camera
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate

                        Text {
                            anchors.right: parent.right
                            anchors.rightMargin: 20
                            color: blue
                            text: qsTr("Reset Camera")
                            font.pixelSize: ScreenTools.mediumFontPointSize * 2.1
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        background: Rectangle {
                            color : transparent
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                parentQML.isWarning = false
                                parentQML.innerText = "Are you sure you wish to reset\ncamera settings?"
                                resetCamera();
                            }
                        }
                    }

                    ToolSeparator {
                        width: parent.width
                        height: hToolSeparator
                        orientation: Qt.Horizontal
                    }

                    //Save Location
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate

                        Text {
                            anchors.left: parent.left
                            color: white
                            text: "Save Location"
                            font.pixelSize: ScreenTools.mediumFontPointSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            anchors.right: parent.right
                            color: blue
                            text: saveLocationText
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: defaultFontSize * 2

                        }

                        background: Rectangle {
                            color : transparent
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                if(!saveLocationLoader.item){
                                    saveLocationLoader.setSource("qrc:/qml/QGroundControl/Controls/SaveLocation.qml",{"parentQML": root})
                                }
                            }
                        }
                    }

                    ToolSeparator {
                        width: parent.width
                        height: hToolSeparator
                        orientation: Qt.Horizontal
                    }

                    // Format SD Card
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate

                        Text {
                            anchors.right: parent.right
                            anchors.rightMargin: 20
                            color: blue
                            text: qsTr("Format SD Card")
                            font.pixelSize: ScreenTools.mediumFontPointSize * 2.1
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        background: Rectangle {
                            color : transparent
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                parentQML.isWarning = true
                                parentQML.innerText = "Formatting will erase ALL data\non the SD card. To format the\nSD card touch 'format'\nto quit touch 'Cancel'"
                                resetCamera();
                            }
                        }
                    }

                    ToolSeparator {
                        width: parent.width
                        height: hToolSeparator
                        orientation: Qt.Horizontal
                    }

                    //Format Flash Card
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate

                        Text {
                            anchors.right: parent.right
                            anchors.rightMargin: 20
                            color: blue
                            text: qsTr("Format Flash Card")
                            font.pixelSize: ScreenTools.mediumFontPointSize * 2.1
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        background: Rectangle {
                            color : transparent
                        }
                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                parentQML.isWarning = true
                                parentQML.innerText = "Formatting will erase ALL data\non the Flash card. To format the\nFlash card touch 'format'\nto quit touch 'Cancel'"
                                resetCamera();
                            }
                        }
                    }

                    ToolSeparator {
                        width: parent.width
                        height: hToolSeparator
                        orientation: Qt.Horizontal
                    }


                    //Model
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate

                        Text {
                            anchors.left: parent.left
                            color: white
                            text: qsTr("Model")
                            font.pixelSize: ScreenTools.mediumFontPointSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            anchors.right: parent.right
                            color: white
                            text: qsTr("XT701")
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: defaultFontSize * 2
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

                    //Camera Version
                    ItemDelegate {
                        width: parent.width
                        height: hItemDelegate

                        Text {
                            anchors.left: parent.left
                            color: white
                            text: qsTr("Camera Version")
                            font.pixelSize: ScreenTools.mediumFontPointSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Text {
                            anchors.right: parent.right
                            color: white
                            text: qsTr("V0.2.32.32")
                            font.pixelSize: defaultFontSize * 2
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.rightMargin: defaultFontSize * 2
                        }

                        background: Rectangle {
                            color : transparent
                        }
                    }
                }
            }
        }
    }
}
