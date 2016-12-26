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
        target: playgroundRoot
        onStateChanged: {
            if(playgroundRoot.state === "" && root.state === "active") {
                if(playgroundRoot.selectedStop !== null) {
                    root.name = playgroundRoot.selectedStop.name
                    root.latitude = playgroundRoot.selectedStop.latitude
                    root.longitude = playgroundRoot.selectedStop.longitude
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
        preventStealing: true
        onClicked: {
            /*
                - na kliknutí zavolám menu
                - zároveň chci vědět, která z těchto dvou komponent událost vyvolala
                - po skrytí menu chci vzít playgroundRoot.selectedStop a dosadit ji do kompomenty, která vyvolala událost
            */
            root.state = "active"
            playgroundRoot.state = "list"
        }
    }
}
