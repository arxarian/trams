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

        ListModel {
            id: visibleModel
            Component.onCompleted: Scripts.createModel(model, this, grid.columns, grid.rows);
            onDataChanged: {
                //Scripts.countVisibleItems(visibleModel);
                console.log("update visible model")
            }
        }

        id: grid

        anchors.fill: parent
        interactive: false
        cellHeight: parent.height / rows
        cellWidth: parent.width / columns
        model: DelegateModel {
            property bool dragging: false

            function computeIndexDuringMove(itemX, itemY) {
                if(itemX > -1 && itemY > -1) {
                    var row = (itemY / grid.cellHeight).toFixed(0);
                    var column = (itemX / grid.cellWidth).toFixed(0);
                    if(row < grid.rows && column < grid.columns) {
                        var newIndex = Number(column) + Number(row * grid.columns);
                        if(newIndex >= 0 && newIndex < (grid.rows * grid.columns)) {
                            return newIndex;
                        }
                    }
                }
                return -1;
            }

            id: visibleView
            model: visibleModel
            delegate: Rectangle {
                id: deleagateItem
                width: grid.cellWidth
                height: grid.cellHeight
                color: "transparent"//Qt.rgba(Math.random(), Math.random(), Math.random(), 0.5)
                border.width: visibleView.dragging ? 1 : 0
                border.color: mouseArea.enableIconOrder ? "gold" : "#50FFD700"

                Rectangle {
                    id: draggedItem
                    height: deleagateItem.height * 0.8
                    width: deleagateItem.width * 0.8
                    x: (deleagateItem.width - draggedItem.width) / 2;
                    y: (deleagateItem.height - draggedItem.height) / 2;
                    visible: added

//                    Component.onCompleted: {
//                        console.log("index", index, "visible", added)
//                    }

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
                        anchors.centerIn: parent
                        text: model.name
                        color: "silver"
                    }

                    MouseArea {
                        property bool enableIconOrder: false

                        id: mouseArea
                        anchors.fill: parent
                        drag.target: undefined

                        onClicked: {
                            if(origin) console.log("origin")
                            else console.log("drag")
                        }

                        onPressAndHold: {
                            if(!origin) {
                                enableIconOrder = true;
                                visibleView.dragging = true;
                                draggedItem.parent = root;
                            }
                        }
                        onReleased: {
                            enableIconOrder = false;
                            visibleView.dragging = false;
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
                                    script: {   // calculate cell index
                                        var mapped = draggedItem.mapToItem(grid, 0, 0);
                                        var newIndex = visibleView.computeIndexDuringMove(mapped.x, mapped.y);
                                        if(newIndex > -1) {
                                            grid.lastIndex = newIndex;
                                            grid.newIndex = newIndex;
                                        }
                                    }
                                }
                            }
                        ]
                        Timer { // the calculation of button new position is triggered every timer.interval ms
                            id: timer
                            interval: 400
                            repeat: true
                            onTriggered: {
                                var mapped = draggedItem.mapToItem(grid, 0, 0);
                                var newIndex = visibleView.computeIndexDuringMove(mapped.x, mapped.y);
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
        }
        onNewIndexChanged: {
            if(lastIndex != newIndex) {
                // gridview layouts items implicitly (cannot be disabled), therefore we have to make MOVE statement twice in specific order
                //console.log(visibleView.items.get(lastIndex).added)
                //console.log(visibleView.items.get(newIndex).added)
                var nFrom = lastIndex;
                var nTo = newIndex;
                var nMin = Math.min(nFrom, nTo);
                var nMax = Math.max(nFrom, nTo);
                visibleView.items.move(nMin, nMax, 1);
                visibleView.items.move(nMax - 1, nMin, 1);
                lastIndex = newIndex;
            }
        }

        move: Transition { // this transition controls the effected cells movement
            NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
        }
    }
}

