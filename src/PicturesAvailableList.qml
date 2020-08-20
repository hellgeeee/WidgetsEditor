import QtQuick 2.0
import "../rs/Light.js" as Styles

Rectangle {
    id: picsAvailableList

    property bool opened: false
    property var pictures: []
    property alias model: picsAvailableContent.model

    height: 0
    radius: Styles.Application.radius * 2
    border.color: Styles.Application.borderColor

    states: State {
        name: "opened"
        when: opened && attributesModeCur === Mode.AttributeRepresentation.ANALOG
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

    ListView {
        id: picsAvailableContent

        anchors.fill: parent
        clip: true
        model: pictures

        delegate: Rectangle{
            id: delegate

            visible: img.status !== Image.Error
            width: parent.width
            height: stringHeight
            radius: Styles.Application.radius * 2
            color: "transparent"

            Row{
                anchors {fill: parent; margins: smallGap * 0.5}
                spacing: smallGap
                Image{
                    id: img

                    property variant images: []

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
                    print("picture path: " + pictures[index].path + "picture ind " + index)
                    attributesTab.imgTxtValue = pictures[index].name

                    /// такие же действия происходят по нажатию Enter на поле имени картинки
                    curentParameters[selectedParameters[selectedParametersCount - 1]].imageCur = attributesTab.imgTxtValue // вписывание в логику
                    parametersList.itemAtIndex(selectedParameters[selectedParametersCount - 1]).setImage(attributesTab.imgTxtValue) // вписывание в интерфейс
                    paramsToJson()
                }
            }

            // разделитель
            Rectangle{
                anchors{
                    right: parent.right; rightMargin: smallGap
                    left: parent.left; leftMargin: smallGap
                    bottom: parent.bottom
                }
                height: 1
                color: Styles.Application.borderColor
            }
        }

    }
}
