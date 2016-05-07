import QtQuick 2.0
import "qrc:/scripts.js" as Scripts

Item {
    property variant deck: undefined
    property int layourDir: Qt.RightToLeft
    property int layoutOrient: Qt.Horizontal
    property int verticalLayout: ListView.TopToBottom
    property int cells: (playground.columns - 1) / 2
    property string dir: "left"

    id: root

    ListView {  // DROP AREA
        anchors.fill: parent
        layoutDirection: root.layourDir
        orientation: root.layoutOrient
        verticalLayoutDirection: root.verticalLayout
        interactive: false
        model: root.cells
        delegate: TramSpot {
            width: cellWidth
            height: cellHeight
            allowedIndex: root.deck.count + 1 - Scripts.canRemove(root.deck)

            onDropState: {
                console.log(root.dir, index, active)

                if(active) { // pořadí nezaručeno?!

                    if((lastDir !== root.dir || playground.karma == 1)/* && !cellMoving*/) {
                        if(index < root.deck.count + 1) {
                            root.deck.insert(index, {name: "", hidden: true})
                        }
                        lastDir = root.dir;
                    }
                    else if(lastDir === root.dir) {
//                        console.log("from", lastIndex, "to", index)
                        root.deck.move(lastIndex, index, 1)
                    }
                    lastIndex = index
                }
                else {
                    if(root.dir !== root.dir || (playground.karma == 0 && firstPlacementActive)) {
                        console.log("should remove", index, "lastDir", lastDir, "can remove", Scripts.canRemove(root.deck),"dir", playground.dir,"removed")
                            root.deck.remove(index);
                    }
                    lastDir = root.dir;
                }
            }
        }
    }

    ListView {  // CARD VIEW
        anchors.fill: parent
        layoutDirection: root.layourDir
        orientation: root.layoutOrient
        verticalLayoutDirection: root.verticalLayout
        interactive: false
        model: root.deck
        delegate: TramCell {
            dir: root.dir
            allowedIndex: root.deck.count + 1 - Scripts.canRemove(root.deck)
        }

        addDisplaced: Transition {
            NumberAnimation { properties: "x,y"; duration: playground.animationLenght}
        }

        move: Transition {
            NumberAnimation { properties: "x,y"; duration: playground.animationLenght}
        }

        displaced: Transition {
            NumberAnimation { properties: "x,y"; duration: playground.animationLenght}
        }
    }
}

