import QtQuick 2.0
import QtQml.Models 2.2
import "qrc:/scripts.js" as Scripts

Item {
    property bool check: false

    property int animationLenght: 200

//    property bool firstPlacementActive: false
//    property bool cellMoving: false
    property bool newCard: false // TODO: předělat na signals&slots
    property int rows: 9
    property int columns: 9
    property int cellHeight: height / rows
    property int cellWidth: width / columns
    property bool clearRequest: false

//    property string lastDir: "none"
//    property int lastIndex: -1

//    property bool canDrop: false

//    property bool placeCell: false;

//    property int karma: 0

//    property bool goodPlace: true


    id: playground
    anchors.fill: parent

//    onKarmaChanged: console.log("karma", karma)
    onNewCardChanged: { // tento slot generuje nové karty do deckModel
        var stop = createNewStop();
    }

    function createNewStop() {
            var component = Qt.createComponent("TramCell.qml");
            if(component.status !== Component.Ready) console.log("TramCell.qml creation error");
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

    // MIDDLE
    ListView {
        // TODO - později smazat

        id: middle
        anchors.centerIn: parent
        width: parent.width / playground.columns
        height: parent.height / playground.rows
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
//        deck: topDeck
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
//        deck: bottomDeck
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
//        deck: leftDeck
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
//        deck: rightDeck
    }
}

