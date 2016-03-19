import QtQuick 2.5
import QtQml.Models 2.2
import "qrc:/scripts.js" as Scripts

Item {
//    property bool check: false

    property int animationLenght: 400

    property int globalZ: 0

    property bool newCard: false // TODO: předělat na signals&slots
    property int rows: 9
    property int columns: 9
    property int cellHeight: playground.height / rows
    property int cellWidth: playground.width / columns

    id: playground
    anchors.fill: parent

    onNewCardChanged: { // tento slot generuje nové karty do deckModel
        if(deckModel.count == 0) {
            // mark another card as added
            // TODO potenciálně nekonečná smyčka
            while(true) {
                var randomIndex = (Math.random() * dataModel.data.length).toFixed(0);
                if(!dataModel.data[randomIndex].added) {
                    dataModel.data[randomIndex].added = true;
                    dataModel.data[randomIndex].hidden = false;
//                    deckModel.append(dataModel.getItem(randomIndex))
                    break;
                }
                else {
                    console.log("conflict detected")
                }
            }
        }
    }

//    onCheckChanged: checkPosition();

//    // kontrola všech karet ve všech směrech, velké TODO! na refaktoring
//    function checkPosition() {
//        playground.goodPlace = true;
//        if(lastDir === "right") {
//            if(lastIndex == 0) {
//               if(middleDeck.get(0).longitude > rightDeck.get(lastIndex).longitude) {
//                   goodPlace = false;
//               }
//            }
//            else {
//                if(rightDeck.get(lastIndex - 1).longitude > rightDeck.get(lastIndex).longitude) {
//                    goodPlace = false;
//                }
//            }
//            if(lastIndex < rightDeck.count - 1) {
//                if(rightDeck.get(lastIndex).longitude > rightDeck.get(lastIndex + 1).longitude) {
//                    goodPlace = false;
//                }
//            }
//            console.log("placement", goodPlace)
//        }
//        else if(lastDir === "left") {
//            if(lastIndex == 0) {
//               if(middleDeck.get(0).longitude < leftDeck.get(lastIndex).longitude) {
//                   goodPlace = false;
//               }
//            }
//            else {
//                if(leftDeck.get(lastIndex - 1).longitude < leftDeck.get(lastIndex).longitude) {
//                    goodPlace = false;
//                }
//            }
//            if(lastIndex < rightDeck.count - 1) {
//                if(leftDeck.get(lastIndex).longitude < leftDeck.get(lastIndex + 1).longitude) {
//                    goodPlace = false;
//                }
//            }
//            console.log("placement", goodPlace)
//        }
//        else if(lastDir === "top") {
//            if(lastIndex == 0) {
//               if(middleDeck.get(0).latitude > topDeck.get(lastIndex).latitude) {
//                   goodPlace = false;
//               }
//            }
//            else {
//                if(topDeck.get(lastIndex - 1).latitude > topDeck.get(lastIndex).latitude) {
//                    goodPlace = false;
//                }
//            }
//            if(lastIndex < rightDeck.count - 1) {
//                if(topDeck.get(lastIndex).latitude > topDeck.get(lastIndex + 1).latitude) {
//                    goodPlace = false;
//                }
//            }
//            console.log("placement", goodPlace)
//        }
//        else if(lastDir === "bottom") {
//            if(lastIndex == 0) {
//               if(middleDeck.get(0).latitude < bottomDeck.get(lastIndex).latitude) {
//                   goodPlace = false;
//               }
//            }
//            else {
//                if(bottomDeck.get(lastIndex - 1).latitude < bottomDeck.get(lastIndex).latitude) {
//                    goodPlace = false;
//                }
//            }
//            if(lastIndex < rightDeck.count - 1) {
//                if(bottomDeck.get(lastIndex).latitude < bottomDeck.get(lastIndex + 1).latitude) {
//                    goodPlace = false;
//                }
//            }
//            console.log("placement", goodPlace)
//        }
//    }

    Canvas {
        id: canvas
        z: 0
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
//        dir: "north"
        x: (playground.columns / 2 | 0) * cellWidth
        y: 0
    }

    OneDirection {  // south
//        dir: "south"
        horizontal: false;
        x: (playground.columns / 2 | 0) * cellWidth
        y: ((playground.rows / 2 | 0) + 1) * cellHeight
    }

    OneDirection {  // east
//        dir: "east"
        horizontal: true;
        x: ((playground.columns / 2 | 0) + 1) * cellWidth
        y: (playground.rows / 2 | 0) * cellHeight
    }

    OneDirection {  // west
//        dir: "east"
        horizontal: true;
        x: 0
        y: (playground.rows / 2 | 0) * cellHeight
    }

    TramStop {
        width: cellWidth
        height: cellHeight
    }

    TramStop {
        x: 0
        y: cellHeight
        width: cellWidth
        height: cellHeight
    }
//    ListModel {
//        id: topDeck
//    }

//    ListModel {
//        id: bottomDeck
//    }

//    ListModel {
//        id: leftDeck
//    }

//    ListModel {
//        id: rightDeck
//    }

//    ListModel {
//        id: deckModel
//    }


}

