import QtQuick 2.0

Item
{
    id: root

    property real verticalDistance: -1
    property real horizontalDistance: -1

    opacity: root.verticalDistance < 0 ? 0 : 1

    Behavior on opacity {NumberAnimation{duration: 400}}

    Text {
        id: textVertialArrow
        height: parent.height / 2
        width: parent.height

        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 16
        text: "↕"
    }

    Text {
        id: textHorizontalArrow
        height: parent.height / 2
        width: parent.height
        anchors.top: textVertialArrow.bottom

        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 16
        text: "↔"
    }

    Text {
        id: textVerticalDistance

        height: parent.height / 2
        anchors.left: textVertialArrow.right
        anchors.right: parent.right

        horizontalAlignment: Text.AlignRight
        font.pixelSize: 16
        text: root.verticalDistance + " m"
    }
    Text {
        id: textHorizontalDistance

        height: parent.height / 2
        anchors.top: textVerticalDistance.bottom
        anchors.left: textHorizontalArrow.right
        anchors.right: parent.right

        horizontalAlignment: Text.AlignRight
        font.pixelSize: 16
        text: root.horizontalDistance + " m"
    }
}
