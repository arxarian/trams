import QtQuick 2.0
import "qrc:/scripts.js" as Scripts

Rectangle {

    property bool movable: true//playground.lastIndex === index && playground.lastDir === dir
    property string dir: "none"
    property int modelIndex: -1

    id: root
    height: cellHeight
    width: cellWidth
    color: "red"//playground.lastDir === dir && playground.lastIndex === index && !playground.goodPlace ? "darkred" : "transparent"
//    border.width: 1
//    border.color: hidden ? "#700000ff" : "#70ff0000"

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        drag.target: movable ? delegate : null

        onReleased: {
            console.log("propertyIndex", delegate.Drag.target, playground.dragTarget)
            // zde parentovat na to, co se objeví v playgroud jako parrent
            root.parent = delegate.Drag.target !== null ? playground.dragTarget : root
            playground.clearRequest = !playground.clearRequest
        }

//        onClicked: console.log(/*"movable", movable, "lastIndex", lastIndex, "index", index, "lastDir", lastDir, "dir", dir*/ "show info!")

        Rectangle {

            id: delegate
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            x: mouseArea.width * 0.1
            y: mouseArea.height * 0.1
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
                height: parent.height * 0.95
                width: parent.width * 0.95
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                text: modelIndex === -1 ? "" : dataModel.data[modelIndex].name
                wrapMode: Text.WordWrap
            }

//            Behavior on x {NumberAnimation {duration: 300}}
//            Behavior on y {NumberAnimation {duration: 300}}

            states: State {
                when: mouseArea.drag.active
                ParentChange { target: delegate; parent: playground }
                AnchorChanges { target: delegate; anchors.verticalCenter: undefined; anchors.horizontalCenter: undefined }
            }
        }
    }
}
