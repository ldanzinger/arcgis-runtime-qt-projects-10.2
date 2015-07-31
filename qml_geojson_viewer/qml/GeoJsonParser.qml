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

/*-------------------------------------------------------------------------------

  GeoJSON Parser

  *Author:
  Lucas Danzinger

  *Purpose:
  - Converts GeoJSON features to Esri Features. Takes in a GeoJSON
  file as the "source" property. Returns a list of Esri Feature objects that
  can be added to a GraphicsLayer. Wait for the featuresParsed() signal to
  fire before adding the output features to the GraphicsLayer. The output
  Esri Feature contains both the Geometry and Attributes from the GeoJSON.
  - Supports Points, MultiPoints, LineStrings, MultiLineStrings, Polygons, and
  MultiPolygons.
  - Marker, Line, and Fill symbols can be specified to define how the features
  display on the map. Default symbols will be used if nothing is specified.

  *Limitations:
  - This is written in QML and thus runs in the main UI thread.
  Smaller files and less complex geometry will still load very quickly,
  but larger files with extremely detailed geometry may take several seconds
  to load.
  - Support for GeoJSON files of type "GeometryCollection" has not yet been added
  - Only supports WGS 1984 and WGS 1984 Web Mercator

-------------------------------------------------------------------------------*/

import QtQuick 2.3
import ArcGIS.Runtime 10.26
import ArcGIS.Extras 1.0

Item {
    property string source
    property var featureList: []
    property var markerSymbol
    property var lineSymbol
    property var fillSymbol
    property SpatialReference sr
    signal featuresParsed

    FileFolder {
        id: geoJsonFile
    }

    function loadGeoJsonFeatures() {
        var geoJson = geoJsonFile.readJsonFile(source);
        parseGeoJsonFeatures(geoJson)
    }

    function parseGeoJsonFeatures(geoJson) {
        // check for coordinate system
        sr = ArcGISRuntime.createObject("SpatialReference");
        if (geoJson["crs"]) {
            if (geoJson["crs"] === "urn:ogc:def:crs:EPSG::3857" || geoJson["crs"]["properties"]["name"] === "EPSG:3857") {
                sr.wkid = 102100;
            }
        } else {
            sr.wkid = 4326;
        }

        if (geoJson["type"] === "FeatureCollection") {
            var features = geoJson["features"];
            for (var i in features) {
                var feature = features[i];
                var geometry = feature["geometry"];
                var attributes = feature["properties"];

                switch(geometry["type"]) {
                case "Point":
                    constructPoint(feature);
                    break;
                case "MultiPoint":
                    constructMultiPoint(feature);
                    break;
                case "LineString":
                    constructLineString(feature);
                    break;
                case "MultiLineString":
                    constructMultiLineString(feature);
                    break;
                case "Polygon":
                    constructPolygon(feature);
                    break;
                case "MultiPolygon":
                    constructMultiPolygon(feature);
                    break;
                }
            }
        }

        featuresParsed(featureList);
    }

    function constructPoint(feature) {
        var coords = feature["geometry"]["coordinates"];
        var pt = ArcGISRuntime.createObject("Point");
        pt.spatialReference = sr;
        pt.setXY(coords[0],coords[1]);
        var graphic = ArcGISRuntime.createObject("Graphic");
        if (!markerSymbol)
            markerSymbol = ArcGISRuntime.createObject("SimpleMarkerSymbol", {color: "blue", size: 12});
        graphic.symbol = markerSymbol;
        graphic.geometry = pt;
        if (feature["properties"])
            graphic.attributes = feature["properties"];
        featureList.push(graphic);
    }

    function constructMultiPoint(feature) {
        var coords = feature["geometry"]["coordinates"];
        var mpt = ArcGISRuntime.createObject("MultiPoint");
        mpt.spatialReference = sr;

        for (var xy in coords) {
            var pt = ArcGISRuntime.createObject("Point");
            pt.spatialReference = sr;
            pt.setXY(coords[xy][0],coords[xy][1]);
            mpt.add(pt);
        }

        var graphic = ArcGISRuntime.createObject("Graphic");
        if (!markerSymbol)
            markerSymbol = ArcGISRuntime.createObject("SimpleMarkerSymbol", {color: "blue", size: 12});
        graphic.symbol = markerSymbol;
        graphic.geometry = mpt;
        if (feature["properties"])
            graphic.attributes = feature["properties"];
        featureList.push(graphic);
    }

    function constructLineString(feature) {
        var coords = feature["geometry"]["coordinates"];
        var line = ArcGISRuntime.createObject("Polyline");
        line.spatialReference = sr;
        for (var i in coords) {
            var xy = coords[i];
            if (i === "0")
                line.startPath(xy[0], xy[1]);
            else
                line.lineTo(xy[0], xy[1]);
        }
        var graphic = ArcGISRuntime.createObject("Graphic");
        if (!lineSymbol)
            lineSymbol = ArcGISRuntime.createObject("SimpleLineSymbol", {color: "red", width: 2});
        graphic.symbol = lineSymbol;
        graphic.geometry = line;
        if (feature["properties"])
            graphic.attributes = feature["properties"];
        featureList.push(graphic);
    }

    function constructMultiLineString(feature) {
        var coords = feature["geometry"]["coordinates"]
        var line = ArcGISRuntime.createObject("Polyline");
        line.spatialReference = sr;
        for (var i in coords) {
            var multipart = coords[i];
            for (var mpart in multipart) {
                var xy = multipart[mpart];
                if (mpart === "0")
                    line.startPath(xy[0], xy[1]);
                else
                    line.lineTo(xy[0], xy[1]);
            }
        }
        var graphic = ArcGISRuntime.createObject("Graphic");
        if (!lineSymbol)
            lineSymbol = ArcGISRuntime.createObject("SimpleLineSymbol", {color: "red", width: 2});
        graphic.symbol = lineSymbol;
        graphic.geometry = line;
        if (feature["properties"])
            graphic.attributes = feature["properties"];
        featureList.push(graphic);
    }

    function constructPolygon(feature) {
        var coords = feature["geometry"]["coordinates"];
        var ply = ArcGISRuntime.createObject("Polygon");
        ply.spatialReference = sr;
        for (var i in coords) {
            var part = coords[i];
            for (var coord in part) {
                var xy = part[coord]
                if (coord === "0")
                    ply.startPath(xy[0], xy[1]);
                else
                    ply.lineTo(xy[0], xy[1]);
            }
        }
        var graphic = ArcGISRuntime.createObject("Graphic");
        if (!fillSymbol) {
            fillSymbol = ArcGISRuntime.createObject("SimpleFillSymbol", {color: "green"});
            fillSymbol.outline = ArcGISRuntime.createObject("SimpleLineSymbol", {color: "black", width: 1});
        }
        graphic.symbol = fillSymbol;
        graphic.geometry = ply;
        if (feature["properties"])
            graphic.attributes = feature["properties"];
        featureList.push(graphic);
    }

    function constructMultiPolygon(feature) {
        var coords = feature["geometry"]["coordinates"]
        var ply = ArcGISRuntime.createObject("Polygon");
        ply.spatialReference = sr;
        for (var i in coords) {
            var multipart = coords[i];
            for (var mpart in multipart) {
                for (var part in multipart[mpart]) {
                    var xy = multipart[mpart][part];
                    if (part === "0")
                        ply.startPath(xy[0], xy[1]);
                    else
                        ply.lineTo(xy[0], xy[1]);
                }
            }
        }
        var graphic = ArcGISRuntime.createObject("Graphic");
        if (!fillSymbol) {
            fillSymbol = ArcGISRuntime.createObject("SimpleFillSymbol", {color: "green"});
            fillSymbol.outline = ArcGISRuntime.createObject("SimpleLineSymbol", {color: "black", width: 1});
        }
        graphic.symbol = fillSymbol;
        graphic.geometry = ply;
        if (feature["properties"])
            graphic.attributes = feature["properties"];
        featureList.push(graphic);
    }
}
