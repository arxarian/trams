import QtQuick 2.0
import QtQml.Models 2.2
import "qrc:/scripts.js" as Scripts

Item {
    property alias timerActive: timer.running

    property var draggedItem: playground
    property bool newCard: false // TODO: předělat na signals&slots
    property int rows: 9
    property int columns: 9
    property int cellHeight: height / rows
    property int cellWidth: width / columns

    property string lastDir: "none"
    property int lastIndex: -1
    property int newIndex: -1

    id: playground

    anchors.fill: parent

//    onLastDirChanged: console.log("lastDir", lastDir)
//    onLastIndexChanged: console.log("lastIndex", lastIndex)

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

//    Connections {
//        target: dataModel
//        onDataModelChanged: {
//            console.log("item added")
//            Scripts.updateVisibleModel(dataModel, visibleModel);
//        }
//    }

    ListModel {
        id: topDeck
        ListElement {
            name: "top first"
        }
        ListElement {
            name: "top second"
        }
    }

    ListModel {
        id: bottomDeck
        ListElement {
            name: "bottom first"
        }
        ListElement {
            name: "bottom second"
        }
        ListElement {
            name: "bottom thrid"
        }
    }

    ListModel {
        id: leftDeck
        ListElement {
            name: "left first"
        }
        ListElement {
            name: "left second"
        }
    }

    ListModel {
        id: rightDeck
        ListElement {
            name: "right first"
        }
        ListElement {
            name: "right second"
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
            borderColor: "green"
        }

        // TODO: tohle to možná dost zalaguje
        onXChanged: {Scripts.topDir = {x: this.x, y: this.y, width: this.width, height: this.height}/*; console.log("x changed")*/}
        onYChanged: {Scripts.topDir = {x: this.x, y: this.y, width: this.width, height: this.height}/*; console.log("y changed")*/}
        onWidthChanged: {Scripts.topDir = {x: this.x, y: this.y, width: this.width, height: this.height}/*; console.log("width changed")*/}
        onHeightChanged: {Scripts.topDir = {x: this.x, y: this.y, width: this.width, height: this.height}/*; console.log("height changed")*/}
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
            movable: false
            borderColor: "red"

            MouseArea {
                anchors.fill: parent
                onClicked: cardModel.insert(0, {name:"appened"})
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
            borderColor: "green"
        }

        // TODO: tohle to možná dost zalaguje
        onXChanged: {Scripts.bottomDir = {x: this.x, y: this.y, width: this.width, height: this.height}/*; console.log("x changed")*/}
        onYChanged: {Scripts.bottomDir = {x: this.x, y: this.y, width: this.width, height: this.height}/*; console.log("y changed")*/}
        onWidthChanged: {Scripts.bottomDir = {x: this.x, y: this.y, width: this.width, height: this.height}/*; console.log("width changed")*/}
        onHeightChanged: {Scripts.bottomDir = {x: this.x, y: this.y, width: this.width, height: this.height}/*; console.log("height changed")*/}
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
            borderColor: "maroon"
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

        // TODO: tohle to možná dost zalaguje
        onXChanged: {Scripts.leftDir = {x: this.x, y: this.y, width: this.width, height: this.height}/*; console.log("x changed")*/}
        onYChanged: {Scripts.leftDir = {x: this.x, y: this.y, width: this.width, height: this.height}/*; console.log("y changed")*/}
        onWidthChanged: {Scripts.leftDir = {x: this.x, y: this.y, width: this.width, height: this.height}/*; console.log("width changed")*/}
        onHeightChanged: {Scripts.leftDir = {x: this.x, y: this.y, width: this.width, height: this.height}/*; console.log("height changed")*/}

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
            borderColor: "maroon"
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

        onXChanged: {Scripts.rightDir = {x: this.x, y: this.y, width: this.width, height: this.height}/*; console.log("x changed")*/}
        onYChanged: {Scripts.rightDir = {x: this.x, y: this.y, width: this.width, height: this.height}/*; console.log("y changed")*/}
        onWidthChanged: {Scripts.rightDir = {x: this.x, y: this.y, width: this.width, height: this.height}/*; console.log("width changed")*/}
        onHeightChanged: {Scripts.rightDir = {x: this.x, y: this.y, width: this.width, height: this.height}/*; console.log("height changed")*/}
    }

    Timer { // the calculation of button new position is triggered every timer.interval ms

        function move(inModel, dir) {
            if(newIndex > -1) {
                console.log("index", newIndex, "last", lastIndex)
                if(lastIndex !== newIndex && lastIndex > -1) {
                    console.log("move", lastIndex, "to", newIndex)
                    inModel.move(lastIndex, newIndex, 1)
                }
                lastIndex = newIndex
                lastDir = dir
            }
        }

        function rightIndex(x, y) {
            return right.indexAt(x + cellWidth / 2, y)
        }

        function leftIndex(x, y) {
            return left.indexAt(x - left.width -  cellWidth / 2, y)
        }

        function topIndex(x, y) {
            return top.indexAt(x, y - top.height - cellHeight / 2)
        }

        function bottomIndex(x, y) {
            return bottom.indexAt(x, y + cellHeight / 2)
        }

        function calcIndex() {
            var mapped = draggedItem.mapToItem(playground, 0, 0);
            var dir = Scripts.getDir(mapped.x, mapped.y)
//            var newIndex = -1
//            console.log(dir.dir)

            if(dir.dir === lastDir) {
                if(dir.dir === "right") {
                    newIndex = rightIndex(dir.x, dir.y);
                    move(rightDeck, dir.dir);
                }

                else if(dir.dir === "left") {
                    newIndex = leftIndex(dir.x, dir.y)
                    move(leftDeck, dir.dir);
                }
                else if(dir.dir === "top") {
                    newIndex = topIndex(dir.x, dir.y)
                    move(topDeck, dir.dir);
                }
                else if(dir.dir === "bottom") {
                    newIndex = bottomIndex(dir.x, dir.y)
                    move(bottomDeck, dir.dir);
                }
            }
            else if (dir.dir === "none"){  // different dir
                console.log("none")
            }
            else {
                lastDir = dir.dir
                lastIndex = -1
                console.log("else")
            }
        }

        id: timer
        interval: 250
        repeat: true
        onRunningChanged: {
            if(running == true) {
                calcIndex()
//                lastIndex = -1
//                lastDir = "none"
//                console.log("\n")
            }
        }
        onTriggered: calcIndex()
    }
}

