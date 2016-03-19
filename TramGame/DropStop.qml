import QtQuick 2.0

DropArea {
    property bool containsStop: children.length > 1

    id: dragTarget

    Rectangle {
        id: dropRectangle

        anchors.fill: parent
        color: "green"
        border.width: 1
        border.color: "gold"

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
