import QtQuick 2.15
import Flydynamics2uidesigner
POIForm {
    id: root
    signal setPoiClicked
    signal setRouteClicked

    btnSetPoi.onClicked: {
        root.setPoiClicked()
        btnSetCheckpointVisible=true
        btnGroupBottomVisible = false
        btnCameraSettingVisible = false
        routeStatusVisible = false
        cameraAngleGroupVisible = false
        barDirectionAndSpeedVisible = false


    }

    btnSetRoute.onClicked: {
        root.setRouteClicked()
        btnCameraSettingVisible = true
        btnGroupBottomVisible = false
        routeStatusVisible = true
        cameraAngleGroupVisible = true
        barDirectionAndSpeedVisible = true
    }

    btnSetCheckpoint.onClicked: {
        btnSetCheckpointVisible=false
        btnGroupBottomVisible = true
        btnCameraSettingVisible = false
    }

    btnExit.onClicked:  {
        btnSetCheckpointVisible=false
        btnGroupBottomVisible = true
        btnCameraSettingVisible = false
        routeStatusVisible = false
        cameraAngleGroupVisible = false
        barDirectionAndSpeedVisible = false
    }

    btnDelete.onClicked: {
        resetMissionVisible = true

    }

    btnResetYES.onClicked: {
        resetMissionVisible = false
    }

    btnResetNO.onClicked: {
        resetMissionVisible = false
    }

    btnSave.onClicked: {

        saveMissionVisible = true

    }

    btnSaveYES.onClicked: {
        saveMissionVisible = false
    }

    btnSaveNO.onClicked: {
        saveMissionVisible = false
    }


    btnRename.onClicked: {
        renameMissionVisible = true
    }


    btnRenameYES.onClicked: {
        renameMissionVisible = false
    }

    btnRenameNO.onClicked: {
        renameMissionVisible = false
    }

    sliderCameraAngle.onValueChanged: {
        gimbalPitch = sliderCameraAngle.value
    }

    sliderDirectionAndSpeed.onValueChanged: {
        var mSpeed = sliderDirectionAndSpeed.value
        var dir = "Left"
        if(mSpeed> 0){
            dir = "Right"
        }
        directionAndSpeed =dir+"-"+Math.abs(mSpeed)
    }

}
