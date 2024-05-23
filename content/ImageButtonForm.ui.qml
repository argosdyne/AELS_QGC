
/*
This is a UI file (.ui.qml) that is intended to be edited in Qt Design Studio only.
It is supposed to be strictly declarative and only uses a subset of QML. If you edit
this file manually, you might introduce QML code that is not supported by Qt Design Studio.
Check out https://doc.qt.io/qtcreator/creator-quick-ui-forms.html for details on .ui.qml files.
*/
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts
import Flydynamics2uidesigner

Item {
    id: root
    implicitHeight: 50
    implicitWidth: 150

    property alias btnLabelText: btnLabel.text
    property alias btnImageSource: btnImage.source
    property alias backgroundColor: rectangle.color

    Rectangle {
        id: rectangle
        color: "#373535"
        anchors.fill: parent

        Row {
            id: rowLayout
            anchors.centerIn: parent
            spacing: 10

            Image {
                id: btnImage
                Layout.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/qtquickplugin/images/template_image.png"
                sourceSize.height: rectangle.height * 0.6
                sourceSize.width: rectangle.height * 0.6
                fillMode: Image.Stretch
            }

            Text {
                id: btnLabel
                text: qsTr("Text")
                color: Constants.btnTextColor
                font.pixelSize: Constants.btnFontsize
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            }
        }
    }
}
