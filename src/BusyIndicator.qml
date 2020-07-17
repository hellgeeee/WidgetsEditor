import QtQuick 2.10

Image {
    id: container
    source: "../rs/settings_gears.svg"
    height: stringHeight
    width: height
    NumberAnimation on rotation {
        running: container.visible
        from: 0; to: 360;
        loops: Animation.Infinite;
        duration: 1200
    }
}
