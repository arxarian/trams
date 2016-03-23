import QtQuick 2.0

DropArea {
    property bool containsStop: children.length > 1
    property int propertyIndex: index
    property int propertyCount: listModel.count
    property bool canPlace: index < propertyCount - 1
    property bool clearRequest: false

    id: dragTarget

    objectName: "dropPlace"


    Connections {
        target: playground
        onClearRequestChanged:  added = 0;
    }

    onEntered: {
        if(children[1] !== playground.draggedRect && added < 1) {
            listModel.insert(index, {erasable: true});
            added++;
        }
    }

    onExited: {
        if(!containsStop && erasable) {
            added--;
            listModel.remove(index);
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
