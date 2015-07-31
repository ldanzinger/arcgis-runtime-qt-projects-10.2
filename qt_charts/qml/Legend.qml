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

import QtQuick 2.0

Rectangle {
    width: 310
    height: 225
    color: "lightgrey"
    radius: 5
    border {
        width: 1.5
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
        spacing: 5
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: 10
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
                pointSize: 12
            }
        }

        Row {
            spacing: 15
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
            spacing: 15
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
            spacing: 15
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
            spacing: 15
            Image {
                anchors.verticalCenter: parent.verticalCenter
                source: legendImage3
            }
            Text {
                anchors.verticalCenter: parent.verticalCenter
                text: legendLabel3
            }
        }

        Row {
            spacing: 15
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
            spacing: 15
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
            spacing: 15
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
            spacing: 15
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

