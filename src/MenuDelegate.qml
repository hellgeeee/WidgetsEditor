
import QtQuick 2.10
import QtGraphicalEffects 1.0 // for ColorOverlay

Rectangle{

    property alias text: titleText.text
    property bool selected: ma.containsMouse
    property int mode
    property int length: text.length*titleText.font.pixelSize*0.8 + delimiter.width

    height: window.height * 0.18;
    width: 1

    Row {
        id: tile

        property color curColor: selected ? "#000000" : "#303030"

        anchors{
            fill: parent
            leftMargin: - length * 0.5
        }

        scale: selected ? 1.5 : 1.0
        Behavior on scale { PropertyAnimation { duration: 300 } }
        Behavior on curColor { ColorAnimation { duration: 300 } }

        Image {
            id: menuItemIcon
            width: height
            height: parent.height - smallGap
            source: "../rs/settings_gears.svg" // todo
            ColorOverlay {
                anchors.fill: parent
                source: parent
                color: tile.curColor  // make image like it lays under white glass
            }
        }

        /// border
        Rectangle{
            id: delimiter

            width: stringHeight
            height: 1
        }

        Text {
            id: titleText

            wrapMode: Text.WrapAnywhere
            anchors.verticalCenter: parent.verticalCenter
            font: typeof(EditingArea.appFont) !== "undefined" ?  EditingArea.appFont : font
            color: tile.curColor
        }

    }

    MouseArea {     //Rectangle{anchors.fill: parent; color: "#80f000ff"}
        id: ma
        anchors{
            left: tile.left; leftMargin: -(menu.anchors.leftMargin + tile.anchors.leftMargin)
            top: tile.top;
            bottom: tile.bottom
        }
        width: window.width
        hoverEnabled: true
        onClicked: {
            curentMode = mode;
            parent.parent.visible = false // todo странно, посмотреть
        }
    }

}
