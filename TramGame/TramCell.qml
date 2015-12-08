import QtQuick 2.0
import "qrc:/scripts.js" as Scripts

Rectangle {

    property bool movable: false
//    property color borderColor: "gold"
//    property string text: "none"
//    property string dir: "none"
    property int allowedIndex: 1
    property alias pressed: mouseArea.pressed

    id: root
    height: cellHeight
    width: cellWidth
    color: "transparent"
    border.width: 1
    border.color: hidden ? "#700000ff" : "#70ff0000"

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        drag.target: movable ? delegate : undefined

        enabled: !hidden
        visible: !hidden

//        onPressedChanged: console.log("pressed", pressed);

        onReleased: {
            if(playground.canDrop) {
                parent = delegate.Drag.target !== null ? delegate.Drag.target : root
            }
        }

        Rectangle {

            id: delegate
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

            Text {
                anchors.centerIn: parent
                text: name
            }

//            Behavior on x {NumberAnimation {duration: 300}}
//            Behavior on y {NumberAnimation {duration: 300}}

            states: State {
                when: mouseArea.drag.active
//                PropertyChanges {target: playground; dragActive: true}
                ParentChange { target: delegate; parent: playground }
                AnchorChanges { target: delegate; anchors.verticalCenter: undefined; anchors.horizontalCenter: undefined }
            }
        }
    }
}
