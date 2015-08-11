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

