import QtQuick 2.15

BigButtonForm {
    signal buttonClicked
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            parent.buttonClicked()
        }
    }
}
