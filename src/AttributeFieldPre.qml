import QtQuick 2.10
import "../rs/Light.js" as Styles

Text{
    width: parent.width * 0.3
    height: font.pixelSize
    anchors{
        left: parent.left;
        verticalCenter: indexSpin.verticalCenter
    }
    wrapMode: TextEdit.WordWrap
    font: appFont
    color: Styles.Input.textColor
}
