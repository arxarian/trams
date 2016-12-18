import QtQuick 2.5
import QtQuick.Controls 1.4
import ProxyModel 1.0

Item {   // Stops-List Wrapper
    id: root

    property int stopsViewCount: 17

    Rectangle {
        id: line
        width: 1
        height: parent.height
        color: "black"
    }

    Item {
        anchors.left: line.right
        height: parent.height
        width: parent.width

        TextField {
            id: filterText
            width: parent.width
            height: parent.height * 0.1;

            font.pixelSize: 18
            placeholderText: "search tram stop..."

            onDisplayTextChanged: proxyModel.filterString = "^" + displayText;

            Connections {
                target: playgroundRoot
                onStateChanged: {
                    filterText.text = "";
                    filterText.focus = false;
                }
            }

            Image {
                anchors.rightMargin: parent.height * 0.4
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                height: filterText.height * 0.35
                width: filterText.height * 0.35

                smooth: true
                mipmap: true
                fillMode: Image.PreserveAspectFit
                source: "qrc:/search-icon.png"
            }
        }

        Rectangle {
            color: Qt.rgba(qmlRoot.redColor.r, qmlRoot.redColor.g, qmlRoot.redColor.b, 0.91)
            anchors.top: filterText.bottom
            anchors.bottom: parent.bottom
            width: parent.width

            ListView {
                id: list
                anchors.fill: parent

                model: ProxyModel {
                    id: proxyModel
                    source: dataModel.count > 0 ? dataModel : null
                    sortRole: dataModel.roleId("name")

                    filterRole: dataModel.roleId("name")
                }

                maximumFlickVelocity: 7500
                delegate: MouseArea {
                    width: root.width
                    height: root.height / (root.stopsViewCount - 1)

                    onClicked: {
                        clickAnimation.start();
                        playgroundRoot.selectedStop = dataModel.get(list.model.mapToSource(index))
                    }

                    SequentialAnimation {
                        id: clickAnimation
                        ColorAnimation {target: rect; property: "color"; from: "#2e472e"; to: rect.color}
                    }

                    Rectangle {
                        id: rect
                        anchors.fill: parent
                        color: "transparent"
                    }

                    Text {
                        anchors.fill: parent
                        anchors.leftMargin: parent.width * 0.05
                        verticalAlignment: Text.AlignVCenter
                        color: qmlRoot.lightColor
                        font.pixelSize: 18
                        text: name
                    }
                }
            }
        }
    }
}
