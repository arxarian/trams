import QtQuick 2.0
import "qrc:/scripts.js" as Scripts

Rectangle {
//    signal clicked(int x, int y)

    property bool movable: true
    property color borderColor: "gold"
//    property string text: "none"
    property string dir: "none"

    id: root
    height: cellHeight
    width: cellWidth
    color: "transparent"
    border.width: 1
    border.color: "#70ff0000"

    MouseArea{
        id: mouseArea
        anchors.fill: parent
        drag.target: movable ? delegate : undefined

        onReleased: timerActive = false

//        onClicked: root.clicked(mouseX, mouseY)

        onPressed: {
            var mapped = delegate.mapToItem(playground, 0, 0);
            playground.lastDir = Scripts.getDir(mapped.x, mapped.y).dir
//            console.log("pressed", playground.lastDir, mapped.x, mapped.y)
        }

        Rectangle {
            id: delegate
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            width: mouseArea.width * 0.8
            height: mouseArea.height * 0.8
            radius: 10
            border.width: 2
            border.color: borderColor

            Text {
                anchors.centerIn: parent
                text: name
            }

//            Behavior on x {NumberAnimation {duration: 1000}}
//            Behavior on y {NumberAnimation {duration: 1000}}
        }

        states: State {
            when: mouseArea.drag.active
            StateChangeScript { script: {draggedItem = delegate; timerActive = true/*; lastIndex = index*/}}
            ParentChange { target: delegate; parent: playground }
            AnchorChanges { target: delegate; anchors.verticalCenter: undefined; anchors.horizontalCenter: undefined }
        }

    }

}
