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
import QtCharts 2.0

Rectangle {
    id: infoGraphicRect
    color: "transparent"

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

                    ChartView {
                        id: chart
                        title: "Population by Race"
                        anchors.fill: parent
                        legend {
                            alignment: Qt.AlignLeft
                            backgroundVisible: true
                        }
                        antialiasing: true
                        animationOptions: ChartView.AllAnimations

                        PieSeries {
                            id: pieSeries
                            PieSlice { label: "White"; value: white; color: "#F7464A" }
                            PieSlice { label: "Black"; value: black; color: "#46BFBD" }
                            PieSlice { label: "Asian"; value: asian; color: "#4D5360" }
                            PieSlice { label: "Hawaiian"; value: hawaiian; color: "#FDB45C" }
                            PieSlice { label: "Hispanic"; value: hispanic; color: "#005d9a" }
                            PieSlice { label: "Native American"; value: nativeAmerican; color: "#FFCCCC" }
                            PieSlice { label: "Other"; value: pop2012 - (white + black + asian + hawaiian + hispanic + nativeAmerican); color: "#6E256E" }

                            onHovered: {
                                if (state === true) {
                                    slice.labelVisible = true;
                                    slice.exploded = true;
                                } else {
                                    slice.exploded = false;
                                    slice.labelVisible = false;
                                }
                            }
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

                    ChartView {
                        id: barChart
                        title: "Crime in the last 30 Days"
                        anchors.fill: parent
                        legend {
                            alignment: Qt.AlignLeft
                            backgroundVisible: true
                        }
                        antialiasing: true
                        animationOptions: ChartView.AllAnimations

                        BarSeries {
                            axisX: BarCategoryAxis { categories: ["Type of Crime"] }
                            BarSet { label: "Arson"; values: totalCrime === 0 ? [1] : [arson]; }
                            BarSet { label: "Rape"; values: totalCrime === 0 ? [1] : [rape]; }
                            BarSet { label: "Grand Theft"; values: totalCrime === 0 ? [1] : [grandTheft]; }
                            BarSet { label: "Theft"; values: totalCrime === 0 ? [1] : [theft]; }
                            BarSet { label: "Homicide"; values: totalCrime === 0 ? [1] : [criminalHomicide]; }
                            BarSet { label: "Robbery"; values: totalCrime === 0 ? [1] : [robbery]; }
                            BarSet { label: "Burglary"; values: totalCrime === 0 ? [1] : [burglary]; }
                            BarSet { label: "Assault"; values: totalCrime === 0 ? [1] : [assault]; }
                            barWidth: 1
                            axisY: ValueAxis { max: 250; min: 0; tickCount: 6}
                        }
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
    }
}

