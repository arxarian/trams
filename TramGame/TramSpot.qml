import QtQuick 2.0

DropArea {
    property bool containsStop: children.length > 1
//    signal dropState(bool active)

//    property int allowedIndex: 1

    id: dropTarget

    objectName: "dropPlace"

    onContainsDragChanged: {
//        if(containsDrag) {
////            playground.karma++;
//            listModel.insert(index, {});
//        }
//        else playground.karma--;
//        if(index < allowedIndex) {
//            playground.canDrop = true;
//            dropState(containsDrag);
//        }
//        else {
//            playground.canDrop = false;
//        }
    }

    Rectangle {
        id: rect
        anchors.fill: parent
        color: "#707070ff"

        states: [
            State {
                when: dropTarget.containsDrag/* && index < allowedIndex*/
                PropertyChanges {
                    target: rect
                    color: "grey"
                }
            }
        ]

        Behavior on color {ColorAnimation{duration: playground.animationLenght}}
    }
}

