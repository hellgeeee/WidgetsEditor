/****************************************************************************
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
****************************************************************************/

import QtQuick 2.10
import QtQuick.XmlListModel 2.0
import QtQuick.Window 2.1
import QtQuick.Controls 1.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import "./"

Item {
    id: window

    property int curentMode: Mode.EditingMode.GRAPHIC_EDITING

    property bool loading: false
    property int stringHeight : 30
    property int smallGap : 8

    property var outputFileContent: JSON.parse('{}')
    signal widgetChanged(var outputFileContent)

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

    Image {
        id: settingsButton

        source: "../rs/settings_gears.svg"
        height: stringHeight - smallGap
        width: height
        anchors {
            top: closeButton.top
            right: saveButton.left
            rightMargin: smallGap * 0.5
        }
        MouseArea {
            anchors.fill: parent
            onClicked: curentMode = curentMode!== Mode.EditingMode.NONE ? Mode.EditingMode.NONE : Mode.EditingMode.GRAPHIC_EDITING
        }
    }

    Image {
        id: saveButton
        source: "../rs/download-symbol.svg"
        height: stringHeight - smallGap
        width: height
        anchors {
            top: closeButton.top
            right: closeButton.left
            rightMargin: width
        }

        MouseArea {
            anchors.fill: parent
            onClicked: with(editingArea){ paramsToJson(); transferParamsToList() }
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
            anchors.fill: parent
            onClicked: Qt.quit()
        }
    }


    BusyIndicator {
        id: choiceProcessing
        visible: true;//false
        anchors.centerIn: parent
        z: 1
    }

    function findAvailableParamsIntersection (){
        choiceProcessing.visible = true;
        if(selectedCategories.length === 0 )
            return [];

        var intersection = deviceCategoriesModel[selectedCategories[0]].attributes
        for(var catCompNum = 1; catCompNum < selectedCategories.length; catCompNum++){
            var intersectionCur = []
            var attributesComp = deviceCategoriesModel[catCompNum].attributes

            /// ищем общие параметры из двух категорий
            for(var iPar = 0; iPar < intersection.length; iPar++){
print("total length of first comparant "+  attributesComp.length)
                for(var iParComp = 1; iParComp < attributesComp.lenght; iParComp++){
print("iter " + iPar)
                    if(intersection[iPar].name === attributesComp[iParComp].name)
                        intersectionCur.push(intersection[iPar])
print("param "  + intersection[iPar] + " name " + intersection[iPar].name + " cat num: " + catCompNum + " num: " + iPar + " numComp: " + iParComp)
                }
            }
            intersection = intersectionCur
print(catCompNum + "__" +intersection.length)
        }
        choiceProcessing.visible = false
        return intersection
        //return deviceCategoriesModel[selectedCategories[0]].attributes;
    }

}
