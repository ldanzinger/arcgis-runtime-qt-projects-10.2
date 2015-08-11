/*
Copyright 2015 Esri.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

import QtQuick 2.3
import QtQuick.Controls 1.2
import QtPositioning 5.3
import QtQuick.Dialogs 1.2
import ArcGIS.Runtime 10.26
import ArcGIS.Extras 1.0
import ArcGIS.Runtime.Toolkit.Controls 1.0

ApplicationWindow {
    id: appWindow
    width: 400
    height: 600
    title: "SDBreweryApp"

    property real scaleFactor: System.displayScaleFactor
    property string locatorFindMode
    property bool directionsMode: false
    property bool searchMode: false

    Component.onCompleted: {
        ArcGISRuntime.identityManager.ignoreSslErrors = true;
    }

    Map {
        id: map
        anchors {
            left: parent.left
            right: parent.right
            top: titlebar.bottom
            bottom: actionbar.top
        }
        extent: initialExtent

        positionDisplay {
            positionSource: PositionSource {
                id: positionSource
            }
        }

        onStatusChanged: {
            if (status === Enums.MapStatusReady) {
                positionSource.active = true;
            }
        }

        onMouseClicked: {
            fl.hitTestFeatures(mouse.x, mouse.y)
        }

        onExtentChanged: {
            mapCallOut.visible = false;
        }

        onMousePressed: {
            mapCallOut.visible = false;
        }

        onMouseWheel: {
            mapCallOut.visible = false;
        }

        ArcGISTiledMapServiceLayer {
            url: "http://services.arcgisonline.com/arcgis/rest/services/Canvas/World_Light_Gray_Base/MapServer"
        }

        ArcGISTiledMapServiceLayer {
            url: "http://services.arcgisonline.com/arcgis/rest/services/Canvas/World_Light_Gray_Reference/MapServer"
        }

        GraphicsLayer {
            id: routeGL
        }

        FeatureLayer {
            id: fl
            featureTable: ft
            enableLabels: true

            renderer: SimpleRenderer {
                symbol: PictureMarkerSymbol {
                    image: "qrc:///Resources/pin_center_star_blue_d.png"
                    width: 55
                    height: 55
                }
            }

            function hitTestFeatures(x,y) {
                var tolerance = Qt.platform.os === "ios" || Qt.platform.os === "android" ? 4 : 1;
                var featureIds = fl.findFeatures(x, y, tolerance * scaleFactor, 1);

                if (featureIds.length > 0) {
                    var selectedFeature = featureTable.feature(featureIds[0]);
                    mapCallOut.breweryName = selectedFeature.attributeValue("NAME");
                    mapCallOut.breweryNumber = selectedFeature.attributeValue("Phone_1");
                    mapCallOut.show(x, y);
                }
            }
        }

        GraphicsLayer {
            id: gl
        }

        Query {
            id: breweryQuery
        }

        Envelope {
            id: initialExtent
            spatialReference: map.spatialReference
            xMin: -13078079
            yMin: 3824559
            xMax: -13008810
            yMax: 3950969
        }

        Text {
            id: resultsText
            anchors {
                left: parent.left
                bottom: parent.bottom
                margins: 10 * scaleFactor
            }
            visible: false
            font {
                family: "Segoe UI"
                pixelSize: 14 * scaleFactor
            }
            renderType: Text.QtRendering
        }

        BusyIndicator {
            id: busyIndicator
            anchors {
                left: resultsText.right
                bottom: parent.bottom
                margins: 10 * scaleFactor
            }
            visible: false
            width: 14 * scaleFactor
            height: width
        }
    }

    GeodatabaseFeatureServiceTable {
        id: ft
        url: "https://services3.arcgis.com/j3MbjXF5w7u93BAL/arcgis/rest/services/SD_Breweries/FeatureServer/0"

        property var tripJson
        property var featAttributes

        function queryBreweries(breweryText) {
            // Set the where clause on the query
            breweryQuery.where = "NAME LIKE '%" + breweryText + "%'";
            // Query the Feature Service Table
            ft.queryIds(breweryQuery);
        }

        onQueryIdsStatusChanged: {
            switch(queryIdsStatus) {
            case Enums.QueryIdsStatusCompleted:
                fl.clearSelection();
                searchWindow.isBusy = false;
                // obtain the matched features Ids
                if (queryIdsResults.length > 0) {
                    searchWindow.resultText = "";
                    for (var i = 0; i < queryIdsResults.length; i++) {
                        // select the features in the Feature Layer
                        fl.selectFeature(queryIdsResults[i]);
                    }
                    zoomToSelected(20000);
                    searchWindow.closeWindow();
                    searchWindow.resetValues();
                    searchMode = true;
                } else {
                    searchWindow.resultText = "No matches found."
                }
                break;
            case Enums.QueryIdsStatusErrored:
                searchWindow.resultText = "An error occurred.\nPlease retry."
                searchWindow.isBusy = false;
                break;
            }
        }

        onQueryFeaturesStatusChanged: {
            switch(queryFeaturesStatus) {
            case Enums.QueryFeaturesStatusCompleted:
                fl.clearSelection();
                startTimer(queryFeaturesResult.featureCount + " breweries found");
                var iter = queryFeaturesResult.iterator;
                while (iter.hasNext()) {
                    var feat = iter.next();
                    var graphic = ArcGISRuntime.createObject("StopGraphic");
                    graphic.geometry = feat.geometry;
                    graphic.name = feat.attributeValue("NAME");
                    gl.addGraphic(graphic);
                    stops.addFeature(graphic);
                    stops.stopCount += 1;
                    fl.selectFeature(feat.uniqueId);
                }
                if (stops.stopCount > 1) {
                    routeTaskParameters.stops = stops;
                    routeTaskParameters.outSpatialReference = map.spatialReference;
                    startTimer("Calculating Route...");
                    busyIndicator.visible = true;
                    routeTask.solve(routeTaskParameters);
                }
                break;
            case Enums.QueryFeaturesStatusErrored:
                msgDialog.showMsgDialog("Trip Planner Error","Please review and resubmit.");
                break;
            }
        }

        function addNewBrewery(newFeat) {
            featAttributes = newFeat;
            //geocode feature first to get point from address
            findTextParams.text = newFeat["Address"] + " " + newFeat["City"] + ", CA";
            locatorFindMode = "AddNew"
            locator.find(findTextParams);
        }

        function zoomToSelected(zoomFactor) {
            var selectedFeatures = fl.selectedFeatures;
            if (selectedFeatures.length === 1) {
                map.zoomTo(selectedFeatures[0].geometry)
            } else if (selectedFeatures.length > 1) {
                var baseGeom = selectedFeatures[0].geometry;
                for (var i = 1; i < selectedFeatures.length; i++) {
                    baseGeom = baseGeom.clone().join(selectedFeatures[i].geometry);
                }
                var env = baseGeom.queryEnvelope().buffer(zoomFactor);
                map.zoomTo(env);
            }
        }

        onApplyFeatureEditsStatusChanged: {
            if (applyFeatureEditsStatus === Enums.ApplyEditsStatusCompleted) {
                console.log("successfully added new brewery");
                editWindow.resetValues();
            }
        }

        function planTheTrip(newPlan) {
            resetRouteParams();
            tripJson = newPlan;
            fl.clearSelection();
            if (tripJson["Address"] === "" || tripJson["Radius"].toString() === "" || tripJson["Number"].toString() === "" || tripJson["Number"] > 10) {
                msgDialog.showMsgDialog("Invalid Input","Please review and resubmit.");
            } else {
                planWindow.closeWindow();
                if (tripJson["Address"] === "MapPoint") {
                    createSearchRadius(map.positionDisplay.mapPoint, "Current Location");
                } else {
                    locatorFindMode = "PlanTrip";
                    findTextParams.text = tripJson["Address"];
                    locator.find(findTextParams);
                }
            }
        }

        function createSearchRadius(point, name) {
            // Add the point to the map
            var graphic = ArcGISRuntime.createObject("StopGraphic");
            graphic.geometry = point;
            graphic.name = name;
            var symbol = ArcGISRuntime.createObject("PictureMarkerSymbol", {image:"qrc:/Resources/pin_star_red_d.png"});
            symbol.width = 30;
            symbol.height = 30;
            graphic.symbol = symbol;
            gl.addGraphic(graphic);
            stops.addFeature(graphic);
            stops.stopCount += 1;

            // Use the Geometry Engine to buffer the point
            var radius = point.buffer(tripJson["Radius"], mile);

            // Set the buffer to the querie's geometry
            tripPlannerQuery.geometry = radius;
            if (tripJson["Dogs"] === 1 && tripJson["Food"] === 1) {
                tripPlannerQuery.where = "DogFriendly = 1 and Food = 1";
            } else if (tripJson["Food"] === 1) {
                tripPlannerQuery.where = "Food = 1";
            } else if (tripJson["Dogs"] === 1) {
                tripPlannerQuery.where = "DogFriendly = 1";
            } else {
                tripPlannerQuery.where = "1=1";
            }
            tripPlannerQuery.maxFeatures = tripJson["Number"];
            ft.queryFeatures(tripPlannerQuery);
        }

        function resetRouteParams() {
            gl.removeAllGraphics();
            routeGL.removeAllGraphics();
            stops.setFeatures(0);
            stops.stopCount = 0;
        }
    }


    Query {
        id: tripPlannerQuery
        spatialRelationship: Enums.SpatialRelationshipIntersects
        outSpatialReference: map.spatialReference
    }

    ServiceLocator {
        id: locator
        url: "http://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer"

        onFindStatusChanged: {
            if (findStatus === Enums.FindStatusCompleted) {
                if (findResults.length < 1) {
                    msgDialog.showMsgDialog("Address Not Found","No matching addresses found. Please review and resubmit.");
                } else {
                    if (locatorFindMode === "AddNew") {
                        // create the new feature
                        var newBrewery = ArcGISRuntime.createObject("Feature");
                        // set the geocode geometry to the new feature
                        newBrewery.geometry = findResults[0].location;
                        // set the new attributes from the form
                        newBrewery.setAttributeValue("NAME", ft.featAttributes["Name"]);
                        newBrewery.setAttributeValue("ADDRESS", ft.featAttributes["Address"]);
                        newBrewery.setAttributeValue("Phone_1", ft.featAttributes["Phone"]);
                        newBrewery.setAttributeValue("CITY_1", ft.featAttributes["City"]);
                        newBrewery.setAttributeValue("STATE", "CA");
                        newBrewery.setAttributeValue("ZIP", ft.featAttributes["Zip"]);
                        newBrewery.setAttributeValue("Hours", ft.featAttributes["Hours"]);
                        newBrewery.setAttributeValue("DogFriendly", ft.featAttributes["Dogs"]);
                        newBrewery.setAttributeValue("Food", ft.featAttributes["Food"]);
                        // add the new feature to the feature table
                        var result = ft.addFeature(newBrewery);
                        if (result.toString() !== "-1") {
                            editWindow.closeWindow();
                            // apply the edits to push from the table to the service
                            ft.applyFeatureEdits();
                            map.zoomTo(newBrewery.geometry);
                        } else {
                            msgDialog.showMsgDialog("Error","Error adding new brewery. Please review and resubmit.");
                        }
                    } else if (locatorFindMode === "PlanTrip") {
                        ft.createSearchRadius(findResults[0].location, ft.tripJson["Address"]);
                    }

                }
            } else if (findStatus === Enums.FindStatusErrored) {
                msgDialog.showMsgDialog("Address Not Found", findError.message);
            }
        }
    }

    LocatorFindParameters {
        id: findTextParams
        outSR: map.spatialReference
        maxLocations: 1
        searchExtent: initialExtent
        sourceCountry: "US"
    }

    SimpleLineSymbol {
        id: routeSymbol
        color: "#00b2ff"
        width: 3
    }

    OnlineRouteTask {
        id: routeTask
        url: "https://route.arcgis.com/arcgis/rest/services/World/Route/NAServer/Route_World"

        // Supply your user credentials here
        credentials: UserCredentials {
            userName: "yourUsername"
            password: "yourUsername"
        }

        onSolveStatusChanged: {
            if (solveStatus === Enums.SolveStatusCompleted) {
                var geom;
                for (var index = 0; index < solveResult.routes.length; index++) {
                    var route = solveResult.routes[index];
                    var graphic = route.route;
                    geom = graphic.geometry;
                    graphic.symbol = routeSymbol;
                    routeGL.addGraphic(graphic);
                    setUpDirections(route);
                }
                busyIndicator.visible = false;
                resultsText.visible = false;
                map.zoomTo(geom.buffer(1500));
                directionsWindow.height = 200 * scaleFactor;
                directionsMode = true;
            } else if (solveStatus === Enums.SolveStatusErrored) {
                msgDialog.showMsgDialog("Route error", solveError.message);
            }
        }

        function setUpDirections(route) {
            var t = "";
            t += "Total Driving Distance: " + Math.round(route.totalMiles) + " miles\n";
            t += "\nTotal Driving Time: " + Math.round(route.totalMinutes) + " minutes\n\n";
            for (var i = 0; i < route.routingDirections.length; i++) {
                t += route.routingDirections[i].text + "\n";
            }
            directionsModel.append({"direction": t});
            directionsWindow.directionsModel = directionsModel;
        }

    }

    ListModel {
        id: directionsModel
    }

    OnlineRouteTaskParameters {
        id: routeTaskParameters
    }

    NAFeaturesAsFeature {
        id: stops
        property int stopCount: 0
    }

    TitleBar {
        id: titlebar
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
    }

    ActionBar {
        id: actionbar
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
    }

    SearchWindow {
        id: searchWindow
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
        }
        width: parent.width
    }

    EditWindow {
        id: editWindow
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
        }
        width: parent.width
    }

    PlanWindow {
        id: planWindow
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
        }
        width: parent.width
    }

    DirectionsWindow {
        id: directionsWindow
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
        }
        width: parent.width
    }

    MessageDialog {
        id: msgDialog

        function showMsgDialog(text, details) {
            msgDialog.text = text;
            msgDialog.informativeText = details;
            msgDialog.open();
        }
    }

    Timer {
        id: timer
        interval: 5000
        onTriggered: {
            resultsText.visible = false;
        }
    }

    StyleToolbar {
        anchors {
            right: map.right
            top: map.top
            margins: 10 * scaleFactor
        }

        StyleButton {
            iconSource: "qrc:/Resources/ic_menu_directionstool_light.png"
            visible: directionsMode
            onClicked: {
                directionsWindow.height = 200 * scaleFactor;
            }
        }
        StyleButton {
            iconSource: "qrc:/Resources/ic_menu_closeclear_light.png"
            visible: directionsMode || searchMode
            onClicked: {
                directionsMode = false;
                searchMode = false;
                directionsWindow.height = 0;
                routeGL.removeAllGraphics();
                fl.clearSelection();
                gl.removeAllGraphics();
                map.zoomTo(initialExtent);
            }
        }
    }

    LinearUnit {
        id: mile
        wkid: Enums.LinearUnitCodeMileUS
    }

    MapCallout {
        id: mapCallOut
        visible: false

        function show(screenX,screenY) {
            visible = true;
            mapCallOut.x = screenX;
            mapCallOut.y = screenY;
        }
    }

    function startTimer(text) {
        resultsText.text = text;
        resultsText.visible = true;
        busyIndicator.visible = false;
        timer.start();
    }
}
