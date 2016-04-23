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
        onCheckChanged: {
//            console.log("checking", dir)
            // TODO - compare all or only the new one?
//            var theLastInnerChildren = -1;
            var lastLongitude = 0;
            var lastLatitude = 0;
            for(var nIterOutChildren = 0; nIterOutChildren < children.length; nIterOutChildren++) {
                if(children[nIterOutChildren].objectName === "dropPlace") {
                    var dropStop = children[nIterOutChildren];

                    for(var nIterInnerChildren = 0; nIterInnerChildren < dropStop.children.length; nIterInnerChildren++) {
                        if(dropStop.children[nIterInnerChildren].objectName === "tramStop") {
                            var nModelIndex = dropStop.children[nIterInnerChildren].modelIndex;
//                            console.log("found", dataModel.data[nModelIndex].name)
                            var goodPlacement = false;

                            if(dropStop.propertyIndex === 0) {
                                // compare with the middle card
//                                console.log("comparing playground", dir, playground.latitude, playground.longitude, dataModel.data[nModelIndex].name)
                                if(dir === "north" || dir === "south") {
                                    goodPlacement = Scripts.checkCoordinates(root.dir, playground.latitude, dataModel.data[nModelIndex].latitude)
                                }
                                else if(dir === "west" || dir === "east") {
                                    goodPlacement = Scripts.checkCoordinates(root.dir, playground.longitude, dataModel.data[nModelIndex].longitude)
                                }
                                if(!goodPlacement) {
                                    console.log("first, bad place of", dataModel.data[nModelIndex].name)
                                }
                            }
                            else {
                                // compare the rest
//                                console.log("comparing", dir, lastLatitude, lastLongitude, dataModel.data[nModelIndex].name)
                                if(dir === "north" || dir === "south") {
                                    goodPlacement = Scripts.checkCoordinates(root.dir, lastLatitude, dataModel.data[nModelIndex].latitude)
                                }
                                else if(dir === "west" || dir === "east") {
                                    goodPlacement = Scripts.checkCoordinates(root.dir, lastLongitude, dataModel.data[nModelIndex].longitude)
                                }

                                if(!goodPlacement) {
                                    console.log("second, bad place of", dataModel.data[nModelIndex].name)
                                }
                            }
                            lastLatitude = dataModel.data[nModelIndex].latitude;
                            lastLongitude = dataModel.data[nModelIndex].longitude;
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
