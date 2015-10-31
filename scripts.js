.pragma library

var nRows = 0
var nColumns = 0

function isIndexValid() {
    console.log("not implemented")
    return true;
}

function updateVisibleModel(inModel, visibleModel) {

    for(var nIterInModel = 0; nIterInModel < inModel.count; nIterInModel++) {

        var nIndexInVisibleModel = -1;

        for(var nIterVisibleModel = 0; nIterVisibleModel < visibleModel.count; nIterVisibleModel++) {
            if(inModel.get(nIterInModel).name === visibleModel.get(nIterVisibleModel).name) {
                nIndexInVisibleModel = nIterVisibleModel;
                break;
            }
        }
        if(inModel.get(nIterInModel).added && nIndexInVisibleModel == -1) { // add to visibleModel
            visibleModel.set(0, inModel.get(nIterInModel));
        }
    }
}

function createModel(inModel, visibleModel) {

    // visibleModel inicialization
    for(var nIndex = 0; nIndex < nColumns * nRows; nIndex++) {
        visibleModel.append({"name":"", "added":false});
    }

    var middleIndex = (visibleModel.count - 1) / 2;
    visibleModel.set(middleIndex, inModel.get(0));
}
