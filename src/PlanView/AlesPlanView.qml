﻿/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick          2.3
import QtQuick.Controls 2.4
import QtQuick.Dialogs  1.2
import QtLocation       5.3
import QtPositioning    5.3
import QtQuick.Layouts  1.2
import QtQuick.Window   2.2

import QGroundControl                   1.0
import QGroundControl.FlightMap         1.0
import QGroundControl.ScreenTools       1.0
import QGroundControl.Controls          1.0
import QGroundControl.FactSystem        1.0
import QGroundControl.FactControls      1.0
import QGroundControl.Palette           1.0
import QGroundControl.Controllers       1.0
import QGroundControl.ShapeFileHelper   1.0
import QGroundControl.Airspace          1.0
import QGroundControl.Airmap            1.0
import QGroundControl.FlightDisplay 1.0

Item {
    id: _root

    property bool planControlColapsed: false
    signal returnToPrevious()
    signal notifyMoveToWaypointMission()

    readonly property int   _decimalPlaces:             8
    readonly property real  _margin:                    ScreenTools.defaultFontPixelHeight * 0.5
    readonly property real  _toolsMargin:               ScreenTools.defaultFontPixelWidth * 0.75
    readonly property real  _radius:                    ScreenTools.defaultFontPixelWidth  * 0.5
    readonly property real  _rightPanelWidth:           Math.min(parent.width / 3, ScreenTools.defaultFontPixelWidth * 30)
    readonly property var   _defaultVehicleCoordinate:  QtPositioning.coordinate(37.803784, -122.462276)
    readonly property bool  _waypointsOnlyMode:         QGroundControl.corePlugin.options.missionWaypointsOnly

    property bool   _airspaceEnabled:                    QGroundControl.airmapSupported ? (QGroundControl.settingsManager.airMapSettings.enableAirMap.rawValue && QGroundControl.airspaceManager.connected): false
    property var    _missionController:                 _planMasterController.missionController
    property var    _geoFenceController:                _planMasterController.geoFenceController
    property var    _rallyPointController:              _planMasterController.rallyPointController
    property var    _visualItems:                       _missionController.visualItems
    property bool   _lightWidgetBorders:                editorMap.isSatelliteMap
    property bool   _addROIOnClick:                     false
    property bool   _singleComplexItem:                 _missionController.complexMissionItemNames.length === 1
    property int    _editingLayer:                      1//layerTabBar.currentIndex ? _layers[layerTabBar.currentIndex] : _layerMission
    property var    _appSettings:                       QGroundControl.settingsManager.appSettings
    property var    _planViewSettings:                  QGroundControl.settingsManager.planViewSettings
    property bool   _promptForPlanUsageShowing:         false

    readonly property var       _layers:                [_layerMission, _layerGeoFence, _layerRallyPoints]

    readonly property int       _layerMission:              1
    readonly property int       _layerGeoFence:             2
    readonly property int       _layerRallyPoints:          3
    readonly property string    _armedVehicleUploadPrompt:  qsTr("Vehicle is currently armed. Do you want to upload the mission to the vehicle?")
    // Overlay for the map
    property bool   _mainWindowIsMap:       editorMap.pipState.state === editorMap.pipState.fullState
    property bool   _isFullWindowItemDark:  _mainWindowIsMap ? editorMap.isSatelliteMap : true
    property real   _fullItemZorder:    0
    property real   _pipItemZorder:     QGroundControl.zOrderWidgets
    property var    _activeVehicle:         QGroundControl.multiVehicleManager.activeVehicle
    // ----
    property int  txtFontSize: ScreenTools.defaultFontPixelHeight/16*16
    function showNotificationBox(){
        notification.item.itemvisible = true
    }

    function mapCenter() {
        var coordinate = editorMap.center
        coordinate.latitude  = coordinate.latitude.toFixed(_decimalPlaces)
        coordinate.longitude = coordinate.longitude.toFixed(_decimalPlaces)
        coordinate.altitude  = coordinate.altitude.toFixed(_decimalPlaces)
        return coordinate
    }


    function createNewMission(){
        newMissionSetting.visible = true
        mapLocationSettings.visible = false
        searchBar.visible = false
        btnBack.visible = false
        createProject.visible = false
        
    }
    
    function _mapCenter() {
        var centerPoint = Qt.point(editorMap.centerViewport.left + (editorMap.centerViewport.width / 2), editorMap.centerViewport.top + (editorMap.centerViewport.height / 2))
        return editorMap.toCoordinate(centerPoint, false /* clipToViewPort */)
    }

    function moveToWaypointMission(){
        newMissionSetting.visible = false
        mapLocationSettings.visible = false
        searchBar.visible = false
        btnBack.visible = false
        createProject.visible = false
        pageWaypointMission.visible = true

        notifyMoveToWaypointMission()        
        toolbar.visible = toolbar.waypointMissionToolbar               
    }

    function cancelCreateNewMission(){
        newMissionSetting.visible = false
        mapLocationSettings.visible = true
        searchBar.visible = true
        btnBack.visible = true
        createProject.visible = true
    }

    function exitWaypointMissionUI(){
        newMissionSetting.visible = false
        mapLocationSettings.visible = true
        searchBar.visible = true
        btnBack.visible = true
        createProject.visible = true
        pageWaypointMission.visible = false
        notification.item.itemvisible = false
    }

    function updateAirspace(reset) {
        if(_airspaceEnabled) {
            var coordinateNW = editorMap.toCoordinate(Qt.point(0,0), false /* clipToViewPort */)
            var coordinateSE = editorMap.toCoordinate(Qt.point(width,height), false /* clipToViewPort */)
            if(coordinateNW.isValid && coordinateSE.isValid) {
                QGroundControl.airspaceManager.setROI(coordinateNW, coordinateSE, true /*planView*/, reset)
            }
        }
    }

    property bool _firstMissionLoadComplete:    false
    property bool _firstFenceLoadComplete:      false
    property bool _firstRallyLoadComplete:      false
    property bool _firstLoadComplete:           false

    MapFitFunctions {
        id:                         mapFitFunctions  // The name for this id cannot be changed without breaking references outside of this code. Beware!
        map:                        editorMap
        usePlannedHomePosition:     true
        planMasterController:       _planMasterController
    }

    on_AirspaceEnabledChanged: {
        if(QGroundControl.airmapSupported) {
            if(_airspaceEnabled) {
                planControlColapsed = QGroundControl.airspaceManager.airspaceVisible
                updateAirspace(true)
            } else {
                planControlColapsed = false
            }
        } else {
            planControlColapsed = false
        }
    }

    onVisibleChanged: {
        if(visible) {
            editorMap.zoomLevel = QGroundControl.flightMapZoom
            editorMap.center    = QGroundControl.flightMapPosition
            if (!_planMasterController.containsItems) {
                // toolStrip.simulateClick(toolStrip.fileButtonIndex)
            }
        }
    }

    Connections {
        target: _appSettings ? _appSettings.defaultMissionItemAltitude : null
        function onRawValueChanged() {
            if (_visualItems.count > 1) {
                mainWindow.showComponentDialog(applyNewAltitude, qsTr("Apply new altitude"), mainWindow.showDialogDefaultWidth, StandardButton.Yes | StandardButton.No)
            }
        }
    }

    Component {
        id: applyNewAltitude
        QGCViewMessage {
            message:    qsTr("You have changed the default altitude for mission items. Would you like to apply that altitude to all the items in the current mission?")
            function accept() {
                hideDialog()
                _missionController.applyDefaultMissionAltitude()
            }
        }
    }

    Component {
        id: promptForPlanUsageOnVehicleChangePopupComponent
        QGCPopupDialog {
            title:      _planMasterController.managerVehicle.isOfflineEditingVehicle ? qsTr("Plan View - Vehicle Disconnected") : qsTr("Plan View - Vehicle Changed")
            buttons:    StandardButton.NoButton

            ColumnLayout {
                QGCLabel {
                    Layout.maximumWidth:    parent.width
                    wrapMode:               QGCLabel.WordWrap
                    text:                   _planMasterController.managerVehicle.isOfflineEditingVehicle ?
                                                qsTr("The vehicle associated with the plan in the Plan View is no longer available. What would you like to do with that plan?") :
                                                qsTr("The plan being worked on in the Plan View is not from the current vehicle. What would you like to do with that plan?")
                }

                QGCButton {
                    Layout.fillWidth:   true
                    text:               _planMasterController.dirty ?
                                            (_planMasterController.managerVehicle.isOfflineEditingVehicle ?
                                                 qsTr("Discard Unsaved Changes") :
                                                 qsTr("Discard Unsaved Changes, Load New Plan From Vehicle")) :
                                            qsTr("Load New Plan From Vehicle")
                    onClicked: {
                        _planMasterController.showPlanFromManagerVehicle()
                        _promptForPlanUsageShowing = false
                        hideDialog();
                    }
                }

                QGCButton {
                    Layout.fillWidth:   true
                    text:               _planMasterController.managerVehicle.isOfflineEditingVehicle ?
                                            qsTr("Keep Current Plan") :
                                            qsTr("Keep Current Plan, Don't Update From Vehicle")
                    onClicked: {
                        if (!_planMasterController.managerVehicle.isOfflineEditingVehicle) {
                            _planMasterController.dirty = true
                        }
                        _promptForPlanUsageShowing = false
                        hideDialog()
                    }
                }
            }
        }
    }


    Component {
        id: firmwareOrVehicleMismatchUploadDialogComponent
        QGCViewMessage {
            message: qsTr("This Plan was created for a different firmware or vehicle type than the firmware/vehicle type of vehicle you are uploading to. " +
                          "This can lead to errors or incorrect behavior. " +
                          "It is recommended to recreate the Plan for the correct firmware/vehicle type.\n\n" +
                          "Click 'Ok' to upload the Plan anyway.")

            function accept() {
                _planMasterController.sendToVehicle()
                hideDialog()
            }
        }
    }

    Connections {
        target: QGroundControl.airspaceManager
        function onAirspaceVisibleChanged() {
            planControlColapsed = QGroundControl.airspaceManager.airspaceVisible
        }
    }

    Component {
        id: noItemForKML
        QGCViewMessage {
            message:    qsTr("You need at least one item to create a KML.")
        }
    }

    PlanMasterController {
        id:         _planMasterController
        flyView:    false

        Component.onCompleted: {
            _planMasterController.start()
            _missionController.setCurrentPlanViewSeqNum(0, true)
            globals.planMasterControllerPlanView = _planMasterController
        }

        onPromptForPlanUsageOnVehicleChange: {
            if (!_promptForPlanUsageShowing) {
                _promptForPlanUsageShowing = true
                mainWindow.showPopupDialogFromComponent(promptForPlanUsageOnVehicleChangePopupComponent)
            }
        }

        function waitingOnIncompleteDataMessage(save) {
            var saveOrUpload = save ? qsTr("Save") : qsTr("Upload")
            mainWindow.showMessageDialog(qsTr("Unable to %1").arg(saveOrUpload), qsTr("Plan has incomplete items. Complete all items and %1 again.").arg(saveOrUpload))
        }

        function waitingOnTerrainDataMessage(save) {
            var saveOrUpload = save ? qsTr("Save") : qsTr("Upload")
            mainWindow.showMessageDialog(qsTr("Unable to %1").arg(saveOrUpload), qsTr("Plan is waiting on terrain data from server for correct altitude values."))
        }

        function checkReadyForSaveUpload(save) {
            if (readyForSaveState() == VisualMissionItem.NotReadyForSaveData) {
                waitingOnIncompleteDataMessage(save)
                return false
            } else if (readyForSaveState() == VisualMissionItem.NotReadyForSaveTerrain) {
                waitingOnTerrainDataMessage(save)
                return false
            }
            return true
        }

        function upload() {
            if (!checkReadyForSaveUpload(false /* save */)) {
                return
            }
            switch (_missionController.sendToVehiclePreCheck()) {
            case MissionController.SendToVehiclePreCheckStateOk:
                sendToVehicle()
                break
            case MissionController.SendToVehiclePreCheckStateActiveMission:
                mainWindow.showMessageDialog(qsTr("Send To Vehicle"), qsTr("Current mission must be paused prior to uploading a new Plan"))
                break
            case MissionController.SendToVehiclePreCheckStateFirwmareVehicleMismatch:
                mainWindow.showComponentDialog(firmwareOrVehicleMismatchUploadDialogComponent, qsTr("Plan Upload"), mainWindow.showDialogDefaultWidth, StandardButton.Ok | StandardButton.Cancel)
                break
            }
        }

        function loadFromSelectedFile() {
            fileDialog.title =          qsTr("Select Plan File")
            fileDialog.planFiles =      true
            fileDialog.selectExisting = true
            fileDialog.nameFilters =    _planMasterController.loadNameFilters
            fileDialog.openForLoad()
        }

        function saveToSelectedFile() {
            if (!checkReadyForSaveUpload(true /* save */)) {
                return
            }
            fileDialog.title =          qsTr("Save Plan")
            fileDialog.planFiles =      true
            fileDialog.selectExisting = false
            fileDialog.nameFilters =    _planMasterController.saveNameFilters
            fileDialog.openForSave()
        }

        function fitViewportToItems() {
            mapFitFunctions.fitMapViewportToMissionItems()
        }

        function saveKmlToSelectedFile() {
            if (!checkReadyForSaveUpload(true /* save */)) {
                return
            }
            fileDialog.title =          qsTr("Save KML")
            fileDialog.planFiles =      false
            fileDialog.selectExisting = false
            fileDialog.nameFilters =    ShapeFileHelper.fileDialogKMLFilters
            fileDialog.openForSave()
        }
    }

    Connections {
        target: _missionController

        function onNewItemsFromVehicle() {
            if (_visualItems && _visualItems.count !== 1) {
                mapFitFunctions.fitMapViewportToMissionItems()
            }
            _missionController.setCurrentPlanViewSeqNum(0, true)
        }
    }

    function insertSimpleItemAfterCurrent(coordinate) {
        var nextIndex = _missionController.currentPlanViewVIIndex + 1
        _missionController.insertSimpleMissionItem(coordinate, nextIndex, true /* makeCurrentItem */)
    }

    function insertROIAfterCurrent(coordinate) {
        var nextIndex = _missionController.currentPlanViewVIIndex + 1
        _missionController.insertROIMissionItem(coordinate, nextIndex, true /* makeCurrentItem */)
    }

    function insertCancelROIAfterCurrent() {
        var nextIndex = _missionController.currentPlanViewVIIndex + 1
        _missionController.insertCancelROIMissionItem(nextIndex, true /* makeCurrentItem */)
    }

    function insertComplexItemAfterCurrent(complexItemName) {
        var nextIndex = _missionController.currentPlanViewVIIndex + 1
        _missionController.insertComplexMissionItem(complexItemName, mapCenter(), nextIndex, true /* makeCurrentItem */)
    }

    function insertTakeItemAfterCurrent() {
        var nextIndex = _missionController.currentPlanViewVIIndex + 1
        _missionController.insertTakeoffItem(mapCenter(), nextIndex, true /* makeCurrentItem */)
    }

    function insertLandItemAfterCurrent() {
        var nextIndex = _missionController.currentPlanViewVIIndex + 1
        _missionController.insertLandItem(mapCenter(), nextIndex, true /* makeCurrentItem */)
    }


    function selectNextNotReady() {
        var foundCurrent = false
        for (var i=0; i<_missionController.visualItems.count; i++) {
            var vmi = _missionController.visualItems.get(i)
            if (vmi.readyForSaveState === VisualMissionItem.NotReadyForSaveData) {
                _missionController.setCurrentPlanViewSeqNum(vmi.sequenceNumber, true)
                break
            }
        }
    }

    property int _moveDialogMissionItemIndex

    QGCFileDialog {
        id:             fileDialog
        folder:         _appSettings ? _appSettings.missionSavePath : ""

        property bool planFiles: true    ///< true: working with plan files, false: working with kml file

        onAcceptedForSave: {
            if (planFiles) {
                _planMasterController.saveToFile(file)
            } else {
                _planMasterController.saveToKml(file)
            }
            close()
        }

        onAcceptedForLoad: {
            _planMasterController.loadFromFile(file)
            _planMasterController.fitViewportToItems()
            _missionController.setCurrentPlanViewSeqNum(0, true)
            close()
        }
    }

    Component {
        id: moveDialog
        QGCViewDialog {
            function accept() {
                var toIndex = toCombo.currentIndex
                if (toIndex === 0) {
                    toIndex = 1
                }
                _missionController.moveMissionItem(_moveDialogMissionItemIndex, toIndex)
                hideDialog()
            }
            Column {
                anchors.left:   parent.left
                anchors.right:  parent.right
                spacing:        ScreenTools.defaultFontPixelHeight

                QGCLabel {
                    anchors.left:   parent.left
                    anchors.right:  parent.right
                    wrapMode:       Text.WordWrap
                    text:           qsTr("Move the selected mission item to the be after following mission item:")
                }

                QGCComboBox {
                    id:             toCombo
                    model:          _visualItems.count
                    currentIndex:   _moveDialogMissionItemIndex
                }
            }
        }
    }

    Item {
        id:             panel
        anchors.fill:   parent

        QGCToolInsets {
            id:                     _toolInsets
            leftEdgeBottomInset:    _pipOverlay.visible ? _pipOverlay.x + _pipOverlay.width : 0
            bottomEdgeLeftInset:    _pipOverlay.visible ? parent.height - _pipOverlay.y : 0
        }

        AlesPlanViewMap {
            id:                     editorMap // mapControl
            property real _leftToolWidth:       0// toolStrip.x + toolStrip.width
            property real _rightToolWidth:      0 // rightPanel.width + rightPanel.anchors.rightMargin
            property rect centerViewport:   Qt.rect(_leftToolWidth + _margin,  _margin, editorMap.width - _leftToolWidth - _rightToolWidth - (_margin * 2), (terrainStatus.visible ? terrainStatus.y : height - _margin) - _margin)

            mapName:                    "MissionEditor"
            allowGCSLocationCenter:     true
            allowVehicleLocationCenter: true
            planView:                   true

            zoomLevel:                  QGroundControl.flightMapZoom
            center:                     QGroundControl.flightMapPosition



            planMasterController:   _planMasterController
            rightPanelWidth:        ScreenTools.defaultFontPixelHeight * 9
            pipMode:                !_mainWindowIsMap
            toolInsets:             _toolInsets
                // Handle guided mode clicks
            MouseArea {
                anchors.fill: parent
                acceptedButtons:  Qt.RightButton | Qt.LeftButton

                QGCMenu {
                    id: clickMenu
                    property var coord
                    property string coordinate: coord ? coord.latitude + ", " + coord.longitude + ", " + coord.altitude : ""
                    QGCMenuItem {
                        text:          addWaypointRallyPointAction.checked?  qsTr("Finish Waypoint"): qsTr("Add waypoint") 
                        visible:        true   //globals.guidedControllerFlyView.showGotoLocation
                        onTriggered: {
                            addWaypointRallyPointAction.checked = !addWaypointRallyPointAction.checked
                        }
                    }
                    QGCMenuItem {
                        text:           qsTr("Return")
                        visible:        true//globals.guidedControllerFlyView.showROI

                        onTriggered: {
                            toolStrip.allAddClickBoolsOff()
                            insertLandItemAfterCurrent()
                        }
                    }
                }

                onClicked: {
                    if (mouse.button === Qt.RightButton) {
                        var clickCoord = editorMap.toCoordinate(Qt.point(mouse.x, mouse.y), false /* clipToViewPort */)
                        clickCoord.latitude = clickCoord.latitude.toFixed(_decimalPlaces)
                        clickCoord.longitude = clickCoord.longitude.toFixed(_decimalPlaces)
                        clickCoord.altitude = clickCoord.altitude.toFixed(_decimalPlaces)
                        clickMenu.coord = clickCoord

                        clickMenu.popup()
                    // if (!globals.guidedControllerFlyView.guidedUIVisible && (globals.guidedControllerFlyView.showGotoLocation || globals.guidedControllerFlyView.showOrbit || globals.guidedControllerFlyView.showROI)) {
                    //     orbitMapCircle.hide()
                    //     gotoLocationItem.hide()
                    //     var clickCoord = _root.toCoordinate(Qt.point(mouse.x, mouse.y), false /* clipToViewPort */)
                    //     clickMenu.coord = clickCoord
                    //     clickMenu.popup()
                    // }
                    } else{
                        editorMap.focus = true
                        var coordinate = editorMap.toCoordinate(Qt.point(mouse.x, mouse.y), false /* clipToViewPort */)
                        coordinate.latitude = coordinate.latitude.toFixed(_decimalPlaces)
                        coordinate.longitude = coordinate.longitude.toFixed(_decimalPlaces)
                        coordinate.altitude = coordinate.altitude.toFixed(_decimalPlaces)
                        if (addWaypointRallyPointAction.checked) {
                            insertSimpleItemAfterCurrent(coordinate)
                        }
                    }

                }
            }

            // Add the mission item visuals to the map
            Repeater {
                model: _missionController.visualItems
                delegate: MissionItemMapVisual {
                    map:         editorMap
                    onClicked:   _missionController.setCurrentPlanViewSeqNum(sequenceNumber, false)
                    opacity:     _editingLayer == _layerMission ? 1 : editorMap._nonInteractiveOpacity
                    interactive: _editingLayer == _layerMission
                    vehicle:     _planMasterController.controllerVehicle
                }
            }

            // Add lines between waypoints
            MissionLineView {
                showSpecialVisual:  _missionController.isROIBeginCurrentItem
                model:              _missionController.simpleFlightPathSegments
                opacity:            _editingLayer == _layerMission ? 1 : editorMap._nonInteractiveOpacity
            }

            // Direction arrows in waypoint lines
            MapItemView {
                model: _editingLayer == _layerMission ? _missionController.directionArrows : undefined

                delegate: MapLineArrow {
                    fromCoord:      object ? object.coordinate1 : undefined
                    toCoord:        object ? object.coordinate2 : undefined
                    arrowPosition:  3
                    z:              QGroundControl.zOrderWaypointLines + 1
                }
            }

            // Incomplete segment lines
            MapItemView {
                model: _missionController.incompleteComplexItemLines

                delegate: MapPolyline {
                    path:       [ object.coordinate1, object.coordinate2 ]
                    line.width: 1
                    line.color: "red"
                    z:          QGroundControl.zOrderWaypointLines
                    opacity:    _editingLayer == _layerMission ? 1 : editorMap._nonInteractiveOpacity
                }
            }

            // UI for splitting the current segment
            MapQuickItem {
                id:             splitSegmentItem
                anchorPoint.x:  sourceItem.width / 2
                anchorPoint.y:  sourceItem.height / 2
                z:              QGroundControl.zOrderWaypointLines + 1
                visible:        _editingLayer == _layerMission

                sourceItem: SplitIndicator {
                    onClicked:  _missionController.insertSimpleMissionItem(splitSegmentItem.coordinate,
                                                                           _missionController.currentPlanViewVIIndex,
                                                                           true /* makeCurrentItem */)
                }

                function _updateSplitCoord() {
                    if (_missionController.splitSegment) {
                        var distance = _missionController.splitSegment.coordinate1.distanceTo(_missionController.splitSegment.coordinate2)
                        var azimuth = _missionController.splitSegment.coordinate1.azimuthTo(_missionController.splitSegment.coordinate2)
                        splitSegmentItem.coordinate = _missionController.splitSegment.coordinate1.atDistanceAndAzimuth(distance / 2, azimuth)
                    } else {
                        coordinate = QtPositioning.coordinate()
                    }
                }

                Connections {
                    target:                 _missionController
                    function onSplitSegmentChanged()  { splitSegmentItem._updateSplitCoord() }
                }

                Connections {
                    target:                 _missionController.splitSegment
                    function onCoordinate1Changed()   { splitSegmentItem._updateSplitCoord() }
                    function onCoordinate2Changed()   { splitSegmentItem._updateSplitCoord() }
                }
            }

            // Add the vehicles to the map
            MapItemView {
                model: QGroundControl.multiVehicleManager.vehicles
                delegate: VehicleMapItem {
                    vehicle:        object
                    coordinate:     object.coordinate
                    map:            editorMap
                    size:           ScreenTools.defaultFontPixelHeight * 3
                    z:              QGroundControl.zOrderMapItems - 1
                }
            }

            GeoFenceMapVisuals {
                map:                    editorMap
                myGeoFenceController:   _geoFenceController
                interactive:            _editingLayer == _layerGeoFence
                homePosition:           _missionController.plannedHomePosition
                planView:               true
                opacity:                _editingLayer != _layerGeoFence ? editorMap._nonInteractiveOpacity : 1
            }

            RallyPointMapVisuals {
                map:                    editorMap
                myRallyPointController: _rallyPointController
                interactive:            _editingLayer == _layerRallyPoints
                planView:               true
                opacity:                _editingLayer != _layerRallyPoints ? editorMap._nonInteractiveOpacity : 1
            }

            // Airspace overlap support
            MapItemView {
                model:              _airspaceEnabled && QGroundControl.airspaceManager.airspaceVisible ? QGroundControl.airspaceManager.airspaces.circles : []
                delegate: MapCircle {
                    center:         object.center
                    radius:         object.radius
                    color:          object.color
                    border.color:   object.lineColor
                    border.width:   object.lineWidth
                }
            }

            MapItemView {
                model:              _airspaceEnabled && QGroundControl.airspaceManager.airspaceVisible ? QGroundControl.airspaceManager.airspaces.polygons : []
                delegate: MapPolygon {
                    path:           object.polygon
                    color:          object.color
                    border.color:   object.lineColor
                    border.width:   object.lineWidth
                }
            }

            Item {
                id: createProjectPage

                anchors.fill: parent
                visible: (parent.width > 1000 && parent.height > 500) ? true : false


                Button{
                    id: btnBack
                    width: ScreenTools.defaultFontPixelHeight/16*50
                    height: ScreenTools.defaultFontPixelHeight/16*50
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.leftMargin: ScreenTools.defaultFontPixelHeight*2
                    anchors.topMargin: ScreenTools.defaultFontPixelHeight*2

                    onClicked: {
                        returnToPrevious();
                        notification.item.itemvisible = false
                    }

                    background: Rectangle{
                        color:"white"
                        radius: height//2
                        Image {
                            anchors.fill: parent
                            anchors.margins: 10
                            source: "/res/ales/mission/Back.svg"
                            fillMode: Image.PreserveAspectFit

                        }
                    }
                }


                Rectangle {
                    id: searchBar
                    width: parent.width/2
                    height: ScreenTools.defaultFontPixelHeight/16*50
                    anchors.horizontalCenter:  parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: ScreenTools.defaultFontPixelHeight*2

                    color: "white"
                    radius: 5
                    border.color: "lightgray"

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 5
                        spacing: 10

                        Image {
                            source: "/res/ales/mission/Search.svg" // Path to your search icon
                            Layout.preferredWidth:  parent.height/3*2
                            Layout.preferredHeight: parent.height/3*2
                            Layout.alignment: Qt.AlignVCenter
                            fillMode: Image.PreserveAspectFit
                        }

                        TextField {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            placeholderText: qsTr("Search")
                            background: Rectangle {
                                color: "transparent"
                            }
                        }
                    }
                }


                Item {
                    id: mapLocationSettings
                    width: ScreenTools.defaultFontPixelHeight/16*150
                    height: ScreenTools.defaultFontPixelHeight/16*200
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.rightMargin: ScreenTools.defaultFontPixelHeight*2
                    anchors.topMargin: ScreenTools.defaultFontPixelHeight*2
                    ColumnLayout{
                        spacing: 20

                        Rectangle{
                            id: locationMapSetting
                            color:"transparent"
                            radius: 10
                            Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*320
                            Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100

                            RowLayout {
                                anchors.centerIn: parent
                                Button{
                                    id: btnLocation
                                    checkable: true
                                    checked: false
                                    Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100
                                    Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
                                    background: Rectangle{
                                        color: parent.checked? "#3d71d7": "transparent"
                                        radius: 5
                                        Image {
                                            anchors.fill: parent
                                            anchors.margins: 10
                                            source: "/res/ales/mission/Location.svg"
                                            fillMode: Image.PreserveAspectFit
                                        }
                                    }
                                    onClicked: {
                                        if (!checked) {
                                            return
                                        }

                                        if (btnMapType.checked) {
                                            btnMapType.checked =false
                                        }
                                    }
                                }

                                Button{
                                    id: btnMapType
                                    checkable: true
                                    checked: false
                                    Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100
                                    Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
                                    background: Rectangle{
                                        color: parent.checked? "#3d71d7": "transparent"
                                        radius: 5
                                        Image {
                                            anchors.fill: parent
                                            anchors.margins: 10
                                            source: "/res/ales/mission/Maptype.svg"
                                            fillMode: Image.PreserveAspectFit
                                        }
                                    }
                                    onClicked: {
                                        if (!checked) {
                                            return
                                        }

                                        if (btnLocation.checked) {
                                            btnLocation.checked =false
                                        }
                                    }
                                }
                            }
                        }




                        Rectangle{
                            id: locationMapSettingV1
                            visible: false
                            color:"#484639"
                            radius: 10
                            Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*320
                            Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100

                            RowLayout {
                                anchors.fill: parent
                                Button{
                                    id: position
                                    checkable: true
                                    checked: false
                                    Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100
                                    Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
                                    background: Rectangle{
                                        color: parent.checked? "#3d71d7": "transparent"
                                        radius: 5
                                        Image {
                                            anchors.fill: parent
                                            anchors.margins: 10
                                            source: "/res/ales/waypoint/PositionType.svg"
                                            fillMode: Image.PreserveAspectFit
                                        }
                                    }
                                }

                                Button{
                                    id: centerObject
                                    checkable: true
                                    checked: false
                                    Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100
                                    Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
                                    background: Rectangle{
                                        color: parent.checked? "#3d71d7": "transparent"
                                        radius: 5
                                        Image {
                                            anchors.fill: parent
                                            anchors.margins: 10
                                            source: "/res/ales/waypoint/CenterIn.svg"
                                            fillMode: Image.PreserveAspectFit
                                        }
                                    }
                                }

                                Button{
                                    id: mapType
                                    checkable: true
                                    checked: false
                                    Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100
                                    Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
                                    background: Rectangle{
                                        color: parent.checked? "#3d71d7": "transparent"
                                        radius: 5
                                        Image {
                                            anchors.fill: parent
                                            anchors.margins: 10
                                            source: "/res/ales/mission/Maptype.svg"
                                            fillMode: Image.PreserveAspectFit
                                        }
                                    }
                                }
                            }
                        }

                        Rectangle{
                            id:mapTypeSetting
                            Layout.preferredWidth:ScreenTools.defaultFontPointSize/16*220
                            Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100
                            Layout.alignment: Qt.AlignHCenter
                            color: "white"
                            anchors.margins: 20
                            visible: btnMapType.checked
                            RowLayout{
                                anchors.centerIn: parent
                                spacing: 10

                                Button{
                                    Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100
                                    Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
                                    background: Rectangle{
                                        color:"transparent"
                                        implicitWidth:ScreenTools.defaultFontPointSize/16*100
                                        implicitHeight:ScreenTools.defaultFontPointSize/16*100
                                        Image {
                                            anchors.fill: parent
                                            source: "/res/ales/waypoint/NormalMap.png"
                                            fillMode: Image.PreserveAspectFit
                                        }
                                    }
                                }

                                Button{
                                    Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100
                                    Layout.preferredWidth:ScreenTools.defaultFontPointSize/16*100
                                    background: Rectangle{
                                        color:"transparent"
                                        implicitWidth:ScreenTools.defaultFontPointSize/16*100
                                        implicitHeight:ScreenTools.defaultFontPointSize/16*100
                                        Image {
                                            anchors.fill: parent
                                            source: "/res/ales/waypoint/HybridMap.png"
                                            fillMode: Image.PreserveAspectFit
                                        }
                                    }
                                }

                            }
                        }


                        Rectangle{
                            Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*220
                            Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100
                            Layout.alignment: Qt.AlignHCenter
                            color: "white"
                            visible: btnLocation.checked
                            RowLayout{
                                anchors.centerIn: parent
                                spacing: 10

                                Button{
                                    Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100
                                    Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
                                    background: Rectangle{
                                        color:"transparent"
                                        implicitWidth: ScreenTools.defaultFontPointSize/16*100
                                        implicitHeight: ScreenTools.defaultFontPointSize/16*100
                                        Image {
                                            anchors.fill: parent
                                            source: "/res/ales/waypoint/Melocation.svg"
                                            fillMode: Image.PreserveAspectFit
                                        }
                                    }
                                }

                                Button{
                                    Layout.preferredHeight: ScreenTools.defaultFontPointSize/16*100
                                    Layout.preferredWidth: ScreenTools.defaultFontPointSize/16*100
                                    background: Rectangle{
                                        color:"transparent"
                                        implicitWidth: ScreenTools.defaultFontPointSize/16*100
                                        implicitHeight: ScreenTools.defaultFontPointSize/16*100
                                        Image {
                                            anchors.fill: parent
                                            source: "/res/ales/waypoint/DroneLocation.png"
                                            fillMode: Image.PreserveAspectFit
                                        }
                                    }
                                }

                            }
                        }
                    }

                }

                Rectangle {
                    id: createProject
                    width: ScreenTools.defaultFontPixelHeight * 10
                    height: ScreenTools.defaultFontPixelHeight * 3
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: parent.height/10
                    color: "#cc3D71D7"
                    radius: 5

                    Text {
                        anchors.centerIn: parent
                        text: qsTr("Create Project")
                        color: "white"
                        font.pixelSize: ScreenTools.defaultFontPixelHeight
                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            createNewMission()

                        }
                    }
                }

            }



            TerrainStatus {
                id:                 terrainStatus
                anchors.margins:    _toolsMargin
                anchors.leftMargin: 0
                anchors.left:       mapScale.left
                anchors.right:      parent.right
                anchors.bottom:     parent.bottom
                height:             ScreenTools.defaultFontPixelHeight * 7
                missionController:  _missionController
                visible:            _internalVisible && _editingLayer === _layerMission && QGroundControl.corePlugin.options.showMissionStatus

                onSetCurrentSeqNum: _missionController.setCurrentPlanViewSeqNum(seqNum, true)

                property bool _internalVisible: _planViewSettings.showMissionItemStatus.rawValue

                function toggleVisible() {
                    _internalVisible = !_internalVisible
                    _planViewSettings.showMissionItemStatus.rawValue = _internalVisible
                }
            }

            MapScale {
                id:                     mapScale
                anchors.margins:        _toolsMargin
                anchors.bottom:         terrainStatus.visible ? terrainStatus.top : parent.bottom
                anchors.left:            parent.left
                mapControl:             editorMap
                buttonsOnLeft:          true
                terrainButtonVisible:   _editingLayer === _layerMission
                terrainButtonChecked:   terrainStatus.visible
                onTerrainButtonClicked: terrainStatus.toggleVisible()
            }

            // Mission Setting

            Rectangle {
                id: newMissionSetting
                width: _root.width/3*2
                height: _root.height/4*3
                anchors.centerIn: parent
                visible: false


                color: "#CC3C3737"


                ColumnLayout{
                    anchors.fill: parent
                    spacing: 10
                    Rectangle{
                        Layout.preferredHeight: ScreenTools.defaultFontPixelHeight/16*40
                        Layout.fillWidth: true
                        color: "#cc3B3737"
                        RowLayout {
                            anchors.centerIn: parent
                            Layout.topMargin: 5
                            spacing: 30

                            // Editable TextField
                            TextField {
                                id: textField

                                text: "New Mission 1"
                                readOnly: true
                                Layout.preferredHeight: ScreenTools.defaultFontPixelHeight/16*40
                                Layout.preferredWidth: newMissionSetting.width/3
                                font.pixelSize: ScreenTools.defaultFontPixelHeight/16*25
                                horizontalAlignment: Text.AlignRight
                                color: "white"

                                background: Rectangle {
                                    color: textField.readOnly ? "transparent" : "grey"
                                    border.color: textField.readOnly ? "transparent" : "lightgray"
                                    radius: 5
                                }

                                onAccepted: {
                                    textField.readOnly = true // Disable editing after pressing Enter
                                }

                                // Also handle the case when the TextField loses focus
                                onFocusChanged: if (!textField.focus) textField.readOnly = true
                            }

                            // Edit Button
                            Button {
                                id: editButton
                                // Path to your edit icon
                                background: Rectangle{
                                    color: "transparent"
                                    Image {
                                        anchors.centerIn: parent
                                        source: "/res/ales/mission/Edit.svg"
                                        fillMode: Image.PreserveAspectFit
                                    }
                                }

                                onClicked: {
                                    textField.readOnly = !textField.readOnly
                                    if (!textField.readOnly) {
                                        textField.forceActiveFocus()
                                    }
                                }
                            }
                        }
                    }

                    GridLayout {
                        rowSpacing: 10
                        columnSpacing: 10
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.rightMargin: 20

                        columns: 4
                        RowLayout{
                            BlueCheckButton{
                                Layout.preferredHeight: ScreenTools.defaultFontPixelHeight/16*50

                            }
                            Text{
                                text: "Altitude (10-800)"
                                color: "white"
                                font.pixelSize: txtFontSize
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter

                            }

                        }
                        MissionSettingText{
                            text: "60m"
                            Layout.fillWidth: true
                            Layout.preferredHeight: txtFontSize+20
                            font.pixelSize: txtFontSize

                        }
                        RowLayout{
                            BlueCheckButton{
                                Layout.preferredHeight: ScreenTools.defaultFontPixelHeight/16*50

                            }
                            Text{
                                text: "Speed (4 - 36)"
                                color: "white"
                                font.pixelSize: txtFontSize
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter

                            }

                        }
                        MissionSettingText{
                            text: "18km/h"
                            Layout.fillWidth: true
                            Layout.preferredHeight: txtFontSize+20
                            font.pixelSize: txtFontSize

                        }

                        // Altitude Type
                        RowLayout{
                            BlueCheckButton{
                                Layout.preferredHeight: ScreenTools.defaultFontPixelHeight/16*50

                            }
                            Text{
                                text: "Altitude Type"
                                color: "white"
                                font.pixelSize: txtFontSize
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter

                            }

                        }
                        MissionSettingCombobox{
                            model: ["AGL","MSL"]
                            Layout.fillWidth: true
                            Layout.preferredHeight: txtFontSize+20
                            font.pixelSize: txtFontSize

                        }


                        // Loss Action
                        RowLayout{
                            BlueCheckButton{
                                Layout.preferredHeight: ScreenTools.defaultFontPixelHeight/16*50

                            }
                            Text{
                                text: "Loss Action"
                                color: "white"
                                font.pixelSize: txtFontSize
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter

                            }

                        }
                        MissionSettingCombobox{
                            model: ["Go Home", "Continue Mission"]
                            Layout.fillWidth: true
                            Layout.preferredHeight: txtFontSize+20
                            font.pixelSize: txtFontSize

                        }


                        // Finish Action
                        RowLayout{
                            BlueCheckButton{
                                Layout.preferredHeight: ScreenTools.defaultFontPixelHeight/16*50

                            }
                            Text{
                                text: "Finish Action"
                                color: "white"
                                font.pixelSize: txtFontSize
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter

                            }

                        }
                        MissionSettingCombobox{
                            model: ["Go Home", "Hover"]
                            Layout.fillWidth: true
                            Layout.preferredHeight: txtFontSize+20
                            font.pixelSize: txtFontSize

                        }

                        // Heading
                        RowLayout{
                            BlueCheckButton{
                                Layout.preferredHeight: ScreenTools.defaultFontPixelHeight/16*50

                            }
                            Text{
                                text: "Heading"
                                color: "white"
                                font.pixelSize: txtFontSize
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter

                            }

                        }

                        MissionSettingCombobox{
                            model: ["Route","Manual", "Custom","-"]
                            Layout.fillWidth: true
                            Layout.preferredHeight: txtFontSize+20
                            font.pixelSize: txtFontSize

                        }

                        // Camera Action
                        RowLayout{
                            BlueCheckButton{
                                Layout.preferredHeight: ScreenTools.defaultFontPixelHeight/16*50

                            }
                            Text{
                                text: "Camera Action"
                                color: "white"
                                font.pixelSize: txtFontSize
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter

                            }

                        }

                        MissionSettingCombobox{
                            model: ["Start Recording","Stop Recording","Take Photo","Time Lapase","Dist. Lapse"]
                            Layout.fillWidth: true
                            Layout.preferredHeight: txtFontSize+20
                            font.pixelSize: txtFontSize

                        }

                        RowLayout{
                            BlueCheckButton{
                                Layout.preferredHeight: ScreenTools.defaultFontPixelHeight/16*70

                            }
                            Text{
                                text: "Gimbal Pitch"
                                color: "white"
                                font.pixelSize: txtFontSize
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter

                            }

                        }
                        MissionSettingText{
                            text: "0\xB0"
                            Layout.fillWidth: true
                            Layout.preferredHeight: txtFontSize+20
                            font.pixelSize: txtFontSize

                        }

                        // Weather
                        RowLayout{
                            BlueCheckButton{
                                Layout.preferredHeight: ScreenTools.defaultFontPixelHeight/16*70

                            }
                            Text{
                                text: "Weather"
                                color: "white"
                                font.pixelSize: txtFontSize
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter

                            }

                        }

                        MissionSettingCombobox{
                            model:["Sunny", "Cloudy"]
                            Layout.fillWidth: true
                            Layout.preferredHeight: txtFontSize+20
                            font.pixelSize: txtFontSize

                        }



                    }

                    Rectangle{
                        color: "transparent"
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                    }

                    RowLayout {
                        spacing: 0
                        Layout.fillWidth: true
                        Layout.preferredHeight: 50
                        Button{
                            Layout.fillWidth: true
                            Layout.preferredHeight: 50
                            onClicked: {
                                cancelCreateNewMission()
                            }

                            background: Rectangle{
                                color: "Transparent"
                                border.color: "#ffffff"
                                border.width: 2
                                Text {
                                    anchors.centerIn: parent
                                    color: "#3D71D7"
                                    text: qsTr("CANCEL")
                                    font.pixelSize: ScreenTools.defaultFontPixelHeight/16*25
                                }

                            }

                        }
                        Button{                            
                            Layout.fillWidth: true
                            Layout.preferredHeight: 50
                            onClicked: {
                                moveToWaypointMission()
                                screenMissionSelection.isMakeMission = true
                            }
                            background: Rectangle{
                                color: "Transparent"
                                border.color: "#ffffff"
                                border.width: 2
                                Text {
                                    anchors.centerIn: parent
                                    color: "#3D71D7"
                                    text: qsTr("OK")
                                    font.pixelSize: ScreenTools.defaultFontPixelHeight/16*25
                                }

                            }

                        }
                    }

                }



            }



            // Mission

            WaypointMission {
                id: pageWaypointMission
                visible: false
                anchors.fill: parent

                onExitWaypointMission:{
                    exitWaypointMissionUI()
                    returnToPrevious()
                }

            }
        }

        
        FlyViewVideo {
            id: videoControl

        }


        QGCPipOverlay {
            id:                     _pipOverlay
            anchors.left:           parent.left
            anchors.top:         parent.top
            anchors.topMargin:      parent.height/8
            anchors.margins:        ScreenTools.defaultFontPixelWidth * 0.75
            item1IsFullSettingsKey: "MainFlyWindowIsMap"
            item1:                  editorMap
            item2:                  QGroundControl.videoManager.hasVideo ? videoControl : null
            fullZOrder:             _fullItemZorder
            pipZOrder:              _pipItemZorder
            show:                   !QGroundControl.videoManager.fullScreen &&
                                    (videoControl.pipState.state === videoControl.pipState.pipState || editorMap.pipState.state === editorMap.pipState.pipState)
        }



        Loader {
            id: notification
            anchors.left: parent.left
            anchors.leftMargin: ScreenTools.defaultFontPixelHeight*2
            anchors.verticalCenter: parent.verticalCenter
            sourceComponent: notificationBox
        }


        ToolStrip {
            id:                 toolStrip
            anchors.margins:    _toolsMargin
            anchors.left:       parent.left
            anchors.top:        parent.top
            z:                  QGroundControl.zOrderWidgets
            maxHeight:          parent.height - toolStrip.y
            title:              qsTr("Plan")
            visible: false
            readonly property int flyButtonIndex:       0
            readonly property int fileButtonIndex:      1
            readonly property int takeoffButtonIndex:   2
            readonly property int waypointButtonIndex:  3
            readonly property int roiButtonIndex:       4
            readonly property int patternButtonIndex:   5
            readonly property int landButtonIndex:      6
            readonly property int centerButtonIndex:    7

            property bool _isRallyLayer:    _editingLayer == _layerRallyPoints
            property bool _isMissionLayer:  _editingLayer == _layerMission

            ToolStripActionList {
                id: toolStripActionList
                model: [
                    ToolStripAction {
                        text:           qsTr("Fly")
                        iconSource:     "/qmlimages/PaperPlane.svg"
                        onTriggered:    mainWindow.showFlyView()
                    },
                    ToolStripAction {
                        text:                   qsTr("File")
                        enabled:                !_planMasterController.syncInProgress
                        visible:                true
                        showAlternateIcon:      _planMasterController.dirty
                        iconSource:             "/qmlimages/MapSync.svg"
                        alternateIconSource:    "/qmlimages/MapSyncChanged.svg"
                        dropPanelComponent:     syncDropPanel
                    },
                    ToolStripAction {
                        text:       qsTr("Takeoff")
                        iconSource: "/res/takeoff.svg"
                        enabled:    _missionController.isInsertTakeoffValid
                        visible:    toolStrip._isMissionLayer && !_planMasterController.controllerVehicle.rover
                        onTriggered: {
                            toolStrip.allAddClickBoolsOff()
                            insertTakeItemAfterCurrent()
                        }
                    },
                    ToolStripAction {
                        id:                 addWaypointRallyPointAction
                        text:               _editingLayer == _layerRallyPoints ? qsTr("Rally Point") : qsTr("Waypoint")
                        iconSource:         "/qmlimages/MapAddMission.svg"
                        enabled:            toolStrip._isRallyLayer ? true : _missionController.flyThroughCommandsAllowed
                        visible:            toolStrip._isRallyLayer || toolStrip._isMissionLayer
                        checkable:          true
                    },
                    ToolStripAction {
                        text:               _missionController.isROIActive ? qsTr("Cancel ROI") : qsTr("ROI")
                        iconSource:         "/qmlimages/MapAddMission.svg"
                        enabled:            !_missionController.onlyInsertTakeoffValid
                        visible:            toolStrip._isMissionLayer && _planMasterController.controllerVehicle.roiModeSupported
                        checkable:          !_missionController.isROIActive
                        onCheckedChanged:   _addROIOnClick = checked
                        onTriggered: {
                            if (_missionController.isROIActive) {
                                toolStrip.allAddClickBoolsOff()
                                insertCancelROIAfterCurrent()
                            }
                        }
                        property bool myAddROIOnClick: _addROIOnClick
                        onMyAddROIOnClickChanged: checked = _addROIOnClick
                    },
                    ToolStripAction {
                        text:               _singleComplexItem ? _missionController.complexMissionItemNames[0] : qsTr("Pattern")
                        iconSource:         "/qmlimages/MapDrawShape.svg"
                        enabled:            _missionController.flyThroughCommandsAllowed
                        visible:            toolStrip._isMissionLayer
                        dropPanelComponent: _singleComplexItem ? undefined : patternDropPanel
                        onTriggered: {
                            toolStrip.allAddClickBoolsOff()
                            if (_singleComplexItem) {
                                insertComplexItemAfterCurrent(_missionController.complexMissionItemNames[0])
                            }
                        }
                    },
                    ToolStripAction {
                        text:       _planMasterController.controllerVehicle.multiRotor ? qsTr("Return") : qsTr("Land")
                        iconSource: "/res/rtl.svg"
                        enabled:    _missionController.isInsertLandValid
                        visible:    toolStrip._isMissionLayer
                        onTriggered: {
                            toolStrip.allAddClickBoolsOff()
                            insertLandItemAfterCurrent()
                        }
                    },
                    ToolStripAction {
                        text:               qsTr("Center")
                        iconSource:         "/qmlimages/MapCenter.svg"
                        enabled:            true
                        visible:            true
                        dropPanelComponent: centerMapDropPanel
                    }
                ]
            }

            model: toolStripActionList.model

            function allAddClickBoolsOff() {
                _addROIOnClick =        false
                addWaypointRallyPointAction.checked = false
            }

            onDropped: allAddClickBoolsOff()
        }

        //-----------------------------------------------------------
        // Right pane for mission editing controls
        Rectangle {
            id:                 rightPanel
            visible: false
            height:             parent.height
            width:              _rightPanelWidth
            color:              qgcPal.window
            opacity:            layerTabBar.visible ? 0.2 : 0
            anchors.bottom:     parent.bottom
            anchors.right:      parent.right
            anchors.rightMargin: _toolsMargin
        }
        //-------------------------------------------------------
        // Right Panel Controls
        Item {
            visible: false
            anchors.fill:           rightPanel
            anchors.topMargin:      _toolsMargin
            DeadMouseArea {
                anchors.fill:   parent
            }
            Column {
                id:                 rightControls
                spacing:            ScreenTools.defaultFontPixelHeight * 0.5
                anchors.left:       parent.left
                anchors.right:      parent.right
                anchors.top:        parent.top
                //-------------------------------------------------------
                // Airmap Airspace Control
                AirspaceControl {
                    id:             airspaceControl
                    width:          parent.width
                    visible:        _airspaceEnabled
                    planView:       true
                    showColapse:    true
                }
                //-------------------------------------------------------
                // Mission Controls (Colapsed)
                Rectangle {
                    width:      parent.width
                    height:     planControlColapsed ? colapsedRow.height + ScreenTools.defaultFontPixelHeight : 0
                    color:      qgcPal.missionItemEditor
                    radius:     _radius
                    visible:    planControlColapsed && _airspaceEnabled
                    Row {
                        id:                     colapsedRow
                        spacing:                ScreenTools.defaultFontPixelWidth
                        anchors.left:           parent.left
                        anchors.leftMargin:     ScreenTools.defaultFontPixelWidth
                        anchors.verticalCenter: parent.verticalCenter
                        QGCColoredImage {
                            width:              height
                            height:             ScreenTools.defaultFontPixelWidth * 2.5
                            sourceSize.height:  height
                            source:             "qrc:/res/waypoint.svg"
                            color:              qgcPal.text
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        QGCLabel {
                            text:               qsTr("Plan")
                            color:              qgcPal.text
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                    QGCColoredImage {
                        width:                  height
                        height:                 ScreenTools.defaultFontPixelWidth * 2.5
                        sourceSize.height:      height
                        source:                 QGroundControl.airmapSupported ? "qrc:/airmap/expand.svg" : ""
                        color:                  "white"
                        visible:                QGroundControl.airmapSupported
                        anchors.right:          parent.right
                        anchors.rightMargin:    ScreenTools.defaultFontPixelWidth
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    MouseArea {
                        anchors.fill:   parent
                        enabled:        QGroundControl.airmapSupported
                        onClicked: {
                            QGroundControl.airspaceManager.airspaceVisible = false
                        }
                    }
                }
                //-------------------------------------------------------
                // Mission Controls (Expanded)
                QGCTabBar {
                    id:         layerTabBar
                    width:      parent.width
                    visible:    (!planControlColapsed || !_airspaceEnabled) && QGroundControl.corePlugin.options.enablePlanViewSelector
                    Component.onCompleted: currentIndex = 0
                    QGCTabButton {
                        text:       qsTr("Mission")
                    }
                    QGCTabButton {
                        text:       qsTr("Fence")
                        enabled:    _geoFenceController.supported
                    }
                    QGCTabButton {
                        text:       qsTr("Rally")
                        enabled:    _rallyPointController.supported
                    }
                }
            }
            //-------------------------------------------------------
            // Mission Item Editor
            Item {
                id:                     missionItemEditor
                anchors.left:           parent.left
                anchors.right:          parent.right
                anchors.top:            rightControls.bottom
                anchors.topMargin:      ScreenTools.defaultFontPixelHeight * 0.25
                anchors.bottom:         parent.bottom
                anchors.bottomMargin:   ScreenTools.defaultFontPixelHeight * 0.25
                visible:                true//_editingLayer == _layerMission && !planControlColapsed
                QGCListView {
                    id:                 missionItemEditorListView
                    anchors.fill:       parent
                    spacing:            ScreenTools.defaultFontPixelHeight / 4
                    orientation:        ListView.Vertical
                    model:              _missionController.visualItems
                    cacheBuffer:        Math.max(height * 2, 0)
                    clip:               true
                    currentIndex:       _missionController.currentPlanViewSeqNum
                    highlightMoveDuration: 250
                    visible:            _editingLayer == true//_layerMission && !planControlColapsed
                    //-- List Elements
                    delegate: MissionItemEditor {
                        map:            editorMap
                        masterController:  _planMasterController
                        missionItem:    object
                        width:          100// 100 parent.width
                        readOnly:       false
                        onClicked:      _missionController.setCurrentPlanViewSeqNum(object.sequenceNumber, false)
                        onRemove: {
                            var removeVIIndex = index
                            _missionController.removeVisualItem(removeVIIndex)
                            if (removeVIIndex >= _missionController.visualItems.count) {
                                removeVIIndex--
                            }
                        }
                        onSelectNextNotReadyItem:   selectNextNotReady()
                    }
                }
            }
            // GeoFence Editor
            GeoFenceEditor {
                anchors.top:            rightControls.bottom
                anchors.topMargin:      ScreenTools.defaultFontPixelHeight * 0.25
                anchors.bottom:         parent.bottom
                anchors.left:           parent.left
                anchors.right:          parent.right
                myGeoFenceController:   _geoFenceController
                flightMap:              editorMap
                visible:                _editingLayer == _layerGeoFence
            }

            // Rally Point Editor
            RallyPointEditorHeader {
                id:                     rallyPointHeader
                anchors.top:            rightControls.bottom
                anchors.topMargin:      ScreenTools.defaultFontPixelHeight * 0.25
                anchors.left:           parent.left
                anchors.right:          parent.right
                visible:                _editingLayer == _layerRallyPoints
                controller:             _rallyPointController
            }
            RallyPointItemEditor {
                id:                     rallyPointEditor
                anchors.top:            rallyPointHeader.bottom
                anchors.topMargin:      ScreenTools.defaultFontPixelHeight * 0.25
                anchors.left:           parent.left
                anchors.right:          parent.right
                visible:                _editingLayer == _layerRallyPoints && _rallyPointController.points.count
                rallyPoint:             _rallyPointController.currentRallyPoint
                controller:             _rallyPointController
            }
        }
        

    }



    Component {
        id: notificationBox

        Rectangle {
            implicitWidth: Screen.width/4
            implicitHeight: txtNotify.height + 20
            property int notiType: 1
            property string notiText: "The phone is not connected to the drone. Please connect the phone to the drone and try again."
            readonly property int warning : 0
            readonly property int error : 1
            readonly property int info : 2
            property bool itemvisible: true
            property string bgcolor: notiType === warning ? "#FFA500" : notiType === error ? "#FF0000" : "#00FF00"
            function showNotification(notiType, notiText) {
                this.notiType = notiType
                this.notiText = notiText
                visible = true
            }

            color: bgcolor
            radius: 2
            border.color: "transparent"
            visible: itemvisible
            RowLayout {
                anchors.margins: 10
                spacing: 10
                anchors.fill: parent

                // multiline text
                Text {
                    id: txtNotify
                    Layout.fillWidth: true
                    wrapMode: Text.WordWrap
                    text: notiText
                    color: "white"
                    font.pixelSize: ScreenTools.defaultFontPixelHeight/16*20
                }
                Button {
                    Layout.preferredWidth: ScreenTools.defaultFontPixelHeight/16*30
                    
                    onClicked: {
                        itemvisible = false
                    }
                    background: Rectangle{
                        color: "transparent"
                        border.color: "transparent"
                        Text{
                            anchors.centerIn: parent
                            text: "X"
                            color: "white"
                            font.pixelSize: ScreenTools.defaultFontPixelHeight/16*30
                        }
                    }
                }
            }
        }
    }

    Component {
        id: syncLoadFromVehicleOverwrite
        QGCViewMessage {
            id:         syncLoadFromVehicleCheck
            message:   qsTr("You have unsaved/unsent changes. Loading from the Vehicle will lose these changes. Are you sure you want to load from the Vehicle?")
            function accept() {
                hideDialog()
                _planMasterController.loadFromVehicle()
            }
        }
    }

    Component {
        id: syncLoadFromFileOverwrite
        QGCViewMessage {
            id:         syncLoadFromVehicleCheck
            message:   qsTr("You have unsaved/unsent changes. Loading from a file will lose these changes. Are you sure you want to load from a file?")
            function accept() {
                hideDialog()
                _planMasterController.loadFromSelectedFile()
            }
        }
    }

    property var createPlanRemoveAllPromptDialogMapCenter
    property var createPlanRemoveAllPromptDialogPlanCreator
    Component {
        id: createPlanRemoveAllPromptDialog
        QGCViewMessage {
            message: qsTr("Are you sure you want to remove current plan and create a new plan? ")
            function accept() {
                createPlanRemoveAllPromptDialogPlanCreator.createPlan(createPlanRemoveAllPromptDialogMapCenter)
                hideDialog()
                if (_missionController.isInsertTakeoffValid){
                    // Insert takeoff item after current item
                    var nextIndex = _missionController.currentPlanViewVIIndex + 1
                    _missionController.insertTakeoffItem(_mapCenter(), nextIndex, true /* makeCurrentItem */)
                }
                mainWindow.showComponentDialog(clickToSetTakeOffLocationDialog, qsTr("Create Plan"), mainWindow.showDialogDefaultWidth, StandardButton.Yes)
            }
        }
    }

    Component { 
        id: clickToSetTakeOffLocationDialog
        QGCViewMessage {
            message: qsTr("Click on the map to set the takeoff location.")
            function accept() {
                hideDialog()
            }
        }
    }

    Component {
        id: clearVehicleMissionDialog
        QGCViewMessage {
            message: qsTr("Are you sure you want to remove all mission items and clear the mission from the vehicle?")
            function accept() {
                _planMasterController.removeAllFromVehicle()
                _missionController.setCurrentPlanViewSeqNum(0, true)
                hideDialog()
            }
        }
    }

    //- ToolStrip DropPanel Components

    Component {
        id: centerMapDropPanel

        CenterMapDropPanel {
            map:            editorMap
            fitFunctions:   mapFitFunctions
        }
    }

    Component {
        id: patternDropPanel

        ColumnLayout {
            spacing:    ScreenTools.defaultFontPixelWidth * 0.5

            QGCLabel { text: qsTr("Create complex pattern:") }

            Repeater {
                model: _missionController.complexMissionItemNames

                QGCButton {
                    text:               modelData
                    Layout.fillWidth:   true

                    onClicked: {
                        insertComplexItemAfterCurrent(modelData)
                        dropPanel.hide()
                    }
                }
            }
        } // Column
    }

    Component {
        id: syncDropPanel

        ColumnLayout {
            id:         columnHolder
            spacing:    _margin

            property string _overwriteText: (_editingLayer == _layerMission) ? qsTr("Mission overwrite") : ((_editingLayer == _layerGeoFence) ? qsTr("GeoFence overwrite") : qsTr("Rally Points overwrite"))

            QGCLabel {
                id:                 unsavedChangedLabel
                Layout.fillWidth:   true
                wrapMode:           Text.WordWrap
                text:               globals.activeVehicle ?
                                        qsTr("You have unsaved changes. You should upload to your vehicle, or save to a file.") :
                                        qsTr("You have unsaved changes.")
                visible:            _planMasterController.dirty
            }

            SectionHeader {
                id:                 createSection
                Layout.fillWidth:   true
                text:               qsTr("Create Plan")
                showSpacer:         false
            }

            GridLayout {
                columns:            2
                columnSpacing:      _margin
                rowSpacing:         _margin
                Layout.fillWidth:   true
                visible:            createSection.visible

                Repeater {
                    model: _planMasterController.planCreators

                    Rectangle {
                        id:     button
                        width:  ScreenTools.defaultFontPixelHeight * 7
                        height: planCreatorNameLabel.y + planCreatorNameLabel.height
                        color:  button.pressed || button.highlighted ? qgcPal.buttonHighlight : qgcPal.button

                        property bool highlighted: mouseArea.containsMouse
                        property bool pressed:     mouseArea.pressed

                        Image {
                            id:                 planCreatorImage
                            anchors.left:       parent.left
                            anchors.right:      parent.right
                            source:             object.imageResource
                            sourceSize.width:   width
                            fillMode:           Image.PreserveAspectFit
                            mipmap:             true
                        }

                        QGCLabel {
                            id:                     planCreatorNameLabel
                            anchors.top:            planCreatorImage.bottom
                            anchors.left:           parent.left
                            anchors.right:          parent.right
                            horizontalAlignment:    Text.AlignHCenter
                            text:                   object.name
                            color:                  button.pressed || button.highlighted ? qgcPal.buttonHighlightText : qgcPal.buttonText
                        }

                        QGCMouseArea {
                            id:                 mouseArea
                            anchors.fill:       parent
                            hoverEnabled:       true
                            preventStealing:    true
                            onClicked:          {
                                if (_planMasterController.containsItems) {
                                    createPlanRemoveAllPromptDialogMapCenter = _mapCenter()
                                    createPlanRemoveAllPromptDialogPlanCreator = object
                                    mainWindow.showComponentDialog(createPlanRemoveAllPromptDialog, qsTr("Create Plan"), mainWindow.showDialogDefaultWidth, StandardButton.Yes | StandardButton.No)
                                } else {
                                    object.createPlan(_mapCenter())
                                }
                                dropPanel.hide()
                            }

                            function _mapCenter() {
                                var centerPoint = Qt.point(editorMap.centerViewport.left + (editorMap.centerViewport.width / 2), editorMap.centerViewport.top + (editorMap.centerViewport.height / 2))
                                return editorMap.toCoordinate(centerPoint, false /* clipToViewPort */)
                            }
                        }
                    }
                }
            }

            SectionHeader {
                id:                 storageSection
                Layout.fillWidth:   true
                text:               qsTr("Storage")
            }

            GridLayout {
                columns:            3
                rowSpacing:         _margin
                columnSpacing:      ScreenTools.defaultFontPixelWidth
                visible:            storageSection.visible

                /*QGCButton {
                    text:               qsTr("New...")
                    Layout.fillWidth:   true
                    onClicked:  {
                        dropPanel.hide()
                        if (_planMasterController.containsItems) {
                            mainWindow.showComponentDialog(removeAllPromptDialog, qsTr("New Plan"), mainWindow.showDialogDefaultWidth, StandardButton.Yes | StandardButton.No)
                        }
                    }
                }*/

                QGCButton {
                    text:               qsTr("Open...")
                    Layout.fillWidth:   true
                    enabled:            !_planMasterController.syncInProgress
                    onClicked: {
                        dropPanel.hide()
                        if (_planMasterController.dirty) {
                            mainWindow.showComponentDialog(syncLoadFromFileOverwrite, columnHolder._overwriteText, mainWindow.showDialogDefaultWidth, StandardButton.Yes | StandardButton.Cancel)
                        } else {
                            _planMasterController.loadFromSelectedFile()
                        }
                    }
                }

                QGCButton {
                    text:               qsTr("Save")
                    Layout.fillWidth:   true
                    enabled:            !_planMasterController.syncInProgress && _planMasterController.currentPlanFile !== ""
                    onClicked: {
                        dropPanel.hide()
                        if(_planMasterController.currentPlanFile !== "") {
                            _planMasterController.saveToCurrent()
                        } else {
                            _planMasterController.saveToSelectedFile()
                        }
                    }
                }

                QGCButton {
                    text:               qsTr("Save As...")
                    Layout.fillWidth:   true
                    enabled:            !_planMasterController.syncInProgress && _planMasterController.containsItems
                    onClicked: {
                        dropPanel.hide()
                        _planMasterController.saveToSelectedFile()
                    }
                }

                QGCButton {
                    Layout.columnSpan:  3
                    Layout.fillWidth:   true
                    text:               qsTr("Save Mission Waypoints As KML...")
                    enabled:            !_planMasterController.syncInProgress && _visualItems.count > 1
                    onClicked: {
                        // First point does not count
                        if (_visualItems.count < 2) {
                            mainWindow.showComponentDialog(noItemForKML, qsTr("KML"), mainWindow.showDialogDefaultWidth, StandardButton.Cancel)
                            return
                        }
                        dropPanel.hide()
                        _planMasterController.saveKmlToSelectedFile()
                    }
                }
            }

            SectionHeader {
                id:                 vehicleSection
                Layout.fillWidth:   true
                text:               qsTr("Vehicle")
            }

            RowLayout {
                Layout.fillWidth:   true
                spacing:            _margin
                visible:            vehicleSection.visible

                QGCButton {
                    text:               qsTr("Upload")
                    Layout.fillWidth:   true
                    enabled:            !_planMasterController.offline && !_planMasterController.syncInProgress && _planMasterController.containsItems
                    visible:            !QGroundControl.corePlugin.options.disableVehicleConnection
                    onClicked: {
                        dropPanel.hide()
                        _planMasterController.upload()
                    }
                }

                QGCButton {
                    text:               qsTr("Download")
                    Layout.fillWidth:   true
                    enabled:            !_planMasterController.offline && !_planMasterController.syncInProgress
                    visible:            !QGroundControl.corePlugin.options.disableVehicleConnection
                    onClicked: {
                        dropPanel.hide()
                        if (_planMasterController.dirty) {
                            mainWindow.showComponentDialog(syncLoadFromVehicleOverwrite, columnHolder._overwriteText, mainWindow.showDialogDefaultWidth, StandardButton.Yes | StandardButton.Cancel)
                        } else {
                            _planMasterController.loadFromVehicle()
                        }
                    }
                }

                QGCButton {
                    text:               qsTr("Clear")
                    Layout.fillWidth:   true
                    Layout.columnSpan:  2
                    enabled:            !_planMasterController.offline && !_planMasterController.syncInProgress
                    visible:            !QGroundControl.corePlugin.options.disableVehicleConnection
                    onClicked: {
                        dropPanel.hide()
                        mainWindow.showComponentDialog(clearVehicleMissionDialog, text, mainWindow.showDialogDefaultWidth, StandardButton.Yes | StandardButton.Cancel)
                    }
                }
            }
        }
    }
}
