import QtQuick 2.0

Item {
    id: playgroundRoot

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
        distancesBar.horizontalDistance = (R * cLon).toFixed();
        distancesBar.verticalDistance = (R * cLat).toFixed();
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
                target: listWrapper
                x: desktop.width - listWrapper.width
            }
        }
    ]

    onSelectedStopChanged: {
        state = "";
        Qt.inputMethod.hide();
    }

    Connections {
        target: stop1
        onStopSet: playgroundRoot.stopSet()
    }

    Connections {
        target: stop2
        onStopSet: playgroundRoot.stopSet()
    }

    Rectangle {
        id: desktop
        width: parent.width
        height: parent.height
        color: qmlRoot.lightColor

        MouseArea {
            z: 1
            enabled: playgroundRoot.state === "list"
            anchors.fill: parent
            onClicked: {
                playgroundRoot.selectedStop = null
                playgroundRoot.state = ""
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

        DistancesBar {
            id: distancesBar

            height: parent.height * 0.05
            width: parent.width * 0.2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: parent.height * 0.01
        }
    }

    StopsView {
        id: listWrapper
        width: parent.width * 0.5
        height: parent.height
        visible: x !== desktop.width
        x: desktop.width

        Behavior on x {NumberAnimation {duration: 200}}
    }
}

