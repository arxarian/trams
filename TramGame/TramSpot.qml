import QtQuick 2.0

DropArea {
    signal dropState(bool active)

    property int allowedIndex: 1

    id: dropTarget

    onContainsDragChanged: {
        if(index < allowedIndex) {
            playground.canDrop = true;
            dropState(containsDrag);
        }
        else {
            playground.canDrop = false;
        }
    }

    Rectangle {
        id: rect
        anchors.fill: parent
        color: "#70707070"
//        border.width: 1
//        border.color: "gold"

        states: [
            State {
                when: dropTarget.containsDrag && index < allowedIndex
                PropertyChanges {
                    target: rect
                    color: "grey"
                }
                StateChangeScript {
                    script: console.log("dropArea", index, "\n")
                }
            }
        ]
    }
}

