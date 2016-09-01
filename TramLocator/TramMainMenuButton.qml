import QtQuick 2.0

Rectangle {
    id: root

    signal clicked()
    property string text: "no text entered"
    property color textColor: "black"
    property color buttonColor: "gray"

//    border.width: 1
    color: mouseArea.containsMouse ? buttonColor : "transparent"

    Behavior on color {ColorAnimation {duration: 100}}

    Text {
        anchors.centerIn: parent
        text: root.text
        font.pixelSize: 20
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
