.pragma library

var nRows = 0
var nColumns = 0
var nMiddleIndex = -1

var leftDir = []
var rightDir = []
var topDir = []
var bottomDir = []

function checkCoordinates(dir, firstCoordinate, secondCoordinate) {
    if(dir === "north") {
        return firstCoordinate <= secondCoordinate;
    }
    if(dir === "south") {
        return firstCoordinate >= secondCoordinate;
    }
    if(dir === "east") {
        return firstCoordinate <= secondCoordinate;
    }
    if(dir === "west") {
        return firstCoordinate >= secondCoordinate;
    }
}

function canRemove(inModel) {
    var count = 0;
    for(var nIndex = 0; nIndex < inModel.count; nIndex++) {
        if(inModel.get(nIndex).hidden && inModel.get(nIndex).name !== "") count++;
    }
    return count;
}

function getDir(x, y) {
/*    if(x > leftDir.x && x < leftDir.x + leftDir.width && y > leftDir.y && y < leftDir.y + leftDir.height) {
        return {dir:"left", x:(x - leftDir.x), y:(y - leftDir.y)};
    }
    else */if(x > rightDir.x && x < rightDir.x + rightDir.width && y > rightDir.y && y < rightDir.y + rightDir.height) {
        return {dir:"right", x:(x - rightDir.x), y:(y - rightDir.y)};
    }
//    else if(x > topDir.x && x < topDir.x + topDir.width && y > topDir.y && y < topDir.y + topDir.height) {
//        return {dir:"top", x:(x - topDir.x), y:(y - topDir.y)};
//    }
//    else if(x > bottomDir.x && x < bottomDir.x + bottomDir.width && y > bottomDir.y && y < bottomDir.y + bottomDir.height) {
//        return {dir:"bottom", x:(x - bottomDir.x), y:(y - bottomDir.y)};
//    }
    return {dir:"none"};
}

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

//function checkRight(referenceCard, inModel) {   // TODO: totálně předělat (např. dočasně vše vrazit do jednoho modelu, tím se vyhnu dvě šíleným cyklům)
//    var nLastCorrectIndex = 0;
//    var nIndex = 0;
//    while(nIndex < inModel.count) {
//        console.log(referenceCard.name, inModel.get(nIndex).name, referenceCard.longitude, "<", inModel.get(nIndex).longitude)
//        if(referenceCard.longitude < inModel.get(nIndex).longitude) {
//            nLastCorrectIndex = nIndex;
//            break;
//        }
//        console.log("while bad right position", nIndex)
//        nIndex++
//    }

//    for(nIndex = nLastCorrectIndex; nIndex < inModel.count - 1; nIndex++) {
//        console.log(inModel.get(nLastCorrectIndex).name, inModel.get(nIndex + 1).name, inModel.get(nLastCorrectIndex).longitude, "<", inModel.get(nIndex + 1).longitude)
//        if(inModel.get(nLastCorrectIndex).longitude < inModel.get(nIndex + 1).longitude) {
//            nLastCorrectIndex = nIndex + 1;
//        }
//        else {
//            console.log("for bad right position", nIndex)
//        }
//    }
//}

function duplicateArray(referenceCard, originalModel) {

    var outModel = []
    outModel.push(referenceCard);
    for(var nIndex = 0; nIndex < originalModel.count; nIndex++) {
        outModel.push(originalModel.get(nIndex));
    }
    return outModel;
}

function checkRight(referenceCard, originalModel) {   // TODO: totálně předělat (např. dočasně vše vrazit do jednoho modelu, tím se vyhnu dvě šíleným cyklům)

    var model = duplicateArray(referenceCard, originalModel)

    var nLastCorrectIndex = 0;

    for(var nIndex = 1; nIndex < model.length; nIndex++) {
        console.log(model[nLastCorrectIndex].name, model[nIndex].name, model[nLastCorrectIndex].longitude, "<", model[nIndex].longitude)
        if(model[nLastCorrectIndex].longitude < model[nIndex].longitude) {
            nLastCorrectIndex = nIndex;
            console.log("ok 0")
            continue;
        }
        if(nLastCorrectIndex - 1 < 0);
        else if(model[nLastCorrectIndex - 1].longitude < model[nIndex].longitude) {
            nLastCorrectIndex = nLastCorrectIndex - 1;
            console.log("ok 0")
            continue;
        }

        console.log("while bad right position", nIndex)
    }
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
