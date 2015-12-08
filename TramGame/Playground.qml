import QtQuick 2.0
import QtQml.Models 2.2
import "qrc:/scripts.js" as Scripts

Item {
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
        // mark another card as added
        // potenciálně nekonečná smyčka
        while(true) {
            var randomIndex = (Math.random() * dataModel.data.length).toFixed(0);
            console.log(randomIndex)
            if(!dataModel.getItem(randomIndex).added) {
                dataModel.setItem(randomIndex, {"added":true})
                Scripts.updateVisibleModel(randomIndex, dataModel, visibleModel);
                break;
            } else {console.log("conflict detected")}
        }
    }

    function setCard(inModel) {
        for(var index = 0; index < inModel.count; index++) {
//                console.log("name", rightDeck.get(index).name, rightDeck.get(index).hidden)
            if(inModel.get(index).hidden) {
                inModel.set(index, deckModel.get(0));
                inModel.setProperty(index, "hidden", false);
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
        ListElement {
            name: "top first"; hidden: false
        }
        ListElement {
            name: "top second"; hidden: false
        }
    }

    ListModel {
        id: bottomDeck
        ListElement {
            name: "bottom first"; hidden: false
        }
        ListElement {
            name: "bottom second"; hidden: false
        }
    }

    ListModel {
        id: leftDeck
        ListElement {
            name: "left first"; hidden: false
        }
        ListElement {
            name: "left second"; hidden: false
        }
    }

    ListModel {
        id: rightDeck
        ListElement {
            name: "right first"; hidden: false
        }
        ListElement {
            name: "right second"; hidden: false
        }
    }

//    // TOP
//    ListView {
//        property int cells: (playground.rows - 1) / 2

//        id: top
//        anchors.bottom: middle.top
//        anchors.left: middle.left
//        height: cells * cellHeight
//        width: parent.width / playground.columns

//        verticalLayoutDirection: ListView.BottomToTop
//        interactive: false
//        model: topDeck
//        delegate: TramCell {
//            allowedIndex: rightDeck.count + 1 - Scripts.canRemove(rightDeck)

//            onPressedChanged: {
//                console.log("pressed", pressed);
//            }
//        }
//    }

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

        id: middle
        anchors.centerIn: parent
        width: parent.width / playground.columns
        height: parent.height / playground.rows

        interactive: false
        model: cells
        delegate: TramCell {
            property string name: "middle"
            property bool hidden: false

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(deckModel.count == 0) {
                        deckModel.append({name:"appended", hidden:false})
                    }
                }
            }
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

