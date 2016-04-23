.pragma library

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
