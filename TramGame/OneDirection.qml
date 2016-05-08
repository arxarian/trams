import QtQuick 2.0
import "qrc:/scripts.js" as Scripts

Item {
    property int layourDir: Qt.RightToLeft
    property int layoutOrient: Qt.Horizontal
    property int verticalLayout: ListView.TopToBottom
    property int cells: (playground.columns - 1) / 2
    property string dir: "left"

    id: root

    Connections {
        target: playground
        onClearRequestChanged: {
            var freeDropPlaces = 0;
            for(var i = 0; i < children.length; i++) {
                var grandChilder = children[i].children[0];
                for(var j = 0; j < grandChilder.children.length; j++) {
                    if(grandChilder.children[j].objectName === "dropPlace") {
                        if(!grandChilder.children[j].containsStop) {
                            freeDropPlaces++;
                        }
                    }
                }
            }
            if(freeDropPlaces === 0) {
                dropModel.append({});
            }
        }
    }

    ListModel {
        id: dropModel
        ListElement {
            // the first DropStop for TramStop
            noWarningRole: true // when deleted, the warning "All ListElement declarations are empty" is set
        }
    }

    ListView {  // DROP AREA
        objectName: "dropListView"
        anchors.fill: parent
        layoutDirection: root.layourDir
        orientation: root.layoutOrient
        verticalLayoutDirection: root.verticalLayout
        interactive: false
        model: dropModel
        delegate: TramSpot {
            width: cellWidth
            height: cellHeight
//            allowedIndex: root.deck.count + 1 - Scripts.canRemove(root.deck)

//            onDropState: {
//                console.log(root.dir, index, active)

//                if(active) { // pořadí nezaručeno?!

//                    if((lastDir !== root.dir || playground.karma == 1)/* && !cellMoving*/) {
//                        if(index < root.deck.count + 1) {
//                            root.deck.insert(index, {name: "", hidden: true})
//                        }
//                        lastDir = root.dir;
//                    }
//                    else if(lastDir === root.dir) {
////                        console.log("from", lastIndex, "to", index)
//                        root.deck.move(lastIndex, index, 1)
//                    }
//                    lastIndex = index
//                }
//                else {
//                    if(root.dir !== root.dir || (playground.karma == 0 && firstPlacementActive)) {
//                        console.log("should remove", index, "lastDir", lastDir, "can remove", Scripts.canRemove(root.deck),"dir", playground.dir,"removed")
//                            root.deck.remove(index);
//                    }
//                    lastDir = root.dir;
//                }
//            }
        }
    }
}

