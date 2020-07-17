import QtQuick 2.2
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

Item{
   id : attributesTab

   property string attributeIndexValue: attributeIndex.text
   property string attributeSignatureValue: attributeSignature.text

   visible: barContainer.isEnoughRoomToShow
   enabled: curentMode === Mode.EditingMode.GRAPHIC_EDITING

   AttributeFieldPre{
       id: attributeIndexPrefix

       anchors{
           left: parent.left
           verticalCenter: attributeIndex.verticalCenter
       }
       text: qsTr("Индекс поля*")
   }

   AttributeFieldText{
       id : attributeIndex

       anchors {
           top: parent.top
           left: attributeIndexPrefix.right; right: parent.right
       }
       placeholderText: qsTr("Число до восьми знаков")
   }

   AttributeFieldPre{
       id: attributeSignaturePrefix

       anchors{
           left: attributeIndexPrefix.left
           verticalCenter: attributeSignature.verticalCenter
       }
       text: qsTr("Подпись поля")
   }

   AttributeFieldText{
       id : attributeSignature
       anchors{
           top: attributeIndex.bottom
           left: attributeSignaturePrefix.right; right: parent.right
       }
       placeholderText: qsTr("Любые символы до 255 знаков")
   }


   /// следующие два атрибута должны появляться лишь в случае, если поле аналоговое, т.е. выбрана вкладка bar.currentIndex == 1
   AttributeFieldPre{
       id: isShowBondariesPrefix
       visible: bar.currentIndex === 1
       anchors{
           left: attributeIndexPrefix.left
           verticalCenter: isShowBondaries.verticalCenter
       }
       text: qsTr("Показывать границы")
   }

   RowLayout {
       id: isShowBondaries
       visible: bar.currentIndex == 1
       anchors{
           top: attributeSignature.bottom
           left: isShowBondariesPrefix.right; right: parent.right
           margins: smallGap
       }
       clip: true
       CheckBox {
           id: upperBondary
           text: qsTr("▲")
           font: appFont
       }
       CheckBox {
           text: qsTr("▼")
           font: appFont
       }
   }

   AttributeFieldPre{
       id: attributeIconPrefix
       visible: bar.currentIndex == 1
       anchors {
           left: attributeIndexPrefix.left
           verticalCenter: attributeIcon.verticalCenter
       }
       text: qsTr("Иконка поля")
   }

   AttributeFieldText{
       id : attributeIcon
       visible: bar.currentIndex == 1
       anchors{
           top: isShowBondaries.bottom
           left: attributeIconPrefix.right; right: parent.right
       }
       placeholderText: qsTr("Любые символы до 255 знаков")
   }

   Image {
       id: saveButton

       visible: attributeIndex.text.length > 0
       source: "../rs/download-symbol.svg"
       height: stringHeight - smallGap
       width: height
       rotation: -90
       anchors {
           top: attributeIcon.bottom; topMargin: smallGap
           right: attributeIcon.right
       }

       MouseArea {
           anchors.fill: parent
           onClicked: with(editingArea){ paramsToJson(); transferParamsToList() }
       }
   }

}
