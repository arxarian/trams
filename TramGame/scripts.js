.pragma library

var nRows = 0
var nColumns = 0

function leftIndex(index) {
    return index - 1;
}

function rightIndex(index) {
    return index + 1;
}

function upIndex(index) {
    return index - nColumns;
}

function downIndex(index) {
    return index + nColumns;
}

function checkPosition(index, model) {

    var location = true;

    if(model.get(leftIndex(index)).added) {
        location = location && (model.get(leftIndex(index)).longitude <= model.get(index).longitude);
        console.log(model.get(leftIndex(index)).longitude, "<", model.get(index).longitude)
    }
    console.log("left", location)
    if(model.get(rightIndex(index)).added) {
        location = location && (model.get(rightIndex(index)).longitude >= model.get(index).longitude);
        console.log(model.get(rightIndex(index)).longitude, ">", model.get(index).longitude)
    }
    console.log("right", location)
    if(model.get(downIndex(index)).added) {
        location = location && (model.get(downIndex(index)).latitude <= model.get(index).latitude);
        console.log(model.get(downIndex(index)).latitude, "<", model.get(index).latitude)
    }
    console.log("down", location)
    if(model.get(upIndex(index)).added) {
        location = location && (model.get(upIndex(index)).latitude >= model.get(index).latitude);
        console.log(model.get(upIndex(index)).latitude, ">", model.get(index).latitude)
    }
    console.log("up", location)
    //return location;
    model.setProperty(index, "location", location)
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
        console.log("true", index)
        return true;
    }

    return false;
}

function updateVisibleModel(index, inModel, visibleModel) {

    visibleModel.set(0, inModel.getItem(index));
    visibleModel.setProperty(0, "added", true)
}

function createModel(inModel, visibleModel) {

    // visibleModel inicialization
    for(var nIndex = 0; nIndex < nColumns * nRows; nIndex++) {
        visibleModel.append({"name":"", "added":false, "location":true});
    }

    var middleIndex = (visibleModel.count - 1) / 2;
    var randomIndex = (Math.random() * inModel.data.length).toFixed(0);

    inModel.setItem(randomIndex, {"origin":true, "added":true})
    visibleModel.set(middleIndex, inModel.getItem(randomIndex));
    visibleModel.setProperty(middleIndex, "location", true)

    // DEBUG
    randomIndex = (Math.random() * inModel.data.length).toFixed(0);
    inModel.setItem(randomIndex, {"added":true})
    visibleModel.set(middleIndex - 1, inModel.getItem(randomIndex));
    visibleModel.setProperty(middleIndex - 1, "location", true)
}
