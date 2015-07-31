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

Rectangle {
    height: 50 * scaleFactor
    color: "#005d9a"

    Text {
        anchors.centerIn: parent
        color: "white"
        text: "San Diego Breweries"

        font {
            family: "Segoe UI"
            pixelSize: 24 * scaleFactor
        }
        renderType: Text.QtRendering
    }
}
