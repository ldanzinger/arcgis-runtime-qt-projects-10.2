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
