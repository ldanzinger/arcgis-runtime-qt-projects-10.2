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
import QtQuick.Controls.Styles 1.2
import ArcGIS.Runtime 10.26

Rectangle {
    id: searchRect
    color: "#333333"
    opacity: .95

    property bool isBusy: false;
    property string resultText;

    MouseArea {
        anchors.fill: parent
        onClicked: mouse.accepted = true;
    }

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
                searchRect.closeWindow()
            }
        }
    }

    function resetValues() {
        breweryText.text = "";
    }

    function closeWindow() {
        searchWindow.height = 0;
    }

    Column {
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            margins: 10 * scaleFactor
        }
        spacing: 10 * scaleFactor

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                color: "white"
                text: "Search Breweries"

                font {
                    family: "Segoe UI"
                    pixelSize: 22 * scaleFactor
                }
                renderType: Text.QtRendering
            }
        }


        TextField {
            id: breweryText
            width: 250 * scaleFactor
            placeholderText: "ex: Stone Brewing"
        }

        Button {
            id: breweryQueryBtn
            width: 250 * scaleFactor
            text: "Search for Breweries"
            onClicked: {
                if (breweryText.text.length > 0) {
                    isBusy = true;
                    ft.queryBreweries(breweryText.text);
                }
            }
        }

        Row {
            id: resultsText
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                color: "white"
                text: resultText

                font {
                    family: "Segoe UI"
                    pixelSize: 14 * scaleFactor
                }
                renderType: Text.QtRendering
            }
        }
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        visible: isBusy
    }
}
