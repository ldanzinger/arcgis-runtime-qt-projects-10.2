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
import QtQuick.Dialogs 1.2
import QtPositioning 5.3
import ArcGIS.Runtime 10.26
import ArcGIS.Runtime.Toolkit.Controls 1.0

ApplicationWindow {
    id: appWindow
    width: 400
    height: 600
    title: "geofence"

    property bool previouslyWithin: false
    property bool within

    Map {
        id: map
        anchors.fill: parent
        focus: true
        extent: esriCampus

        ArcGISTiledMapServiceLayer {
            url: "http://server.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer"
        }       

        GraphicsLayer {
            id: gl
            opacity: 0.5
        }

        Envelope {
            id: esriCampus
            xMin: -13046340.492629018
            yMin: 4036308.8291057628
            xMax: -13046101.626915699
            yMax: 4036487.9783907514
            spatialReference: map.spatialReference
        }

        onStatusChanged: {
            if (status === Enums.MapStatusReady) {
                ps.active = true;
                gl.addGraphic(graphic);
            }
        }

        positionDisplay {
            id: pd
            mode: Enums.AutoPanModeNavigation
            positionSource: PositionSource {
                id: ps
                nmeaSource: "qrc:///Resources/campus.txt"                
            }

            onMapPointChanged: {
                within = pd.mapPoint.within(poly);
                console.log("within?", within);
                if (!(previouslyWithin) && within) {
                    previouslyWithin = true;
                    md.text = "Hello";
                    md.open();
                } else if (previouslyWithin && !(within)) {
                    previouslyWithin = false;
                    md.text = "Goodbye";
                    md.open();
                } else if (previouslyWithin && within) {
                    // they were previously within, and still are
                    previouslyWithin = true;
                    return;
                } else if (!(previouslyWithin) && !(within)) {
                    // they were not previously within, and still are not
                    return;
                }
            }
        }

        Graphic {
            id: graphic
            geometry: poly
            symbol: SimpleFillSymbol {
                color: "red"
                style: Enums.SimpleFillSymbolStyleSolid
                outline: SimpleLineSymbol {
                    color: "black"
                    width: 4
                    style: Enums.SimpleLineSymbolStyleDash
                }
            }
        }

        Polygon {
            id: poly
            json: {"rings":[[[-13046212.520199999,4036277.4038000032],[-13046212.520199999,4036650.7616999969],[-13046176.962400001,4036650.7616999969],[-13046176.962400001,4036277.4038000032],[-13046212.520199999,4036277.4038000032]]],"spatialReference":{"wkid":102100,"latestWkid":3857}}
        }

        MessageDialog {
            id: md
        }

        NavigationToolbar {
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                margins: 15
            }
        }
    }
}

