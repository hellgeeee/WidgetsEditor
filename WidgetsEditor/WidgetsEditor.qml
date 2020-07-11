/****************************************************************************
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
****************************************************************************/

import QtQuick 2.2
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

    property bool loading: false
    property int stringHeight : 30
    property int smallGap : 8
    property font appFont: deviceCategorySearch.font
    property int prefixWidth: barContainer.width * 0.33
    property var outputFileContent: JSON.parse('{}')
    width: 800
    height: 480
    signal widgetChanged(var outputFileContent)

    TextArea{
        id: deviceCategorySearch

        height: stringHeight
        anchors.left: deviceCategories.left
        anchors.right: deviceCategories.right
        placeholderText: qsTr("Поиск")
        wrapMode: TextEdit.WordWrap
        font.pixelSize: 14
        z: 10
    }

    ListView {
        id: deviceCategories

        property variant selectedItems: [1, "four", "five"]
        property int itemWidth: 190
        width: itemWidth
        orientation: ListView.Vertical
        anchors { top: deviceCategorySearch.bottom; bottom: parent.bottom}
        model: typeof(facilityCategoriesModel) !== "undefined" ? facilityCategoriesModel : null
        footer: Footer{selectedItemsCount: deviceCategories.selectedItems.length}
        delegate: CategoryDelegate {
            property variant categoryModel: model
            selectedItems: parameters.selectedItems
            visible: model.name.toLowerCase().indexOf(deviceCategorySearch.text.toLowerCase()) >= 0 || deviceCategorySearch.text === ""
            itemSize: visible ? parent.width : 0
        }
    }

    ScrollBar {
        orientation: Qt.Vertical
        height: deviceCategories.height;
        width: smallGap
        scrollArea: deviceCategories;
        anchors.right: deviceCategories.right
    }


    ListView {
        id: parameters

        property variant selectedItems: [1, 2, 3, "four", "five"]
        anchors.left: deviceCategories.right
        anchors.right: fileEdit.left
        anchors.top: window.top
        anchors.bottom: barContainer.isEnoughRoomToShow ? barContainer.top : parent.bottom
        anchors.leftMargin: stringHeight
        anchors.rightMargin: stringHeight
        clip: true
        model: typeof(facilityCategoriesModel) !== "undefined" ? deviceCategories.currentItem.categoryModel.attributes : null
        footer: Footer{selectedItemsCount: parameters.selectedItems.length}
        delegate: ParameterDelegate {selectedItems: parameters.selectedItems}
    }

    ScrollBar {
        scrollArea: parameters
        width: smallGap
        anchors.right: parameters.right
        anchors.top: window.top
        anchors.bottom: parameters.bottom
    }

    Item{
        id: barContainer
        property bool isEnoughRoomToShow: barContainer.width - 150> bar.height
        height: 180
        anchors.right: parameters.right
        anchors.left: parameters.left
        anchors.bottom: window.bottom

        TabBar {
           id: bar
           visible: parent.isEnoughRoomToShow
           rotation: 90
           x: (-width + height)/ 2
           y: -x
           height: profilesBtn.height
            currentIndex: 0
            font: appFont
            TabButton {
                id: profilesBtn
                width: barContainer.height * 0.5
                height: width*0.33;
                text: qsTr("Текстовое")
            }
            TabButton {
                width: profilesBtn.width
                id: filtersBtn
                height: width*0.33;
                text: qsTr("Аналоговое")
            }

        }
        StackLayout {
            anchors.fill: barContainer
            anchors.leftMargin: bar.height + smallGap
            anchors.topMargin: 8
            currentIndex: bar.currentIndex
            Loader { sourceComponent: attributesTab }
            Loader { sourceComponent: attributesTab }
        }
        Rectangle{anchors.left: parent.left; anchors.right: parent.right; height: 1; color: "gray"}
    }

    Image {
        id: settingsButton
        source: "../rs/settings_gears.svg"
        height: stringHeight - smallGap
        width: height
        anchors.top: closeButton.top
        anchors.right: saveButton.left
        anchors.rightMargin: smallGap * 0.5
    }

    Image {
        id: saveButton
        source: "../rs/file.svg"
        height: stringHeight - smallGap
        width: height
        anchors.top: closeButton.top
        anchors.right: closeButton.left
        anchors.rightMargin: width

        MouseArea {
            anchors.fill: parent
            onClicked: {
                paramsToJson()
            }
        }
    }

    Image {
        id: closeButton
        source: "../rs/close-button.svg"
        height: stringHeight - smallGap
        width: height
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: smallGap * 0.5

        MouseArea {
            anchors.fill: parent
            onClicked: {
                Qt.quit()
            }
        }
    }
    TextEdit {
        Rectangle{color: "#80804000"; anchors.fill: parent;}
        id: fileEdit
        visible: x > deviceCategories.width
        width: window.width * 0.3
        anchors.right: window.right
        anchors.top: deviceCategories.top
        anchors.bottom: fileNameInput.top
        textMargin: smallGap
        wrapMode: TextEdit.WordWrap
        text: qsTr("Текст, который в файле")
        clip: true
        font: appFont
//ListView{
//    id: scrA
//    anchors.fill: parent
//    anchors.margins: 100
//}
    }

//    ScrollBar {
//        width: 8
//        anchors.right: fileEdit.right
//        anchors.top: fileEdit.top
//        anchors.bottom: fileEdit.bottom
//        scrollArea: scrA
//    }

    TextArea {
        id: fileNameInput
        anchors.bottom: window.bottom
        anchors.left: fileEdit.left
        anchors.right: fileEdit.right
        placeholderText: qsTr("Название файла")
        wrapMode: TextEdit.WordWrap
        height: stringHeight
        font: appFont
    }

    Component{
       id : attributesTab
       Item{
           visible: barContainer.isEnoughRoomToShow
           AttributeFieldPrefix{
               id: attributeIndexPrefix
               anchors.left: parent.left
               anchors.verticalCenter: attributeIndex.verticalCenter
               text: qsTr("Индекс поля*")
           }
           AttributeField{
               id : attributeIndex
               anchors.top: parent.top
               anchors.left: attributeIndexPrefix.right
               anchors.right: parent.right
               placeholderText: qsTr("Число до восьми знаков")
//
           }
           AttributeFieldPrefix{
               id: attributeSignaturePrefix
               anchors.left: attributeIndexPrefix.left
               anchors.verticalCenter: attributeSignature.verticalCenter
               text: qsTr("Подпись поля")
           }
           AttributeField{
               id : attributeSignature
               anchors.top: attributeIndex.bottom
               anchors.left: attributeSignaturePrefix.right
               anchors.right: parent.right
               placeholderText: qsTr("Любые символы до 255 знаков")
           }


           /// следующие два атрибута должны появляться лишь в случае, если поле аналоговое, т.е. выбрана вкладка bar.currentIndex == 1
           AttributeFieldPrefix{
               id: isShowBondariesPrefix
               visible: bar.currentIndex == 1
               anchors.left: attributeIndexPrefix.left
               anchors.verticalCenter: isShowBondaries.verticalCenter
               text: qsTr("Показывать границы")
           }
           RowLayout {
               id: isShowBondaries
               visible: bar.currentIndex == 1
               anchors.top: attributeSignature.bottom
               anchors.left: isShowBondariesPrefix.right
               anchors.right: parent.right
               anchors.margins: smallGap
               clip: true
               CheckBox {
                   id: upperBondary
                   anchors.left: parent.left
                   text: qsTr("Нижнюю")
                   font: appFont
               }
               CheckBox {
                   anchors.left: upperBondary.right
                   anchors.right: parent.right
                   text: qsTr("Верхнюю")
                   font: appFont
               }
           }
           AttributeFieldPrefix{
               id: attributeIconPrefix
               visible: bar.currentIndex == 1
               anchors.left: attributeIndexPrefix.left
               anchors.verticalCenter: attributeIcon.verticalCenter
               text: qsTr("Иконка поля")
           }
           AttributeField{
               id : attributeIcon
               visible: bar.currentIndex == 1
               anchors.top: isShowBondaries.bottom
               anchors.left: attributeIconPrefix.right
               anchors.right: parent.right
               placeholderText: qsTr("Любые символы до 255 знаков")
           }

       }
   }

   function addOrDeleteItem(item, items){

   }

   function paramsToJson(){

       if(JSON.stringify(outputFileContent) === '{}'){
           outputFileContent["analog_params"] = JSON.parse('{}')
           outputFileContent["text_params"] = JSON.parse('{}')
           outputFileContent["param_icons"] = JSON.parse('{}')
       }
var attributes = { 'color': 'red', 'width': 100 }
attributes = attributes + { 'color': 'red', 'width': 100 }

       var analogAttrsCount = 1, textAttrsCount = 1
       for (var keyAnalog in outputFileContent["analog_params"])
           analogAttrsCount++
       for (var keyText in outputFileContent["analog_params"])
           textAttrsCount++

       outputFileContent["analog_params"][analogAttrsCount] = [analogAttrsCount, analogAttrsCount]
       outputFileContent["text_params"][textAttrsCount] = [textAttrsCount, textAttrsCount]
       outputFileContent["param_icons"][textAttrsCount] = [textAttrsCount, textAttrsCount]
       console.debug(JSON.stringify(outputFileContent))

       widgetChanged(outputFileContent);
   }
}
