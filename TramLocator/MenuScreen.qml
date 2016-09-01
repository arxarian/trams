import QtQuick 2.0

Item {
    id: menuRoot

    width: parent.width
    height: parent.height

    Column {
        id: column
        height: parent.height / 4
        width: parent.width / 3
        anchors.centerIn: parent
        spacing: 1; // TODO - zvětšit

        TramMainMenuButton {
            width: parent.width - column.spacing
            height: parent.height / 3
            text: "Compare"
            textColor: qmlRoot.redColor
            buttonColor: qmlRoot.redColor
            onClicked: screensView.currentIndex = 2;
        }
        TramMainMenuButton {
            width: parent.width - column.spacing
            height: parent.height / 3
            text: "About"
            textColor: qmlRoot.redColor
            buttonColor: qmlRoot.redColor
            onClicked: screensView.currentIndex = 0;
        }
        TramMainMenuButton {
            width: parent.width - column.spacing
            height: parent.height / 3
            text: "Exit"
            textColor: qmlRoot.redColor
            buttonColor: qmlRoot.redColor

            onClicked: Qt.quit();
        }
    }
}
