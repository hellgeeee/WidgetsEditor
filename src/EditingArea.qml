import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import Qt.labs.platform 1.1
import Qt.labs.settings 1.0
import QtQuick.Extras 1.4
import "../rs/Light.js" as Styles

//todo разбить
Item {
    id: editingArea

    property font appFont: deviceCategorySearch.font

    property alias attributesModeCur: attributesContainer.mode
    property alias attributesTab: attributesTab
    property alias categoriesModel: deviceCategoriesList.model
    property alias parametersList: parametersList
    property alias outFileName: outFileNameInput.text

    visible: curentMode === Mode.EditingMode.TEXT_EDITING || curentMode === Mode.EditingMode.GRAPHIC_EDITING
    anchors.fill: parent
    AttributeFieldText{
        id: deviceCategorySearch

        height: stringHeight
        width: deviceCategoriesList.width
        anchors{
           left: parent.left;
           top: parent.top
        }
        placeholderText: qsTr("Поиск")
        wrapMode: TextEdit.WordWrap
        font.pixelSize: stringHeight * 0.5
        ToolTip.visible: hovered && shift < 0
        ToolTip.delay: 300
    }


    Text{
        id: categoriesListEmptyText
        visible: categoriesInfoLine.availableItemsCount === 0
        text: "Считанный файл не содержит категорий устройств"
        anchors.fill: deviceCategoriesList
        font: appFont
        color: borderColor
        wrapMode: Text.WordWrap
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    ListView {
       id: deviceCategoriesList

       width: stringHeight * 8
       anchors {
           top: deviceCategorySearch.bottom;
           bottom: parent.bottom
       }
       clip: true
       orientation: ListView.Vertical

       maximumFlickVelocity: 5000
       model: typeof(widgetsEditorManager) !== "undefined" ? widgetsEditorManager.categories : null//typeof(deviceCategoriesModel) !== "undefined" ? deviceCategoriesModel : null

       delegate: CategoryDelegate {}

       Footer{
           id: categoriesInfoLine
           selectedItemsCount: selectedCategoriesCount
           availableItemsCount: (typeof(deviceCategoriesList.model) !== "undefined" && deviceCategoriesList.model !== null) ? deviceCategoriesList.model.length : 0
           width: deviceCategoriesList.width
           opacity: area.containsMouse || closeBtn.containsMouse? 0.3 : deviceCategoriesScroll.opacity * 0.3
           closeBtn.onClicked: {
               selectedCategories = []
               selectedCategoriesCount = 0
               selectedParameters = []
               selectedParametersCount = 0
               curentParameters = []

               /// Обновление списка. Пауза - чтобы возвращение к началу происходило красиво
               /// но это костыль: обновление внешнего вида модели не происходит естественным путем почему-то
               deviceCategoriesList.flick(0, deviceCategoriesList.maximumFlickVelocity)
               attributesContainer.opened = false
               parametersList.model = []

               pause(500).triggered.connect(function () {
                   deviceCategoriesList.model = []
                   deviceCategoriesList.model = widgetsEditorManager.categories
               })

               /// костыль! должно обновиться автоматически
               fileEdit.text = ""
           }
       }
    }

   ScrollLine {
       id: deviceCategoriesScroll

       height: scrollArea.height
       scrollArea: deviceCategoriesList
       anchors {
           right: deviceCategoriesList.right
           top: deviceCategorySearch.bottom
           bottom: parent.bottom
       }
   }

   Text{
       id: parametersListEmptyText
       visible: paramsInfoLine.availableItemsCount === 0
       text: "Категории не выбраны"
       anchors.centerIn: parametersList
       font: appFont
       color: borderColor
   }

       ListView {
           id: parametersList

           property bool isUpdatingNow: false

           anchors {
               left: deviceCategoriesList.right; leftMargin: smallGap
           }
           height: window.height - attributesContainer.height
           width: stringHeight * 12
           model: curentParameters
           delegate: ParameterDelegate {}
           onModelChanged: {
               /// для анимации нового списка параметров
               isUpdatingNow = true
               pause(5000).triggered.connect(function () {
                   isUpdatingNow = false
               })
           }

           Footer{
               id: paramsInfoLine
               selectedItemsCount: selectedParametersCount
               availableItemsCount: curentParameters.length
               opacity: area.containsMouse || closeBtn.containsMouse ? 0.3 : parametersScroll.opacity * 0.3
               closeBtn.onClicked: {
                   selectedParameters = [];
                   selectedParametersCount = 0

                   /// Обновление списка. Пауза - чтобы возвращение к началу происходило красиво, т.е. список успевал колыхнуться
                   parametersList.flick(0, parametersList.maximumFlickVelocity)
                   pause(500).triggered.connect(function () {

                       /// костыль: обновление внешнего вида модели не происходит естественным путем почему-то
                       parametersList.model = [];
                       parametersList.model = curentParameters
                   })
                   attributesTab.clear()

                   /// костыль!
                   attributesContainer.opened = false
                   fileEdit.text = ""
               }
           }
       }

       ScrollLine {
           id: parametersScroll

           scrollArea: parametersList
           width: smallGap
           anchors {
               right: parametersList.right;
               top: parent.top;
               bottom: parametersList.bottom
           }
       }

       Rectangle{
           id: attributesContainer

           property bool isEnoughRoomToShow: width - 70 > bar.height
           property int mode: bar.currentIndex
           property bool opened: false

           onModeChanged:  {
               attributesTab.indexSpinValue = curentParameters[selectedParameters[selectedParametersCount - 1]].indexCur
               /// найди наименьший подходящий индекс (true - значит переприсвоить, если текущий повторяет имеющиеся), потом запиши последний параметр
               attributesTab.findIndexFstAvailable(true)
               attributesTab.writeParam(selectedParameters[selectedParametersCount - 1])
               attributesTab.findIndexFstAvailable(false) // false - значит индекс влияет только на спинбокс, но не наданные
           }

           anchors{
               right: parametersList.right;
               left: parametersList.left
               bottom: deviceCategoriesList.bottom
           }

           states: State {
               name: "opened"
               when: attributesContainer.opened
               PropertyChanges { target: attributesContainer; height: stringHeight * 6}
           }
           transitions: Transition {
               to: "opened"
               reversible: true
               ParallelAnimation {
                   NumberAnimation {property: "height"; duration: 500; easing.type: Easing.InQuart}
               }
           }

           border.color: borderColor
           radius: elementsRadius

           TabBar {
              id: bar

              visible: parent.isEnoughRoomToShow && attributesContainer.opened
              rotation: 90
              x: (-width + height )/ 2 + 1 // +1 и +2 здесь для того, чтобы кнопки не загораживали рамку
              y: - x + 2
              height: stringHeight * 1.5
              currentIndex: 0
              font: appFont

               TabButton {
                   id: textRepresentationModeBtn

                   width: attributesContainer.height * 0.33
                   height: parent.height
                   anchors.bottom: parent.bottom
                   Text{
                       font: appFont
                       rotation: -30; text: qsTr("<b>Текстовый</b>");
                       color: textRepresentationModeBtn.checked ? "black" : "white"
                       anchors.centerIn: parent
                       verticalAlignment: Text.AlignVCenter
                       scale: 0.7
                   }
               }

               TabButton {
                   id: analogRepresentationModeBtn

                   width: textRepresentationModeBtn.width
                   height: parent.height
                   anchors.bottom: parent.bottom
                   Text{
                       font: appFont
                       rotation: -30; text: qsTr("<b>Аналоговый</b>");
                       color: analogRepresentationModeBtn.checked ? "black" : "white"
                       anchors.centerIn: parent
                       verticalAlignment: Text.AlignVCenter
                       scale: 0.7
                   }
               }

               TabButton {
                   id: boolRepresentationModeBtn

                   width: textRepresentationModeBtn.width
                   height: parent.height
                   anchors.bottom: parent.bottom
                   Text{
                       font: appFont
                       rotation: -30; text: qsTr("<b>Битовый</b>");
                       color: boolRepresentationModeBtn.checked ? "black" : "white"
                       anchors.centerIn: parent
                       verticalAlignment: Text.AlignVCenter
                       scale: 0.7
                   }
               }

           }
           AttributesTab{
               id: attributesTab

               anchors {
                   fill: parent
                   leftMargin: bar.height + smallGap
                   topMargin: smallGap
               }
           }
       }

       Rectangle{
           id: fileEditContainer

           color: "lightgrey"
           anchors{
                right: parent.right
                left: parametersList.right; leftMargin: smallGap
                top: deviceCategoriesList.top
                bottom: parent.bottom; bottomMargin: stringHeight
           }

           Flickable {
               id: fileEditMovableContainer
               anchors.fill: parent
               contentWidth: width;
               contentHeight: fileEdit.height
               clip: true

               TextArea{
                   id: fileEdit

                   /// предполагаем, что ширина буквы примерно 0.7 от ее высоты
                   property double textHeight: ( text.length * (font.pixelSize * 0.7) / width // сколько строчек
                                               + text.split("\n").length - 1) // с учетом переносов на новую строку ( при этом получится с большим запасом)
                                               * font.pixelSize * 1.2 // высота строчки
                   anchors{ top: parent.top; topMargin: -height * 0.1}
                   scale: 0.8
                   width: parent.width;
                   height: textHeight > window.height ? textHeight : window.height - stringHeight
                   wrapMode: TextEdit.WrapAnywhere
                   placeholderText: qsTr("Пока что пусто")
                   font: appFont
                   color: "red"
               }
            }
        }

       ScrollLine {
           scrollArea: fileEditMovableContainer
           width: smallGap
           anchors {
               right: fileEditContainer.right;
               top: fileEditContainer.top; bottom: fileEditContainer.bottom
           }
       }

       Item{
           anchors{
               top: fileEditContainer.bottom
               right: fileEditContainer.right
           }
           height: stringHeight
           width: fileEditContainer.width

           AttributeFieldText{
               id: outFileNameInput

               isBorder: false
               placeholderText: qsTr("Выходной файл")
                anchors{
                    right: outFileCoiceBtn.left
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                }
                ToolTip.text: "Введите имя файла без расширения. Файл будет доступен в директории \"./qml/SensorView/templates\" относительно корневой директории проекта Integra Planet Earth"
                ToolTip.delay: 300

               FileDialog {
                   id: fileDialog

                   title: qsTr("Выбор текстового файла вывода")
                   nameFilters: [ "Text files (*.qml)", "All files (*)" ]
                   onAccepted: {
                       var fileNameNoExt = file.toString()
                        outFileNameInput.text = fileNameNoExt.substring(fileNameNoExt.lastIndexOf("/")+1, fileNameNoExt.lastIndexOf("."))

                       /// в с++ в сеттере outFileName происходит считывание файла в свойство outFileContent
                       widgetsEditorManager.outFileName = outFileNameInput.text
                       fileEdit.text = widgetsEditorManager.outFileContent
                   }
               }

               //Settings { property alias outFileName: outFileNameInput.text }
           }

           Image {
               id: outFileCoiceBtn

               anchors{
                   top: parent.top; bottom: parent.bottom
                   right: outFileAcceptBtn.left
                   margins: smallGap * 0.5
               }
               width: height
               source: "qrc:/../rs/svg/file.svg"

               MouseArea {
                   id: outFileButton

                   anchors.fill: parent
                   hoverEnabled: true
                   onClicked: fileDialog.open()
                   ToolTip.visible: containsMouse
                   ToolTip.text: outFileNameInput.text === "" ? qsTr("Выбрать выходной файл") : outFileNameInput.placeholderText + outFileNameInput.text
                   ToolTip.delay: 300
               }
           }

           /// кнопка принятия файла вывода
           Image {
               id: outFileAcceptBtn

               anchors{
                   top: parent.top; bottom: parent.bottom
                   right: outFileRecordBtn.left
                   margins: smallGap * 0.5
               }
               width: height
               source: "qrc:/../rs/svg/download-symbol.svg"

               MouseArea {
                   id: outFileAcceptMa
                   anchors.fill: parent
                   hoverEnabled: true
                   onClicked: {

                       /// в с++ в сеттере outFileName происходит считывание файла в свойство outFileContent
                       widgetsEditorManager.outFileName = outFileNameInput.text
                       fileEdit.text = widgetsEditorManager.outFileContent
                       //doneSound.play()
                   }
                   ToolTip.visible: containsMouse
                   ToolTip.text: qsTr("Прочитать выходной файл")
                   ToolTip.delay: 300
               }
           }

           /// кнопка записи файла вывода
           DelayButton{
               id: outFileRecordBtn

               enabled: checked === false
               height: stringHeight
               width: height
               anchors{
                   top: parent.top; bottom: parent.bottom
                   right: parent.right
                   margins: smallGap * 0.25
               }
               delay: 1000

               ToolTip.visible: hovered
               ToolTip.text: "Удерживайте, чтобы записать выходной файл"
               ToolTip.delay: 300
               onProgressChanged: if(progress > 0.015 && progress < 0.017){
                                      var matchStr = outFileNameInput.text.match(/^[\w\- ]+/)
                                      if(!matchStr || matchStr.toString() !== outFileNameInput.text.toString())
                                          errorWnd.show(qsTr("Внимание, сохранение в файл не было произведено, потому что имя выходного файла недопустимо"))
                                 }
               onActivated: {

                   /// хотим, чтобы после клика кнопка немного помигала. Показывая, что в файл произошла запись
                   pause(5000).triggered.connect(function () {checked = false})

                   /// если файл уже есть, выдаем сообщение о его перезаписи
                   widgetsEditorManager.outFileName = outFileNameInput.text


                   /// пустое текстовое поле используем как показатель того, что пользователь ничего не редактировал
                   if(fileEdit.text === '' ||
                       fileEdit.text ===
                       '"text_params": {},
                       "analog_params": {},
                       "param_icons": {}')
                   {
                       errorWnd.show(qsTr("Внимание, сохранение в файл не было произведено, поскольку никаких атрибутов выбрано и записано не было. Пустой виджет не имеет смысла"))
                       return
                   }

                   if(inOutSettings.doesFileExist(widgetsEditorManager.outFileName))
                       fileRecordQuestionWnd.show(qsTr("Файл вывода уже существует и будет перезаписан. Продолжить?"))
                   else
                       fileRecordQuestionWnd.show(qsTr("Файл вывода не существует, перед записью он будет создан. Продолжить?"))

                   //pause(5000).triggered.connect(function () {
                   //
                   //    /// если файл так и не был создан (либо по каким-то еще причинам не отвечает), значит и записан он небыл: что-то пошло не так
                   //    if(inOutSettings.doesFileExist(widgetsEditorManager.outFileName))
                   //     errorWnd.text = "Готово"
                   //    else
                   //        errorWnd.text = "Извините, но открыть файл для записи не удалось.
                   //                         Пожалуйста, убедитесь, что Ваших прав достаточно для редактирования данного файла в файловой системе.
                   //                         Попробуйте открыть и закрыть файл из проводника. После чего повторите попытку."
                   //});

               }

               Rectangle{
                   anchors.fill: parent;
                   radius: width * 0.5;
                   anchors.margins: smallGap > 7 ? smallGap * 0.25 : 2;
                   Image {
                       source: "qrc:/../rs/svg/download-symbol.svg";
                       rotation: -90
                       anchors.fill: parent
                   }
               }
           }

       }

       /// вертикальные разделители

       Rectangle{
           anchors{
               top: parent.top; topMargin: smallGap
               bottom: parent.bottom; bottomMargin: smallGap
               right: deviceCategoriesList.right
           }
           width: 1
           color: Styles.Application.borderColor
       }

       Rectangle{
           anchors{
               top: parent.top; topMargin: smallGap
               bottom: parent.bottom; bottomMargin: smallGap
               right: parametersList.right
           }
           width: 1
           color: Styles.Application.borderColor
       }

   function addOrReplace(curItemNum, selectedItems){

       /// кликнули на пункт - он становится выделенным, если не был, и невыделенным, если был
       with(selectedItems){
           var numberAmongSelected = indexOf(curItemNum)
           var isAdded = numberAmongSelected >= 0
           if(isAdded)
               splice(numberAmongSelected, 1)
           else
               push(curItemNum)
           return indexOf(curItemNum) >= 0
       }
   }

   function paramsToJson(){

       with(JSON){
               outFileContent["text_params"] = parse('{}')
               outFileContent["analog_params"] = parse('{}')
               outFileContent["param_icons"] = parse('{}')
               outFileContent["switch_params"] = parse('{}')
       }

       for(var i = 0; i < selectedParameters.length; i++){

           /// выяснение, в режиме редактирования секции каких параметров мы оказались - текстовых или аналоговых
           var belongsTo, notBelongTo1, notBelongTo2
           with(curentParameters[selectedParameters[i]]){ // name вместо curentParameters[selectedParameters[i]].name и т.д.
               //if()
               belongsTo =
                representType === Mode.AttributeRepresentation.TEXT ?
                   outFileContent["text_params"] :
                   representType === Mode.AttributeRepresentation.ANALOG ?
                       outFileContent["analog_params"] :
                       outFileContent["switch_params"]
               notBelongTo1 = outFileContent["text_params"]
               notBelongTo2 = outFileContent["analog_params"]
               if (representType === Mode.AttributeRepresentation.TEXT)
                    notBelongTo1 = outFileContent["switch_params"]
               else if(representType === Mode.AttributeRepresentation.TEXT)
                    notBelongTo2 = outFileContent["switch_params"]

                   /// добавление в нужную секцию (аналоговую или текстовую) либо переписывание параметров в ней
                   belongsTo[indexCur] = []
                   belongsTo[indexCur][0] = name
                   belongsTo[indexCur][1] = signatureCur
                   /// в случае, если  секция аналоговая, еще двух параметров и добавление картинки в секцию картинок
                   if(representType === Mode.AttributeRepresentation.ANALOG){
                       belongsTo[indexCur][2] = upperBoundCur
                       belongsTo[indexCur][3] = lowerBoundCur
                       if(imageCur != "")
                            outFileContent["param_icons"][name] = imageCur
                   }

                   ///если не аналоговая, надо удалить картинки из секции картинок
                   else
                       delete outFileContent["param_icons"][name]

               /// извлечение из секции, которой атрибут не принадлежит (аналоговой или текстовой или булевой)
               var anotherSectionParam
               for (anotherSectionParam in notBelongTo1)
                   if(anotherSectionParam[0] === name){
                        delete anotherSectionParam
                       break;
                   }

               for (anotherSectionParam in notBelongTo2)
                   if(anotherSectionParam[0] === name){
                        delete anotherSectionParam
                       break;
                   }
           }
       }
       fileEdit.text = JSON.stringify(outFileContent, [], ' ')
   }

   function recordFile(){

       /// создание строчки для записи в файл виджетов
       var selectedCategoriesJsn = JSON.parse('{}')
       selectedCategoriesJsn[outFileNameInput.text] = [];
       for (var i = 0; i < selectedCategoriesCount; i++)
           selectedCategoriesJsn[outFileNameInput.text].push(widgetsEditorManager.categories[selectedCategories[i]].name)
       var selectedCategoriesStr = JSON.stringify(selectedCategoriesJsn)
       //selectedCategoriesStr = selectedCategoriesStr.substring(1, selectedCategoriesStr.length-1)
       widgetsEditorManager.selectedCategories = selectedCategoriesStr

       try {
           outFileContent = JSON.parse(' double quotes sentence '.replace("double quotes sentence", fileEdit.text))
           widgetsEditorManager.outFileContent = fileEdit.text
       } catch(e) {
           errorWnd.show(qsTr("Ошибка синтаксиса в текстовом файле вывода. Проверьте пожалуйста правильность выражений либо отредактируйте в графическом режиме"))
       }
   }
}

/// приведение к красивому формату (может быть, это и не надо)
/// далее - оптимизировать! т.к. постоянно делать вставки из строки - очень затратно
// with(fileEdit){ /// with позволяет заменить fileEdit.text => text
//    while (enterInd >= 0){
//        enterInd = text.substring(enterInd).search(/\[\n( *)/, enterInd);
//        text = text.replace(/\[\n( *)/, "[")
//        text = text.replace(/\n( *)\]/, "]")
//    }
//
//    enterInd = 0;
//    while (enterInd >= 0){
//        enterInd = text.substring(enterInd).search(/,\n( *)/, enterInd);
//        text = text.replace(/,\n( *)/, ",")
//    }
// }
/// конец приведения к красивому формату
