

/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick 2.15
import QtQuick.Controls 2.15
import Flydynamics2uidesigner

Item {
    id: root
    width: 200
    height: 100
    property alias btnLabelText: btnLabel.text
    property alias btnImageSource: btnImage.source
    property alias backgroundColor: rectangle.color

    Rectangle {
        id: rectangle
        color: "#373535"
        anchors.fill: parent
        radius: 10
        Image {
            id: btnImage
            height: root.height * 0.3
            width: root.height * 0.3
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 10
            source: "qrc:/qtquickplugin/images/template_image.png"
            fillMode: Image.PreserveAspectFit
        }

        Text {
            id: btnLabel
            height: root.height / 3
            width: root.width - 20
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.margins: 10
            color: Constants.btnTextColor
            font.pixelSize: 24
            text: qsTr("Text")
        }
    }
}
