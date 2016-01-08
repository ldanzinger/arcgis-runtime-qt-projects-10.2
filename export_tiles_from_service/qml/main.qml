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
import ArcGIS.Extras 1.0

ApplicationWindow {
    id: appWindow
    width: 800
    height: 600
    title: "ExportTiles"

    property string outputTpkPath: "~/TPKs/WorldImagery.tpk"

    Map {
        id: map
        anchors.fill: parent

        ArcGISTiledMapServiceLayer {
            url: "http://services.arcgisonline.com/arcgis/rest/services/World_Imagery/MapServer"
        }
    }

    Column {
        spacing: 10

        anchors {
            left: parent.left
            top: parent.top
            margins: 10
        }

        TextField {
            id: minScaleTextBox
            placeholderText: "Min LOD (ex: 0)"
            width: 175
        }

        TextField {
            id: maxScaleTextBox
            placeholderText: "Max LOD (ex: 5)"
            width: 175
        }

        Button {
            text: "Export"
            width: 175
            onClicked: {
                console.log("fetching map service info");
                serviceInfoTask.fetchMapServiceInfo();
            }
        }
    }


    Text {
        anchors {
            right: parent.right
            top: parent.top
            margins: 10
        }
        color: "white"
        style: Text.Outline
        text: "Scale: " + Math.round(map.mapScale)
    }

    ExportTileCacheParameters {
        id: taskParams
        extent: map.extent
        recompressTileCache: true
        recompressionQuality: 75
    }

    ExportTileCacheTask {
        id: exportTask
        url: "http://tiledbasemaps.arcgis.com/arcgis/rest/services/World_Imagery/MapServer"
        credentials: UserCredentials {
            oAuthClientInfo: oauthinfo
        }

        onExportStatusChanged: {
            if (exportStatus === Enums.ExportStatusCompleted) {
                console.log("export complete!");
                var tiledLayer = ArcGISRuntime.createObject("ArcGISLocalTiledLayer", {path: outputTpkPath});
                map.reset();
                map.addLayer(tiledLayer);
            } else if (exportStatus === Enums.ExportStatusErrored) {
                console.log("export error...");
                for (var i = 0; i < tileCacheErrors.length; i++) {
                    console.log("error", i, ":", tileCacheErrors[i]);
                }
            } else if (exportStatus === Enums.ExportStatusInProgress) {
                console.log("Export in Progress...")
            }
        }

        onEstimateStatusChanged: {
            if (estimateStatus === Enums.EstimateStatusCompleted) {
                var estimate = estimatedSize;
                var estString;
                if ( estimate < 1048576 )
                    estString = (estimate/1024).toString() + " kb";
                else if ( estimate >= 1048576  && estimate < 1073741824)
                    estString = ((estimate/1024)/1024).toString() + " mb";
                else if ( estimate >= 1073741824)
                    estString = (((estimate/1024)/1024)/1024).toString() + " gb";
                console.log("Estimated size : " + estString);
                exportTask.exportTileCache(taskParams, outputTpkPath);
            }
        }
        onTileCacheJobStatusChanged: {
            console.log(tileCacheJobStatus.statusString);
        }
    }

    ServiceInfoTask {
        id: serviceInfoTask
        url: exportTask.url
        credentials: UserCredentials {
            oAuthClientInfo: OAuthClientInfo {
                id: oauthinfo
                clientId: "your_client_id"
                clientSecret: "your_client_secret"
                oAuthMode: Enums.OAuthModeApp
            }
        }

        onMapServiceInfoStatusChanged: {
            if (mapServiceInfoStatus === Enums.MapServiceInfoStatusCompleted) {
                console.log("Service info received");
                taskParams.initialize(mapServiceInfo);
                console.log("Estimating size...");
                taskParams.minLevelOfDetail = minScaleTextBox.text;
                taskParams.maxLevelOfDetail = maxScaleTextBox.text;
                exportTask.estimateTileCacheSize(taskParams);
            } else if (mapServiceInfoStatus === Enums.MapServiceInfoStatusErrored){
                console.log("Error:", mapServiceInfoError.message);
            }
        }
    }

    Rectangle {
        id: openingWindow
        anchors.fill: parent
        color: "black"
        opacity: .8

        Column {
            anchors.centerIn: parent
            spacing: 5

            Text {
                text: "Zoom to the desired extent,\nenter the desired min/max LOD,\nand press the Export button"
                color: "white"
                width: 175
                wrapMode: Text.WordWrap
            }

            Button {
                text: "Ok"
                width: 175

                onClicked: {
                    openingWindow.visible = false;
                }
            }
        }
    }
}

