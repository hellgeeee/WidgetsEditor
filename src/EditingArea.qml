import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import Qt.labs.platform 1.1
import Qt.labs.settings 1.0

import QtQuick.Extras 1.4

//todo разбить
Item {
    id: editingArea

    property font appFont: deviceCategorySearch.font

    property alias attributesModeCur: attributesContainer.mode
    property alias attributesTab: attributesTab
    property alias categoriesModel: deviceCategoriesList.model
    property alias parametersList: parametersList

    visible: curentMode === Mode.EditingMode.TEXT_EDITING || curentMode === Mode.EditingMode.GRAPHIC_EDITING
    anchors.fill: parent
    AttributeFieldText{
        id: deviceCategorySearch

        bBorder: 0
        height: stringHeight
        width: deviceCategoriesList.width
        anchors{
           left: parent.left;
           top: parent.top
        }
        placeholderText: qsTr("Поиск")
        wrapMode: TextEdit.WordWrap
        font.pixelSize: stringHeight * 0.5
        z: 1
    }


    Text{
        id: categoriesListEmptyText
        visible: categoriesInfoLine.availableItemsCount === 0
        text: "Категории не выбраны"
        anchors.centerIn: deviceCategoriesList
        font: appFont
        color: borderColor
    }

    ListView {
       id: deviceCategoriesList

       width: stringHeight * 4
       anchors {
           top: deviceCategorySearch.bottom;
           bottom: parent.bottom
       }
       clip: true
       orientation: ListView.Vertical

       maximumFlickVelocity: 5000
       model: typeof(widgetsEditorManager) !== "undefined" ? widgetsEditorManager.categories : null//typeof(deviceCategoriesModel) !== "undefined" ? deviceCategoriesModel : null

       delegate: CategoryDelegate {}

       Rectangle{anchors.fill: parent; color: "transparent"; border.color: borderColor}
    }

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
            pause(500).triggered.connect(function () {
                deviceCategoriesList.model = []
                deviceCategoriesList.model = widgetsEditorManager.categories
            })

            /// костыль! должно обновиться автоматически
            parametersList.model = []
            attributesContainer.height = 0
            fileEdit.text = ""
        }
    }

   ScrollLine {
       id: deviceCategoriesScroll

       height: scrollArea.height;
       width: smallGap
       scrollArea: deviceCategoriesList;
       anchors {
           right: deviceCategoriesList.right;
           top: deviceCategorySearch.bottom;
           bottom: parent.bottom
       }
   }

   Text{
       id: parametersListEmptyText
       visible: pareamsInfoLine.availableItemsCount === 0
       text: "Категории не выбраны"
       anchors.centerIn: parametersList
       font: appFont
       color: borderColor
   }

       ListView {
           id: parametersList

           anchors {
               left: deviceCategoriesList.right; leftMargin: stringHeight
               top: parent.top;
               bottom:attributesContainer.top
           }
           width: stringHeight * 12
           model: curentParameters
           delegate: ParameterDelegate {}


           Footer{
               id: pareamsInfoLine
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

                   /// костыль!
                   attributesContainer.height = 0
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

           Component.onCompleted: height = 0

           Behavior on height {
               PropertyAnimation {
                   duration: 500;
                   easing.type: Easing.InQuart
               }
           }

           visible: height > 0
           height: window.width * 0.3 // достаточно для расположения всевозможных атрибутов
           anchors{
               right: parametersList.right;
               left: parametersList.left
               bottom: deviceCategoriesList.bottom
           }

           TabBar {
              id: bar

              visible: parent.isEnoughRoomToShow
              rotation: 90
              x: (-width + height )/ 2
              y: - x
              height: profilesBtn.height
              currentIndex: 0
              font: appFont

               TabButton {
                   id: profilesBtn

                   width: attributesContainer.height * 0.5
                   //height: width * 0.33;
                   text: qsTr("Текстовое")
               }

               TabButton {
                   id: filtersBtn

                   width: profilesBtn.width
                   text: qsTr("Аналоговое")
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

           /// рамка
           Rectangle{color: "transparent"; anchors.fill: parent; border.color: borderColor}
       }

       Flickable {
           id: fileEditContainer

           anchors{
                right: parent.right
                left: parametersList.right; leftMargin: stringHeight
                top: deviceCategoriesList.top
                bottom: parent.bottom; bottomMargin: stringHeight
           }
           contentWidth: width;
           contentHeight: fileEdit.height
           clip: true

           TextArea{
               id: fileEdit

               /// предполагаем, что ширина буквы примерно 0.7 от ее высоты
               property double textHeight: ( text.length * (font.pixelSize * 0.7) / width // сколько строчек
                                           + text.split("\n").length - 1) // с учетом переносов на новую строку ( при этом получится с большим запасом)
                                           * font.pixelSize * 1.2 // высота строчки

               width: parent.width;
               height: textHeight > window.height ? textHeight : window.height - stringHeight
               wrapMode: TextEdit.WrapAnywhere
               placeholderText: qsTr("Пока что пусто")
               font: appFont

               /// фон
               Rectangle{color: "#80804000"; anchors.fill: parent}
           }
       }

       ScrollLine {
           scrollArea: fileEditContainer
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

               rBorder: 0
               placeholderText: qsTr("Выходной файл ")
                anchors{
                    right: outFileCoiceBtn.left
                    left: parent.left
                    top: parent.top
                    bottom: parent.bottom
                }

               FileDialog {
                   id: fileDialog

                   title: qsTr("Выбор текстового файла вывода")
                   folder: typeof(widgetsEditorManager) !== "undefined" ? "file:///" + widgetsEditorManager.curDir : ""
                   nameFilters: [ "Text files (*.qml)", "All files (*)" ]
                   onAccepted: {
                       var fileNameNoExt = file.toString()
                        outFileNameInput.text = fileNameNoExt.substring(fileNameNoExt.lastIndexOf("/")+1, fileNameNoExt.lastIndexOf("."))

                       /// в с++ в сеттере outFileName происходит считывание файла в свойство outFileContent
                       widgetsEditorManager.outFileName = outFileNameInput.text
                       fileEdit.text = widgetsEditorManager.outFileContent
                   }
               }

               Settings { property alias outputFileName: outFileNameInput.text }
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
                   ToolTip.text: outFileNameInput.text === "" ? qsTr("Выбрать выходной файл") : outFileNameInput.placeholderText + outFileNameInput.text;
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
               ToolTip.text: "Удерживайте, чтобы записать выходной файл";

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
                       "param_icons": {}'){
                       errorWnd.show(qsTr("Внимание, сохранение в файл не было произведено, поскольку никаких атрибутов выбрано и записано не было. Пустой виджет не имеет смысла"))
                       return
                   }

                   //if(curentMode === Mode.EditingMode.GRAPHIC_EDITING) {
                   //
                   //        widgetsEditorManager.outFileContent = JSON.stringify(outFileContent, [], '\t')
                   //
                       /// создание строчки для записи в файл виджетов
                       var selectedCategoriesJsn = JSON.parse('{}')
                       selectedCategoriesJsn[outFileNameInput.text] = [];
                       for (var i = 0; i < selectedCategoriesCount; i++)
                           selectedCategoriesJsn[outFileNameInput.text].push(widgetsEditorManager.categories[selectedCategories[i]].name)
                       var selectedCategoriesStr = JSON.stringify(selectedCategoriesJsn)
                       //selectedCategoriesStr = selectedCategoriesStr.substring(1, selectedCategoriesStr.length-1)
                       widgetsEditorManager.selectedCategories = selectedCategoriesStr
                   //}
                   //{
                       try {
                           outFileContent = JSON.parse(' double quotes sentence '.replace("double quotes sentence", fileEdit.text))
                           widgetsEditorManager.outFileContent = fileEdit.text
                       } catch(e) {
                           errorWnd.show(qsTr("Ошибка синтаксиса в текстовом файле вывода. Проверьте правильность выражений либо отредактируйте в графическом режиме"))
                           return
                       }
                   //}

                   errorWnd.isQuestion = true
                   if(inOutSettings.doesFileExist(widgetsEditorManager.outFileName)){
                       // todo не знаю, как остановить работу программы до момента ответа пользователя
                       errorWnd.show("Файл вывода уже существует и будет перезаписан")//. Продолжить?")
                   }
                   else
                       errorWnd.show("Файл вывода не существует и перед записью будет создан")//. Продолжить?")

                   pause(5000).triggered.connect(function () {

                       /// если файл так и не был создан (либо по каким-то еще причинам не отвечает), значит и записан он небыл: что-то пошло не так
                       if(inOutSettings.doesFileExist(widgetsEditorManager.outFileName)){
                        //successSound.play();
                        errorWnd.text = "Готово"
                       }
                       else {
                           //errorSound.play();
                           errorWnd.text = "Извините, но открыть файл для записи не удалось.
                                            Пожалуйста, убедитесь, что Ваших прав достаточно для редактирования данного файла в файловой системе.
                                            Попробуйте открыть и закрыть файл из проводника. После чего повторите попытку."
                       }
                   });

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

       /// инициализация выходного объекта, делается один раз за одну выборку категорий
       with(JSON){
               outFileContent["text_params"] = parse('{}')
               outFileContent["analog_params"] = parse('{}')
               outFileContent["param_icons"] = parse('{}')
       }

       /// мы запоминаем все индексы элементов, что добавлены для каждой секции во избежание добавления элементов с одинаковыми индексами
       var indexesForTextAdded = []
       var indexesForAnalogAdded = []
       for(var i = 0; i < selectedParameters.length; i++){
           with(curentParameters[selectedParameters[i]]){

               /// выяснение, в режиме редактирования секции каких параметров мы оказались - текстовых или аналоговых
               var belongsTo, notBelongsTo
               belongsTo = representType === Mode.AttributeRepresentation.TEXT ? outFileContent["text_params"] : outFileContent["analog_params"]
               notBelongsTo = representType === Mode.AttributeRepresentation.TEXT ? outFileContent["analog_params"] : outFileContent["text_params"]

               /// если параметр с таким именем встречается в файле он будет переписан, нет - он будет дописан         //
                if(representType === Mode.AttributeRepresentation.TEXT){
                    while(indexesForTextAdded.indexOf(indexCur) >= 0)
                        indexCur++
                    indexesForTextAdded.push(indexCur)
                }
                else if(representType === Mode.AttributeRepresentation.ANALOG){
                    while(indexesForAnalogAdded.indexOf(indexCur) >= 0)
                        indexCur++
                indexesForAnalogAdded.push(indexCur)
                }

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

                   ///если же текстовая, надо удалить картинки из секции картинок
                   else
                       delete outFileContent["param_icons"][name]

               /// извлечение из секции, которой атрибут не принадлежит (аналоговой или текстовой)
               var anotherSectionParam
               for (anotherSectionParam in notBelongsTo)
                   if(anotherSectionParam[0] === name){
                        delete anotherSectionParam
                       break;
                   }
           }
       }

       fileEdit.text = JSON.stringify(outFileContent, [], ' ')
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
