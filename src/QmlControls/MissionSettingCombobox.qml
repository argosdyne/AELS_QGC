import QtQuick          2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts  1.11
import QtQuick.Dialogs  1.3
import QtQuick.Window 2.0

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.Palette               1.0
import QGroundControl.ScreenTools           1.0



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
        border.color: control.pressed ? borderColor : borderColorFocus
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


