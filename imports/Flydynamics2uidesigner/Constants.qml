pragma Singleton
import QtQuick 6.5
import QtQuick.Studio.Application

QtObject {
    readonly property int width: 1596
    readonly property int height: 950
    readonly property color btnBackgroundColor: "#4DD9D9D9"
    readonly property color btnTextColor: "white"
    readonly property int btnFontsize: 30

    // The point and pixel font size values are computed at runtime

    property real defaultFontPointSize:     10
    property real platformFontPointSize:    10

    /// You can use this property to position ui elements in a screen resolution independent manner. Using fixed positioning values should not
    /// be done. All positioning should be done using anchors or a ratio of the defaultFontPixelHeight and defaultFontPixelWidth values. This way
    /// your ui elements will reposition themselves appropriately on varying screen sizes and resolutions.
    property real defaultFontPixelHeight:   10

    /// You can use this property to position ui elements in a screen resolution independent manner. Using fixed positioning values should not
    /// be done. All positioning should be done using anchors or a ratio of the defaultFontPixelHeight and defaultFontPixelWidth values. This way
    /// your ui elements will reposition themselves appropriately on varying screen sizes and resolutions.
    property real defaultFontPixelWidth:    10

    /// QFontMetrics::descent for default font at default point size
    property real defaultFontDescent:       0

    property string relativeFontDirectory: "fonts"

    /* Edit this comment to add your custom font */
    readonly property font font: Qt.font({
                                             family: Qt.application.font.family,
                                             pixelSize: Qt.application.font.pixelSize
                                         })
    readonly property font largeFont: Qt.font({
                                                  family: Qt.application.font.family,
                                                  pixelSize: Qt.application.font.pixelSize * 1.6
                                              })
    readonly property font superLargeFont: Qt.font({
                                                  family: Qt.application.font.family,
                                                  pixelSize: Qt.application.font.pixelSize * 4
                                              })
    readonly property color backgroundColor: "#000000"


    property StudioApplication application: StudioApplication {
        fontPath: Qt.resolvedUrl("../../content/" + relativeFontDirectory)
    }
}
