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
    color: "#F5F5F5"

    border {
        color: "#B2B2B2"
        width: .75
    }

    Image {
        id: searchButton
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
            leftMargin: 35 * scaleFactor
        }
        clip: true
        height: 40 * scaleFactor
        width: 40 * scaleFactor
        source: "qrc:/Resources/ic_menu_find_light_d.png"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                searchWindow.height = 150 * scaleFactor;
            }
        }
    }

    Image {
        id: editButton
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
        clip: true
        height: 40 * scaleFactor
        width: 40 * scaleFactor
        source: "qrc:/Resources/ic_menu_editmap_light_d.png"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                editWindow.height = 350 * scaleFactor;
            }
        }
    }

    Image {
        id: planButton
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
            rightMargin: 35 * scaleFactor
        }
        clip: true
        height: 40 * scaleFactor
        width: 40 * scaleFactor
        source: "qrc:/Resources/ic_menu_newmap_light_d.png"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                planWindow.height = 325 * scaleFactor;
            }
        }
    }
}

