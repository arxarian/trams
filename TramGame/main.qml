import QtQuick 2.5
import QtQuick.Window 2.2

Window {
    property bool containsStop: false

    id: globalRoot

    /* BUG#2 - vytvořené políčko nezmizí, pokud přejedu přes jiné (zmizí, pokud ho přetáhnu v tom směru - a v druhém-, v kterém jsem to přitáhl)
     * BUG#4 - posunutí podložky posune kartu, kterou právě umisťuji
     * BUG#7 - pokud novou kartičku pustím nad jinou kartičkou, vrátí mimo plochu, ale do toho samého směru nejde opět položit (protože playground.draggedRect.sourceDir si pamatuje poslední směr)
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

    Rectangle {
        width: playground.cellWidth
        height: playground.cellHeight
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        color: "silver"
        Text {
            anchors.centerIn: parent
            text: "check positions"
        }

        MouseArea {
            anchors.fill: parent
            onClicked: playground.check = !playground.check
        }
    }
}

