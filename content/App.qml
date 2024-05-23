import QtQuick 6.5
import QtQuick.Controls 6.5
import Flydynamics2uidesigner

Window {
    width: Constants.width
    height: Constants.height

    visible: true
    minimumHeight: 700
    minimumWidth: 1000

    SwipeView {
        id: swipeView
        anchors.top: tabBar.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        currentIndex: tabBar.currentIndex

        ScreenLogin {
            onMissionClicked: tabBar.currentIndex = 1
        }

        MissionSelection {
            onPoiCLicked: tabBar.currentIndex = 2
        }

        POI {
        }
    }

    TabBar {
        anchors.left: parent.left
        anchors.right: parent.right

        id: tabBar
        currentIndex: swipeView.currentIndex

        TabButton {
            text: qsTr("Login")
        }
        TabButton {
            text: qsTr("Menu")
        }

        TabButton {
            text: qsTr("POI")
        }
    }
}
