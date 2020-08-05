import QtQuick 2.2
import QtQuick.Controls 2.0
TextArea{
    id: attributeField

    property double shift: width - text.length * 0.5 * font.pixelSize

    hoverEnabled: true
    clip: true
    anchors{
        top: parent.top
        right: parent.right
        margins: smallGap
    }
    height: font.pixelSize * 2.5
    width: parent.width
    verticalAlignment: "AlignVCenter"
    font: appFont
    leftPadding: shift < 0 ? shift : smallGap

    ToolTip.visible: hovered && shift < 0
    ToolTip.text: attributeField.text;

    /// рамка
    Rectangle{color: "transparent"; anchors.fill: parent; border.color: "grey"}
}
