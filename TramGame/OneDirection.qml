import QtQuick 2.0

Grid {
    property bool horizontal: false
//    property string dir: "none"

    columns: horizontal ? 4 : 1
    rows: horizontal ? 1 : 4

    Repeater {
        model: 4
        delegate: DropStop {
            width: cellWidth
            height: cellHeight
        }
    }
}

