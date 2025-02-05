/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/


import QtQuick                  2.3
import QtQuick.Controls         1.2
import QtQuick.Controls.Styles  1.4
import QtQuick.Dialogs          1.2
import QtQuick.Layouts          1.2

import QGroundControl                       1.0
import QGroundControl.FactSystem            1.0
import QGroundControl.FactControls          1.0
import QGroundControl.Controls              1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.Palette               1.0
import QGroundControl.Controllers           1.0
import QGroundControl.SettingsManager       1.0



Rectangle {
    id:                 _root
    color:              qgcPal.window
    anchors.fill:       parent
    anchors.margins:    ScreenTools.defaultFontPixelWidth

    property Fact _savePath:                            QGroundControl.settingsManager.appSettings.savePath

    property real   _comboFieldWidth:           ScreenTools.defaultFontPixelWidth * 30
    property real   _valueFieldWidth:           ScreenTools.defaultFontPixelWidth * 10
    property real   _margins:                   ScreenTools.defaultFontPixelWidth

    property var    _planViewSettings:          QGroundControl.settingsManager.planViewSettings
    property var    _flyViewSettings:           QGroundControl.settingsManager.flyViewSettings
    property var    _videoSettings:             QGroundControl.settingsManager.videoSettings


        QGCFlickable {
            clip:               true
            anchors.fill:       parent
            contentHeight:      outerItem.height
            contentWidth:       outerItem.width

            Item {
                id:     outerItem
                width:  Math.max(_root.width, settingsColumn.width)
                height: settingsColumn.height

                ColumnLayout {
                    id:                         settingsColumn
                    anchors.horizontalCenter:   parent.horizontalCenter

                    QGCLabel {
                        id:         flyViewSectionLabel
                        text:       qsTr("GeoAwareness Settings")
                        visible:    QGroundControl.settingsManager.flyViewSettings.visible
                    }
                    Rectangle {
                        Layout.preferredHeight: flyViewCol.height + (_margins * 2)
                        Layout.preferredWidth:  flyViewCol.width + (_margins * 2)
                        color:                  qgcPal.windowShade
                        visible:                flyViewSectionLabel.visible
                        Layout.fillWidth:       true

                        ColumnLayout {
                            id:                         flyViewCol
                            anchors.margins:            _margins
                            anchors.top:                parent.top
                            anchors.horizontalCenter:   parent.horizontalCenter
                            spacing:                    _margins

                            GridLayout {
                                columns: 2
                                QGCLabel {
                                    text:       qsTr("Set Alarm Distance (meters) ")
                                    visible:    alarmDistance.visible
                                }
                                FactTextField {
                                    id:                     alarmDistance
                                    Layout.preferredWidth:  _valueFieldWidth
                                    visible:                true
                                    fact:                    _flyViewSettings.alarmDistance
                                }
                            }

                            GridLayout {
                                id:         videoGrid
                                columns:    2
                                visible:    true

                                QGCLabel {
                                    id:         videoDecodeLabel
                                    text:       qsTr("Select GeoAwareness data type")
                                    visible:    geoDataType.visible
                                }
                                FactComboBox {
                                    id:                     geoDataType
                                    Layout.preferredWidth:  _comboFieldWidth
                                    fact:                   _flyViewSettings.dataType
                                    visible:                true
                                    indexModel:             false
                                }
                            }
                            QGCLabel { text: qsTr("Application Load/Save Path") }

                            FactTextField {
                                id: filePathTextField
                                Layout.fillWidth:   true
                                readOnly:           true
                                visible:            true
                                fact:   _flyViewSettings.filePath
                            }
                            QGCButton {
                                text:       qsTr("Browse")
                                onClicked:  androidFileDialog.open()
                                FileDialog {
                                    id: androidFileDialog
                                    title: "Select a File"
                                    folder: Qt.platform.os === "android" ? "/storage/emulated/0/" : fileUrl
                                    nameFilters: ["All Files (*)", "Text Files (*.txt)"] // 원하는 파일 필터
                                    selectExisting: true
                                    selectMultiple: false
                                    selectFolder: false

                                    // 파일 선택 완료 시 호출
                                    onAccepted: {
                                        console.log("Selected file path: " + fileUrl) // 선택한 파일의 경로 출력
                                        console.log("Current platform : " + Qt.platform.os)

                                        if(Qt.platform.os === "windows"){
                                            let plainPath = fileUrl.toString().startsWith("file:///") ? fileUrl.toString().substring(8) : fileUrl.toString()
                                                console.log("Plain file path: " + plainPath)
                                                filePathTextField.text = plainPath
                                        }
                                        else {
                                            filePathTextField.text = fileUrl.toString()
                                        }
                                    }
                                    // 파일 선택 취소 시 호출
                                    onRejected: {
                                        console.log("File selection cancelled.")
                                    }
                                }
                            }
                        }
                    }
                }
            }
    }
}
