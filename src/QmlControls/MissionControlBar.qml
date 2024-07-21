import QtQuick          2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts  1.11
import QtQuick.Dialogs  1.3
import QtQuick.Window 2.0

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.Palette               1.0
import QGroundControl.ScreenTools           1.0



Rectangle{
    implicitWidth: 800
    implicitHeight: 100
    color:"white"
    radius: 10

    property alias btnCurrentWaypoint: btnCurrentWaypoint

    ButtonGroup{
        id: barButtonGroup
        buttons: rowButtons.children
    }

    RowLayout {
        id: rowButtons
        anchors.centerIn:parent
        spacing: 10

        Button{
            checkable: true
            Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
            Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100

            background: Rectangle{
                color: parent.checked? "#3d71d7":"transparent"
                Image {
                    anchors.fill: parent
                    anchors.margins: 5
                    source: "/res/ales/waypoint/RooteAB.svg"
                    fillMode: Image.PreserveAspectFit
                }
                radius: 5
            }
        }

        ToolSeparator{

        }

        Button{
            id: btnCurrentWaypoint
            checkable: true
            Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
            Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100

            background: Rectangle{
                color: parent.checked? "#3d71d7":"transparent"
                Image {
                    anchors.fill: parent
                    anchors.margins: 5
                    source: "/res/ales/waypoint/CurrentLocation.svg"
                    fillMode: Image.PreserveAspectFit
                }
                radius: 5
            }
        }
        Button{
            checkable: true
            Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
            Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100

            background: Rectangle{
                color: parent.checked? "#3d71d7":"transparent"
                Image {
                    anchors.fill: parent
                    anchors.margins: 5
                    source: "/res/ales/waypoint/LandingLocation.svg"
                    fillMode: Image.PreserveAspectFit
                }
                radius: 5
            }
        }
        Button{
            checkable: true
            Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
            Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100

            background: Rectangle{
                color: parent.checked? "#3d71d7":"transparent"
                Image {
                    anchors.fill: parent
                    anchors.margins: 5
                    source: "/res/ales/waypoint/StarLocation.svg"
                    fillMode: Image.PreserveAspectFit
                }
                radius: 5
            }
        }
        Button{
            checkable: true
            Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
            Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100

            background: Rectangle{
                color: parent.checked? "#3d71d7":"transparent"
                Image {
                    anchors.fill: parent
                    anchors.margins: 5
                    source: "/res/ales/waypoint/Capture.svg"
                    fillMode: Image.PreserveAspectFit
                }
                radius: 5
            }
        }

        ToolSeparator{

        }

        Button{
            checkable: true
            Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
            Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100

            background: Rectangle{
                color: parent.checked? "#3d71d7":"transparent"
                Image {
                    anchors.fill: parent
                    anchors.margins: 5
                    source: "/res/ales/waypoint/Switch.svg"
                    fillMode: Image.PreserveAspectFit
                }
                radius: 5
            }
        }
        Button{
            checkable: true
            Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
            Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100

            background: Rectangle{
                color: parent.checked? "#3d71d7":"transparent"
                Image {
                    anchors.fill: parent
                    anchors.margins: 5
                    source: "/res/ales/waypoint/Delete.svg"
                    fillMode: Image.PreserveAspectFit
                }
                radius: 5
            }
        }
        Button{
            checkable: true
            Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
            Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100

            background: Rectangle{
                color: parent.checked? "#3d71d7":"transparent"
                Image {
                    anchors.fill: parent
                    anchors.margins: 5
                    source: "/res/ales/waypoint/Save.svg"
                    fillMode: Image.PreserveAspectFit
                }
                radius: 5
            }
        }
        Button{
            checkable: true
            Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
            Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100

            background: Rectangle{
                color: parent.checked? "#3d71d7":"transparent"
                Image {
                    anchors.fill: parent
                    anchors.margins: 5
                    source: "/res/ales/waypoint/Rename.svg"
                    fillMode: Image.PreserveAspectFit
                }
                radius: 5
            }
        }
    }
}

