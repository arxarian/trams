import QtQuick 2.3
import QtTest 1.0
import "qrc:/../TramGame/scripts.js" as Scripts

TestCase {
    name: "TramGame, JS Unittests"

    function initTest(rows, columns) {
        Scripts.nRows = rows
        Scripts.nColumns = columns
    }

    // NAVIGATION UNIT TESTS
    function test_leftIndex() {
        compare(Scripts.leftIndex(4), 3);
    }
    function test_rightIndex() {
        compare(Scripts.rightIndex(4), 5);
    }
    function test_upIndex() {
        initTest(3, 3);
        compare(Scripts.upIndex(4), 1);
    }
    function test_downIndex() {
        initTest(3, 3);
        compare(Scripts.downIndex(4), 7);
    }
}
