
import QtQuick 2.2
import QtQuick.Controls 2.0
TextArea{
        Rectangle{color: "#00000000"; anchors.fill: parent; border.color: "grey"}
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: smallGap
        wrapMode: TextEdit.WordWrap
        height: font.pixelSize * 2 +1
        font: appFont
}
