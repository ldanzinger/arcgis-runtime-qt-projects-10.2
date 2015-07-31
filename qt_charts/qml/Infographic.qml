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
import QtCharts 2.0

Rectangle {
    id: infoGraphicRect
    color: "transparent"

    Column {
        spacing: 15

        Column {
            spacing: 0

            Row {
                spacing: 15

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
                    width: 20
                    height: 25
                    source: pop2012 > pop2010 ? "qrc:///Resources/Up.png" : "qrc:///Resources/Down.png"
                }
            }

            Row {
                Rectangle {
                    height: 300
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
                spacing: 15

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
                    height: 300
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

