import QtQuick 2.15
import Flydynamics2uidesigner

MissionSelectionForm {
    signal poiCLicked
    signal hoppingPoiClicked

    btnPOI.onButtonClicked:{
        poiCLicked()
    }

    btnHoppingPOI.onButtonClicked: {
        hoppingPoiClicked()
    }
}
