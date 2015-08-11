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
