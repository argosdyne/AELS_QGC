import QtQuick          2.11
import QtQuick.Layouts  1.11
import QtQuick.Dialogs  1.2
import QtQuick.Controls 1.4

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Palette               1.0
import QGroundControl.FactSystem            1.0
import QGroundControl.FactControls          1.0

import CustomQmlInterface                   1.0
import Custom.Widgets                       1.0

Item {
    id:  _root
    width:          signalRow.width

    QGCPalette { id: qgcPal }

    property var thridFactory: QGroundControl.corePlugin.thridRCFactory

    // Signal
    Row {
        id:                                     signalRow
        spacing:                                ScreenTools.defaultFontPixelWidth
        anchors.top:                            parent.top
        anchors.bottom:                         parent.bottom
        anchors.horizontalCenter:               parent.horizontalCenter

        QGCColoredImage {
            source:             "qrc:/qmlimages/RC.svg"
            fillMode:           Image.PreserveAspectFit
            width:              ScreenTools.defaultFontPixelHeight * 2
            height:             width
            color:              thridFactory.running ? (thridFactory.enabled ? qgcPal.colorGreen : qgcPal.buttonText) : qgcPal.colorRed
            sourceSize.height:  height
        }
    }
}
