import QtQuick 2.0

MouseArea {
    id: delegate

    drag.target: parent
    drag.axis: Drag.XandYAxis

    Rectangle {
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width * 0.8
        height: parent.height * 0.8
        radius: 10
        border.width: 2
        border.color: "darkgreen"

        Text {
            anchors.centerIn: parent
            text: name
        }
    }
}
