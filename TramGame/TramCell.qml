import QtQuick 2.0
import "qrc:/scripts.js" as Scripts

Rectangle {

//    property bool movable: true
//    property color borderColor: "gold"
//    property string text: "none"
//    property string dir: "none"
    property int allowedIndex: 1

    id: root
    height: cellHeight
    width: cellWidth
    color: "transparent"
    border.width: 1
    border.color: hidden ? "#700000ff" : "#70ff0000"

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        drag.target: delegate

        enabled: !hidden
        visible: !hidden

        onReleased: {
            if(playground.canDrop) {
                console.log("ok", index, allowedIndex)
                parent = delegate.Drag.target !== null ? delegate.Drag.target : root
//            }
                //            if(lastDir !== "none") {
                playground.cellPlaced = !playground.cellPlaced;
            }
        }

        Rectangle {

            id: delegate
//            visible: !hidden
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            width: mouseArea.width * 0.8
            height: mouseArea.height * 0.8
            radius: 10
            border.width: 2
            border.color: "darkgreen"

            Drag.active: mouseArea.drag.active
            Drag.hotSpot.x: root.width / 2
            Drag.hotSpot.y: root.height / 2

////            onParentChanged: {
////                draggedItem = delegate
////                draggedItem.parent = playground
////            }

            Text {
                anchors.centerIn: parent
                text: name
            }

//            Behavior on x {NumberAnimation {duration: 300}}
//            Behavior on y {NumberAnimation {duration: 300}}
//        }

            states: State {
                when: mouseArea.drag.active
                PropertyChanges {target: playground; dragActive: true}
                StateChangeScript { script: {draggedItem = delegate; removeCell = true/* timerActive = true*/; console.log("")}}
                ParentChange { target: delegate; parent: playground }
                AnchorChanges { target: delegate; anchors.verticalCenter: undefined; anchors.horizontalCenter: undefined }
            }
        }
    }
}
