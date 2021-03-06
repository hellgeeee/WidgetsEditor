import QtQuick 2.10
import QtGraphicalEffects 1.0 // for ColorOverlay
import "../rs/Light.js" as Styles

Rectangle{
    id: delegate

    property alias text: titleText.text
    property bool selected: ma.containsMouse
    property int mode
    property alias ma: ma
    property alias image: menuItemIcon.source

    width: parent.width
    height: parent.height * 0.15
    border.color: borderColor
    color: "white"
    radius: elementsRadius

    Rectangle{
        id: tile

        property color curColor: selected ? Styles.Input.textColor : Styles.Button.textColor

        anchors{
            fill: parent
            margins: smallGap * 0.5
        }
        scale: selected ? 1 : 0.75
        Behavior on scale { NumberAnimation { duration: 300 } }
        Behavior on curColor { ColorAnimation { duration: 300 } }

        Image {
            id: menuItemIcon

            width: height
            height: delegate.height
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }
        }

        Text {
            id: titleText

            wrapMode: Text.WrapAnywhere
            anchors {left: menuItemIcon.right; leftMargin: smallGap * 0.5}
            verticalAlignment: Text.AlignVCenter
            font: typeof(appFont) !== "undefined" ?  appFont : font
            color: tile.curColor
        }
    }

    MouseArea {     //Rectangle{anchors.fill: parent; color: "#80f000ff"}
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            curentMode = mode
            menu.opened = false
        }
}
}
