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
import ArcGIS.Runtime 10.26

ApplicationWindow {
    id: appWindow
    width: 1000
    height: 800
    title: "geojson"

    Map {
        id: map
        anchors.fill: parent
        wrapAroundEnabled: true
        focus: true

        ArcGISTiledMapServiceLayer {
            url: "http://services.arcgisonline.com/arcgis/rest/services/ESRI_StreetMap_World_2D/MapServer"
        }

        GraphicsLayer {
            id: gl
            renderingMode: Enums.RenderingModeStatic
            onFindGraphicsComplete: {
                gl.clearSelection();
                if (graphicIDs[0]) {
                    gl.selectGraphic(graphicIDs[0]);
                    console.log(JSON.stringify(gl.graphic(graphicIDs[0]).attributes))
                }
            }
        }

        onMouseClicked: {
            gl.findGraphic(mouse.x, mouse.y, 4)
        }

        Button {
            id: fileBtn
            anchors {
                left: parent.left
                top: parent.top
                margins: 15
            }
            text: "Load File"
            width: 150
            onClicked: {
                geoJsonParser.loadGeoJsonFeatures();
            }
        }

        Button {
            anchors {
                left: parent.left
                top: fileBtn.bottom
                margins: 15
            }
            text: "Load Service"
            width: 150
            onClicked: {
                request('http://services2.arcgis.com/2B0gmGCMCH3iKkax/arcgis/rest/services/LA_Farmers_Markets/FeatureServer/0/query?where=1%3D1&outSR=4326&outFields=*&f=geojson', function (o) {
                    geoJsonParser.parseGeoJsonFeatures(JSON.parse(o.responseText));
                });
            }

            function request(url, callback) {
                console.log(url)
                var xhr = new XMLHttpRequest();
                xhr.onreadystatechange = (function(myxhr) {
                    return function() {
                        if(myxhr.readyState === 4) callback(myxhr)
                    }
                })(xhr);
                xhr.open('GET', url, true);
                xhr.send('');
            }
        }

        GeoJsonParser {
            id: geoJsonParser
            source: "geojson/countries.geojson"
            onFeaturesParsed: {
                featureList.forEach(function parseFeatures(inFeature){
                    gl.addGraphic(inFeature);
                });
            }

            // to specify a different marker symbol
            markerSymbol: PictureMarkerSymbol {
                image: "qrc:///Resources/RedShinyPin.png"
            }

            // to specify a different line symbol
            lineSymbol: SimpleLineSymbol {
                color: "blue"
                style: Enums.SimpleLineSymbolStyleDash
                width: 3
            }

            // to specify a different fill symbol
            fillSymbol: SimpleFillSymbol {
                color: "aqua"
                style: Enums.SimpleFillSymbolStyleBackwardDiagonal
                outline: SimpleLineSymbol {
                    color: "black"
                    width: 2
                }
            }
        }
    }
}

