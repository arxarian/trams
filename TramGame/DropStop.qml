import QtQuick 2.0

DropArea {
    id: dragTarget

    Rectangle {
        id: dropRectangle

        anchors.fill: parent
        color: "green"
        border.width: 1
        border.color: "gold"

        states: [
            State {
                when: dragTarget.containsDrag
                PropertyChanges {
                    target: dropRectangle
                    color: "grey"
                }
            }
        ]
    }
}
