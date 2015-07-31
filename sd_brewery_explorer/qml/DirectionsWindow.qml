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
import QtQuick.Controls.Styles 1.1

Rectangle {
    id: directionsRect
    color: "#333333"
    opacity: .95

    property ListModel directionsModel

    Behavior on height {
        NumberAnimation { duration: 250 }
    }

    Image {
        id: collapseButton
        anchors {
            left: parent.left
            top: parent.top
            margins: 5 * scaleFactor
        }
        clip: true
        height: 35 * scaleFactor
        width: 35 * scaleFactor
        source: "qrc:/Resources/ic_menu_collapsed_dark.png"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                directionsRect.closeWindow();
            }
        }
    }

    function closeWindow() {
        directionsWindow.height = 0;
    }

    Row {
        id: titleRow
        anchors{
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            margins: 10 * scaleFactor
        }
        Text {
            color: "white"
            text: "Trip Directions"

            font {
                family: "Segoe UI"
                pixelSize: 22 * scaleFactor
            }
            renderType: Text.QtRendering
        }

    }

    ListView {
        anchors {
            top: titleRow.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: 10 * scaleFactor
        }
        clip: true
        model: directionsModel
        delegate: Text {
            text: direction
            wrapMode: Text.WordWrap
            color: "white"
            font {
                family: "Segoe UI"
                pixelSize: 14 * scaleFactor
            }
            renderType: Text.QtRendering
        }
    }
}
