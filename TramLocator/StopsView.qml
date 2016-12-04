import QtQuick 2.0

Item {   // Stops-List Wrapper
    id: root

    Rectangle {
        id: line
//        width: 1
        height: parent.height
        color: "black"
    }

    Rectangle {
        color: Qt.rgba(qmlRoot.redColor.r, qmlRoot.redColor.g, qmlRoot.redColor.b, 0.91)
        anchors.left: line.right
        width: parent.width
        height: parent.height

        ListView {
            id: list
            anchors.fill: parent
            model: dataModel
            maximumFlickVelocity: 7500
            delegate: MouseArea {
                width: root.width
                height: root.height / 17

                onClicked: {
                    clickAnimation.start();
                    playgroundRoot.selectedStop = dataModel.get(index)
                }

                SequentialAnimation {
                    id: clickAnimation
                    ColorAnimation {target: rect; property: "color"; from: "#2e472e"; to: rect.color}
                }

                Rectangle {
                    id: rect
                    anchors.fill: parent
                    color: "transparent"
                }

                Text {
                    anchors.fill: parent
                    anchors.leftMargin: parent.width * 0.05
                    verticalAlignment: Text.AlignVCenter
                    color: qmlRoot.lightColor
                    font.pixelSize: 18
                    text: name
                }
            }
        }
    }
}
