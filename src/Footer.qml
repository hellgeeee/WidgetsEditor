import QtQuick 2.0
import QtQuick.Controls 2.14

Rectangle {
    id: infoBox

    property variant selectedItemsCount: 0
    property int availableItemsCount: 0
    property alias closeBtn: closeBtn
    property alias area: area

    width: parent.width
    anchors.bottom: parent.bottom
    height: stringHeight
    color: "black"

    /// для сокрытия при сжатии окна
    visible: parent.parent.visible

    MouseArea{
        id: area;
        anchors.fill: parent;
        hoverEnabled: true
    }

    Row{
       anchors.centerIn: parent
        Text {
            id: txt
            text: qsTr("Выбрано: " + selectedItemsCount + " из " + availableItemsCount)
            //anchors {right: closeButton.left; verticalCenter: parent.verticalCenter}
            font: appFont
            height: stringHeight
            verticalAlignment: Text.AlignVCenter
        }

        Item{ width: smallGap; height: 1 }

        Image {
            id: closeButton
            source: "qrc:/../rs/svg/close-button.svg"
            height: stringHeight - smallGap
            width: height
            anchors.verticalCenter: parent.verticalCenter

            MouseArea {
                id: closeBtn
                anchors.fill: parent
                hoverEnabled: true
                ToolTip.visible: containsMouse
                ToolTip.text: "Снять выделения";
            }

        }
    }
}
