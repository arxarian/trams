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

        function calculateDistances() {
            // compute distances
            var dLat_r = (stop1.latitude - stop2.latitude) * Math.PI / 180;
            var dLon_r = (stop1.longitude - stop2.longitude) * Math.PI / 180;
            var lat1_r = stop1.latitude * Math.PI / 180;
            var lat2_r = stop2.latitude * Math.PI / 180;

            var aLat = Math.sin(dLat_r/2) * Math.sin(dLat_r/2);
            var aLon = Math.cos(lat1_r) * Math.cos(lat2_r) * Math.sin(dLon_r/2) * Math.sin(dLon_r/2);

            var cLat = 2 * Math.atan2(Math.sqrt(aLat), Math.sqrt(1 - aLat));
            var cLon = 2 * Math.atan2(Math.sqrt(aLon), Math.sqrt(1 - aLon));

            var R = 6373000; // Earth's radius in metres
            textHorizontalDistance.distance = (R * cLon).toFixed();
            textVerticalDistance.distance = (R * cLat).toFixed();

        }

        function compareStops() {
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

        function stopSet() {
            if(stop1.set && stop2.set) {
                compareStops();
                calculateDistances();
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
            onStopSet: qmlRoot.stopSet()
        }

        Connections {
            target: stop2
            onStopSet: qmlRoot.stopSet()
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

            Text {
                property double distance: -1

                id: textVerticalDistance
                opacity: distance < 0 ? 0 : 1
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: textHorizontalDistance.top
                font.pixelSize: 16
                text: "↕ " + distance + " m"

                Behavior on opacity {NumberAnimation{duration: 400}}
            }
            Text {
                property double distance: -1

                id: textHorizontalDistance
                opacity: distance < 0 ? 0 : 1
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height * 0.01
                font.pixelSize: 16
                text: "↔ " + distance + " m"

                Behavior on opacity {NumberAnimation{duration: 400}}
            }
        }

        StopsView {
            id: listWrapper
            width: parent.width * 0.6
            height: parent.height
            anchors.left: desktop.right
        }
    }
}










