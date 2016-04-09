import QtQuick 2.5

Rectangle { // tento je hýbán časovačem
    id: item
    width: 50
    height: 50
    color: "gold"

    Rectangle { // tento chytnu
        function restoreBinding() {
            draggedItem.x = Qt.binding(function() {return item.x})
            draggedItem.y = Qt.binding(function() {return item.y})
        }

        id: draggedItem
        parent: item.parent
        width: item.width
        height: item.height

        Behavior on x {
            NumberAnimation {
                easing.type: Easing.OutBounce;duration: 800
            }
        }
        Behavior on y {
            NumberAnimation {
                easing.type: Easing.OutBounce;duration: 800
            }
        }
        Drag.active: mouseArea.drag.active
        Drag.hotSpot.x: width / 2
        Drag.hotSpot.y: height / 2
        Drag.onActiveChanged: {
            if(mouseArea.drag.active) {
                draggedItem.x = item.x
                draggedItem.y = item.y
                console.log("broken");
            }
            else {
                restoreBinding();
                console.log("restored");
            }
        }

        Component.onCompleted: restoreBinding();

        MouseArea {
            id: mouseArea
            width: item.width
            height: item.height
            drag.target: draggedItem
        }
    }
    Timer {
        interval: 1500
        repeat: true
        running: true
        onTriggered: {
            console.log("triggered")
            item.x = Math.random() * globalRoot.width
            item.y = Math.random() * globalRoot.height
        }
    }
}
