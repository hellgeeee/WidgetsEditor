import QtQuick 2.10

Image { // todo наверное это не надо
    source: "qrc:/../rs/svg/settings_gears.svg"
    height: stringHeight
    width: height
    NumberAnimation on rotation {
        running: parent.visible
        from: 0; to: 360;
        loops: Animation.Infinite;
        duration: 1200
    }
}
