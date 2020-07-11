import QtQuick 2.0

Rectangle {
    id: infoBox

    property int selectedItemsCount: 3
    property alias text: txt.text

    onSelectedItemsCountChanged: {console.debug("prop changed: " + selectedItemsCount)}
    width: parent.width
    height: stringHeight
    color: "lightgray"
    visible: parent.parent.visible
    Text {
        id: txt
        text: qsTr("Всего выбрано: " + selectedItemsCount)
        anchors.centerIn: parent
        font: appFont
    }
}
