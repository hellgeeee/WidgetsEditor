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
import Qt.labs.settings 1.0

Item {
    id: window

    property int curentMode: Mode.EditingMode.IN_OUT_SETTINGS
    property bool loading: false

    /// основное мерило - высота строчки - должно колебаться 30 - 16 px
    property int stringHeight : Math.min(30, Math.max(16, window.width * 0.05))
    property int smallGap : stringHeight * 0.2
    property font appFont: editingArea.appFont
    property color textColor: "#303030"
    property color borderColor: "lightgray"


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
        id: warnSound
        source: "qrc:/../rs/mp3/attention.mp3"
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
        height: stringHeight - smallGap
        width: height
        anchors {
            top: closeButton.top
            right: closeButton.left
            rightMargin: width
        }
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onClicked: menu.height === 0 ? menu.height = window.height  * 0.3 : menu.height = 0//menu.visible = !menu.visible
            ToolTip.visible: containsMouse
            ToolTip.text: "Опции"
        }
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

            ToolTip.visible: containsMouse
            ToolTip.text: "Закрыть"
        }
    }

    Settings {
        property alias width: window.width
        property alias height: window.height
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
            var attributesComp = widgetsEditorManager.categories[selectedCategories[catCompNum]].parameters//deviceCategoriesModel[selectedCategories[catCompNum]].attributes

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
        curentParameters[paramNum].upperBoundCur = false
        curentParameters[paramNum].lowerBoundCur = false
        curentParameters[paramNum].imageCur = ""
        curentParameters[paramNum].representType = -1
        editingArea.parametersList.itemAtIndex(paramNum).image = ""
        editingArea.parametersList.itemAtIndex(paramNum).description = ""
    }

    function writeParamFromGui(paramNum){
        curentParameters[paramNum].indexCur = editingArea.attributesTab.indexCur
        curentParameters[paramNum].signatureCur = editingArea.attributesTab.signatureCur
        curentParameters[paramNum].representType = editingArea.attributesModeCur
        editingArea.parametersList.itemAtIndex(paramNum).description =
            curentParameters[paramNum].indexCur !== -1 ?
                qsTr("<i><small>Параметр " + (curentParameters[paramNum].representType === Mode.AttributeRepresentation.TEXT ? "текстовый" : "аналоговый") +
                " с индексом " + editingArea.attributesTab.indexCur  +
                     "\nи подписью \"" + editingArea.attributesTab.signatureCur + "\" </i></small>") :
                ""
        if(curentParameters[paramNum].representType === Mode.AttributeRepresentation.ANALOG){
            curentParameters[paramNum].upperBoundCur = editingArea.attributesTab.upperBoundCur
            curentParameters[paramNum].lowerBoundCur = editingArea.attributesTab.lowerBoundCur
            curentParameters[paramNum].imageCur = editingArea.attributesTab.imageCur
            editingArea.parametersList.itemAtIndex(paramNum).image =
                    curentParameters[paramNum].imageCur !== "" ?
                        Qt.resolvedUrl("../rs/svg/" + curentParameters[paramNum].imageCur + ".svg") :
                        ""
        }
    }

    function trimUrl(str){
        if(str === "")
            return ""
        return str.toString().substring(8, str.length)
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

