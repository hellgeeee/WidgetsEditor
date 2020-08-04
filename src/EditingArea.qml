import QtQuick 2.14
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

//todo разбить
Item {
    id: editingArea

    property font appFont: deviceCategorySearch.font
    property int prefixWidth: attributesContainer.width * 0.3

    property alias attributesContainer: attributesContainer
    property alias attributesTab: attributesTab
    property alias deviceCategoriesList: deviceCategoriesList
    property alias parametersList: parametersList
    property alias outputFileText: fileEdit.text

    visible: curentMode === Mode.EditingMode.TEXT_EDITING || curentMode === Mode.EditingMode.GRAPHIC_EDITING
    anchors.fill: parent

    AttributeFieldText{
        id: deviceCategorySearch

        height: stringHeight
        anchors{
           left: deviceCategoriesList.left;
           right: deviceCategoriesList.right
        }
        placeholderText: qsTr("Поиск")
        wrapMode: TextEdit.WordWrap
        font.pixelSize: 14
        z: 1
    }

    ListView {
       id: deviceCategoriesList

       width: window.width * 0.25
       anchors {
           top: deviceCategorySearch.bottom;
           bottom: parent.bottom
       }
       orientation: ListView.Vertical

       maximumFlickVelocity: 5000
       model: typeof(widgetsEditorManager) !== "undefined" ? widgetsEditorManager.categories : null//typeof(deviceCategoriesModel) !== "undefined" ? deviceCategoriesModel : null

       delegate: CategoryDelegate {}
    }

    Footer{
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
            attributesContainer.visible = false
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
               top: parent.top;
               bottom: parent.bottom
           }
       }

       ListView {
           id: parametersList

           anchors {
               left: deviceCategoriesList.right; leftMargin: stringHeight
               right: fileEditContainer.left; rightMargin: stringHeight
               top: parent.top
               bottom: attributesContainer.isEnoughRoomToShow ? attributesContainer.top : parent.bottom
           }
           clip: true
           model: curentParameters
           delegate: ParameterDelegate {}

           Footer{
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
                   attributesContainer.visible = false
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
               top: parent.top; bottom: parametersList.bottom
           }
       }

       Item{
           id: attributesContainer

           property bool isEnoughRoomToShow: attributesContainer.width - 150 > bar.height
           property int mode: bar.currentIndex

           visible: selectedParametersCount > 0
           height: 200 // достаточно для расположения всевозможных атрибутов
           anchors{
               right: parametersList.right; left: parametersList.left
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
       }

       Flickable {
           id: fileEditContainer

           anchors{
                right: parent.right
                top: deviceCategoriesList.top
                bottom: parent.bottom
           }
           width: window.width * 0.3
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
               enabled: curentMode === Mode.EditingMode.TEXT_EDITING
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

               /// выяснение, в режиме редактирования каких параметров мы находимся - текстовых или аналоговых
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
               if(attributesContainer.mode === Mode.AttributeRepresentation.ANALOG){
                   belongsTo[indexCur][2] = upperBoundaryCur
                   belongsTo[indexCur][3] = lowerBoundaryCur
                   if(imageCur != "")
                   outFileContent["param_icons"][name] = imageCur
               }
               ///если же текстовая, надо удалить картинки из секции картинок
               else
                   delete outFileContent["param_icons"][name]
            }

           /// извлечение из секции, которой атрибут не принадлежит (аналоговой или текстовой)
           for (var keyNotBelong in notBelongsTo){
               delete notBelongsTo[indexCur]
               console.debug("notBelongsTo Worked")
           }
       }

       fileEdit.text = "ComplexWidget" + JSON.stringify(outFileContent, [], ' ')
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
