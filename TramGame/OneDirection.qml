import QtQuick 2.0
import "qrc:/scripts.js" as Scripts

Item {
    property int layourDir: Qt.RightToLeft
    property int layoutOrient: Qt.Horizontal
    property int verticalLayout: ListView.TopToBottom
    property int cells: (playground.columns - 1) / 2
    property string dir: "left"

    property int activeIndex: -1        // index aktivní pozice pro položení (TraSpot, DropArea)

    id: root

    Connections {
        target: playground
        onClearRequestChanged: {
            // 1st - promzat prázdné (bez zastávky)
            for(var nIndex = 0; nIndex < cardModel.count; ++nIndex) {
                if(!cardModel.get(nIndex).containsStop) {
                    cardModel.remove(nIndex);
                    --nIndex;
                }
            }
            // 2nd - pokud jsou na všech pozicích zastávky, přidám novou pozici na konec
            if(dropAreaModel.count === cardModel.count) {
                dropAreaModel.append({});
            }
        }
    }

    ListModel {
        id:  dropAreaModel
        ListElement {
            noWarningRole: true
        }
    }

    ListView {  // DROP AREA

        id: dropAreaView

        anchors.fill: parent
        layoutDirection: root.layourDir
        orientation: root.layoutOrient
        verticalLayoutDirection: root.verticalLayout
        interactive: false
        model: dropAreaModel
        delegate: TramSpot {
            width: cellWidth
            height: cellHeight
            model: cardModel

            onContainsDragChanged: {
                if(containsDrag) {
                    activeIndex = index;
                    if(index !== playground.lastIndex || dir !== playground.lastDir) {
                        if(index <= cardModel.count) {
                            cardModel.insert(index, {"containsStop": false});
                        }
                    }
//                        lastDir = root.dir;
//                    }
//                    else if(lastDir === root.dir) {
////                        console.log("from", lastIndex, "to", index)
//                        root.deck.move(lastIndex, index, 1)
//                    }
//                    lastIndex = index
                }
                else {
//                    if(root.dir !== root.dir || (playground.karma == 0 && firstPlacementActive)) {
//                    if(/*!cardModel.get(index).containsStop ||  */(index !== playground.lastIndex && dir !== playground.lastDir)) {
                    if(!cardModel.get(index).containsStop) {
                        cardModel.remove(index);
                    }
                }
//                    lastDir = root.dir;
//                }
            }
        }
    }

    ListModel {
        id: cardModel
    }

    ListView {  // CARD VIEW
        id: cardView
        anchors.fill: parent
        layoutDirection: root.layourDir
        orientation: root.layoutOrient
        verticalLayoutDirection: root.verticalLayout
        interactive: false
        model: cardModel
        delegate: Item {
            // signalizuje novou zatávku na událost onReleased
            signal newStop();
            // směr, ve kterém delegát leží
            property string stopDir: root.dir
            // index delegáta
            property int stopIndex: index
            // noStop - pokud delegát potomka, zatávka byla přesunuta, a proto je označena pro smazání (containsStop = false)
            property bool noStop: children.length < 2   // NOTE - později změnit na 1 (dva kvůlu zelenému trojúhelníku)

            onNoStopChanged: {
                if(noStop) {
                    console.log("no stop", index)
                    cardModel.setProperty(index, "containsStop", false);
                }
            }

            objectName: "dropParent" + index
            width: cellWidth
            height: cellHeight

            onNewStop: {
                cardModel.setProperty(index, "containsStop", true);
                console.log("new stop", cardModel.get(index).containsStop);
            }


            Rectangle {
                anchors.fill: parent
                color: Qt.rgba(0, 1,0, 0.25)
            }
        }
        onCountChanged: {
            // smyčka zjistí, na kterou pozicí se zastávka právě vznáší - a onen objekt uloží do dragTarget
            var child = cardView.children[0];
            for(var i = 0; i < child.children.length; i++) {
                var oName = child.children[i].objectName;
                var strIndex = oName.replace("dropParent", "");
                if(activeIndex !== -1 && strIndex.length > 0 && activeIndex === Number(strIndex)) {
                    playground.dragTarget = child.children[i]; // využívá se k reparentování zastávky a k nastavení obaszenosti pozice v okamžiku puštění
                }
            }
        }
    }
}

