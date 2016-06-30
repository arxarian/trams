import QtQuick 2.5
import QtQuick.Window 2.2

Window {
    visible: true
    width: 480
    height: 800
    title: qsTr("Tram Locator")
//    visibility: Window.FullScreen

    Item {
        id: qmlRoot

        property color redColor: "#e20401"
        property color lightColor: "#fdfdf0"
        property var selectedStop: null

        function compareStops() {
            if(stop1.set && stop2.set) {
                // nastavit cílové souřadnice a rotovat přes střed?
                if(stop1.latitude > stop2.latitude) {
                    // severnejsí
                    stop1.y = 0;
                    stop2.y = playground.height - stop2.height
                }
                else if(stop1.latitude < stop2.latitude) {
                    // jiznejsi
                    stop1.y = playground.height - stop1.height
                    stop2.y = 0;
                }
                else {
                    // stejná
                    stop1.y = playground.height / 2 - stop1.height / 2
                    stop2.y = playground.height / 2 - stop2.height / 2;
                }
                if(stop1.longitude > stop2.longitude) {
                    // vychodnejsi
                    stop1.x = playground.width - stop1.width
                    stop2.x = 0;

                }
                else if(stop1.longitude < stop2.longitude) {
                    // zapadnejsi
                    stop1.x = 0;
                    stop2.x = playground.width - stop2.width
                }
                else {
                    // stejná
                    stop1.x = playground.width / 2 - stop1.width / 2
                    stop2.x = playground.width / 2 - stop2.width / 2;
                }
            }
        }

        anchors.fill: parent
        states: [
            State {
                name: "list"
                PropertyChanges {
                    target: desktop
                    x: -listWrapper.width
                }
            }
        ]

        onSelectedStopChanged: state = ""

        Connections {
            target: stop1
            onStopSet: qmlRoot.compareStops()
        }

        Connections {
            target: stop2
            onStopSet: qmlRoot.compareStops()
        }

        Rectangle {
            id: desktop
            width: parent.width
            height: parent.height
            color: qmlRoot.lightColor

            MouseArea {
                z: 1
                enabled: qmlRoot.state === "list"
                anchors.fill: parent
                onClicked: {
                    qmlRoot.selectedStop = null
                    qmlRoot.state = ""
                }
            }

            Item {
                id: playground
                anchors.centerIn: parent
                width: Math.min(parent.width, parent.height) * 0.75
                height: width

                Stop {
                    id: stop1
                    width: parent.width * 0.4
                    height: width
                    setColor: qmlRoot.redColor
                }

                Stop {
                    id: stop2
                    x: playground.width - width
                    y: playground.height - height
                    width: parent.width * 0.4
                    height: width
                    setColor: qmlRoot.redColor
                }
            }

            Behavior on x {NumberAnimation {duration: 200}}
        }

        Item {
            id: listWrapper
            width: parent.width * 0.6
            height: parent.height
            anchors.left: desktop.right

            ListView {
                id: list
                anchors.fill: parent
                model: dataModel
                maximumFlickVelocity: 7500
                delegate: MouseArea {
                    width: listWrapper.width
                    height: listWrapper.height / 17

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

            Rectangle {
                z: -1
                anchors.fill: parent
                color: qmlRoot.redColor
            }
        }
    }
}










