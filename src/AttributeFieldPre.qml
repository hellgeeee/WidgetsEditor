import QtQuick 2.10

Text{
    width: prefixWidth
    height: font.pixelSize
    anchors{
        left: parent.left;
        verticalCenter: attributeIndex.verticalCenter
    }
    wrapMode: TextEdit.WordWrap
    font: appFont
}
