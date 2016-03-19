import QtQuick 2.0

Item {
    id: root

    Rectangle {
        property bool enableAnimation: true

        id: draggedItem

        z: root.z
        x: (root.width - width) / 2
        y: (root.height - height) / 2
        width: root.width * 0.8;
        height: root.height * 0.8;

        color: "blue"

//        onXChanged: console.log(x, y)

        Drag.active: mouseArea.drag.active
        Drag.hotSpot.x: width / 2
        Drag.hotSpot.y: height / 2

        states: State {
            when: mouseArea.drag.active
            ParentChange {
                target: draggedItem;
                parent: root
            }
            StateChangeScript {
                script: {
                    root.z = ++playground.globalZ   // TODO nefunguje
                }
            }
        }

        Behavior on x {
            enabled: draggedItem.enableAnimation;
            NumberAnimation {
                easing.type: Easing.OutBounce
                duration: playground.animationLenght
            }
        }
        Behavior on y {
            enabled: draggedItem.enableAnimation;
            NumberAnimation {
                easing.type: Easing.OutBounce
                duration: playground.animationLenght
            }
        }

        MouseArea {
            id: mouseArea

            anchors.fill: parent
            drag.target: draggedItem
            onReleased: {
                draggedItem.enableAnimation = false

                var dropPos = playground.mapFromItem(draggedItem.Drag.target);
                var dragPos = playground.mapFromItem(draggedItem)

                root.x = root.y = 0;

                root.parent = draggedItem.Drag.target !== null ? draggedItem.Drag.target : root  // reparentuje mouseareu
                draggedItem.x = dragPos.x - dropPos.x;
                draggedItem.y = dragPos.y - dropPos.y;

                draggedItem.enableAnimation = true

                draggedItem.x = (root.width - width) / 2//Qt.binding(function() {return (mouseArea.width - tile.width) / 2});
                draggedItem.y = (root.height - height) / 2//Qt.binding(function() {return (mouseArea.height - tile.height) / 2});
            }
        }
    }
}
