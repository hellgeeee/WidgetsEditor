import QtQuick 2.2
import QtQuick.Controls 2.0
TextArea{
    id: attributeField

    property int tBorder: 1
    property int bBorder: 1
    property int rBorder: 1
    property int lBorder: 1
    property double shift: width - text.length * 0.5 * font.pixelSize

    hoverEnabled: true
    clip: true
    height: font.pixelSize * 2.5
    width: parent.width
    verticalAlignment: "AlignVCenter"
    font: appFont
    leftPadding: shift < 0 ? shift : smallGap

    ToolTip.visible: hovered && shift < 0
    ToolTip.text: attributeField.text;

    /// рамка
    Rectangle{color: borderColor; height: tBorder; width: parent.width; anchors.top: parent.top}
    Rectangle{color: borderColor; height: bBorder; width: parent.width; anchors.bottom: parent.bottom}
    Rectangle{color: borderColor; height: parent.height; width: rBorder; anchors.right: parent.right}
    Rectangle{color: borderColor; height: parent.height; width: lBorder; anchors.left: parent.left}
    //Rectangle{color: "white"; anchors.fill: parent; border.color: borderColor}

}
