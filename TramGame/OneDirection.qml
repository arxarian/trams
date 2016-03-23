import QtQuick 2.5

Grid {
    property bool horizontal: false
    property string dir: "none"
    property int added: 0

    id: root
    columns: horizontal ? 4 : 1
    rows: horizontal ? 1 : 4

    layoutDirection: root.dir === "west" ? Qt.RightToLeft : Qt.LeftToRight
    rotation: root.dir === "north" ? 180 : 0

    Connections {
        target: playground
        onClearRequestChanged: {
            for(var i = 0; i < children.length; i++) {
                if(children[i].objectName === "dropPlace") {
                    var dropIndex = children[i].propertyIndex;
//                    console.log("index", dropIndex, listModel.get(dropIndex).erasable, !children[i].containsStop)
                    if(listModel.get(dropIndex).erasable && !children[i].containsStop) {
//                        console.log("delete", dropIndex);
                        listModel.remove(dropIndex);
                        i--;
                    }

                }
            }
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
            rotation: root.dir === "north" ? 180 : 0
        }
    }
}
