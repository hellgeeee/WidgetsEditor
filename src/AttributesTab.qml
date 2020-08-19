import QtQuick 2.2
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls.Styles 1.4 // for spinbox style
import Qt.labs.settings 1.0
import Qt.labs.folderlistmodel 2.14

Item{
   id : attributesTab

   property alias indexSpinValue: indexSpin.value
   property alias imgTxtValue: imageTxt.text
   property string ipeFolder

   visible: attributesContainer.opened

   onIpeFolderChanged:{
       picsFolder.folder = "file:///" + widgetsEditorManager.IPEFolder + "/qml/resources/svg/"
       openPicsListBtn.source = "file:///" + widgetsEditorManager.IPEFolder + "/qml/resources/svg/" +  "open_eye.svg"
   }

   /// невидима, служит для считывания каталога картинок
   FolderListModel {
       id: picsFolder
       nameFilters: ["*.svg"]
       onFolderChanged: {
           for(var i = 0; i < picsFolder.count; i++){
               if(picsFolder.get(i, "fileIsDir"))
                   continue
               var name = picsFolder.get(i,"fileBaseName")//"open_eye.svg"// todo
               avalablePicsList.pictures[i] = []
               avalablePicsList.pictures[i].path = "file:///" + picsFolder.get(i,"filePath")
               avalablePicsList.pictures[i].name = name
           }
           avalablePicsList.model = avalablePicsList.pictures
       }
   }

   AttributeFieldPre{
       id: attributeIndexPrefix

       anchors{
           left: parent.left
           verticalCenter: indexSpin.verticalCenter
       }
       width: parent.width * 0.5
       text: qsTr("Индекс поля*")
   }

   SpinBox{
       id : indexSpin

       anchors{
           left: attributeIndexPrefix.right
           right: parent.right;
           margins: smallGap
       }
       height: stringHeight
       font: appFont
       editable: true
       value: 1
       onValueModified: {
           findIndexFstAvailable(true);
           paramsToJson()
       }
   }

   AttributeFieldPre{
       id: attributeSignaturePrefix

       anchors{
           left: parent.left
           verticalCenter: signatureTxt.verticalCenter
       }
       width: parent.width * 0.5
       text: qsTr("Подпись поля")
   }

   AttributeFieldText{
       id : signatureTxt

       anchors{
           left: attributeSignaturePrefix.right
           top: indexSpin.bottom
           right: parent.right;
           margins: smallGap
       }
       placeholderText: qsTr("Любые символы")
       onTextChanged: {
           curentParameters[selectedParametersCount - 1].signatureCur = text
           paramsToJson()
       }
       ToolTip.visible: hovered && shift < 0
       ToolTip.delay: 300

       Border{}
   }

   /// следующие два атрибута должны появляться лишь в случае, если поле аналоговое, т.е. выбрана вкладка bar.currentIndex == 1
   AttributeFieldPre{
       id: isShowBondariesPrefix

       visible: bar.currentIndex === Mode.AttributeRepresentation.ANALOG
       anchors{
           left: parent.left
           verticalCenter: upperBoundChb.verticalCenter
       }
       width: parent.width * 0.5
       text: qsTr("Показывать границы*")
   }

   CheckBox {
       id: upperBoundChb

       visible: bar.currentIndex === Mode.AttributeRepresentation.ANALOG
       anchors{
           top: signatureTxt.bottom
           left: attributeIndexPrefix.right
           margins: smallGap
       }
       text: qsTr("▲")
       indicator{height: stringHeight}
       onCheckStateChanged: {
           curentParameters[selectedParameters[selectedParametersCount - 1]].upperBoundCur = checked
           paramsToJson()
       }

   }
   CheckBox {
       id: lowerBoundChb

       visible: bar.currentIndex === Mode.AttributeRepresentation.ANALOG
       anchors{
           top: signatureTxt.bottom
           left: upperBoundChb.right
           right: parent.right;
           margins: smallGap
       }
       text: qsTr("▼")
       indicator{height: stringHeight}
       onCheckStateChanged: {
           curentParameters[selectedParameters[selectedParametersCount - 1]].lowerBoundCur = checked
           paramsToJson()
       }

   }

   AttributeFieldPre{
       id: attributeIconPrefix

       visible: bar.currentIndex === Mode.AttributeRepresentation.ANALOG
       anchors {
           left: parent.left
           verticalCenter: imageTxt.verticalCenter
       }
       width: parent.width * 0.5
       text: qsTr("Иконка поля")
   }

   AttributeFieldText{
       id : imageTxt

       visible: bar.currentIndex === Mode.AttributeRepresentation.ANALOG
       anchors{
           left: attributeIconPrefix.right
           top: upperBoundChb.bottom;
           right: parent.right;
           margins: smallGap
       }

       placeholderText: qsTr("Имя картинки")
       onTextChanged: {
           if(text.indexOf("\n") >= 0){ /// нажали на Enter
               text = text.replace("\n", "")
               curentParameters[selectedParameters[selectedParametersCount - 1]].imageCur = text // вписывание в логику
               parametersList.itemAtIndex(selectedParameters[selectedParametersCount - 1]).setImage(text) // вписывание в интерфейс
           }
           paramsToJson()
       }
       ToolTip.text: "Введите имя без расширения и нажмите Enter"
       ToolTip.delay: 300
       hoverEnabled: !avalablePicsList.opened

       Image {
           id: openPicsListBtn

           anchors {right: parent.right; rightMargin: smallGap}
           height: parent.height
           width: height
           smooth: true
           MouseArea{
               id: openPicsListBtnMa
               anchors.fill: parent
               hoverEnabled: true
               onClicked: avalablePicsList.opened = !avalablePicsList.opened
               ToolTip.text: "Посмотреть, какие есть"
               ToolTip.visible: containsMouse && !avalablePicsList.opened
               ToolTip.delay: 300
           }
           z: 1
       }

       Border{}
   }

   PicturesAvailableList{
       id: avalablePicsList

       width: imageTxt.width
       anchors{
           bottom: imageTxt.top
           left: imageTxt.left
       }
   }

   //Image {
      //id: saveButton
      //
      //source: "qrc:/../rs/svg/download-symbol.svg"
      //height: stringHeight - smallGap
      //width: height
      //rotation: -90
      //anchors {
      //    bottom: parent.bottom
      //    right: parent.right
      //    margins: smallGap
      //}
      //
      // MouseArea {
      //     id: saveButtonMa
      //
      //     anchors.fill: parent
      //     hoverEnabled: true
      //     onClicked: {
      //         writeParamFromGui(selectedParameters[selectedParametersCount - 1])
      //         editingArea.paramsToJson()
      //         //doneSound.play()
      //     }
      // }
   //}

   function findIndexFstAvailable(isImpactOnData = false){

       /// мы запоминаем все индексы элементов, что добавлены для каждой секции во избежание добавления элементов с одинаковыми индексами
       var indexesForTextAdded = []
       var indexesForAnalogAdded = []

       var indexFstAvailable = 1
       /// выяснение, в режиме редактирования секции каких параметров мы оказались - текстовых или аналоговых
       for(var i = 0; i < selectedParametersCount; i++)
            if(curentParameters[selectedParameters[i]].representType === Mode.AttributeRepresentation.TEXT)
               indexesForTextAdded.push(curentParameters[selectedParameters[i]].indexCur)
            else
               indexesForAnalogAdded.push(curentParameters[selectedParameters[i]].indexCur)

       if(attributesContainer.mode === Mode.AttributeRepresentation.TEXT){
           while(indexesForTextAdded.indexOf(indexFstAvailable) >= 0)
               indexFstAvailable++

          if(isImpactOnData){
              if (indexesForTextAdded.indexOf(indexSpin.value) >= 0){
                errorWnd.show("Внимание, во избежание дублирования индексов в пределах секции текстовых параметров \nпри записи индекс отредактированного параметра будет изменен с " + indexSpin.value + " на " + indexFstAvailable)
                indexSpin.value = indexFstAvailable
              }

               /// индексу последнего выбранного
                curentParameters[selectedParameters[selectedParametersCount - 1]].indexCur = indexSpin.value
          }
          else indexSpin.value = indexFstAvailable
       }
       else {
            while(indexesForAnalogAdded.indexOf(indexFstAvailable) >= 0)
                indexFstAvailable++

            if(isImpactOnData){
                if (indexesForAnalogAdded.indexOf(indexSpin.value) >= 0){
                  errorWnd.show("Внимание, во избежание дублирования индексов в пределах секции текстовых параметров \nпри записи индекс отредактированного параметра будет изменен с " + indexSpin.value + " на " + indexFstAvailable)
                  indexSpin.value = indexFstAvailable
                }

             /// индексу последнего выбранного
              curentParameters[selectedParameters[selectedParametersCount - 1]].indexCur = indexSpin.value
            }
            else indexSpin.value = indexFstAvailable
       }
   }

   function writeParam(paramNum){
       curentParameters[paramNum].indexCur = indexSpin.value
       curentParameters[paramNum].signatureCur = signatureTxt.text
       curentParameters[paramNum].representType = attributesContainer.mode
       editingArea.parametersList.itemAtIndex(paramNum).descr =
           curentParameters[paramNum].indexCur !== -1 ?
               qsTr("<i><small>Вы присвоили тип " + (curentParameters[paramNum].representType === Mode.AttributeRepresentation.TEXT ? "текстовый" : "аналоговый") +
               ", индекс " + curentParameters[paramNum].indexCur  +
               " и подпись \"" + curentParameters[paramNum].signatureCur + "\" </i></small>") :
               ""
       if(curentParameters[paramNum].representType === Mode.AttributeRepresentation.ANALOG){
           curentParameters[paramNum].upperBoundCur = upperBoundChb.checked // todo не происходит запись
           curentParameters[paramNum].lowerBoundCur = lowerBoundChb.checked
           curentParameters[paramNum].imageCur = imageTxt.text

           editingArea.parametersList.itemAtIndex(paramNum).setImage(curentParameters[paramNum].imageCur)
       }
       else
           editingArea.parametersList.itemAtIndex(paramNum).setImage("")
       paramsToJson()
   }

   function clear(){
       findIndexFstAvailable(false);
       signatureTxt.text = ""
       upperBoundChb.checked = false
       lowerBoundChb.checked = false
       imageTxt.text = ""
   }

}
