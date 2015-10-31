import QtQuick 2.0
import QtQml.Models 2.2
import "qrc:/scripts.js" as Scripts

Item {
    property bool newCard: false // TODO: předělat na signals&slots

    id: root

    onNewCardChanged: {
        // mark another card as added
        for(var i = 0; i < model.count; i++) {
            console.log(model.get(i).name, model.get(i).added)
            if(!model.get(i).added) {
                model.setProperty(i, "added", true)
                console.log("added")
                break;
            }
        }
    }

    ListModel {
        id: model
        ListElement {name: "Turnov"; added: true; origin: true}
        ListElement {name: "Praha"; added: false; origin: false}
        ListElement {name: "Liberec"; added: false; origin: false}
        ListElement {name: "Jihlava"; added: false; origin: false}

        onDataChanged: {
            console.log("city added")
            Scripts.updateVisibleModel(this, visibleModel);
        }
    }

    GridView {
        property int rows: 5
        property int columns: 5
        property int newIndex: -1
        property int lastIndex: -1
        property bool dragging: false

        ListModel {
            id: visibleModel
            Component.onCompleted: {
                Scripts.nRows = grid.rows
                Scripts.nColumns = grid.columns
                Scripts.createModel(model, this);
            }
            onDataChanged: {
                //Scripts.countVisibleItems(visibleModel);
                console.log("update visible model")
            }
        }

        id: grid

        anchors.fill: parent
        interactive: false
        cellHeight: height / rows
        cellWidth: width / columns
        model: visibleModel

        delegate: Rectangle {
            id: deleagateItem
            width: grid.cellWidth
            height: grid.cellHeight
            color: "transparent"
            border.width: grid.dragging ? 1 : 0
            border.color: mouseArea.enableIconOrder ? "gold" : "#50FFD700"

            Rectangle {
                id: draggedItem
                height: deleagateItem.height * 0.8
                width: deleagateItem.width * 0.8
                visible: added
                x: (deleagateItem.width - draggedItem.width) / 2;
                y: (deleagateItem.height - draggedItem.height) / 2;
                color: Qt.rgba(Math.random() / 2, Math.random() / 2, Math.random() / 2)
                border.width: 3
                border.color: Qt.rgba(1 - Math.random() / 2, 1 - Math.random() / 2, 1 - Math.random() / 2)
                radius: 10
                states: [   // draggedItem states
                    State {
                        when: mouseArea.enableIconOrder
                        ParentChange {
                            target: draggedItem
                            parent: root
                        }
                        PropertyChanges {
                            target: draggedItem;
                            border.width: 6
                        }
                    }
                ]

                Text {
                    anchors.margins: 15
                    anchors.fill: parent
                    text: name
                    color: "silver"
                    horizontalAlignment: Text.AlignLeft
                }

                MouseArea {
                    property bool enableIconOrder: false

                    id: mouseArea
                    anchors.fill: parent
                    drag.target: undefined

                    onPressAndHold: {
                        if(!visibleModel.get(index).origin) {
                            enableIconOrder = true; //TODO: vytvořit z toho stav?
                            grid.dragging = true; //TODO: přesunout do stavu
                            draggedItem.parent = root; //TODO: přesunout do stavu ?
                        }
                    }
                    onReleased: {
                        enableIconOrder = false;
                        grid.dragging = false;
                        // restore property binding
                        draggedItem.x = Qt.binding(function() {return (deleagateItem.width - draggedItem.width) / 2});
                        draggedItem.y = Qt.binding(function() {return (deleagateItem.height - draggedItem.height) / 2});
                    }
                    states: [   // mouseArea states
                        State {
                            when: mouseArea.enableIconOrder
                            PropertyChanges {
                                target: mouseArea
                                drag.target: mouseArea.parent
                            }
                            PropertyChanges {   // run timer
                                target: timer
                                running: true
                            }
                            StateChangeScript {
                                script: {
                                    grid.lastIndex = index;
                                    grid.newIndex = index;
                                }
                            }
                        }
                    ]
                    Timer { // the calculation of button new position is triggered every timer.interval ms
                        id: timer
                        interval: 400
                        repeat: true
                        onTriggered: {  // calculate new index
                            var mapped = draggedItem.mapToItem(grid, 0, 0);
                            var newIndex = grid.indexAt(mapped.x, mapped.y)
                            if(newIndex > -1) {
                                grid.newIndex = newIndex;
                            }
                        }
                    }
                }

                // behavior on x,y controls only selected button
                Behavior on x {
                    NumberAnimation {
                        //duration: Scripts.animationLength
                        easing.type: Easing.InOutCubic
                    }
                }
                Behavior on y {
                    NumberAnimation {
                        //duration: Scripts.animationLength
                        easing.type: Easing.InOutCubic
                    }
                }
            }
        }

        onNewIndexChanged: {
            if(lastIndex != newIndex) {
                if(!visibleModel.get(newIndex).origin) {
                    if(Scripts.isIndexValid(newIndex)) {
                        var nFrom = lastIndex;
                        var nTo = newIndex;
                        var nMin = Math.min(nFrom, nTo);
                        var nMax = Math.max(nFrom, nTo);
                        visibleModel.move(nMin, nMax, 1);
                        visibleModel.move(nMax - 1, nMin, 1);
                        lastIndex = newIndex;
                    }
                }
            }
        }

        move: Transition { // this transition controls the effected cells movement
            NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
        }
    }
}

