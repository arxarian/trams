import QtQuick 2.0

Rectangle {
    property string sourceDir: "none"
    property int sourceIndex: 0

    id: root
    color: Qt.rgba(255, 0, 0, 0.5)

    Rectangle {
        function restoreBinding() {
            draggedItem.x = Qt.binding(function() {return (root.x + (root.width - width) / 2)})
            draggedItem.y = Qt.binding(function() {return (root.y + (root.height - height) / 2)})
        }

        property bool enableAnimation: true

        id: draggedItem

        parent: root.parent
//        z: root.z
        width: root.width * 0.8;
        height: root.height * 0.8;

        color: Qt.rgba(Math.random(), Math.random(), Math.random(), 1)

        Drag.active: mouseArea.drag.active
        Drag.hotSpot.x: width / 2
        Drag.hotSpot.y: height / 2

        Component.onCompleted: restoreBinding();

        states: State {
            when: mouseArea.drag.active
//            ParentChange {
//                target: draggedItem;
//                parent: root
//            }
            StateChangeScript {
                script: {
                    playground.draggedRect = root;
//                    playground.lastDir = "none";
                    if(draggedItem.Drag.target !== null) {
                        root.sourceDir = draggedItem.Drag.target.propertyDir;
                        root.sourceIndex = draggedItem.Drag.target.propertyIndex
                    }

//                    root.z = ++playground.globalZ   // TODO nefunguje
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
                if(draggedItem.Drag.target === null/* || !draggedItem.Drag.target.canPlace*/)
                {
                    draggedItem.restoreBinding();
                    // do nothing
                }
                else if(!draggedItem.Drag.target.containsStop) {
//                    var dropPos = playground.mapFromItem(draggedItem.Drag.target);
//                    var dragPos = playground.mapFromItem(draggedItem)

//                    root.x = root.y = 0;
//                    root.parent = draggedItem.Drag.target   // reparentuje mouseareu

//                    draggedItem.restoreBinding();
//                    draggedItem.enableAnimation = false
//                    draggedItem.x = dragPos.x - dropPos.x;
//                    draggedItem.y = dragPos.y - dropPos.y;
//                    draggedItem.enableAnimation = true
                }
//                draggedItem.x = (root.width - width) / 2//Qt.binding(function() {return (mouseArea.width - tile.width) / 2});
//                draggedItem.y = (root.height - height) / 2//Qt.binding(function() {return (mouseArea.height - tile.height) / 2});
                playground.clearRequest = !playground.clearRequest;
            }
        }
    }
}
