import QtQuick 2.0

ListView {
    id: picsAvailableList

    property bool opened: false
    property var pictures: []

    height: 0
    clip: true
    model: pictures

    states: State {
        name: "opened"
        when: opened
        PropertyChanges {
            target: picsAvailableList
            height: Math.min(model.length * stringHeight, window.height * 0.5)
        }
    }
    transitions: Transition {
        to: "opened"
        reversible: true
        ParallelAnimation {
            NumberAnimation {property: "height"; duration: 500; easing.type: Easing.InQuart}
        }
    }

    delegate: Rectangle{
        id: delegate

        width: parent.width
        height: stringHeight
        clip: false

        Row{
            anchors {fill: parent; margins: smallGap * 0.5}
            spacing: smallGap
            Image{
                property variant images: []

                id: img

                height: parent.height
                width: height
                source:  typeof(pictures[index]) !== "undefined" ? pictures[index].path : ""
            }
            Text{
                height: parent.height
                width: parent.width - height
                font: appFont
                color: textColor
                text: typeof(pictures[index]) !== "undefined" ? pictures[index].name : ""
            }
        }
        MouseArea{
            anchors.fill: parent
            onClicked: {
                picsAvailableList.opened = false
                attributesTab.imgTxtValue = pictures[index].name

                /// такие же действия происходят по нажатию Enter на поле имени картинки
                curentParameters[selectedParameters[selectedParametersCount - 1]].imageCur = attributesTab.imgTxtValue // вписывание в логику
                parametersList.itemAtIndex(selectedParameters[selectedParametersCount - 1]).setImage(attributesTab.imgTxtValue) // вписывание в интерфейс
                paramsToJson()
            }
        }
        Border{bBorder: index === (picsAvailableList.model.length - 1)}
    }
    Border{
        rBorder:0; bBorder:0; lBorder: 0;
        tBorder: picsAvailableList.visibleArea.yPosition > 0
    }

}
