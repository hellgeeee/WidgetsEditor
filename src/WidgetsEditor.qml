/****************************************************************************
** Copyright (C) 2020 Integra-s.
** Contact: olga.riazanova2011@ya.ru
****************************************************************************/

import QtQuick 2.10
import QtQuick.XmlListModel 2.0
import QtQuick.Window 2.1
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import QtQuick.Extras 1.4
import QtMultimedia 5.12



Item {
    id: window

    property int curentMode: Mode.EditingMode.IN_OUT_SETTINGS

    property bool loading: false
    property int stringHeight : 30
    property int smallGap : 8
    property font appFont: editingArea.appFont

    property var outFileContent: JSON.parse('{}')

    property variant selectedCategories: [] // todo узнать
    property int selectedCategoriesCount: 0

    property variant selectedParameters: []
    property int selectedParametersCount: 0
    property var curentParameters: []//:  typeof(facilityCategoriesModel) !== "undefined" ? findAvailableParamsIntersection() : null //EditingArea.deviceCategories.currentItem.categoryModel.attributes  : null // todo find intersection

    width: 800
    height: 480

    WidgetsEditorMenu{id: menu}
    EditingArea{id: editingArea}
    InOutSettings{id: inOutSettings}
    Tutorial{id: tutorial}
    About{id: about}
    ErrorWnd{id: errorWnd}

    MediaPlayer{
        id: errorSound
        source: "qrc:/../rs/mp3/error_but_funny2.mp3"
    }
    MediaPlayer{
        id: successSound
        source: "qrc:/../rs/mp3/success.mp3"
    }
    MediaPlayer{
        id: doneSound
        source: "qrc:/../rs/mp3/done.mp3"
        volume: 0.5
    }
    MediaPlayer{
        id: closeSound
        source: "qrc:/../rs/mp3/widget_closed.mp3"
        volume: 0.5
    }

    Image {
        id: settingsButton

        source: "qrc:/../rs/svg/settings_gears.svg"
        smooth: true
        height: stringHeight
        width: height
        anchors {
            top: closeButton.top
            right: saveButton.left
            rightMargin: smallGap * 0.5
        }
        MouseArea {
            id: ma
            anchors.fill: parent
            hoverEnabled: true
            onClicked: {
                curentMode = (curentMode!== Mode.EditingMode.SETTINGS ? Mode.EditingMode.SETTINGS : Mode.EditingMode.GRAPHIC_EDITING)

                /// костыль, почему-то не обновляется само собой
                menu.visible = curentMode === Mode.EditingMode.SETTINGS
            }
        }

        ToolTip{
            visible: ma.containsMouse
            text: "Настройки";
            y: stringHeight
        }
    }

    DelayButton{
        id: saveButton

        visible: curentMode === Mode.EditingMode.GRAPHIC_EDITING ||
                 curentMode === Mode.EditingMode.TEXT_EDITING
        enabled: checked === false

        height: stringHeight
        width: height
        anchors {
            top: closeButton.top
            right: closeButton.left
            rightMargin: width
        }
        delay: 1000

        onHoveredChanged: infoTooltip.visible = !infoTooltip.visible
        onActivated: {

            /// хотим, чтобы после клика кнопка немного помигала. Показывая, что в файл идет запись
            pause(3000).triggered.connect(function () {checked = false})

            switch(curentMode) {
                case Mode.EditingMode.GRAPHIC_EDITING:
                    ///editingArea.paramsToJson()
                    if(editingArea.outputFileText === '' ||
                        editingArea.outputFileText ===
                        '"text_params": {},
                        "analog_params": {},
                        "param_icons": {}'){
                        errorWnd.show(qsTr("Внимание, сохранение в файл не было произведено, поскольку никаких атрибутов выбрано и записано не было. Пустой виджет не имеет смысла"))
                        return
                    }
                    console.time("1")
                    widgetsEditorManager.outFileContent = JSON.stringify(outFileContent, [], '\t')
                break

                case Mode.EditingMode.TEXT_EDITING:
                    try {
                        outFileContent = JSON.parse(editingArea.outputFileText)
                        widgetsEditorManager.outFileContent = outFileContent
                    } catch(e) {
                        errorWnd.show(qsTr("Ошибка синтаксиса в текстовом файле вывода. Проверьте правильность выражений либо отредактируйте в графическом режиме"))
                    }
                break

              default:
                break
            }
            successSound.play()

        }

        Rectangle{anchors.fill: parent; anchors.margins: 1; radius: width * 0.5;
            Image {source: "qrc:/../rs/svg/download-symbol.svg"; anchors.fill: parent}
        }

        ToolTip{
            id: infoTooltip
            text: "Удерживайте, чтобы сорханить изменения во внешнюю память";
            y: stringHeight
        }
        //
    }

    Image {
        id: closeButton
        source: "../rs/svg/close-button.svg"
        height: stringHeight - smallGap
        width: height
        anchors{
            top: parent.top
            right: parent.right
            margins: smallGap * 0.5
        }

        MouseArea {
            id: maClose
            anchors.fill: parent
            hoverEnabled: true
            onClicked:
                if(curentMode === Mode.EditingMode.ABOUT
                    || curentMode === Mode.EditingMode.TUTORIAL
                    || curentMode === Mode.EditingMode.SETTINGS
                    || curentMode === Mode.EditingMode.IN_OUT_SETTINGS)
                       curentMode = Mode.EditingMode.GRAPHIC_EDITING
                    else{
                       window.visible = false
                       pause(1200).triggered.connect(function () {Qt.quit()})
                       closeSound.play();
                    }
        }

        ToolTip{
            visible: maClose.containsMouse
            text: "Закрыть";
            y: stringHeight
        }
    }



    function findAvailableParamsIntersection (){
        if(selectedCategories.length === 0 ){
            selectedParameters = []
            selectedParametersCount = 0
            return []
        }

        /// первая группа параметров - изначально параметры первой выбранной категории, но в последующих итерациях это пересечение, т.е. результат.
        /// т. е. вот как мы ищем (аi - параметры i-й категории):
        /// a1 ^ a2 = aRez
        /// aRez ^ a3 = aRez
        /// aRez ^ a4 = aRez ...
        var intersection = widgetsEditorManager.categories[selectedCategories[0]].parameters
        for(var catCompNum = 1; catCompNum < selectedCategories.length; catCompNum++){
            var intersectionCur = []
            var attributesComp = widgetsEditorManager.categories[selectedCategories[catCompNum]].attributes//deviceCategoriesModel[selectedCategories[catCompNum]].attributes

            /// ищем общие параметры из двух категорий
            for(var i = 0; i < intersection.length; i++){
                for(var j = 0; j < attributesComp.length; j++){
                    if(intersection[i].name === attributesComp[j].name){
                        intersectionCur.push(intersection[i])
                    }
                }
            }

            /// когда мы возьмем атрибуты следующей категории, мы будем их сравнивать уже не с атрибутами предыдущей, а с результатом
            intersection = intersectionCur
        }
        return intersection
    }

    function resetParam(paramNum){
        curentParameters[paramNum].indexCur = -1
        curentParameters[paramNum].signatureCur = ""
        curentParameters[paramNum].upperBoundaryCur = false
        curentParameters[paramNum].lowerBoundaryCur = false
        curentParameters[paramNum].imageCur = ""
        curentParameters[paramNum].representType = -1
        editingArea.parametersList.itemAtIndex(paramNum).image = ""
        editingArea.parametersList.itemAtIndex(paramNum).description = ""
    }

    function writeParamFromGui(paramNum){
        curentParameters[paramNum].indexCur = editingArea.attributesTab.attributeIndex
        curentParameters[paramNum].signatureCur = editingArea.attributesTab.attributeSignature
        curentParameters[paramNum].representType = editingArea.attributesContainer.mode
        editingArea.parametersList.itemAtIndex(paramNum).description =
            curentParameters[paramNum].indexCur !== -1 ?
                qsTr("Параметр " + (curentParameters[paramNum].representType === Mode.AttributeRepresentation.TEXT ? "текстовый" : "аналоговый") +
                " с индексом " + editingArea.attributesTab.attributeIndex +
                " и подписью \"" + editingArea.attributesTab.attributeSignature + "\" ") :
                ""
        if(curentParameters[paramNum].representType === Mode.AttributeRepresentation.ANALOG){
            curentParameters[paramNum].upperBoundaryCur = editingArea.attributesTab.attributeUpperBondary
            curentParameters[paramNum].lowerBoundaryCur = editingArea.attributesTab.attributeLowerBondary
            curentParameters[paramNum].imageCur = editingArea.attributesTab.attributeIcon
            editingArea.parametersList.itemAtIndex(paramNum).image = Qt.resolvedUrl("../rs/svg/" + curentParameters[paramNum].imageCur + ".svg")
        }
    }


    /// отсрочка для выполнения определенных действий (остальные действия она не тормозит)
    function pause(duration){
        var timer = Qt.createQmlObject("import QtQuick 2.0; Timer {}", editingArea);
        timer.interval = duration;
        timer.repeat = false;
        timer.start()
        return timer
    }
}

