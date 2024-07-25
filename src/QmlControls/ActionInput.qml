import QtQuick          2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts  1.11
import QtQuick.Dialogs  1.3
import QtQuick.Window 2.0

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.Palette               1.0
import QGroundControl.ScreenTools           1.0



Rectangle {
    id: root
    height: 600
    width: 1100

    visible: true
    color: "#cf454545"
    radius: 5
    property int sizeText: ScreenTools.defaultFontPointSize/16*16



    function addNewScreen() {
        var screenIndex = viewsModel.count+1
        var screenName = "SC"+ screenIndex

        viewsModel.append({"name": screenName})
        var newItem = null
        if (btnLiveAction.checked){
            newItem = liveActionComponent.createObject(swipeView)
        } else {
            newItem = waypointActionComponent.createObject(swipeView)
        }

        // newItem.textName = screenName (assign variable in this way)
        swipeView.addItem(newItem)
        swipeView.setCurrentIndex(screenIndex)
    }

    function removeCurrentScreen(){
        var screenIndex = swipeView.currentIndex -1
        swipeView.removeItem(swipeView.currentItem)
        viewsModel.remove(screenIndex)
    }

    ListModel {
            id: viewsModel
//            ListElement { name: "Initial Screen" }
    }

    Component{
        id: comboBoxComponent
        ComboBox {
            id: control
            model: ["First", "Second", "Third"]
            property string backgroundColor: "#3b3737"
            property string popupBackgroundColor: "black"
            property string borderColor: "#cecdcd"
            property string borderColorFocus: "#7f7f7f"

            delegate: ItemDelegate {
                width: control.width
                contentItem: Text {
                    text: modelData
                    color: "grey"
                    font: control.font
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }
                highlighted: control.highlightedIndex === index
            }

            indicator: Canvas {
                id: canvas
                x: control.width - width - control.rightPadding
                y: control.topPadding + (control.availableHeight - height) / 2
                width: 12
                height: 8
                contextType: "2d"

                Connections {
                    target: control
                    function onPressedChanged() { canvas.requestPaint(); }
                }

                onPaint: {
                    context.reset();
                    context.moveTo(0, 0);
                    context.lineTo(width, 0);
                    context.lineTo(width / 2, height);
                    context.closePath();
                    context.fillStyle = control.pressed ? "white" : "white";
                    context.fill();
                }
            }

            contentItem: Text {

                leftPadding: 0
                rightPadding: control.indicator.width + control.spacing
                text: control.displayText
                font: control.font
                color: "white"
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
            }

            background: Rectangle {
                implicitWidth: ScreenTools.defaultFontPointSize/16*120
                implicitHeight: ScreenTools.defaultFontPointSize/16*40
                color:backgroundColor
                border.color: control.visualFocus ?  borderColor : borderColorFocus
                border.width: control.visualFocus ? 5 : 2
                radius: 5
            }

            popup: Popup {
                y: control.height - 1
                width: control.width
                implicitHeight: contentItem.implicitHeight
                padding: 1

                contentItem: ListView {
                    clip: true
                    implicitHeight: contentHeight
                    model: control.popup.visible ? control.delegateModel : null
                    currentIndex: control.highlightedIndex

                    ScrollIndicator.vertical: ScrollIndicator { }
                }

                background: Rectangle {
                    border.color: borderColorFocus
                    color:popupBackgroundColor
                    radius: 5
                }
            }
        }
    }

    Component {
        id: liveActionComponent

        Rectangle {
            property string textName: "ABC"
            width: swipeView.width
            height: swipeView.height
            color: "transparent"
            ColumnLayout{
                anchors.fill: parent
                anchors.margins: 20
                spacing: 10
                RowLayout{
                    Text {
                        text: qsTr("Camera Action")
                        Layout.preferredWidth: 150
                        color: "white"
                        font.pointSize: sizeText
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth:  true
                    }
                    
                    Loader{
                        Layout.fillHeight: true
                        Layout.preferredWidth: 300
                        sourceComponent: comboBoxComponent
                        onLoaded: {
                            onLoaded: {
                                item.model = ["Start Recording", "Stop Recording", "Take Photo", "Time Lapse", "Distance Lapse", " PhotoEnd","--"] // Ensure the model is set correctly
                            }
                        }
                    }

                }

                RowLayout{
                    Text {
                        text: qsTr("Gimbal Pitch")
                        Layout.preferredWidth: 150
                        color: "white"
                        font.pointSize: sizeText
                    }

                    TextField{
                        text: slider.value+"\xB0"
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        Layout.preferredWidth: 100
                        Layout.preferredHeight: 50
                        background: Rectangle {
                            radius: 5
                            color: "transparent"
                            border.color: "#8a8a8a"
                        }
                    }

                    Label{
                        text: slider.from
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        Layout.preferredWidth: 80
                        color:   "#797979"
                        font.pointSize: sizeText
                    }

                    Slider {
                        id: slider
                        live: true
                        spacing: 0
                        stepSize: 1
                        value: 10
                        to: 90
                        from: 0
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        background: Rectangle {
                            x: parent.leftPadding
                            y: parent.topPadding
                               + parent.availableHeight / 2 - height / 2
                            implicitHeight: 5
                            implicitWidth: 200
                            height: implicitHeight
                            width: parent.availableWidth
                        }

                        handle: Rectangle {
                                x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
                                y: parent.topPadding + parent.availableHeight / 2 - height / 2
                                implicitWidth: 26
                                implicitHeight: 26
                                radius: 13
                                color: parent.pressed ? "#f0f0f0" : "#4c6fda"
                                border.color: "#4c6fda"
                            }
                    }

                    Label{
                        text: slider.to
                        Layout.preferredWidth: 80
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: sizeText
                        color:   "#797979"

                    }


                }

                RowLayout{
                    Text {
                        text: qsTr("Heading")
                        Layout.preferredWidth: 150
                        color: "white"
                        font.pointSize: sizeText
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth:  true
                    }

                    Loader{
                        Layout.fillHeight: true
                        Layout.preferredWidth: 300
                        sourceComponent: comboBoxComponent
                        onLoaded: {
                            onLoaded: {
                                item.model = ["Route", "Manual", "Custom"] // Ensure the model is set correctly
                            }
                        }
                    }

                }

                RowLayout{
                    Text {
                        text: qsTr("")
                        color: "white"
                        Layout.preferredWidth: 150
                        font.pointSize: sizeText
                    }

                    TextField{
                        text: headSlider.value+"\xB0"
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        Layout.preferredWidth: 100
                        Layout.preferredHeight: 50
                        background: Rectangle {
                            radius: 5
                            color: "transparent"
                            border.color: "#8a8a8a"
                        }
                    }

                    Label{
                        text: headSlider.from
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        Layout.preferredWidth: 80
                        color:   "#797979"
                        font.pointSize: sizeText
                    }

                    Slider {
                        id: headSlider
                        live: true
                        spacing: 0
                        stepSize: 1
                        value: 10
                        from: 0
                        to: 359
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        background: Rectangle {
                            x: parent.leftPadding
                            y: parent.topPadding
                               + parent.availableHeight / 2 - height / 2
                            implicitHeight: 5
                            implicitWidth: 200
                            height: implicitHeight
                            width: parent.availableWidth
                        }

                        handle: Rectangle {
                                x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
                                y: parent.topPadding + parent.availableHeight / 2 - height / 2
                                implicitWidth: 26
                                implicitHeight: 26
                                radius: 13
                                color: parent.pressed ? "#f0f0f0" : "#4c6fda"
                                border.color: "#4c6fda"
                            }
                    }

                    Label{
                        text: headSlider.to
                        Layout.preferredWidth: 80
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: sizeText
                        color:   "#797979"

                    }
                }
            }
        }
    }


    Component {
        id: waypointActionComponent

        Rectangle {
            width: swipeView.width
            height: swipeView.height
            color: "transparent"
            ColumnLayout{
                anchors.fill: parent
                anchors.margins: 20
                spacing: 10
                RowLayout{
                    Text {
                        text: qsTr("Camera Action")
                        Layout.preferredWidth: 150
                        color: "white"
                        font.pointSize: sizeText
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth:  true
                    }

                    Loader{
                        Layout.fillHeight: true
                        Layout.preferredWidth: 300
                        sourceComponent: comboBoxComponent
                        onLoaded: {
                            onLoaded: {
                                item.model = ["Time Lapse", "Record", "Take Photo"] // Ensure the model is set correctly
                            }
                        }
                    }

                }

                RowLayout{
                    Text {
                        text: qsTr("Interval")
                        Layout.preferredWidth: 150
                        color: "white"
                        font.pointSize: sizeText
                    }

                    TextField{
                        text: slider.value+"s"
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        Layout.preferredWidth: 100
                        Layout.preferredHeight: 50
                        background: Rectangle {
                            radius: 5
                            color: "transparent"
                            border.color: "#8a8a8a"
                        }
                    }

                    Label{
                        text: slider.from
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        Layout.preferredWidth: 80
                        color:   "#797979"
                        font.pointSize: sizeText
                    }

                    Slider {
                        id: slider
                        live: true
                        spacing: 0
                        stepSize: 1
                        value: 10
                        to: 60
                        from: 0
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        background: Rectangle {
                            x: parent.leftPadding
                            y: parent.topPadding
                               + parent.availableHeight / 2 - height / 2
                            implicitHeight: 5
                            implicitWidth: 200
                            height: implicitHeight
                            width: parent.availableWidth
                        }

                        handle: Rectangle {
                                x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
                                y: parent.topPadding + parent.availableHeight / 2 - height / 2
                                implicitWidth: 26
                                implicitHeight: 26
                                radius: 13
                                color: parent.pressed ? "#f0f0f0" : "#4c6fda"
                                border.color: "#4c6fda"
                            }
                    }

                    Label{
                        text: slider.to
                        Layout.preferredWidth: 80
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: sizeText
                        color:   "#797979"

                    }


                }

                RowLayout{
                    Text {
                        text: qsTr("Photo Time")
                        Layout.preferredWidth: 150
                        color: "white"
                        font.pointSize: sizeText
                    }

                    TextField{
                        text: photoTimeSlider.value+"s"
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        Layout.preferredWidth: 100
                        Layout.preferredHeight: 50
                        background: Rectangle {
                            radius: 5
                            color: "transparent"
                            border.color: "#8a8a8a"
                        }
                    }

                    Label{
                        text: photoTimeSlider.from
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        Layout.preferredWidth: 80
                        color:   "#797979"
                        font.pointSize: sizeText
                    }

                    Slider {
                        id: photoTimeSlider
                        live: true
                        spacing: 0
                        stepSize: 1
                        value: 10
                        to: 1800
                        from: 0
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        background: Rectangle {
                            x: parent.leftPadding
                            y: parent.topPadding
                               + parent.availableHeight / 2 - height / 2
                            implicitHeight: 5
                            implicitWidth: 200
                            height: implicitHeight
                            width: parent.availableWidth
                        }

                        handle: Rectangle {
                                x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
                                y: parent.topPadding + parent.availableHeight / 2 - height / 2
                                implicitWidth: 26
                                implicitHeight: 26
                                radius: 13
                                color: parent.pressed ? "#f0f0f0" : "#4c6fda"
                                border.color: "#4c6fda"
                            }
                    }

                    Label{
                        text: photoTimeSlider.to
                        Layout.preferredWidth: 80
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: sizeText
                        color:   "#797979"

                    }


                }

                RowLayout{
                    Text {
                        text: qsTr("Gimbal Pitch")
                        Layout.preferredWidth: 150
                        color: "white"
                        font.pointSize: sizeText
                    }

                    TextField{
                        text: gimbalPitchSlider.value+"\xB0"
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        Layout.preferredWidth: 100
                        Layout.preferredHeight: 50
                        background: Rectangle {
                            radius: 5
                            color: "transparent"
                            border.color: "#8a8a8a"
                        }
                    }

                    Label{
                        text: gimbalPitchSlider.from
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        Layout.preferredWidth: 80
                        color:   "#797979"
                        font.pointSize: sizeText
                    }

                    Slider {
                        id: gimbalPitchSlider
                        live: true
                        spacing: 0
                        stepSize: 1
                        value: 0
                        to: 90
                        from: 0
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        background: Rectangle {
                            x: parent.leftPadding
                            y: parent.topPadding
                               + parent.availableHeight / 2 - height / 2
                            implicitHeight: 5
                            implicitWidth: 200
                            height: implicitHeight
                            width: parent.availableWidth
                        }

                        handle: Rectangle {
                                x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
                                y: parent.topPadding + parent.availableHeight / 2 - height / 2
                                implicitWidth: 26
                                implicitHeight: 26
                                radius: 13
                                color: parent.pressed ? "#f0f0f0" : "#4c6fda"
                                border.color: "#4c6fda"
                            }
                    }

                    Label{
                        text: gimbalPitchSlider.to
                        Layout.preferredWidth: 80
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pointSize: sizeText
                        color:   "#797979"

                    }


                }

                RowLayout{
                    Text {
                        text: qsTr("Heading")
                        Layout.preferredWidth: 150
                        color: "white"
                        font.pointSize: sizeText
                    }

                    Item {
                        Layout.fillHeight: true
                        Layout.fillWidth:  true
                    }

                    Loader{
                        Layout.fillHeight: true
                        Layout.preferredWidth: 300
                        sourceComponent: comboBoxComponent
                        onLoaded: {
                            onLoaded: {
                                item.model = ["Defined by Waypoint", "Record", "Take Photo"] // Ensure the model is set correctly
                            }
                        }
                    }

                }



            }
        }
    }


    ColumnLayout{
        anchors.fill: parent
        spacing: 10

        Rectangle{
            Layout.fillWidth: true
            Layout.preferredHeight:80
            color: "#464646"

            ButtonGroup{
                buttons: waypointActionLayout.children

            }

            RowLayout{
                id:waypointActionLayout
                anchors.fill: parent
                anchors{
                    rightMargin:  50
                    leftMargin: 10
                    topMargin: 10
                    bottomMargin: 10
                }

                spacing: 10
                Text{
                    Layout.fillHeight: true
                    text: "Waypoint Action"
                    color: "#2763d9"
                    font.pixelSize: ScreenTools.defaultFontPointSize/16*24
                    verticalAlignment: Text.AlignVCenter
                }

                Item{
                    //Spacing
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                }

                Button{
                    id:btnLiveAction
                    checked: true
                    checkable: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: 200

                    background: Rectangle{
                        color: parent.checked?"#3d71d7":"#868686"
                        radius: 10
                        Text{
                            anchors.centerIn: parent
                            font.pixelSize: ScreenTools.defaultFontPointSize/16*24
                            text: "Live Action"
                            color: "White"
                        }

                    }
                }

                Button{
                    id:btnWaypointAction
                    checked: false
                    checkable: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: 200

                    background: Rectangle{
                        color: parent.checked?"#3d71d7":"#868686"
                        radius: 10
                        Text{
                            anchors.centerIn: parent
                            font.pixelSize: ScreenTools.defaultFontPointSize/16*24
                            text: "Waypoint Action"
                            color: "White"
                        }
                    }
                }
            }

        }

        Rectangle{
            Layout.fillWidth: true
            Layout.preferredHeight:80
            color: "#464646"


            RowLayout{
                anchors.fill: parent
                anchors{
                    rightMargin:  100
                    leftMargin: 10
                    topMargin: 10
                    bottomMargin: 10
                }

                spacing: 10
                Text{
                    Layout.fillHeight: true
                    text: "Payload Action"
                    color: "#2763d9"
                    font.pixelSize: ScreenTools.defaultFontPointSize/16*24
                    verticalAlignment: Text.AlignVCenter
                }

                Item{
                    //Spacing
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    ButtonGroup{
                        id: buttonGroup
                    }

                    RowLayout{
                        id:buttonRow
                        anchors.fill: parent
                        Repeater{
                            model: Math.min(10, viewsModel.count)
                            delegate: Button{
                                Layout.fillHeight: true
                                Layout.preferredWidth: height*0.5
                                checkable: true
                                checked:  (viewsModel.count- Math.min(10, viewsModel.count) + index) + 1 //swipeView.currentIndex===index+1
                                onClicked: {
                                    swipeView.currentIndex =  (viewsModel.count- Math.min(10, viewsModel.count) + index) + 1//index+1
                                }
                                ButtonGroup.group: buttonGroup
                                background: Rectangle{
                                    color: parent.checked?"#3d71d7":"#868686"
                                    radius: 5
                                    Text {
                                        anchors.centerIn:parent
                                        text: viewsModel.get(viewsModel.count- Math.min(10, viewsModel.count) + index).name // name
                                        color: "white"
                                        font.pointSize: sizeText
                                    }
                                }
                            }
                        }
                        Item{
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                        }
                    }
                }

                Button{
                    id:btnAdd
                    icon.height: ScreenTools.defaultFontPointSize/16*50
                    icon.width: ScreenTools.defaultFontPointSize/16*50
                    icon.color: "#00000000"
                    icon.source: "/res/ales/waypoint/AddButton.svg"
                    checked: true
                    checkable: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: 100

                    background: Rectangle{
                        color: "transparent"

                    }

                    onClicked: {
                        addNewScreen()

                    }
                }

                Button{
                    id:btnMinus
                    icon.height: ScreenTools.defaultFontPointSize/16*50
                    icon.width: ScreenTools.defaultFontPointSize/16*50
                    visible: viewsModel.count
                    icon.color: "#00000000"
                    icon.source: "/res/ales/waypoint/MinusButton.png"
                    checked: true
                    checkable: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: 100

                    background: Rectangle{
                        color: "transparent"

                    }

                    onClicked: {
                        removeCurrentScreen()

                    }
                }


            }

        }

        SwipeView  {
            id: swipeView
            interactive: false
            Layout.fillHeight: true
            Layout.fillWidth: true
            clip: true

            Rectangle{
                color: "transparent"
                ColumnLayout{
                    anchors.centerIn: parent
                    spacing: 40

                    Text {
                        Layout.fillWidth: true
                        text: qsTr("No camera action at the current waypoint")
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: "white"
                        font.pointSize: sizeText*2
                    }

                    Text {
                        Layout.fillWidth: true
                        text: qsTr("Click on the top right corner Add Button (+) for camera action")
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        color: "white"
                        font.pointSize: sizeText*2
                    }
                }
            }

        }
    }

}
