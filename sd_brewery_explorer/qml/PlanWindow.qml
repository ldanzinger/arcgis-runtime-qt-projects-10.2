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
    id: planRect
    color: "#333333"
    opacity: .95

    MouseArea {
        anchors.fill: parent
        onClicked: mouse.accepted = true;
    }

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
                planRect.closeWindow();
            }
        }
    }

    function closeWindow() {
        planWindow.height = 0;
    }

    Column {
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            margins: 10 * scaleFactor
        }
        spacing: 10 * scaleFactor

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            Text {
                color: "white"
                text: "Plan Your Trip"

                font {
                    family: "Segoe UI"
                    pixelSize: 22 * scaleFactor
                }
                renderType: Text.QtRendering
            }

        }

        Column {
            Text {
                color: "white"
                text: "Number of breweries to visit (max 10)"

                font {
                    family: "Segoe UI"
                    pixelSize: 14 * scaleFactor
                }
                renderType: Text.QtRendering
            }
            TextField {
                id: numberOfBreweries
                width: 250 * scaleFactor
                placeholderText: "ex: 3"
            }
        }

        Column {
            Text {
                color: "white"
                text: "Starting address"

                font {
                    family: "Segoe UI"
                    pixelSize: 14 * scaleFactor
                }
                renderType: Text.QtRendering
            }

            ComboBox {
                id: cboStartingAddress
                model: ["Address","Current Location"]
                width: 250 * scaleFactor
                onCurrentTextChanged: {
                    if (currentText === "Current Location") {
                        map.zoomTo(map.positionDisplay.mapPoint);
                    }
                }
            }

            TextField {
                id: startingAddress
                width: 250 * scaleFactor
                placeholderText: "ex: 18 5th St, San Diego, CA"
                visible: cboStartingAddress.currentText === "Address"
            }
        }

        Column {
            Text {
                color: "white"
                text: "Distance from starting point (miles)"

                font {
                    family: "Segoe UI"
                    pixelSize: 14 * scaleFactor
                }
                renderType: Text.QtRendering
            }
            TextField {
                id: breweryDistance
                width: 250 * scaleFactor
                placeholderText: "ex: 5"
            }
        }

        Row {
            spacing: 25
            CheckBox {
                id: breweryDogs
                style: CheckBoxStyle {
                    label: Text {
                        color: "white"
                        text: "Dog Friendly"

                        font {
                            family: "Segoe UI"
                            pixelSize: 14 * scaleFactor
                        }
                        renderType: Text.QtRendering
                    }
                }
            }

            CheckBox {
                id: breweryFood
                style: CheckBoxStyle {
                    label: Text {
                        color: "white"
                        text: "Serves Food"

                        font {
                            family: "Segoe UI"
                            pixelSize: 14 * scaleFactor
                        }
                        renderType: Text.QtRendering
                    }
                }
            }
        }

        Button {
            width: 250 * scaleFactor
            text: "Plan My Trip"
            onClicked: {
                var newPlan = {};
                newPlan["Radius"] = breweryDistance.text;
                newPlan["Dogs"] = breweryDogs.checked ? 1 : 0;
                newPlan["Food"] = breweryFood.checked ? 1 : 0;
                newPlan["Address"] = cboStartingAddress.currentText === "Address" ? startingAddress.text : "MapPoint";
                newPlan["Number"] = numberOfBreweries.text;
                ft.planTheTrip(newPlan);
            }
        }
    }
}
