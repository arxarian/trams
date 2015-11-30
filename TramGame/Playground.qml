import QtQuick 2.0
import QtQml.Models 2.2
import "qrc:/scripts.js" as Scripts

Item {
    property alias timerActive: timer.running

    property var draggedItem: []
    property bool dragActive: false
    property bool newCard: false // TODO: předělat na signals&slots
    property int rows: 9
    property int columns: 9
    property int cellHeight: height / rows
    property int cellWidth: width / columns

    property string lastDir: "none"
    property int lastIndex: -1
    property int newIndex: -1

    property var lastModel: []
    property var newModel: []

    property bool removeCell: false
    property int removeIndex: -1

    property bool cellPlaced: false

    id: playground

    anchors.fill: parent


//    onRemoveCellChanged: {
//        console.log("remove", removeCell/*, removeIndex*/)
////        if(removeCell) {
////            lastModel.remove(removeIndex);
////            removeCell = false;
////        }
//    }
//    onDragActiveChanged: console.log("dragActive", dragActive)

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

//    onLastDirChanged: console.log("lastDir", lastDir)
    onLastIndexChanged: console.log("lastIndex", lastIndex)

//    onCellPlacedChanged: {
//        console.log("count dect", rightDeck.count)
//        for(var nIndex = 0; nIndex < rightDeck.count; nIndex++) {
//            console.log(rightDeck.get(nIndex).hidden)
//        }

//        console.log("cell placed")
//    }
//    Connections {
//        target: dataModel
//        onDataModelChanged: {
//            console.log("item added")
//            Scripts.updateVisibleModel(dataModel, visibleModel);
//        }
//    }

//    ListModel {
//        id: topDeck
//        ListElement {
//            name: "top first"
//        }
//        ListElement {
//            name: "top second"
//        }
//    }

//    ListModel {
//        id: bottomDeck
//        ListElement {
//            name: "bottom first"
//        }
//        ListElement {
//            name: "bottom second"
//        }
//        ListElement {
//            name: "bottom thrid"
//        }
//    }

//    ListModel {
//        id: leftDeck
//        ListElement {
//            name: "left first"
//        }
//        ListElement {
//            name: "left second"
//        }
//    }

    ListModel {
        id: rightDeck
        ListElement {
            name: "right first"; hidden: false
        }
//        ListElement {
//            name: "right second"; hidden: false
//        }
        onCountChanged: console.log("count", count)
    }

    // TOP
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
//            borderColor: "green"
//        }

//        // TODO: tohle to možná dost zalaguje
//        onXChanged: {Scripts.topDir = {x: this.x, y: this.y, width: this.width, height: this.height}/*; console.log("x changed")*/}
//        onYChanged: {Scripts.topDir = {x: this.x, y: this.y, width: this.width, height: this.height}/*; console.log("y changed")*/}
//        onWidthChanged: {Scripts.topDir = {x: this.x, y: this.y, width: this.width, height: this.height}/*; console.log("width changed")*/}
//        onHeightChanged: {Scripts.topDir = {x: this.x, y: this.y, width: this.width, height: this.height}/*; console.log("height changed")*/}
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
//            onPressed: {
//                visible = false
//                var component = component = Qt.createComponent("InnerCell.qml");
//                var sprite = component.createObject(playground, {x: cellWidth, y: cellHeight, height: cellHeight, width: cellWidth, name: "fake"});
////                sprite.drag.active = true
//            }
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
//            movable: false
//            borderColor: "red"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if(deckModel.count == 0) {
                        deckModel.append({name:"appended", hidden:false})
                    }
//                    var component = component = Qt.createComponent("TramCell.qml");
//                    var sprite = component.createObject(playground, {x: 100, y: 100, height: cellHeight, width: cellWidth, name:"lol"});
//                    rightDeck.insert(0, {name:"appened"})
                }
            }
        }
    }
//    // BOTTOM
//    ListView {
//        property int cells: (playground.rows - 1) / 2

//        id: bottom
//        anchors.top: middle.bottom
//        anchors.left: middle.left
//        height: cells * cellHeight
//        width: parent.width / playground.columns

//        interactive: false
//        model: bottomDeck
//        delegate: TramCell {
//            borderColor: "green"
//        }

//        // TODO: tohle to možná dost zalaguje
//        onXChanged: {Scripts.bottomDir = {x: this.x, y: this.y, width: this.width, height: this.height}/*; console.log("x changed")*/}
//        onYChanged: {Scripts.bottomDir = {x: this.x, y: this.y, width: this.width, height: this.height}/*; console.log("y changed")*/}
//        onWidthChanged: {Scripts.bottomDir = {x: this.x, y: this.y, width: this.width, height: this.height}/*; console.log("width changed")*/}
//        onHeightChanged: {Scripts.bottomDir = {x: this.x, y: this.y, width: this.width, height: this.height}/*; console.log("height changed")*/}
//    }
//    // LEFT
//    ListView {
//        property int cells: (playground.columns - 1) / 2

//        id: left
//        anchors.top: middle.top
//        anchors.right: middle.left
//        height: parent.height/ playground.rows
//        width: cells * cellWidth

//        layoutDirection: Qt.RightToLeft
//        orientation: Qt.Horizontal
//        interactive: false
//        model: leftDeck
//        delegate: TramCell {
////            text: name
//            borderColor: "maroon"
//        }

////        add: Transition {
////            NumberAnimation { properties: "x,y"; from: -200; duration: 1000 }
////        }
////        addDisplaced: Transition {
////            NumberAnimation { properties: "x,y"; duration: 1000 }
////        }

////        move: Transition {
////            NumberAnimation { properties: "x,y"; duration: 1000 }
////        }

//        // TODO: tohle to možná dost zalaguje
//        onXChanged: {Scripts.leftDir = {x: this.x, y: this.y, width: this.width, height: this.height}/*; console.log("x changed")*/}
//        onYChanged: {Scripts.leftDir = {x: this.x, y: this.y, width: this.width, height: this.height}/*; console.log("y changed")*/}
//        onWidthChanged: {Scripts.leftDir = {x: this.x, y: this.y, width: this.width, height: this.height}/*; console.log("width changed")*/}
//        onHeightChanged: {Scripts.leftDir = {x: this.x, y: this.y, width: this.width, height: this.height}/*; console.log("height changed")*/}

//    }

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
//                var mapped = draggedItem.mapToItem(playground, 0, 0);
//                var dir = Scripts.getDir(mapped.x, mapped.y)

                if(active) { // pořadí nezaručeno?!
                    newIndex = index;

                    if(lastDir !== rightDropArea.dir) {
                        if(index < rightDeck.count + 1) {
                            rightDeck.insert(index, {name: "-", hidden: true})
                        }
                        lastDir = rightDropArea.dir;
                    }
                    else if(lastDir === rightDropArea.dir) {
                        console.log("from", lastIndex, "to", index)
                        rightDeck.move(lastIndex, index, 1)
                    }
                    lastIndex = index
//                    else {
//                        console.log("active")
//                    }

//                        rightDeck.append({name: "", hidden: true})
                        // první prvek - vytvořit invisible na první prvek
                        // poslední prvek - vytvořit invisible na poslední prvek
                        // drop area musí být o jedna větší
//                    }
                }
                else {
//                    console.log("else",index)
//                    if(/*rightDeck.get(index).hidden && */dir.dir !== "right"/* && lastIndex != index*/) {// s tímhle to funuje i na první vložení
                        console.log("should remove", index, "lastDir", lastDir, "newIndex", newIndex, "can remove", Scripts.canRemove(rightDeck),"dir", dir,"removed")
//                        console.log()

//                        if(lastDir === "none" || newIndex !== lastIndex) {
                            rightDeck.remove(index);
//                            console.log()
//                        }
//                    }
//                    else if(dir === lastDir) {
//                        rightDeck.move(lastIndex, index)
//                        lastIndex = index;
//                    }
                    lastDir = dir.dir;

//                    console.log(index, "not taken")
                }
                console.log("")
            }
//            borderColor: "maroon"
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
//            borderColor: "maroon"
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

        onXChanged: {Scripts.rightDir = {x: this.x, y: this.y, width: this.width, height: this.height}/*; console.log("x changed")*/}
        onYChanged: {Scripts.rightDir = {x: this.x, y: this.y, width: this.width, height: this.height}/*; console.log("y changed")*/}
        onWidthChanged: {Scripts.rightDir = {x: this.x, y: this.y, width: this.width, height: this.height}/*; console.log("width changed")*/}
        onHeightChanged: {Scripts.rightDir = {x: this.x, y: this.y, width: this.width, height: this.height}/*; console.log("height changed")*/}
    }

    Timer { // the calculation of button new position is triggered every timer.interval ms

//        function move(inModel, dir) {
//            if(newIndex > -1) {
//                console.log("index", newIndex, "last", lastIndex)
//                if(lastIndex !== newIndex && lastIndex > -1) {
//                    console.log("move", lastIndex, "to", newIndex)
//                    inModel.move(lastIndex, newIndex, 1)
//                }
//                lastIndex = newIndex
//                lastDir = dir
//            }
//        }

//        function rightIndex(x, y) {
//            return right.indexAt(x + cellWidth / 2, y)
//        }

//        function leftIndex(x, y) {
//            return left.indexAt(x - left.width -  cellWidth / 2, y)
//        }

//        function topIndex(x, y) {
//            return top.indexAt(x, y - top.height - cellHeight / 2)
//        }

//        function bottomIndex(x, y) {
//            return bottom.indexAt(x, y + cellHeight / 2)
//        }

//        function calcIndex() {
//            var mapped = draggedItem.mapToItem(playground, 0, 0);
//            var dir = Scripts.getDir(mapped.x, mapped.y)
////            var newIndex = -1
////            console.log(dir.dir)

//            if(dir.dir === lastDir) {
//                if(dir.dir === "right") {
//                    newIndex = rightIndex(dir.x, dir.y);
//                    move(rightDeck, dir.dir);
//                }
//                else if(dir.dir === "left") {
//                    newIndex = leftIndex(dir.x, dir.y)
//                    move(leftDeck, dir.dir);
//                }
//                else if(dir.dir === "top") {
//                    newIndex = topIndex(dir.x, dir.y)
//                    move(topDeck, dir.dir);
//                }
//                else if(dir.dir === "bottom") {
//                    newIndex = bottomIndex(dir.x, dir.y)
//                    move(bottomDeck, dir.dir);
//                }
//            }
//            else if (dir.dir === "none"){  // different dir
//                console.log("none")
//            }
//            else {
//                lastDir = dir.dir
////                lastIndex = -1
//                console.log("else")

//                if(dir.dir === "right") {
//                    newIndex = rightIndex(dir.x, dir.y);
//                    if(newIndex > -1) {
//                        rightDeck.insert(newIndex, {name:"inserted", hidden:true});
//                        newModel = rightDeck
////                        console.log(newModel.get(newIndex).name)
////                        lastModel.remove(lastIndex)
//                    }

//                    console.log("index", newIndex)
////                    move(rightDeck, dir.dir);
//                }
//                else if(dir.dir === "left") {
//                    newIndex = leftIndex(dir.x, dir.y)
//                    console.log("index", newIndex)
////                    move(leftDeck, dir.dir);
//                }
//                else if(dir.dir === "top") {
//                    newIndex = topIndex(dir.x, dir.y)
//                    console.log("index", newIndex)
////                    move(topDeck, dir.dir);
//                }
//                else if(dir.dir === "bottom") {
//                    newIndex = bottomIndex(dir.x, dir.y)
//                    console.log("index", newIndex)
////                    move(bottomDeck, dir.dir);
//                }
//            }
//        }

        id: timer
        interval: 250
        repeat: true
//        onRunningChanged: {
//            if(running == true) {
//                console.log("\n")
//                lastIndex = -1
//                var mapped = draggedItem.mapToItem(playground, 0, 0);
//                playground.lastDir = Scripts.getDir(mapped.x, mapped.y).dir

//                if(lastDir == "right") {
//                    lastModel = rightDeck
//                }
//                else if(lastDir == "left") {
//                    lastModel = leftDeck
//                }
//                else if(lastDir == "top") {
//                    lastModel = topDeck
//                }
//                else if(lastDir == "bottom") {
//                    lastModel = bottomDeck
//                }
//                else {
//                    console.log("error")
//                }

//                calcIndex()
////                lastDir = "none"
////                console.log("\n")
//            }
////            else {
//////                console.log("index",newIndex, newModel.get(newIndex).x, newModel.get(newIndex).y)
////                draggedItem.x = 200//newModel.get(newIndex).x
////                draggedItem.y = 200//newModel.get(newIndex).y
////            }
//        }
//        onTriggered: calcIndex()
    }
}

