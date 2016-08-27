import QtQuick 2.0

Rectangle {  // Stops-List Wrapper
    id: root
    color: qmlRoot.redColor

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
                qmlRoot.selectedStop = dataModel.get(index)
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
