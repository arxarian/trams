import QtQuick 2.5

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
//                    console.log("index", dropIndex, listModel.get(dropIndex).erasable, !children[i].containsStop)
                    if(/*listModel.get(dropIndex).erasable && */!children[i].containsStop) {
//                        console.log("delete", dropIndex);
                        listModel.remove(dropIndex);
                        i--;
                    }
                }
            }
            listModel.append({});
        }
    }

    ListModel {
        id: listModel
        ListElement {
            erasable: false
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
