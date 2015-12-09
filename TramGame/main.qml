import QtQuick 2.5
import QtQuick.Window 2.2

Window {
    id: globalRoot

    visible: true
    width: 800
    height: 800
    color: "black"

    Playground {
        id: playground
        anchors.fill: parent
    }

    Rectangle {
        width: 100
        height: 100
        anchors.bottom: parent.bottom
        color: "silver"
        Text {
            anchors.centerIn: parent
            text: "new card"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: playground.newCard = !playground.newCard
        }
    }

    Rectangle {
        width: 100
        height: 100
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        color: "silver"
        Text {
            anchors.centerIn: parent
            text: "check positions"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: playground.check = !playground.check
        }
    }
}

