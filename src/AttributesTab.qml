import QtQuick 2.2
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.4 // for spinbox style

Item{
   id : attributesTab

   property alias attributeIndex: attributeIndex.value
   property alias attributeSignature: attributeSignature.text
   property alias attributeUpperBondary: upperBondary.checked
   property alias attributeLowerBondary: lowerBondary.checked
   property alias attributeIcon: attributeIcon.text

   visible: attributesContainer.isEnoughRoomToShow
   enabled: curentMode === Mode.EditingMode.GRAPHIC_EDITING

   AttributeFieldPre{
       id: attributeIndexPrefix

       anchors{
           left: parent.left
           verticalCenter: attributeIndex.verticalCenter
       }
       text: qsTr("Индекс поля*")
   }

   SpinBox{
       id : attributeIndex

       anchors.left: attributeSignature.left
       width: attributeSignature.width
       height: font.pixelSize * 2 +1
       font: appFont
       editable: true
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
           top: attributeIndex.bottom; topMargin: smallGap * 2
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
       text: qsTr("Показывать границы *")
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
           id: lowerBondary
           text: qsTr("▼")
           font: appFont
       }
   }

   AttributeFieldPre{
       id: attributeIconPrefix
       visible: bar.currentIndex === 1
       anchors {
           left: attributeIndexPrefix.left
           verticalCenter: attributeIcon.verticalCenter
       }
       text: qsTr("Иконка поля")
   }

   AttributeFieldText{
       id : attributeIcon
       visible: bar.currentIndex === 1
       anchors{
           top: isShowBondaries.bottom; topMargin: smallGap*2
           left: attributeIconPrefix.right; right: parent.right
       }
       placeholderText: qsTr("Любые символы до 255 знаков")

       /// Почему здесь определили тултип: потому, что этот тултип рядом со своей кнопкой saveButtonMa не становится в правильную позицию, с (у меня нет идей, почему, может, из-за поворота -90)
       ToolTip.visible: saveButtonMa.containsMouse
       ToolTip.text: "Перевести отредактированные атрибуты в текстовый формат"
   }

   Image {
       id: saveButton

       source: "qrc:/../rs/svg/download-symbol.svg"
       height: stringHeight - smallGap
       width: height
       rotation: -90
       anchors {
           bottom: parent.bottom
           right: parent.right
           margins: smallGap
       }

       MouseArea {
           id: saveButtonMa
           anchors.fill: parent
           hoverEnabled: true
           onClicked: {
               writeParamFromGui(selectedParameters[selectedParametersCount - 1])
               editingArea.paramsToJson()
               doneSound.play()
           }

       }

   }
}
