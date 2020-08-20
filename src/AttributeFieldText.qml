import QtQuick 2.2
import QtQuick.Controls 2.0
import "../rs/Light.js" as Styles

TextArea{
    id: attributeField

    property double shift: width - text.length * 0.5 * font.pixelSize
    property bool isBorder: true

    clip: true
    height: stringHeight
    width: parent.width
    verticalAlignment: "AlignVCenter"
    font: appFont
    leftPadding: shift < 0 ? shift : smallGap
    hoverEnabled: true

    ToolTip.visible: hovered
    ToolTip.text: text
    ToolTip.delay: 300
    background : Rectangle{
        border.color: isBorder ? Styles.Application.borderColor: "transparent"
        radius: Styles.Application.radius
    }
}
