import QtQuick 2.0

DropArea {
    property bool containsStop: children.length > 1
    property int propertyIndex: index
    property int propertyCount: listModel.count
    property bool canPlace: index < propertyCount - 1
    property bool clearRequest: false
    property string propertyDir: dir

    id: dragTarget

    objectName: "dropPlace"

    Connections {
        target: playground
        onClearRequestChanged: added = 0;
    }

    onEntered: {
        console.log("entered", index)
        if(children[1] !== playground.draggedRect && added < 1) {
            console.log("lol", playground.draggedRect.sourceDir, dir)
            if(!playground.theFirstDrag)
            {
                if(playground.draggedRect.sourceDir !== dir && canPlace) {
                    console.log("creating", index)
                    listModel.insert(index, {});
                    added++;
                }
                else if(canPlace && playground.draggedRect.sourceIndex !== index) {
                    var tempIndex = index;
                    listModel.move(playground.draggedRect.sourceIndex, index, 1);
                    playground.draggedRect.sourceIndex = tempIndex;
                }
            }
        }
        playground.theFirstDrag = false;
    }

    onExited: {
//        console.log(propertyIndex, propertyDir, !containsStop, erasable, !containsStop && erasable)
        if(!containsStop && canPlace) {
            console.log("deleting", index)
            added--;
            listModel.remove(index);
//            playground.clearRequest = !playground.clearRequest;
        }
    }

    Rectangle {
        id: dropRectangle

        anchors.fill: parent
        color: "skyblue"//Qt.rgba(255, 0, 0, 0.2)
        border.width: 1
        border.color: "gold"

        Text {
            anchors.centerIn: parent
            font.pixelSize: 20
            color: "yellow"
            text: index
        }

        states: [
            State {
                when: dragTarget.containsDrag && !containsStop && playground.draggedRect.sourceDir !== dir
                PropertyChanges {
                    target: dropRectangle
                    color: "grey"//canPlace ? "grey" : "green"
                }
            }
        ]
    }
}
