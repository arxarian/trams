import QtQuick 2.0
import QtQml.Models 2.2
import "qrc:/scripts.js" as Scripts

Item {
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

    onPlaceCellChanged: {
        if(lastDir === "right") {
            for(var index = 0; index < rightDeck.count; index++) {
//                console.log("name", rightDeck.get(index).name, rightDeck.get(index).hidden)
                if(rightDeck.get(index).hidden) {
                    rightDeck.setProperty(index, "name", deckModel.get(0).name);
                    rightDeck.setProperty(index, "hidden", false);
                    deckModel.clear();
                }
            }
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
        ListElement {
            name: "bottom thrid"; hidden: false
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

    // TOP
    ListView {
        property int cells: (playground.rows - 1) / 2

        id: top
        anchors.bottom: middle.top
        anchors.left: middle.left
        height: cells * cellHeight
        width: parent.width / playground.columns

        verticalLayoutDirection: ListView.BottomToTop
        interactive: false
        model: topDeck
        delegate: TramCell {
//            borderColor: "green"
        }
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
    // BOTTOM
    ListView {
        property int cells: (playground.rows - 1) / 2

        id: bottom
        anchors.top: middle.bottom
        anchors.left: middle.left
        height: cells * cellHeight
        width: parent.width / playground.columns

        interactive: false
        model: bottomDeck
        delegate: TramCell {
//            borderColor: "green"
        }
    }
    // LEFT
    ListView {
        property int cells: (playground.columns - 1) / 2

        id: left
        anchors.top: middle.top
        anchors.right: middle.left
        height: parent.height/ playground.rows
        width: cells * cellWidth

        layoutDirection: Qt.RightToLeft
        orientation: Qt.Horizontal
        interactive: false
        model: leftDeck
        delegate: TramCell {
//            text: name
//            borderColor: "maroon"
        }

//        add: Transition {
//            NumberAnimation { properties: "x,y"; from: -200; duration: 1000 }
//        }
//        addDisplaced: Transition {
//            NumberAnimation { properties: "x,y"; duration: 1000 }
//        }

//        move: Transition {
//            NumberAnimation { properties: "x,y"; duration: 1000 }
//        }
    }

    // RIGHT DropArea
    ListView {

        function rightIndex(x, y) {
            return right.indexAt(x + cellWidth / 2, y)
        }

        property int cells: (playground.columns - 1) / 2
        property string dir: "right"

        id: rightDropArea
        anchors.top: middle.top
        anchors.left: middle.right
        height: parent.height / playground.rows
        width: cells * cellWidth

        orientation: Qt.Horizontal
        interactive: false
        model: cells
        delegate: TramSpot {
            width: cellWidth
            height: cellHeight
            allowedIndex: rightDeck.count + 1 - Scripts.canRemove(rightDeck)

            onDropState: {
                console.log("right", index, active)

                if(active) { // pořadí nezaručeno?!

                    if((lastDir !== rightDropArea.dir || playground.karma == 1)/* && !cellMoving*/) {
                        if(index < rightDeck.count + 1) {
                            rightDeck.insert(index, {name: "", hidden: true})
                        }
                        lastDir = rightDropArea.dir;
                    }
                    else if(lastDir === rightDropArea.dir) {
//                        console.log("from", lastIndex, "to", index)
                        rightDeck.move(lastIndex, index, 1)
                    }
                    lastIndex = index
                }
                else {
                    if(rightDropArea.dir !== "right" || (playground.karma == 0 && firstPlacementActive)) {
//                        console.log("should remove", index, "lastDir", lastDir, "can remove", Scripts.canRemove(rightDeck),"dir", playground.dir,"removed")
                            rightDeck.remove(index);
                    }
                    lastDir = rightDropArea.dir;
                }
            }
        }
    }
    // RIGHT
    ListView {
        property int cells: (playground.columns - 1) / 2

        id: right
        anchors.top: middle.top
        anchors.left: middle.right
        height: parent.height / playground.rows
        width: cells * cellWidth

        orientation: Qt.Horizontal
        interactive: false
        model: rightDeck
        delegate: TramCell {
            allowedIndex: rightDeck.count + 1 - Scripts.canRemove(rightDeck)

            onPressedChanged: {
                console.log("pressed", pressed);
//                playground.cellMoving = pressed
            }
        }

        add: Transition {
            NumberAnimation { properties: "x,y"; from: -200; duration: 1000 }
        }
        addDisplaced: Transition {
            NumberAnimation { properties: "x,y"; duration: 1000 }
        }

        move: Transition {
            NumberAnimation { properties: "x,y"; duration: 500 }
        }

        moveDisplaced: Transition {
            NumberAnimation { properties: "x,y"; duration: 500 }
        }

        removeDisplaced: Transition {
            NumberAnimation { properties: "x,y"; duration: 500 }
        }
    }
}

