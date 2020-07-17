import QtQuick 2.0

Rectangle {
    id: infoBox

    property int selectedItemsCount: 0
    property int availableItemsCount: 0

    width: parent.width
    height: stringHeight
    color: "lightgray"

    /// для сокрытия при сжатии окна
    visible: parent.parent.visible
    Text {
        id: txt
        text: qsTr("Всего выбрано: " + selectedItemsCount + " из " + availableItemsCount)
        anchors.centerIn: parent
        font: appFont
    }
}
