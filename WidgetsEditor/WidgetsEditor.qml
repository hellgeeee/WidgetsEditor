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
    width: 800
    height: 480
//    property string currentFeed: rssFeeds.get(0).feed
    property bool loading: true//feedModel.status === XmlListModel.Loading
    property int stringHeight : 30
    property int smallGap : 8
    property font appFont: deviceCategorySearch.font
    property int prefixWidth: barContainer.width * 0.33

    TextArea{
        id: deviceCategorySearch
        height: stringHeight
        anchors.left: deviceCategory.left
        anchors.right: deviceCategory.right
        placeholderText: qsTr("Поиск")
        wrapMode: TextEdit.WordWrap
        font.pixelSize: 14
    }
    ListView {
        id: deviceCategory
        property int itemWidth: 190
        width: itemWidth
        height: parent.height
        orientation: ListView.Vertical
        anchors.top: deviceCategorySearch.bottom
        model: facilityCategoriesModel
        delegate: CategoryDelegate {
            visible: model.name.toLowerCase().indexOf(deviceCategorySearch.text.toLowerCase()) >= 0 || deviceCategorySearch.text === ""
            property variant categoryModel: model
            //color: model.name
            itemSize: parent.width
        }
        spacing: 3
    }

    ScrollBar {
        orientation: Qt.Vertical
        height: deviceCategory.height;
        width: smallGap
        scrollArea: deviceCategory;
        anchors.right: deviceCategory.right
    }


    ListView {
        id: parameters
        anchors.left: deviceCategory.right
        anchors.right: fileEdit.left
        anchors.top: window.top
        anchors.bottom: barContainer.isEnoughRoomToShow ? barContainer.top : parent.bottom
        anchors.leftMargin: stringHeight
        anchors.rightMargin: stringHeight
        clip: true
        model: deviceCategory.currentItem.categoryModel.attributes
        footer: footerText
        delegate: ParameterDelegate {}
    }

    ScrollBar {
        scrollArea: parameters
        width: smallGap
        anchors.right: fileEdit.left
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
        visible: x > deviceCategory.width
        width: window.width * 0.3
        anchors.right: window.right
        anchors.top: deviceCategory.top
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
           AttributeFieldPrefix{
               id: isShowBondariesPrefix
               visible: bar.currentIndex == 1
               anchors.left: attributeIndexPrefix.left
               anchors.verticalCenter: isShowBondaries.verticalCenter
               text: qsTr("Показывать границы")
           }
           RowLayout {
               id: isShowBondaries
               visible: bar.currentIndex == 1 && (width > 0)
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

   Component {
       id: footerText
       Rectangle {
           width: parameters.width
           height: stringHeight
           color: "lightgray"
           visible: parent.parent.visible
           Text {
               text: qsTr("Выбрано атрибутов:")
               anchors.centerIn: parent
               font: appFont
           }
       }
   }
}
