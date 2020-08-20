import QtQuick 2.0
import QtQuick.Controls 2.14
import "../rs/Light.js" as Styles

Rectangle {
    id: infoBox

    property variant selectedItemsCount: 0
    property int availableItemsCount: 0
    property alias closeBtn: closeBtn
    property alias area: area

    width: parent.width
    anchors{
        bottom: parent.bottom
        left: parent.left
        right: parent.right
    }

    height: stringHeight + 2
    color: Styles.Shadow.deepColor

    /// для сокрытия при сжатии окна
    visible: parent.parent.visible

    MouseArea{
        id: area;

        anchors.fill: parent;
        hoverEnabled: true
    }
    Text {
        id: txt
        text: qsTr("Выбрано " + selectedItemsCount + " из " + availableItemsCount)
        font: appFont
        height: stringHeight
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        anchors.fill: parent
        anchors.rightMargin: stringHeight
        wrapMode: Text.WordWrap
    }

    Image {
        id: closeButton

        source: "qrc:/../rs/svg/close-button.svg"
        width: height
        anchors{
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            margins: smallGap
        }

        MouseArea {
            id: closeBtn

            anchors.fill: parent
            hoverEnabled: true
            ToolTip.visible: containsMouse
            ToolTip.text: "Снять выделение"
            ToolTip.delay: 300
        }
    }
}
