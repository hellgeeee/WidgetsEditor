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
    height: font.pixelSize * 2 +1
    font: appFont
    width: 100
    leftPadding: shift < 0 ? shift : smallGap
    ToolTip{
        visible: attributeField.hovered && shift < 0
        text: attributeField.text;
        y: stringHeight
    }

    /// рамка
    Rectangle{color: "transparent"; anchors.fill: parent; border.color: "grey"}
}
