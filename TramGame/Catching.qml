import QtQuick 2.0

DropArea {
    id: dragTarget

    Rectangle {
        id: rect
        anchors.fill: parent
        color: "maroon"

        states: [
            State {
                when: dragTarget.containsDrag
                PropertyChanges {
                    target: rect
                    color: "grey"
                }
            }
        ]
    }
}
