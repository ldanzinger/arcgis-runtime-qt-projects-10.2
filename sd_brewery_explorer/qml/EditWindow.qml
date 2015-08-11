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
    id: editRect
    color: "#333333"
    opacity: .95

    property bool isBusy: false

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
                editRect.closeWindow();
            }
        }
    }

    function closeWindow() {
        editWindow.height = 0;
    }

    function resetValues() {
        breweryDogs.checked = false;
        breweryFood.checked = false;
        breweryHours.text = "";
        breweryPhone.text = "";
        breweryAddress.text = "";
        breweryName.text = "";
        breweryCity.text = "";
        breweryZip.text = "";
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
                text: "Add New Brewery"

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
                text: "Brewery Name"

                font {
                    family: "Segoe UI"
                    pixelSize: 14 * scaleFactor
                }
                renderType: Text.QtRendering
            }
            TextField {
                id: breweryName
                width: 250 * scaleFactor
                placeholderText: "ex: Luke's Brewing"
            }
        }

        Column {
            Text {
                color: "white"
                text: "Address"

                font {
                    family: "Segoe UI"
                    pixelSize: 14 * scaleFactor
                }
                renderType: Text.QtRendering
            }
            TextField {
                id: breweryAddress
                width: 250 * scaleFactor
                placeholderText: "ex: 18 5th St"
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10

            Column {
                Text {
                    color: "white"
                    text: "City"

                    font {
                        family: "Segoe UI"
                        pixelSize: 14 * scaleFactor
                    }
                    renderType: Text.QtRendering
                }
                TextField {
                    id: breweryCity
                    width: 120 * scaleFactor
                    placeholderText: "ex: San Diego"
                }
            }

            Column {
                Text {
                    color: "white"
                    text: "Zip Code"

                    font {
                        family: "Segoe UI"
                        pixelSize: 14 * scaleFactor
                    }
                    renderType: Text.QtRendering
                }
                TextField {
                    id: breweryZip
                    width: 120 * scaleFactor
                    placeholderText: "ex: 92101"
                }
            }
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10

            Column {
                Text {
                    color: "white"
                    text: "Phone Number"

                    font {
                        family: "Segoe UI"
                        pixelSize: 14 * scaleFactor
                    }
                    renderType: Text.QtRendering
                }
                TextField {
                    id: breweryPhone
                    width: 120 * scaleFactor
                    placeholderText: "ex: 234-123-9873"
                }
            }

            Column {
                Text {
                    color: "white"
                    text: "Hours Open"

                    font {
                        family: "Segoe UI"
                        pixelSize: 14 * scaleFactor
                    }
                    renderType: Text.QtRendering
                }
                TextField {
                    id: breweryHours
                    width: 120 * scaleFactor
                    placeholderText: "12pm - 10pm"
                }
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
            text: "Submit new Brewery"
            onClicked: {
                var newFeat = {};
                newFeat["Dogs"] = breweryDogs.checked ? 1 : 0;
                newFeat["Food"] = breweryFood.checked ? 1 : 0;
                newFeat["Hours"] = breweryHours.text;
                newFeat["Phone"] = breweryPhone.text;
                newFeat["Address"] = breweryAddress.text;
                newFeat["Name"] = breweryName.text;
                newFeat["City"] = breweryCity.text;
                newFeat["Zip"] = breweryZip.text;
                ft.addNewBrewery(newFeat);
            }
        }
    }
}
