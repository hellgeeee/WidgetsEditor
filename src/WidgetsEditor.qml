/****************************************************************************
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
****************************************************************************/

import QtQuick 2.10
import QtQuick.XmlListModel 2.0
import QtQuick.Window 2.1
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

import "./"

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

    Image {
        id: settingsButton

        source: "../rs/settings_gears.svg"
        smooth: true
        height: stringHeight - smallGap
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
            onClicked: curentMode = curentMode!== Mode.EditingMode.SETTINGS ? Mode.EditingMode.SETTINGS : Mode.EditingMode.GRAPHIC_EDITING
        }

        ToolTip{
            visible: ma.containsMouse
            text: "Настройки";
            y: stringHeight
        }
    }

    Image {
        id: saveButton

        visible: curentMode === Mode.EditingMode.GRAPHIC_EDITING ||
                 curentMode === Mode.EditingMode.TEXT_EDITING
        source: "../rs/file.svg"
        height: stringHeight - smallGap
        width: height
        anchors {
            top: closeButton.top
            right: closeButton.left
            rightMargin: width
        }

        MouseArea {
            id: maSave
            anchors.fill: parent
            hoverEnabled: true
            onClicked:{

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
                            print("write file Without mistake")
                        } catch(e) {
                            print("write file mistake")
                            errorWnd.show(qsTr("Ошибка синтаксиса в текстовом файле вывода. Проверьте правильность выражений либо отредактируйте в графическом режиме"))
                        }
                    break

                  default:
                    break
                }
           }
        }

        ToolTip{
            visible: maSave.containsMouse
            text: "Сорханить изменения";
            y: stringHeight
        }
    }

    Image {
        id: closeButton
        source: "../rs/close-button.svg"
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
            onClicked: if(curentMode === Mode.EditingMode.ABOUT || curentMode === Mode.EditingMode.TUTORIAL)
                           curentMode = Mode.EditingMode.GRAPHIC_EDITING
                       else
                           Qt.quit()
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
        var intersection = widgetsEditorManager.categories[selectedCategories[0]].attributes
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
}
