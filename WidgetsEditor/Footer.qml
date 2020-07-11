import QtQuick 2.0

Rectangle {
    id: footerText

    property int selectedItemsCount: 0
    width: parent.width
    height: stringHeight
    color: "lightgray"
    visible: parent.parent.visible
    Text {
        text: qsTr("Всего выбрано: " + selectedItemsCount)
        anchors.centerIn: parent
        font: appFont
    }
}
