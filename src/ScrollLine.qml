import QtQuick 2.10

Item {
    id: container

    property variant scrollArea

    opacity: 0.1

    function size()
    {
      return (scrollArea.visibleArea.heightRatio + scrollArea.visibleArea.yPosition) * container.height;
    }

    Rectangle { anchors.fill: parent; color: "Black"; opacity: 0.3 }

    BorderImage {
        width: smallGap; height: width * 2
        y: scrollArea.visibleArea.yPosition * container.height;
        Rectangle{
            anchors.fill: parent;
            anchors.margins: 1;
            radius: width * 0.5;
            color: "lightgray"
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
