import QtQuick 2.2
import QtQuick.Controls 2.10
import QtGraphicalEffects 1.0 // for DropShadow
import "../rs/Light.js" as Styles

Item{ // todo get rid of outer Rectangle
    id: delegate

    property bool selected: selectedParameters.indexOf(index) >= 0
    property bool hovered: ma.containsMouse
    property url image: curentParameters.length > 0 && typeof(curentParameters[index]) !== "undefined" && curentParameters[index].indexCur !== -1 ?
                            setImage(curentParameters[index].imageCur):
                            ""
    property int parameterIndex: 0
    property string descr: // todo обобщить в функцию, иначе дублирование кода
     curentParameters.length > 0 && typeof(curentParameters[index]) !== "undefined" && curentParameters[index].indexCur !== -1 ?
      qsTr("<i><small>Вы присвоили тип " + (curentParameters[index].representType === 0 ? "текстовый" : "аналоговый") +
      ", индекс " + curentParameters[index].indexCur +
      " и подпись \"" + curentParameters[index].signatureCur + "\" </small></i>") :
      ""

    width: parent.width
    height: stringHeight * 2

    /// вращение по появлению
    Component.onCompleted: if(parametersList.isUpdatingNow) showAnim.start()
    transform: Rotation { id:rt; origin.x: 0; origin.y: height; axis { x: 0.3; y: 1; z: 0 } angle: 0}//     <--- I like this one more!
    SequentialAnimation {
        id: showAnim
        running: false
        RotationAnimation { target: rt; from: 0; to: 45; duration: 100 * (index + 1); easing.type: Easing.OutQuart; property: "angle" }
        RotationAnimation { target: rt; from: 45; to: 0; duration: 100 * (index + 1) ; easing.type: Easing.InQuart; property: "angle" }
    }

    Rectangle {
        id: row

        states: [
            State {
            name: "brighter"
            when: selected
            PropertyChanges { target: row; color: Styles.Bulges.strongOutColor; scale: 0.95}
            PropertyChanges { target: titleText; color: Styles.Input.textColor}
            PropertyChanges { target: descriptionText; color: Styles.Input.textColor}
        },
            State {
            name: "hovered"
            when: hovered
            PropertyChanges { target: row; scale: 0.8}
        }]

        transitions: [
            Transition {
            to: "brighter"
            reversible: true
            ParallelAnimation {
                NumberAnimation {property: "scale"; duration: 500; easing.type: Easing.InQuart}
                ColorAnimation { duration: 500 }
            }
        },
            Transition {
            to: "hovered"
            reversible: true
            ParallelAnimation {
                NumberAnimation {property: "scale"; duration: 300}
            }
        }]

        scale: 0.75
        anchors{
            centerIn: parent
            //fill: parent
        }
        width: parent.width; height: stringHeight * 2
        border.color: borderColor
        radius: elementsRadius

      Row {
          id: title

          width: parent.width
          height: parent.height * 0.4
          spacing: smallGap
          anchors.centerIn: parent

            Item{width: 1; height: 1}
            Image {
                id: img
                visible: status === Image.Ready
                height: visible ? parent.height : 0
                width: height
                source: image
                onStatusChanged:
                    if(status === Image.Error){
                        errorWnd.show(qsTr("Внимание, файл " + trimUrl(image) + " не был найден. \nПожалуйста, проверьте его наличие по указанному пути и соответствие его формата его расширению"))
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
            anchors.left: parent.left; anchors.leftMargin: smallGap
            width: parent.width
            font: appFont
            textFormat: Text.RichText
            text: descr
            color: "transparent"
        }
    }

    MouseArea {
        id: ma

      anchors.centerIn: parent
      width: parent.width; height: stringHeight * 2

      hoverEnabled: true
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
                descr = "<b><i><small>Редактируется в данный момент</small></i></b>"// todo попробовать убрать
                attributesTab.writeParam(selectedParameters[selectedParametersCount - 1])
            }
            /// если произошел сброс параметра
            else resetParam(index)

            attributesTab.findIndexFstAvailable()
            //doneSound.play()
        }
    }


    DropShadow {
        parent: row.parent
        anchors.fill: source
        horizontalOffset: 3
        verticalOffset: 3
        radius: 20.0 * scale
        samples: Styles.Shadow.samples
        color: Styles.Shadow.slightColor
        source: row
        scale: row.scale
    }

    function setImage(imgName){
        image = imgName !== "" ?
            "file:///" + widgetsEditorManager.IPEFolder + "/qml/resources/svg/" + imgName + ".svg" :
            ""
        // раскомментить, если понадобится ставить картинку по умолчанию
        //"file:///" + widgetsEditorManager.IPEFolder + "/qml/resources/svg/" + "no-camera.svg"
        return image
    }
}
