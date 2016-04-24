import QtQuick 2.5
import "scripts.js" as Scripts

Grid {
    property bool horizontal: false
    property string dir: "none"
    property int added: 0

    id: root
    columns: horizontal ? playground.columns / 2 : 1
    rows: horizontal ? 1 : playground.rows / 2

    rotation: {
        if(root.dir === "north") return 180;
        else if(root.dir === "west") return 180;
        else return 0;
    }

    Connections {
        target: playground
        onClearRequestChanged: {
            for(var i = 0; i < children.length; i++) {
                if(children[i].objectName === "dropPlace") {
                    var dropIndex = children[i].propertyIndex;
                    if(!children[i].containsStop) {
                        listModel.remove(dropIndex);
                        i--;
                    }
                }
            }
            listModel.append({});
        }
        onCheckChanged: {   // NOTE - možná se tahle šílenost nemusí provádět zde
            var preChecked = false;
            var postChecked = false;
            var preLongitude = 0;
            var preLatitude = 0;

            // nejprve projdu dropAreas
            for(var nIterOutChildren = 0; nIterOutChildren < children.length && !postChecked; nIterOutChildren++) {
                if(children[nIterOutChildren].objectName === "dropPlace") {
                    var dropStop = children[nIterOutChildren];

                    for(var nIterInnerChildren = 0; nIterInnerChildren < dropStop.children.length; nIterInnerChildren++) {
                        if(dropStop.children[nIterInnerChildren].objectName === "tramStop") {
                            var nModelIndex = dropStop.children[nIterInnerChildren].modelIndex;
                            console.log("found", dataModel.data[nModelIndex].name)

                            // tímhle získám zastávku před
                            if(dropStop.propertyIndex === 0) {
                                preLatitude = playground.latitude;
                                preLongitude = playground.longitude;
                                console.log("zero index", preLatitude, preLongitude)
                            }

                            // zkontroluji pozici
                            var goodPlacement = false;
                            if(dropStop.children[nIterInnerChildren].canBeDrag || preChecked) {
                                // teď bych měl mít poslední vloženou zastávku (TODO - co to udělá, pokud jsem zastávku neumístil?)
                                console.log("found to check", dataModel.data[nModelIndex].name, dataModel.data[nModelIndex].added, dataModel.data[nModelIndex].latitude, dataModel.data[nModelIndex].longitude)

                                if(dir === "north" || dir === "south") {
                                    goodPlacement = Scripts.checkCoordinates(dir, preLatitude, dataModel.data[nModelIndex].latitude)
                                }
                                else if(dir === "west" || dir === "east") {
                                    goodPlacement = Scripts.checkCoordinates(dir, preLongitude, dataModel.data[nModelIndex].longitude)
                                }
                                if(!goodPlacement) {
                                    console.log("first, bad place of", dataModel.data[nModelIndex].name)
                                    playground.draggedRect.color = Qt.rgba(255, 0, 0, 0.8)
                                }
                                if(preChecked) {
                                    postChecked = true;
                                }

                                preChecked = true;
                                console.log("prechecked done");
                                preLatitude = dataModel.data[nModelIndex].latitude;
                                preLongitude = dataModel.data[nModelIndex].longitude;

                            }
                            preLatitude = dataModel.data[nModelIndex].latitude;
                            preLongitude = dataModel.data[nModelIndex].longitude;
                            console.log("other index", preLatitude, preLongitude)
                        }
                    }

                }
            }
        }
    }

    ListModel {
        id: listModel
        ListElement {
            // the first DropStop for TramStop
            noWarningRole: true // when deleted, the warning "All ListElement declarations are empty" is set
        }
    }

    Repeater {
        model: listModel
        delegate: DropStop {
            width: cellWidth
            height: cellHeight
            rotation: {if(root.dir === "north") return 180;
                else if(root.dir === "west") return 180;
                else return 0;
            }
        }
    }

    move: Transition {
           NumberAnimation { properties: "x,y"; duration: animationLenght / 5}
    }
}
