import QtQuick          2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts  1.11
import QtQuick.Dialogs  1.3
import QtQuick.Window 2.0

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.Palette               1.0
import QGroundControl.ScreenTools           1.0

Item {
    id: root
    implicitWidth: ScreenTools.width
    implicitHeight:  ScreenTools.height
    
    signal exitWaypointMission()



    MissionWaypointInformation{
        width: 400
        height: 80
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: ScreenTools.toolbarHeight
        anchors.rightMargin: 30

    }


    MissionControlBar{
        id: barMissionControl
        width: root.width/1.5 < 800? 800: root.width/1.5
        height: 80
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 40
        anchors.horizontalCenter: parent.horizontalCenter
        btnCurrentWaypoint.onClicked: {
            barMissionControl.visible = false
            barWaypointStatus.visible = true
        }

    }

    MissionFlyReadyButton{
        width: 100
        height: 100
        visible: barMissionControl.visible
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: 30
    }

    WaypointStatus{
        id:barWaypointStatus
        width: root.width/1.3 < 850? 850: root.width/1.3
        height: 80
        visible: false
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        btnStop.onClicked: {
            barWaypointStatus.visible = false
            barMissionControl.visible = true
        }
        btnExit.onClicked: {
            exitWaypointMission()
        }

    }

    AltitudeBar{
        visible: barWaypointStatus.btnAltitude.checked
        width: root.width/1.4
        height: 80
        anchors.bottom: barWaypointStatus.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 0

    }

    SpeedSlider{
        visible: barWaypointStatus.btnSpeed.checked
        width: root.width/1.4
        height: 80
        anchors.bottom: barWaypointStatus.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 0
    }

    TurningRadiusSlider{
        visible: barWaypointStatus.btnTurningRadius.checked
        width: root.width/1.4
        height: 80
        anchors.bottom: barWaypointStatus.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 0
    }

    LatitudeLongitudeInput{
        visible: barWaypointStatus.btnLongLat.checked
        width: 300
        height: 220
        anchors.bottom: barWaypointStatus.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 0

    }

    ActionInput{
        visible: barWaypointStatus.btnAction.checked
        width: root.width/1.4
        height: root.height/1.4
        anchors.bottom: barWaypointStatus.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottomMargin: 0
    }

}
