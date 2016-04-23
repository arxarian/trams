import QtQuick 2.5
import QtQml.Models 2.2
import "qrc:/scripts.js" as Scripts

Item {
    property int animationLenght: 1200

    property bool newCard: false // TODO: předělat na signals&slots
    property bool check: false   // TODO - to samé jako new card
    property bool makeStopsNonDraggable: true

    property int rows: 17
    property int columns: 17
    property int cellHeight: playground.height / rows
    property int cellWidth: playground.width / columns

    property var draggedRect: null

    property bool clearRequest: false
    property bool theFirstDrag: true

    property real longitude: 0
    property real latitude: 0

    id: playground
    anchors.fill: parent

    onNewCardChanged: { // tento slot generuje nové karty do deckModel
        var nTrampStops = 0;
        for(var nChildIndex = 0; nChildIndex < children.length; nChildIndex++) {
            if(children[nChildIndex].objectName === "tramStop") {
                nTrampStops++;
            }
        }
        if(nTrampStops < 2) {   // NOTE - the first tramStop is the starting tramStop
            // mark all stops as non dragable
            makeStopsNonDraggable = !makeStopsNonDraggable;
            var stop = createNewStop();
        }
    }

    function createNewStop() {
        var component = Qt.createComponent("TramStop.qml");
        if(component.status !== Component.Ready) console.log("TramStop.qml creation error");
        var sprite = component.createObject(playground, {"width": cellWidth, "height": cellHeight});
        // mark another card as added
        // TODO potenciálně nekonečná smyčka
        while(true) {
            var randomIndex = (Math.random() * dataModel.data.length).toFixed(0);
            if(!dataModel.data[randomIndex].added) {
                dataModel.data[randomIndex].added = true;
                sprite.modelIndex = randomIndex;
                return sprite;
            }
            else {
                console.log("conflict detected")
            }
        }
    }

    Component.onCompleted: {
        // init game - gener the middle card
        timer.running = true
    }

    Timer {
        id: timer
        interval: 1
        running: false
        repeat: false
        onTriggered: {
            var newStop = createNewStop();
            newStop.anchors.centerIn = parent;
            newStop.canBeDrag = false
            longitude = dataModel.data[newStop.modelIndex].longitude
            latitude = dataModel.data[newStop.modelIndex].latitude
        }
    }

    Canvas {
        id: canvas
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d");

            for(var i = 1; i < playground.columns; i++) {

                ctx.beginPath();
                ctx.lineWidth = 1;
                ctx.strokeStyle = "gold";
                ctx.moveTo(i * (canvas.width / playground.columns), 0);
                ctx.lineTo(i * (canvas.width / playground.columns), canvas.height);
                ctx.stroke();

                ctx.beginPath();
                ctx.lineWidth = 1;
                ctx.strokeStyle = Qt.rgba(255, 215, 0, 0.4);
                ctx.moveTo(0, i * (canvas.height / playground.rows));
                ctx.lineTo(canvas.width, i * (canvas.height / playground.rows));
                ctx.stroke();
            }
        }
    }

    OneDirection {  // north
        horizontal: false;
        dir: "north"
        x: (playground.columns / 2 | 0) * cellWidth
        y: 0
        width: cellWidth
        height: cellHeight * (playground.columns / 2 | 0)
    }

    OneDirection {  // south
        dir: "south"
        horizontal: false;
        x: (playground.columns / 2 | 0) * cellWidth
        y: ((playground.rows / 2 | 0) + 1) * cellHeight
        width: cellWidth
        height: cellHeight * (playground.columns / 2 | 0)
    }

    OneDirection {  // east
        dir: "east"
        horizontal: true;
        x: ((playground.columns / 2 | 0) + 1) * cellWidth
        y: (playground.rows / 2 | 0) * cellHeight
        width: cellWidth * (playground.rows / 2 | 0)
        height: cellHeight
    }

    OneDirection {  // west
        dir: "west"
        horizontal: true;
        x: 0
        y: (playground.rows / 2 | 0) * cellHeight
        width: cellWidth * (playground.rows / 2 | 0)
        height: cellHeight
    }

    // NOTE - tato komponeta řeší problém se překrýváním právě umisťované kartičky
//    Rectangle {
//        id: globalTramStop
//        visible: false
//        width: cellWidth * 0.8  // TODO - navázat konstantu 0.8 na rozměry TramStop
//        height: cellHeight * 0.8// TODO - navázat konstantu 0.8 na rozměry TramStop
//    }
}

