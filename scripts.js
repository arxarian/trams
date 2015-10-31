.pragma library

var visibleItems = 0; // ToDO velice dočasné!

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
            //addToVisibleModel(inModel.get(nIterInModel), visibleModel)
            visibleModel.set(visibleItems++, inModel.get(nIterInModel));
        }
//        if(!inModel.get(nIterInModel).added && nIndexInVisibleModel != -1) {
//            removeFromVisibleModel(nIndexInVisibleModel, visibleModel)
//        }
    }
}

function createModel(inModel, visibleModel, columns, rows) {

    // visibleModel inicialization
    //visibleItems = model
    for(var nIndex = 0; nIndex < columns * rows; nIndex++) {
        visibleModel.append({"name":"", "added":false});
    }

    var middleIndex = (visibleModel.count - 1) / 2;
    visibleModel.set(middleIndex, inModel.get(0));
}
