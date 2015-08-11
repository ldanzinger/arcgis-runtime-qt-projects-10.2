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
