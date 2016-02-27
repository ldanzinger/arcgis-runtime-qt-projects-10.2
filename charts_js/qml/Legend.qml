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

import QtQuick 2.0

Rectangle {
    width: 275 * scaleFactor
    height: 225 * scaleFactor
    color: "lightgrey"
    radius: 5
    border {
        width: 1.5 * scaleFactor
        color: "black"
    }

    property string legendLabel0: ""
    property string legendImage0: ""
    property string legendLabel1: ""
    property string legendImage1: ""
    property string legendLabel2: ""
    property string legendImage2: ""
    property string legendLabel3: ""
    property string legendImage3: ""
    property string legendLabel4: ""
    property string legendImage4: ""
    property string legendLabel5: ""
    property string legendImage5: ""
    property string legendLabel6: ""
    property string legendImage6: ""
    property string legendLabel7: ""
    property string legendImage7: ""

    MouseArea {
        anchors.fill: parent
        onClicked: mouse.accepted
    }

    Column {
        spacing: 5 * scaleFactor
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: 10 * scaleFactor
        }

        Text {
            text: "Legend"
            font {
                bold: true
                family: "sanserif"
            }
        }
        Text {
            text: "Median Household Income (2012)"
            font {
                family: "sanserif"
                pixelSize: 12 * scaleFactor
            }
        }

        Row {
            spacing: 15 * scaleFactor
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: legendImage0
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: legendLabel0
            }
        }

        Row {
            spacing: 15 * scaleFactor
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: legendImage1
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: legendLabel1
            }
        }

        Row {
            spacing: 15 * scaleFactor
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: legendImage2
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: legendLabel2
            }
        }

        Row {
            spacing: 15 * scaleFactor
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: legendImage3
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: legendLabel3.substring(0,19)
            }
        }

        Row {
            spacing: 15 * scaleFactor
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: legendImage4
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: legendLabel4
            }
        }

        Row {
            spacing: 15 * scaleFactor
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: legendImage5
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: legendLabel5
            }
        }

        Row {
            spacing: 15 * scaleFactor
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: legendImage6
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: legendLabel6
            }
        }

        Row {
            spacing: 15 * scaleFactor
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: legendImage7
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: legendLabel7
            }
        }
    }
}

