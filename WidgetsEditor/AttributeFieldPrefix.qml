import QtQuick 2.0

Text{
    width: prefixWidth
    height: font.pixelSize
    anchors.left: parent.left
    anchors.verticalCenter: attributeIndex.verticalCenter
    wrapMode: TextEdit.WordWrap
    font: appFont
}
