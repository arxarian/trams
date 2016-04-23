import QtQuick 2.5
import QtQuick.Window 2.2

Window {
    property bool containsStop: false

    id: globalRoot

    /* BUG#1 (fixed) - pokud odeberu kartičku z jiného místa, než jsem právě vložil, vytvoří se volná kartička navíc
     *       - mělo by to fungovat, složí k tomu propertyIndex a propertyDir
     * BUG#2 - vytvořené políčko nezmizí, pokud přejedu přes jiné (zmizí, pokud ho přetáhnu v tom směru - a v druhém-, v kterém jsem to přitáhl)
     * BUG#3 - z-souřadnice kartiček (není úplně bug, spíš vlastnost)
     * BUG#4 - posunutí podložky posune kartu, kterou právě umisťuji
     * BUG#5 (fixed) - poté, co umístím kartičku do jiného směru, se mi opět vygeneruje pozice navíc (viz BUG#1)
     */



    visible: true
    width: 850
    height: 850
    color: "black"

    Playground {
        id: playground
        anchors.fill: parent
    }

    Rectangle {
        width: playground.cellWidth
        height: playground.cellHeight
        anchors.bottom: parent.bottom
        color: "silver"
        Text {
            anchors.centerIn: parent
            text: "new card"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: playground.newCard = !playground.newCard
        }
    }

//    Rectangle {
//        width: 100
//        height: 100
//        anchors.bottom: parent.bottom
//        anchors.right: parent.right
//        color: "silver"
//        Text {
//            anchors.centerIn: parent
//            text: "check positions"
//        }

//        MouseArea {
//            anchors.fill: parent
//            onClicked: playground.check = !playground.check
//        }
//    }
}

