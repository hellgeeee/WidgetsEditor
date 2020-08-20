import QtQuick 2.10
import "../rs/Light.js" as Styles

Item {
    id: container

    property variant scrollArea

    opacity: 0
    width: smallGap

    Rectangle { anchors.fill: parent; color: Styles.Shadow.deepColor; opacity: 0.3 }

    BorderImage {
        width: smallGap;
        height: width * 2
        y: scrollArea.visibleArea.yPosition * container.height;
        Rectangle{
            anchors.fill: parent;
            anchors.margins: 1;
            radius: width * 0.5;
            color: Styles.Bulges.deepInColor
        }
    }
    states: State {
        name: "visible"
        when: scrollArea.movingVertically
        PropertyChanges { target: container; opacity: 1.0 }
    }

    transitions: Transition {
        from: "visible"; to: ""
        NumberAnimation { properties: "opacity"; duration: 600 }
    }
}
