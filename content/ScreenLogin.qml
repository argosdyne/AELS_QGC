import QtQuick 2.15
import Flydynamics2uidesigner

ScreenLoginForm {
    id: root
    signal cameraClicked
    signal missionClicked

    btnCamera.onButtonClicked: {
        root.cameraClicked()
    }

    btnMission.onButtonClicked: {
        root.missionClicked()
    }

}
