.pragma library

var nRows = 0
var nColumns = 0
var nMiddleIndex = -1

function leftInvalidIndex() {
    if(nMiddleIndex == -1) {
        computeMiddleIndex()
    }
    return nMiddleIndex - Math.floor(nColumns / 2) - 1;
}

function rightInvalidIndex() {
    if(nMiddleIndex == -1) {
        computeMiddleIndex()
    }
    return nMiddleIndex + Math.floor(nColumns / 2) + 1;
}

//function leftInvalidIndex() {
//    return nMiddleIndex - Math.floor(nColumns / 2) - 1;
//}

//function leftInvalidIndex() {
//    if(nMiddleIndex == -1) {
//        computeMiddleIndex()
//    }
//    return nMiddleIndex - Math.floor(nColumns / 2) - 1;
//}

function leftIndex(index) {
    if(nMiddleIndex == -1) {
        computeMiddleIndex()
    }

    var nLeftIndex = index - 1;
    return nLeftIndex < nMiddleIndex - Math.floor(nColumns / 2) ? -1 : nLeftIndex;
}

function rightIndex(index) {
    if(nMiddleIndex == -1) {
        computeMiddleIndex()
    }

    var nRightIndex = index + 1;
    return nRightIndex > nMiddleIndex + Math.floor(nColumns / 2) ? -1 : nRightIndex;
}

function upIndex(index) {
    if(nMiddleIndex == -1) {
        computeMiddleIndex()
    }

    var nUpIndex = index - nColumns;
    return nUpIndex < 0 ? -1 : nUpIndex;
}

function downIndex(index) {
    if(nMiddleIndex == -1) {
        computeMiddleIndex()
    }

    var nDownIndex = index + nColumns;
    return nDownIndex > nRows * nColumns - 1 ? -1 : nDownIndex;
}

function checkPosition(index, model) {

    var location = true;
    // TODO: qrc:/scripts.js:47: TypeError: Cannot read property 'added' of undefined
    if(model.get(leftIndex(index)).added) {
        location = location && (model.get(leftIndex(index)).longitude <= model.get(index).longitude);
//        console.log(model.get(leftIndex(index)).longitude, "<", model.get(index).longitude)
    }
//    console.log("left", location)
    if(model.get(rightIndex(index)).added) {
        location = location && (model.get(rightIndex(index)).longitude >= model.get(index).longitude);
//        console.log(model.get(rightIndex(index)).longitude, ">", model.get(index).longitude)
    }
//    console.log("right", location)
    if(model.get(downIndex(index)).added) {
        location = location && (model.get(downIndex(index)).latitude <= model.get(index).latitude);
//        console.log(model.get(downIndex(index)).latitude, "<", model.get(index).latitude)
    }
//    console.log("down", location)
    if(model.get(upIndex(index)).added) {
        location = location && (model.get(upIndex(index)).latitude >= model.get(index).latitude);
//        console.log(model.get(upIndex(index)).latitude, ">", model.get(index).latitude)
    }
//    console.log("up", location)
    //return location;
    model.setProperty(index, "location", location)
}

function isLeft(index) {
    return (index < nMiddleIndex && index > nMiddleIndex - Math.floor(nColumns / 2) - 1)
}

function isRight(index) {
    return (index > nMiddleIndex && index < nMiddleIndex + Math.floor(nColumns / 2) + 1)
}

function isUp(index) {
    return (index < nMiddleIndex && index % nColumns == Math.floor(nColumns / 2))
}

function isDown(index) {
    return (index > nMiddleIndex && index % nColumns == Math.floor(nColumns / 2))
}

function computeMiddleIndex() {
    nMiddleIndex = (nRows * nColumns - 1) / 2;
}

function moveDirection(index) {
    if(nMiddleIndex == -1) {
        computeMiddleIndex()
    }

    if(isLeft(index))
        return 0;
    if(isRight(index))
        return 1;
    if(isUp(index))
        return 2;
    if(isDown(index))
        return 3;

    return -1;
}

function isIndexValid(index) { // při umístění např. 12 je platný pouze 7, 11, 13 a 17
    // 12 není valid? Potlačuje to origin?
    // 5 x 5
    //       2
    //       7
    //10 11 12 13 14
    //      17
    //      22
    var xOffset = Math.floor(nColumns / 2);
    var yOffset = Math.floor(nRows / 2);

    if(index % nColumns == xOffset) {
        return true;
    }
    else if((index > yOffset * nColumns - 1) && index < (yOffset + 1) * nColumns) {
//        console.log("true", index)
        return true;
    }

    return false;
}

function updateVisibleModel(index, inModel, visibleModel) {

    visibleModel.set(0, inModel.getItem(index));
    visibleModel.setProperty(0, "added", true)
}

function moveItems(lastIndex, newIndex, visibleModel, lastMove) {

    if(lastIndex != newIndex) {
        if(!visibleModel.get(newIndex).origin) {
            if(isIndexValid(newIndex)) {
                var dir = moveDirection(newIndex)
                // TODO kontrola na přepadnutí
                // TODO revert
                if(dir == 0) {
                    lastMove = "left"
                    visibleModel.move(lastIndex, newIndex, 1);
                    visibleModel.move(leftInvalidIndex(), 0, 1)
                } else if(dir == 1) {
                    // right
                    lastMove = "right"  // TODO nelze méně pohybů?
                    visibleModel.move(rightInvalidIndex(), newIndex, 1);
                    visibleModel.move(newIndex, lastIndex, 1);
                    visibleModel.move(lastIndex + 1, newIndex, 1);
                } else if(dir == 2) {
                    // up
                    lastMove = "up"
                    // změnit flow? Propočítat?
                    console.log("to up")
                } else if(dir == 3) {
                    // down
                    lastMove = "down"
                    console.log("to down")
                } else {
                    console.log("invalid move")
                }

//                        var nFrom = lastIndex;
//                        var nTo = newIndex;
//                        var nMin = Math.min(nFrom, nTo);
//                        var nMax = Math.max(nFrom, nTo);
//                        visibleModel.move(nMin, nMax, 1);
//                        visibleModel.move(nMax - 1, nMin, 1);
//                        lastIndex = newIndex;

//                        // check position
//                        Scripts.checkPosition(newIndex, visibleModel);

            }
            else {
//                if(lastMove != "")
//                {
//                    lastMove = ""
//                    console.log("revert")
//                }
//                else {
//                    console.log("no revert")
//                }
            }
        }
    }
    return lastMove;
}

function createModel(inModel, visibleModel) {

    // visibleModel inicialization
    for(var nIndex = 0; nIndex < nColumns * nRows; nIndex++) {
        visibleModel.append({"name":"", "added":false, "location":true});
    }

    computeMiddleIndex()
    var randomIndex = (Math.random() * inModel.data.length).toFixed(0);

    inModel.setItem(randomIndex, {"origin":true, "added":true})
    visibleModel.set(nMiddleIndex, inModel.getItem(randomIndex));
    visibleModel.setProperty(nMiddleIndex, "location", true)

    // DEBUG
    randomIndex = (Math.random() * inModel.data.length).toFixed(0);
    inModel.setItem(randomIndex, {"added":true})
    visibleModel.set(leftIndex(nMiddleIndex), inModel.getItem(randomIndex));
    visibleModel.setProperty(leftIndex(nMiddleIndex), "location", true)

    randomIndex = (Math.random() * inModel.data.length).toFixed(0);
    inModel.setItem(randomIndex, {"added":true})
    visibleModel.set(rightIndex(nMiddleIndex), inModel.getItem(randomIndex));
    visibleModel.setProperty(rightIndex(nMiddleIndex), "location", true);

//    randomIndex = (Math.random() * inModel.data.length).toFixed(0);
//    inModel.setItem(randomIndex, {"added":true})
//    visibleModel.set(upIndex(nMiddleIndex), inModel.getItem(randomIndex));
//    visibleModel.setProperty(upIndex(nMiddleIndex), "location", true)

//    randomIndex = (Math.random() * inModel.data.length).toFixed(0);
//    inModel.setItem(randomIndex, {"added":true})
//    visibleModel.set(downIndex(nMiddleIndex), inModel.getItem(randomIndex));
//    visibleModel.setProperty(downIndex(nMiddleIndex), "location", true)}

    randomIndex = (Math.random() * inModel.data.length).toFixed(0);
    inModel.setItem(randomIndex, {"added":true})
    visibleModel.set(0, inModel.getItem(randomIndex));
    visibleModel.setProperty(0, "location", true);
}
