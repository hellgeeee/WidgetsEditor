
import QtQuick 2.2
import QtQuick.Controls 2.10

Rectangle{
    id: delegate

    property bool selected: selectedParameters.indexOf(index) >= 0
    property url image: setImage(curentParameters[index].imageCur)
    property int parameterIndex: 0
    property string descr: // todo обобщить в функцию, иначе дублирование кода
     curentParameters[index].indexCur !== -1 ?
      qsTr("<i><small>Вы присвоили тип " + (curentParameters[index].representType === 0 ? "текстовый" : "аналоговый") +
      ", индекс " + curentParameters[index].indexCur +
      " и подпись \"" + curentParameters[index].signatureCur + "\" </small></i>") :
      ""

    width: parent.width
    height: stringHeight * 2


        Rectangle {
            id: row
                states: State {
                    name: "brighter"
                    when: selected
                    PropertyChanges { target: row; color: "ivory"; scale: 1}
                    PropertyChanges { target: titleText; color: "#000000"}
                    PropertyChanges { target: descriptionText; color: "#000000"}
                }

                transitions: Transition {
                    to: "brighter"
                    reversible: true
                    ParallelAnimation {
                        NumberAnimation {property: "scale"; duration: 500; easing.type: Easing.InQuart}
                        ColorAnimation { duration: 500 }
                    }
                }
            scale: 0.75

            anchors{
                centerIn: parent
                fill: parent
            }
            clip: true

            Row {
                id: title

                width: parent.width
                height: parent.height * 0.4
                spacing: smallGap
                anchors.centerIn: parent

                Item{width: smallGap; height: 1}
                Image {
                    id: img
                    visible: status === Image.Ready
                    height: visible ? parent.height : 0
                    width: height
                    source: image
                    onStatusChanged:
                        if(status === Image.Error){
                            errorWnd.show("Внимание, файл " + trimUrl(image) + " не был найден. \nПожалуйста, проверьте его наличие по указанному пути и соответствие его формата его расширению")
                            curentParameters[index].imageCur = ""
                        }
                }

                Text {
                    id: titleText

                    text: typeof(curentParameters[index]) !== "undefined" ? "<b>" + curentParameters[index].name + "</b>" : ""
                    wrapMode: Text.WordWrap
                    font: appFont
                    color: textColor
                }
            }

           Text {
                id: descriptionText

                anchors.top: title.bottom
                width: parent.width
                font: appFont
                textFormat: Text.RichText
                text: descr
                color: "transparent"
            }
        }

    MouseArea {
        anchors.fill: parent
        onClicked: {

            /// 1. Действия в интерфейсе списка по выделению либо сбросу параметра.
            /// параметр не был выделен - стал, был - выделение сбросилось
            selected = addOrReplace(index, selectedParameters)

            /// панель атрибутов показываем лишь тогда, когда есть выбранные параметры
            attributesContainer.opened = selectedParameters.length > 0
            selectedParametersCount = selectedParameters.length

            /// если произошел выбор параметра кликом (а не сброс), то тому, который был выбран до него (предпоследнему выбранному, получается),
            /// присваиваются значения атрибутов из табы атрибутов
            if(selected){
                if(selectedParametersCount > 1)
                    writeParamFromGui(selectedParameters[selectedParametersCount - 2])
                descr = "<b><i><small>Редактируется в данный момент</small></i></b>"
            }
            /// если произошел сброс параметра
            else resetParam(index)

            /// 2. Запись выбранных параметров в область редактирования текстового файла (false значит не включая последний)
            editingArea.paramsToJson(false)

            attributesTab.clear()
            //doneSound.play()
        }
    }

    Border{bBorder: 0}

    function setImage(imgName){
        image = imgName !== "" ?
            "file:///" + widgetsEditorManager.IPEFolder + "/qml/resources/svg/" + imgName + ".svg" :
            ""
        // раскомментить, если понадобится ставить картинку по умолчанию
        //"file:///" + widgetsEditorManager.IPEFolder + "/qml/resources/svg/" + "no-camera.svg"
        return image
    }
}
