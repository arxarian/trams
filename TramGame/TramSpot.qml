import QtQuick 2.0

DropArea {
    property int propertyIndex: index
    property var model: undefined

    id: dropTarget

    Rectangle {
        id: rect
        anchors.fill: parent
        color: "#70707070"

        states: [
            State {
                when: dropTarget.containsDrag
                PropertyChanges {
                    target: rect
                    color: "grey"
                }
                StateChangeScript {
                    script: console.log("dropArea", index)
                }
            }
        ]

        Behavior on color {ColorAnimation{duration: playground.animationLenght}}
    }
}

