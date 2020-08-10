import QtQuick 2.0

Item {

    property int tBorder: 1
    property int bBorder: 1
    property int rBorder: 1
    property int lBorder: 1

    anchors.fill: parent

    /// рамка
    Rectangle{color: borderColor; height: tBorder; width: parent.width; anchors.top: parent.top}
    Rectangle{color: borderColor; height: bBorder; width: parent.width; anchors.bottom: parent.bottom}
    Rectangle{color: borderColor; height: parent.height; width: rBorder; anchors.right: parent.right}
    Rectangle{color: borderColor; height: parent.height; width: lBorder; anchors.left: parent.left}
}
