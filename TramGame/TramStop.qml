import QtQuick 2.5

Rectangle {
    property string sourceDir: "none"
    property int sourceIndex: -1

    id: root
    color: Qt.rgba(255, 0, 0, 0.5)

    Rectangle {
        property bool enableAnimation: true

        id: draggedItem

        x: (root.width - width) / 2
        y: (root.height - height) / 2
        width: root.width * 0.8;
        height: root.height * 0.8;

        color: Qt.rgba(Math.random(), Math.random(), Math.random(), 1)

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
                    playground.draggedRect = root;
                    if(draggedItem.Drag.target !== null) {
                        root.sourceIndex = draggedItem.Drag.target.propertyIndex;
                        // umístění obdelníku nad obdelník draggedItem tak, aby se neskrýval pod komponenty OneDirection (řeší z-index)
                        var positionOffset = root.mapToItem(playground);
//                        globalTramStop.x = Qt.binding(function() {return positionOffset.x + draggedItem.x})
//                        globalTramStop.y = Qt.binding(function() {return positionOffset.y + draggedItem.y})
//                        globalTramStop.color = draggedItem.color
//                        globalTramStop.visible = true
                    }
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
                    // do nothing
                    console.log("do nothing")
                }
                else if(!draggedItem.Drag.target.containsStop && playground.draggedRect.sourceDir !== draggedItem.Drag.target.propertyDir) {

                    console.log("new position")
                    var dropPos = playground.mapFromItem(draggedItem.Drag.target);
                    var dragPos = playground.mapFromItem(draggedItem)

                    root.x = root.y = 0;
                    root.parent = draggedItem.Drag.target   // reparentuje mouseareu

                    draggedItem.enableAnimation = false
                    draggedItem.x = dragPos.x - dropPos.x;
                    draggedItem.y = dragPos.y - dropPos.y;
                    draggedItem.enableAnimation = true
                }
//                if(draggedItem.Drag.target !== null && playground.draggedRect.sourceDir !== draggedItem.Drag.target.propertyDir)
//                {
//                    globalTramStop.visible = false  // TODO - pri pusteni zastavky se zastavka (TramStop) skryje pod komponentu OneDirection
//                }
                draggedItem.x = (root.width - width) / 2;
                draggedItem.y = (root.height - height) / 2;
                playground.clearRequest = !playground.clearRequest;

                // pokud byla zastávka položena do některého směru, urči, který směr to je
                if(draggedItem.Drag.target !== null) {
                    root.sourceDir = draggedItem.Drag.target.propertyDir;
                    root.sourceIndex = draggedItem.Drag.target.propertyIndex;
                }
                playground.theFirstDrag = true;
            }
        }
    }
}
