import QtQuick 2.3
import QtTest 1.0
import "qrc:/../TramGame/scripts.js" as Scripts

TestCase {
    name: "TramGame, JS Unittests"

    ListModel {
        id: inModel
    }

    ListModel {
        id: visibleModel
    }

    function initTest(rows, columns) {
        Scripts.nRows = rows
        Scripts.nColumns = columns
    }

    // NAVIGATION UNIT TESTS
    function test_leftIndex() {
        initTest(5, 5);
        compare(Scripts.leftIndex(12), 11, "left in range");
        compare(Scripts.leftIndex(10), -1, "left out of range");
    }
    function test_rightIndex() {
        initTest(5, 5);
        compare(Scripts.rightIndex(12), 13, "right in range");
        compare(Scripts.rightIndex(14), -1, "right out of range");
    }
    function test_upIndex() {
        initTest(5, 5);
        compare(Scripts.upIndex(12), 7, "up in range");
        compare(Scripts.upIndex(2), -1, "up out of range");
    }
    function test_downIndex() {
        initTest(5, 5);
        compare(Scripts.downIndex(12), 17, "down in range");
        compare(Scripts.downIndex(22), -1, "down out in range");
    }

    function test_moveDirection() {
        initTest(5, 5);
        compare(Scripts.moveDirection(11), 0, "left");  // left
        compare(Scripts.moveDirection(13), 1, "right"); // right
        compare(Scripts.moveDirection(7), 2, "up");     // up
        compare(Scripts.moveDirection(17), 3, "down");  // down
    }

    // MOVING UNIT TESTS
//    function test_moveItems() {
//        initTest(7, 7);
//        inModel.append({"name":"0"})
//        Scripts.createModel(inModel, visibleModel);
//    }
}
