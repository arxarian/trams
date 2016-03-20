import QtQuick 2.5

Grid {
    property bool horizontal: false
    property string dir: "none"
//    property bool newPlace: false
//    property bool deletePlace: false
//    property int newPlaceIndex: 0

    id: root
    columns: horizontal ? 4 : 1
    rows: horizontal ? 1 : 4

    layoutDirection: root.dir === "west" ? Qt.RightToLeft : Qt.LeftToRight
    rotation: root.dir === "north" ? 180 : 0

//    onNewPlaceChanged: {
//        console.log("reparent request from", dir, "index", newPlaceIndex)
//        var component = Qt.createComponent("DropStop.qml");
//        if (component.status === Component.Ready) {
//            component.createObject(parent, {"x": 100, "y": 100});
//        }
//        console.log("create, place", newPlaceIndex)
//        listModel.insert(newPlaceIndex, {erasable: true});
//    }

    ListModel {
        id: listModel
        ListElement {
            erasable: false
        }
    }

    Repeater {
        model: listModel
        delegate: DropStop {
            width: cellWidth
            height: cellHeight
            rotation: root.dir === "north" ? 180 : 0
        }
    }
}
