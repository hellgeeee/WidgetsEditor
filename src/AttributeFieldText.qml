import QtQuick 2.2
import QtQuick.Controls 2.0
TextArea{
    anchors{
        top: parent.top
        right: parent.right
        margins: smallGap
    }
    wrapMode: TextEdit.WordWrap
    height: font.pixelSize * 2 +1
    font: appFont

    /// рамка
    Rectangle{color: "#00000000"; anchors.fill: parent; border.color: "grey"}
}
