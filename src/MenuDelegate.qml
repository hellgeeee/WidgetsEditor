
import QtQuick 2.10
import QtGraphicalEffects 1.0 // for ColorOverlay

Rectangle{

    property alias text: titleText.text
    property bool selected: ma.containsMouse
    property int mode

    width: parent.width
    height: parent.height * 0.2
    border.color: borderColor
    color: "white"

    Rectangle{
        id: tile

        property color curColor: selected ? "#000000" : "#303030"

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
            height: parent.height * 0.6
            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
            }

            source: "qrc:/../rs/svg/settings_gears.svg" // todo
            ColorOverlay {
                anchors.fill: parent
                source: parent
                color: tile.curColor  // make image like it lays under white glass
            }
        }

        Text {
            id: titleText

            wrapMode: Text.WrapAnywhere
            anchors{
                verticalCenter: parent.verticalCenter
                left: menuItemIcon.right
            }

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
