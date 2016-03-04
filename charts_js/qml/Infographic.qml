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
import jbQuick.Charts 1.0
import "QChart.js" as Charts

Rectangle {
    id: infoGraphicRect
    color: "transparent"

    signal dataUpdated()

    onDataUpdated: {
        chart_bar.repaint();
    }

    Component.onCompleted: {
        barChartData = {
            labels: ["Arson","Rape","Grand Theft","Theft","Homicide","Robbery","Burglary", "Assault"],
            datasets: [{
                    fillColor: "rgba(0, 115, 153, 0.5)",
                    strokeColor: "rgba(0, 115, 153, 1)",
                    data: [0,0,0,0,0,0,0,0]
                }]
        };

        pieChartData = [{
                            value: 0,
                            color: "#4daf4a"
                        },
                        {
                            value: 0,
                            color: "#e41a1c"
                        },
                        {
                            value: 0,
                            color: "#377eb8"
                        }];
    }

    Column {
        spacing: 15 * scaleFactor

        Column {
            spacing: 0

            Row {
                spacing: 15 * scaleFactor

                Text {
                    text: "Total Population:"
                    font {
                        family: "sanserif"
                        pointSize: 24
                        italic: true
                    }
                }

                Text {
                    text: pop2012 === 0 ? "" : pop2012
                    font {
                        family: "sanserif"
                        pointSize: 24
                        italic: true
                    }
                }

                Image {
                    visible: pop2010 > 0
                    width: 20 * scaleFactor
                    height: 25 * scaleFactor
                    source: pop2012 > pop2010 ? "qrc:///Resources/Up.png" : "qrc:///Resources/Down.png"
                }
            }

            Row {
                Rectangle {
                    height: 300 * scaleFactor
                    width: infoGraphicRect.width

                    Chart {
                        id: chart_pie
                        anchors {
                            verticalCenter: parent.verticalCenter
                            right: parent.right
                            margins: 25 * scaleFactor
                        }

                        width: parent.width * .55
                        height: width
                        chartAnimated: true
                        chartAnimationEasing: Easing.OutBounce
                        chartAnimationDuration: 1000
                        chartData: pieChartData
                        chartType: Charts.ChartType.PIE
                    }

                    Column {
                        anchors {
                            left: parent.left
                            top: parent.top
                            bottom: parent.bottom
                            margins: 15 * scaleFactor
                        }
                        height: parent.height
                        width: 200
                        spacing: 10
                        Text {
                            text: "Housing Characteristics"
                        }
                        ListView {
                            height: 200
                            width: 200
                            model: demographicListModel
                            delegate: legendDelegate
                        }
                    }
                }
            }
        }

        Column {
            spacing: 0
            Row {
                spacing: 15 * scaleFactor

                Text {
                    text: "Total Crimes (May 2015):"
                    font {
                        family: "sanserif"
                        pointSize: 24
                        italic: true
                    }
                }

                Text {
                    text: totalCrime === 0 ? "" : totalCrime
                    font {
                        family: "sanserif"
                        pointSize: 24
                        italic: true
                    }
                }
            }

            Row {
                Rectangle {
                    height: 300 * scaleFactor
                    width: infoGraphicRect.width

                    Chart {
                        id: chart_bar
                        anchors.fill: parent
                        chartAnimated: true
                        chartAnimationEasing: Easing.OutBounce
                        chartAnimationDuration: 1000
                        chartData: barChartData
                        chartType: Charts.ChartType.BAR
                    }
                }
            }
        }

        Column {
            spacing: 0
            Text {
                text: "Data Credits"
                font {
                    family: "sanserif"
                    bold: true
                }
            }

            Text {
                text: "-Demographic data provided by the US Census Bureau through Esri Data & Maps"
                font {
                    pointSize: 12
                    family: "sanserif"
                }
            }
            Text {
                text: "-Crime data from last 30 days acquired from LA County Sheriff's Dept\nData obtained from LA County Sheriff only (does not include LAPD or other local precincts)\nhttp://egis3.lacounty.gov/dataportal/2012/03/05/crime-data-la-county-sheriff/"
                font {
                    pointSize: 12
                    family: "sanserif"
                }
            }
        }

        ListModel {
            id: demographicListModel
            ListElement {
                legendLabel: "Owner Occupied"
                legendColor: "#4daf4a"
            }
            ListElement {
                legendLabel: "Renter Occupied"
                legendColor: "#e41a1c"
            }
            ListElement {
                legendLabel: "Vacant"
                legendColor: "#377eb8"
            }            
        }

        Component {
            id: legendDelegate
            Item {
                width: parent.width
                height: 30 * scaleFactor

                Row {
                    spacing: 10
                    Rectangle {
                        color: legendColor
                        width: 20 * scaleFactor
                        height: width
                        radius: 2
                    }
                    Row {
                        anchors.verticalCenter: parent.verticalCenter
                        Text {
                            text: legendLabel
                        }
                    }
                }
            }
        }
    }
}
