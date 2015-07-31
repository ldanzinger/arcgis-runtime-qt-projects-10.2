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
    width: 160 * scaleFactor
    height: 50 * scaleFactor
    color: "white"
    radius: 5
    opacity: .9
    border {
        color: "black"
        width: 2
    }

    property string breweryName
    property string breweryNumber

    Text {
        id: breweryNameText
        anchors {
            top: parent.top
            left: parent.left
            margins: 5 * scaleFactor
        }
        width: parent.width - anchors.margins
        color: "black"
        text: breweryName
        elide: Text.ElideRight
        font {
            family: "Segoe UI"
            pixelSize: 12 * scaleFactor
        }
        renderType: Text.QtRendering
    }

    Text {
        anchors {
            left: parent.left
            top: breweryNameText.bottom
            margins: 5 * scaleFactor
        }
        color: "#005d9a"
        text: breweryNumber

        font {
            family: "Segoe UI"
            pixelSize: 12 * scaleFactor
        }
        renderType: Text.QtRendering

        MouseArea {
            anchors.fill: parent
            onClicked: {
                Qt.openUrlExternally("tel:%1".arg(breweryNumber));
            }
        }
    }
}
