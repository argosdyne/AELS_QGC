import QtQuick          2.3
import QtQuick.Controls 2.4
import QtQuick.Layouts  1.11
import QtQuick.Dialogs  1.3

import QGroundControl                       1.0
import QGroundControl.Controllers           1.0
import QGroundControl.Controls              1.0
import QGroundControl.FactControls          1.0
import QGroundControl.FactSystem            1.0
import QGroundControl.Palette               1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.SettingsManager       1.0

Column {
    id: root
    clip: true

    property real _margins: ScreenTools.defaultFontPixelHeight * 0.5
    property var  _ntripSource: QGroundControl.corePlugin.codevRTCMManager.rtcmSource

    QGCPalette { id: gcPal; colorGroupEnabled: enabled }

    GridLayout {
        id:     outerItem
        anchors.margins:    ScreenTools.defaultFontPixelHeight
        columnSpacing:      ScreenTools.defaultFontPixelHeight
        anchors.horizontalCenter: parent.horizontalCenter
        columns: 2
        QGCLabel {
            text:           qsTr("Port:")
            Layout.minimumWidth: _labelWidth
        }
        QGCComboBox {
            id: rtcmPort
            Layout.minimumWidth:  _valueWidth

            model:  ListModel {
            }

            onActivated: {
                if (index != -1) {
                    _ntripSource.port.value = textAt(index);
                }
            }
            Component.onCompleted: {
                QGroundControl.linkManager.manualRefreshSerialPorts()
                rtcmPort.model.append({text:"/dev/ttysWK0"})
                var serialPorts = QGroundControl.linkManager.serialPorts
                for (var i in serialPorts) {
                    rtcmPort.model.append({text:serialPorts[i]})
                }
                var index = rtcmPort.find(_ntripSource.port.valueString);
                if(index < 0 && _ntripSource.port.valueString.length !== 0) {
                    rtcmPort.model.append({text:_ntripSource.port.valueString})
                    index = serialPorts.length
                }
                if (serialPorts.length === 0 && _ntripSource.port.valueString.length === 0) {
                    rtcmPort.model.append({text: "Serial <none available>"})
                }
                if(index < 0) {
                    rtcmPort.currentIndex = 0
                    _ntripSource.port.value = textAt(rtcmPort.currentIndex);
                }
            }
        }
        QGCLabel {
            text:           qsTr("Baud:")
            Layout.minimumWidth: _labelWidth
        }
        QGCComboBox {
            id: rtcmBaud
            Layout.minimumWidth:  _valueWidth
            model:                  [4800, 9600, 19200, 38400, 57600, 115200]

            onActivated: {
                if (index != -1) {
                    _ntripSource.baud.value = textAt(index);
                }
            }
            Component.onCompleted: {
                var index = rtcmBaud.find(_ntripSource.baud.valueString);
                rtcmBaud.currentIndex = index;
            }
        }
    }
}
