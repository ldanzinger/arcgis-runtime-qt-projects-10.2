
// Copyright 2015 ESRI
//
// All rights reserved under the copyright laws of the United States
// and applicable international laws, treaties, and conventions.
//
// You may freely redistribute and use this sample code, with or
// without modification, provided you include the original copyright
// notice and use restrictions.
//
// See the Sample code usage restrictions document for further information.
//

import QtQuick 2.3
import QtQuick.Controls 1.2
import ArcGIS.Runtime 10.25
import QtPositioning 5.3

ApplicationWindow {
    id: appWindow
    width: 800
    height: 600
    title: "template"

    property Point myLocation

    Map {
        id: mainMap
        anchors.fill: parent
        extent: initialExtent
        focus: true

        ArcGISTiledMapServiceLayer {
            url: "http://services.arcgisonline.com/arcgis/rest/services/Canvas/World_Dark_Gray_Base/MapServer"
        }

        GeodatabaseFeatureServiceTable {
            id: featureServiceTable
            url: "http://services2.arcgis.com/2B0gmGCMCH3iKkax/arcgis/rest/services/LA_Farmers_Markets/FeatureServer/0"
        }

        FeatureLayer {
            id: featureLayer
            featureTable: featureServiceTable

            function hitTestFeatures(x,y) {
                var featureIds = featureLayer.findFeatures(x, y, 5, 1);
                if (featureIds.length > 0) {
                    featureLayer.clearSelection();
                    var selectedFeatureId = featureIds[0];
                    var selectedFeature = featureTable.feature(selectedFeatureId);
                    selectFeature(selectedFeatureId);
                    addLine();
                }
            }

            function addLine() {
                gl.removeAllGraphics();
                var newGraphic = graphic.clone();
                var selectedPoint = featureLayer.selectedFeatures[0].geometry;
                var simplePolyline = polyline.clone();
                simplePolyline.startPath(myLocation);
                simplePolyline.lineTo(selectedPoint);
                newGraphic.geometry = simplePolyline;
                gl.addGraphic(newGraphic);
                calculateDistance(simplePolyline);
            }

            function calculateDistance(simplePolyline) {
                lengthText.text = "Planar Length: " + simplePolyline.calculateLength2D() + " meters";
                geodesicLengthText.text = "Geodesic Length: " + simplePolyline.geodesicLength() +  " meters";
            }
        }

        GraphicsLayer {
            id: gl
        }

        Polyline {
            id: polyline
        }

        Graphic {
            id: graphic
            symbol: SimpleLineSymbol {
                width: 2
                color: "cyan"
                style: Enums.SimpleLineSymbolStyleDash
            }
        }

        onMouseClicked: {
            featureLayer.hitTestFeatures(mouse.x, mouse.y);
        }

        onStatusChanged: {
            if (status === Enums.MapStatusReady) {
                ps.active = true;
            }
        }

        Envelope {
            id: initialExtent
            xMax:-12518302.273374509
            xMin:-13368309.843602201
            yMax:4336880.926204643
            yMin:3699375.2485338743
            spatialReference: mainMap.spatialReference
        }

        positionDisplay {
            id: pd
            positionSource: PositionSource {
                id: ps
            }
            onMapPointChanged: {
                myLocation = pd.mapPoint;
            }
        }
    }

    Text {
        id: geodesicLengthText
        anchors {
            top: lengthText.bottom
            right: parent.right
            margins: 15
        }
        color: "white"
        font {
            pointSize: 18
            family: "sanserif"
        }
    }

    Text {
        id: lengthText
        anchors {
            top: parent.top
            right: parent.right
            margins: 15
        }
        color: "white"
        font {
            pointSize: 18
            family: "sanserif"
        }
    }
}

