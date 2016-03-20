import QtQuick 2.0

DropArea {
    property bool containsStop: children.length > 1

    id: dragTarget

    onEntered: {
        console.log(erasable)
        if((!erasable || containsStop) && children[1] !== playground.draggedRect) {
            console.log("adding to", index)
            listModel.insert(index, {erasable: true});
        }
    }

    onExited: {
        if(/*listModel.count > 1*/erasable && !containsStop) {
            console.log("deleting from", index)
            listModel.remove(index, 1)
        }
    }

    Rectangle {
        id: dropRectangle

        anchors.fill: parent
        color: Qt.rgba(255, 0, 0, 0.2)
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
                when: dragTarget.containsDrag && !containsStop
                PropertyChanges {
                    target: dropRectangle
                    color: "grey"
                }
            }
        ]
    }
}
