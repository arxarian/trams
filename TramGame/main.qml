import QtQuick 2.5
import QtQuick.Window 2.2

Window {
    property bool containsStop: false

    id: globalRoot

    visible: true
    width: 550
    height: 550
    color: "black"

//    Item {
//        width: 200; height: 200

//        DropArea {
//            x: 75; y: 75
//            width: 50; height: 50

//            Rectangle {
//                anchors.fill: parent
//                color: (parent.containsDrag || containsStop) ? "green" : "gold"

//                Behavior on color {ColorAnimation{duration: 200}}
//            }
//        }

//        Rectangle {
//            x: 10; y: 10
//            width: 40; height: 40
//            color: "red"

//            Drag.active: dragArea.drag.active
//            Drag.hotSpot.x: width/2
//            Drag.hotSpot.y: height/2

//            MouseArea {
//                id: dragArea
//                anchors.fill: parent
//                drag.target: parent
//            }
//        }
//    }

    CatchMe {
    }

//****************
//    Playground {
//        id: playground
//        anchors.fill: parent
//    }
//****************

//    Rectangle {
//        width: 100
//        height: 100
//        anchors.bottom: parent.bottom
//        color: "silver"
//        Text {
//            anchors.centerIn: parent
//            text: "new card"
//        }

//        MouseArea {
//            anchors.fill: parent
//            onClicked: playground.newCard = !playground.newCard
//        }
//    }

//    Rectangle {
//        width: 100
//        height: 100
//        anchors.bottom: parent.bottom
//        anchors.right: parent.right
//        color: "silver"
//        Text {
//            anchors.centerIn: parent
//            text: "check positions"
//        }

//        MouseArea {
//            anchors.fill: parent
//            onClicked: playground.check = !playground.check
//        }
//    }
}

