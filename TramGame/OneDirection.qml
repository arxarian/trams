import QtQuick 2.0
import "qrc:/scripts.js" as Scripts

Item {
    property int layourDir: Qt.RightToLeft
    property int layoutOrient: Qt.Horizontal
    property int verticalLayout: ListView.TopToBottom
    property int cells: (playground.columns - 1) / 2
    property string dir: "left"

    property int activeIndex: -1

    id: root

    Connections {
        target: playground
        onClearRequestChanged: {
            // 1st - promzat prázdné (bez zastávky) - měl bych poznat z cardModel (poznám?)
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
//                console.log(root.dir, index, containsDrag)
                if(containsDrag) {
                    activeIndex = index;
//                    if((lastDir !== root.dir || playground.karma == 1)/* && !cellMoving*/) {
                    console.log("adding", index <= cardModel.count)
                        if(index <= cardModel.count) {
                            cardModel.insert(index, {containsStop: false});
//                            cardModel.insert(index, {});


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
//                        console.log("should remove", index, "lastDir", lastDir, "can remove", Scripts.canRemove(root.deck),"dir", playground.dir,"removed")
                    console.log("removing", !cardModel.get(index).containsStop)
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
            objectName: "dropParent" + index
            width: cellWidth
            height: cellHeight

            Rectangle {
                anchors.fill: parent
                color: Qt.rgba(0, 1,0, 0.25)
            }
        }
        onCountChanged: {
            var child = cardView.children[0];
            for(var i = 0; i < child.children.length; i++) {
                var oName = child.children[i].objectName;
                var strIndex = oName.replace("dropParent", "");
//                console.log("new index", strIndex, activeIndex, strIndex.length > 0 && activeIndex === Number(strIndex));
                if(activeIndex !== -1 && strIndex.length > 0 && activeIndex === Number(strIndex)) {
                    playground.dragTarget = child.children[i];
//                    console.log("playround", playground.dragTarget)
                    cardModel.setProperty(activeIndex, "containsStop", true);
                }
            }
        }
    }
}

