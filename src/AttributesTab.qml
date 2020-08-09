import QtQuick 2.2
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.4 // for spinbox style
import Qt.labs.settings 1.0

Item{
   id : attributesTab

   property alias indexCur: indexCur.value
   property alias signatureCur: signatureCur.text
   property alias upperBoundCur: upperBoundCur.checked
   property alias lowerBoundCur: lowerBoundCur.checked
   property alias imageCur: imageCur.text

   visible: attributesContainer.visible
   enabled: curentMode === Mode.EditingMode.GRAPHIC_EDITING


   AttributeFieldPre{
       id: attributeIndexPrefix

       anchors{
           left: parent.left
           verticalCenter: indexCur.verticalCenter
       }
       width: parent.width * 0.5
       text: qsTr("Индекс поля*")
   }

   SpinBox{
       id : indexCur

       anchors{
           left: attributeIndexPrefix.right
           right: parent.right;
           margins: smallGap
       }
       height: stringHeight - smallGap
       font: appFont
       editable: true
   }

   AttributeFieldPre{
       id: attributeSignaturePrefix

       anchors{
           left: parent.left
           verticalCenter: signatureCur.verticalCenter
       }
       width: parent.width * 0.5
       text: qsTr("Подпись поля")
   }

   AttributeFieldText{
       id : signatureCur

       anchors{
           left: attributeSignaturePrefix.right
           top: indexCur.bottom
           right: parent.right;
           margins: smallGap
       }
       height: stringHeight - smallGap
       placeholderText: qsTr("Любые символы до 255 знаков")
   }

   /// следующие два атрибута должны появляться лишь в случае, если поле аналоговое, т.е. выбрана вкладка bar.currentIndex == 1
   AttributeFieldPre{
       id: isShowBondariesPrefix

       visible: bar.currentIndex === 1
       anchors{
           left: parent.left
           verticalCenter: isShowBondaries.verticalCenter
       }
       width: parent.width * 0.5
       text: qsTr("Показывать границы *")
   }

   RowLayout {
       id: isShowBondaries
       visible: bar.currentIndex == 1
       anchors{
           left: isShowBondariesPrefix.right
           right: parent.right;
           top: signatureCur.bottom
           margins: smallGap
       }
       height: stringHeight
       clip: true
       CheckBox {
           id: upperBoundCur

           text: qsTr("▲")
           font: appFont
           height: stringHeight - smallGap
           width: height
       }
       CheckBox {
           id: lowerBoundCur

           text: qsTr("▼")
           font: appFont
           height: stringHeight - smallGap
           width: height
       }
   }

   AttributeFieldPre{
       id: attributeIconPrefix

       visible: bar.currentIndex === 1
       anchors {
           left: parent.left
           verticalCenter: imageCur.verticalCenter
       }
       width: parent.width * 0.5
       text: qsTr("Иконка поля")
   }

   AttributeFieldText{
       id : imageCur

       visible: bar.currentIndex === 1
       anchors{
           left: attributeIconPrefix.right
           top: isShowBondaries.bottom;
           right: parent.right;
           margins: smallGap
       }
       height: stringHeight - smallGap

       placeholderText: qsTr("Любые символы до 255 знаков")

       /// Почему здесь определили тултип: потому, что этот тултип рядом со своей кнопкой saveButtonMa не становится в правильную позицию, с (у меня нет идей, почему, может, из-за поворота -90)
       ToolTip.visible: saveButtonMa.containsMouse
       ToolTip.text: "Сохранить текущий параметр \n(произойдет автоматически, когда перейдете на следующий)"
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
               //doneSound.play()
           }
       }
   }
}
