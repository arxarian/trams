.pragma library

var nRows = 0
var nColumns = 0

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

function updateVisibleModel(inModel, visibleModel) {

    for(var nIterInModel = 0; nIterInModel < inModel.data.length; nIterInModel++) {

        var nIndexInVisibleModel = -1;

        for(var nIterVisibleModel = 0; nIterVisibleModel < visibleModel.count; nIterVisibleModel++) {
            if(inModel.getItem(nIterInModel).name === visibleModel.get(nIterVisibleModel).name) {
                nIndexInVisibleModel = nIterVisibleModel;
                break;
            }
        }
        if(inModel.getItem(nIterInModel).added && nIndexInVisibleModel == -1) { // add to visibleModel
            visibleModel.set(0, inModel.getItem(nIterInModel));
        }
    }
}

function createModel(inModel, visibleModel) {

    // visibleModel inicialization
    for(var nIndex = 0; nIndex < nColumns * nRows; nIndex++) {
        visibleModel.append({"name":"", "added":false});
    }

    var middleIndex = (visibleModel.count - 1) / 2;
    inModel.setItem(0, {"origin":true, "added":true})
    visibleModel.set(middleIndex, inModel.getItem(0));
}
