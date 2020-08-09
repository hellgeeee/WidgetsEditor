
import QtQuick 2.2
import QtQuick.Controls 2.10

Rectangle{
    property alias description: descriptionText.text
    property url image:
        curentParameters.length !== 0 && curentParameters[index].imageCur !== "" ?
            Qt.resolvedUrl("../rs/svg/" + curentParameters[index].imageCur + ".svg") :
            ""

    width: parent.width
    height: stringHeight * 2.5 // todo make width dependent on content
    border.color: borderColor

    Rectangle {
        id: delegate

        property int parameterIndex: 0

        clip: true

        anchors.fill: parent
        anchors.margins: 1 // чтобы не загораживать рамку

        scale: selectedParameters.indexOf(index) >= 0 ? 1 : 0.75
        color: selectedParameters.indexOf(index) >= 0 ? "ivory" : "white"
        Behavior on scale { PropertyAnimation { duration: 300 } }
        Behavior on color { ColorAnimation { duration: 300 } }

        Item {
            anchors.centerIn: parent
            anchors.fill: parent
            anchors.margins: smallGap
            clip: true

            Row {
                id: title

                width: parent.width
                height: parent.height * 0.4
                spacing: smallGap

                Image {
                    visible: status === Image.Ready
                    height: visible ? parent.height : 0
                    width: height
                    source: image
                    onStatusChanged:
                        if(status === Image.Error){
                            errorWnd.show("Внимание, файл " + image + " не был найден. \nПожалуйста, проверьте его наличие по указанному пути и соответствие его формата его расширению")
                            curentParameters[index].imageCur = ""
                        }
                }

                Text {
                    id: titleText

                    color: selectedParameters.indexOf(index) >= 0 ? "#000000" : "#303030"
                    text: typeof(curentParameters[index]) !== "undefined" ? "<b>" + curentParameters[index].name + "</b>" : ""
                    wrapMode: Text.WordWrap
                    font: appFont

                    Behavior on color { ColorAnimation { duration: 150 } }
                }
            }

           Text {
                id: descriptionText

                anchors.top: title.bottom
                width: parent.width
                font: appFont
                textFormat: Text.RichText
                text: curentParameters.length > 0 && curentParameters[index].indexCur !== -1 && selectedParameters.indexOf(index)?
                        qsTr("<i><small>Параметр" + (curentParameters[index].representType === 0 ? " текстовый" : " аналоговый") +
                        " с индексом " + curentParameters[index].indexCur +
                        "\nи подписью \"" + curentParameters[index].signatureCur + "\" </small></i>") :
                        ""
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {

                /// 1. Действия в интерфейсе списка по выделению либо сбросу параметра.
                /// параметр не был выделен - стал, был - выделение сбросилось
                var isAdded = addOrReplace(index, selectedParameters)

                /// панель атрибутов показываем лишь тогда, когда есть выбранные параметры
                attributesContainer.height = (selectedParameters.length > 0) ? window.height * 0.3 : 0

                /// если параметр выделен, яркий цвет и размер, сброшен - размер уменьшается и цвет блеклый
                titleText.color = isAdded >= 0 ? "#000000" : "#303030"
                delegate.scale = isAdded ? 1 : 0.75
                delegate.color = isAdded ? "ivory" : "white"
                descriptionText.text = "<b><i><small>" +qsTr(isAdded ? "Редактируется в данный момент" : "Выделение сброшено")+ "</small></i></b>"

                selectedParametersCount = selectedParameters.length

                /// если произошел выбор параметра кликом (а не сброс), то тому, который был выбран до него (предпоследнему выбранному, получается),
                /// присваиваются значения атрибутов из табы атрибутов
                if(isAdded && selectedParametersCount > 1)
                    writeParamFromGui(selectedParameters[selectedParametersCount - 2])

                /// если произошел сброс параметра
                else
                    resetParam(index)

                /// 2. Запись выбранных параметров в область редактирования текстового файла
                writeParamFromGui(selectedParameters[selectedParametersCount - 1])
                editingArea.paramsToJson()
                //doneSound.play()

            }
        }

    }
}
