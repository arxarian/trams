import QtQuick 2.0

Item {
    // version of game
    // last date of tramstops update
    // tramstops count
    // created by
    // license

    Text {
        anchors.centerIn: parent
        horizontalAlignment: Text.AlignHCenter
        text: "TramLocator " + appVersion +
              "\n" +
              "\nTramstops count: " + dataModel.count +
              "\n" +
              "\nLast update: " + compileTime +
              "\nCreated by arxarian@gmail.com"
        font.pixelSize: 16
    }
}
