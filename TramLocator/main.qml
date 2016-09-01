import QtQuick 2.5
import QtQuick.Window 2.2
import QtQuick.Controls 1.4

ApplicationWindow {
    visible: true
    width: 480
    height: 800
    title: qsTr("Tram Locator")
//    visibility: Window.FullScreen

    onClosing: {
        if(Qt.platform.os === "android" && screensView.currentIndex !== 1) {
            close.accepted = false;
            screensView.currentIndex = 1;
        }
    }

    Item {
        id: qmlRoot

        property color redColor: "#e20401"
        property color lightColor: "#fdfdf0"

        anchors.fill: parent

        ListModel {
            id: screenModel

            ListElement {
                screenSource: "qrc:/AboutScreen.qml"
            }
            ListElement {
                screenSource: "qrc:/MenuScreen.qml"
            }
            ListElement {
                screenSource: "qrc:/PlaygroundScreen.qml"
            }
        }

        ListView {
            id: screensView

            currentIndex: 1
            anchors.fill: parent
            orientation: ListView.Horizontal
            snapMode: ListView.SnapOneItem
            highlightMoveDuration: 400
            highlightRangeMode: ListView.StrictlyEnforceRange   // changes the current index during flick
            cacheBuffer: count * width;     // keeps loaded items in memory, prevents objects' destructions, the number indicates how many pixels in row/column will be cached
            model: screenModel
            delegate: Component {
                Loader {
                    width: screensView.width
                    height: screensView.height
                    source: screenSource
                }
            }
        }
    }
}










