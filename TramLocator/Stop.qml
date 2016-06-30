import QtQuick 2.0

Rectangle {
    id: root

    signal stopSet()
    property bool set: false

    property string name: "+"
    property real latitude: 0
    property real longitude: 0

    property color setColor: "darkblue"

    border.width: 1

    color: mouseArea.containsMouse ? setColor : "transparent"

    Behavior on color {ColorAnimation {duration: 200}}

    states: [
        State {
            name: "active"
            PropertyChanges {
                target: root
                color: root.setColor
            }
        }
    ]

    Behavior on x {
        enabled: root.set
        NumberAnimation {
            easing.type: Easing.InOutQuint
            duration: 800
        }
    }

    Behavior on y {
        enabled: root.set
        NumberAnimation {
            easing.type: Easing.InOutQuint
            duration: 800
        }
    }

    Connections {
        target: qmlRoot
        onStateChanged: {
            if(qmlRoot.state === "" && root.state === "active") {
                if(qmlRoot.selectedStop !== null) {
                    root.name = qmlRoot.selectedStop.name
                    root.latitude = qmlRoot.selectedStop.latitude
                    root.longitude = qmlRoot.selectedStop.longitude
                    root.set = true
                    root.stopSet()
                }
                root.state = ""
            }
        }
    }

    Text {
        id: text
        anchors.fill: parent
        font.pixelSize: 20
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
        text: root.name
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent

        onClicked: {
            /*
                - na kliknutí zavolám menu
                - zároveň chci vědět, která z těchto dvou komponent událost vyvolala
                - po skrytí menu chci vzít qmlRoot.selectedStop a dosadit ji do kompomenty, která vyvolala událost
            */
            root.state = "active"
            qmlRoot.state = "list"
        }
    }
}
