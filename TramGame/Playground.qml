import QtQuick 2.0
import QtQml.Models 2.2
import "qrc:/scripts.js" as Scripts

Item {
    property bool check: false

    property int animationLenght: 200

    property bool firstPlacementActive: false
//    property bool cellMoving: false
    property bool newCard: false // TODO: předělat na signals&slots
    property int rows: 9
    property int columns: 9
    property int cellHeight: height / rows
    property int cellWidth: width / columns

    property string lastDir: "none"
    property int lastIndex: -1

    property bool canDrop: false

    property bool placeCell: false;

    property int karma: 0


    id: playground
    anchors.fill: parent

    onKarmaChanged: console.log("karma", karma)
    onNewCardChanged: {
        if(deckModel.count == 0) {
            // mark another card as added
            // potenciálně nekonečná smyčka
            while(true) {
                var randomIndex = (Math.random() * dataModel.data.length).toFixed(0);
                console.log(randomIndex)
                if(!dataModel.data[randomIndex].added) {
                    dataModel.data[randomIndex].added = true;
                    dataModel.data[randomIndex].hidden = false;
                    deckModel.append(dataModel.getItem(randomIndex))
                    break;
                }
                else {
                    console.log("conflict detected")
                }
            }
        }
    }

    onCheckChanged: {
        var goodPlace = true;
        if(lastDir === "right") {
            if(lastIndex == 0) {
               if(middleDeck.get(0).longitude > rightDeck.get(lastIndex).longitude) {
                   goodPlace = false;
               }
            }
            else {
                if(rightDeck.get(lastIndex - 1).longitude > rightDeck.get(lastIndex).longitude) {
                    goodPlace = false;
                }
            }
            if(lastIndex < rightDeck.count - 1) {
                if(rightDeck.get(lastIndex).longitude > rightDeck.get(lastIndex + 1).longitude) {
                    goodPlace = false;
                }
            }
            console.log("placement", goodPlace)
        }
        else if(lastDir === "left") {
            if(lastIndex == 0) {
               if(middleDeck.get(0).longitude < leftDeck.get(lastIndex).longitude) {
                   goodPlace = false;
               }
            }
            else {
                if(leftDeck.get(lastIndex - 1).longitude < leftDeck.get(lastIndex).longitude) {
                    goodPlace = false;
                }
            }
            if(lastIndex < rightDeck.count - 1) {
                if(leftDeck.get(lastIndex).longitude < leftDeck.get(lastIndex + 1).longitude) {
                    goodPlace = false;
                }
            }
            console.log("placement", goodPlace)
        }
        else if(lastDir === "top") {
            if(lastIndex == 0) {
               if(middleDeck.get(0).latitude > topDeck.get(lastIndex).latitude) {
                   goodPlace = false;
               }
            }
            else {
                if(topDeck.get(lastIndex - 1).latitude > topDeck.get(lastIndex).latitude) {
                    goodPlace = false;
                }
            }
            if(lastIndex < rightDeck.count - 1) {
                if(topDeck.get(lastIndex).latitude > topDeck.get(lastIndex + 1).latitude) {
                    goodPlace = false;
                }
            }
            console.log("placement", goodPlace)
        }
        else if(lastDir === "bottom") {
            if(lastIndex == 0) {
               if(middleDeck.get(0).latitude < bottomDeck.get(lastIndex).latitude) {
                   goodPlace = false;
               }
            }
            else {
                if(bottomDeck.get(lastIndex - 1).latitude < bottomDeck.get(lastIndex).latitude) {
                    goodPlace = false;
                }
            }
            if(lastIndex < rightDeck.count - 1) {
                if(bottomDeck.get(lastIndex).latitude < bottomDeck.get(lastIndex + 1).latitude) {
                    goodPlace = false;
                }
            }
            console.log("placement", goodPlace)
        }
    }

    function setCard(inModel) {
        for(var index = 0; index < inModel.count; index++) {
//                console.log("name", rightDeck.get(index).name, rightDeck.get(index).hidden)
            if(inModel.get(index).hidden) {
                inModel.set(index, deckModel.get(0));
                deckModel.clear();
            }
        }
    }

    onPlaceCellChanged: {
        if(lastDir === "right") {
            setCard(rightDeck);
        }
        else if(lastDir === "bottom") {
            setCard(bottomDeck);
        }
        else if(lastDir === "top") {
            setCard(topDeck);
        }
        else if(lastDir === "left") {
            setCard(leftDeck);
        }
    }
    ListModel {
        id: topDeck
    }

    ListModel {
        id: bottomDeck
    }

    ListModel {
        id: leftDeck
    }

    ListModel {
        id: rightDeck
//        onCountChanged: console.log("count", count)
    }

    ListModel {
        id: deckModel
    }
    // DECK
    ListView {
        property int cells: 1

        id: deckView
        x: cellWidth
        y: cellHeight
        width: cellWidth
        height: cellHeight
        interactive: false
        model: deckModel
        delegate: TramCell {
            movable: true
            onPressedChanged: {
//                console.log("pressed delegate", pressed);
                firstPlacementActive = pressed;
                if(!pressed && playground.karma) {
//                    console.log("make it still in", lastDir)
                    playground.placeCell = !playground.placeCell
                }
            }
        }

        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.width: 1
            border.color: "#70ff0000"
        }
    }

    // MIDDLE
    ListView {
        property int cells: 1

        ListModel {
            id: middleDeck

            Component.onCompleted: {
                var randomIndex = (Math.random() * dataModel.data.length).toFixed(0);//6
                dataModel.data[randomIndex].added = true;
                dataModel.data[randomIndex].hidden = false;
                middleDeck.append(dataModel.data[randomIndex])
            }
        }

        id: middle
        anchors.centerIn: parent
        width: parent.width / playground.columns
        height: parent.height / playground.rows

        interactive: false
        model: middleDeck
        delegate: TramCell {

//            MouseArea {
//                anchors.fill: parent
//                onClicked: {
//                    if(deckModel.count == 0) {
//                        deckModel.append({name:"appended", hidden:false})
//                    }
//                }
//            }
        }
    }

    OneDirection {  // TOP
        id: topDir
        anchors.top: parent.top
        anchors.left: middle.left
        anchors.bottom: middle.top
        width: parent.width / playground.columns

        dir: "top"
        layourDir: Qt.LeftToRight
        layoutOrient: Qt.Vertical
        cells: (playground.rows - 1) / 2
        deck: topDeck
        verticalLayout: ListView.BottomToTop
    }

    OneDirection {  // BOTTOM
        id: bottomDir
        anchors.top: middle.bottom
        anchors.left: middle.left
        anchors.bottom: parent.bottom
        width: parent.width/ playground.columns

        dir: "bottom"
        layourDir: Qt.LeftToRight
        layoutOrient: Qt.Vertical
        cells: (playground.rows - 1) / 2
        deck: bottomDeck
    }

    OneDirection {  // LEFT
        id: leftDir
        anchors.top: middle.top
        anchors.right: middle.left
        anchors.left: parent.left
        height: parent.height / playground.rows

        dir: "left"
        layourDir: Qt.RightToLeft
        layoutOrient: Qt.Horizontal
        cells: (playground.columns - 1) / 2
        deck: leftDeck
    }

    OneDirection {  // RIGHT
        id: rightDir
        anchors.top: middle.top
        anchors.left: middle.right
        anchors.right: parent.right
        height: parent.height / playground.rows

        dir: "right"
        layourDir: Qt.LeftToRight
        layoutOrient: Qt.Horizontal
        cells: (playground.columns - 1) / 2
        deck: rightDeck
    }
}

