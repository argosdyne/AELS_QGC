import QtQuick 2.15
import Flydynamics2uidesigner

ImageButtonForm {
    backgroundColor: Constants.btnBackgroundColor
    signal buttonClicked
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            parent.buttonClicked()
        }
    }
}
