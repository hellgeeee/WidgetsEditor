import QtQuick 2.14
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

//todo разбить
Item {
    id: editingArea

    property font appFont: deviceCategorySearch.font
    property int prefixWidth: attributesContainer.width * 0.3

    property alias attributeIndex: attributeTab.attributeIndexValue
    property alias attributeSignature: attributeTab.attributeSignatureValue
    property alias attributeUpperBondary: attributeTab.attributeUpperBondary
    property alias attributeLowerBondary: attributeTab.attributeLowerBondary
    property alias attributeIcon: attributeTab.attributeIcon
    property alias attributesContainer: attributesContainer
    property alias deviceCategoriesModel: deviceCategories.model
    property alias outputFileText: fileEdit.text

    visible: curentMode === Mode.EditingMode.TEXT_EDITING || curentMode === Mode.EditingMode.GRAPHIC_EDITING
    anchors.fill: parent

    AttributeFieldText{
        id: deviceCategorySearch

        height: stringHeight
        anchors{
           left: deviceCategories.left;
           right: deviceCategories.right
        }
        placeholderText: qsTr("Поиск")
        wrapMode: TextEdit.WordWrap
        font.pixelSize: 14
        z: 1
    }

    ListView {
       id: deviceCategories

       width: window.width * 0.25
       orientation: ListView.Vertical
       anchors {
           top: deviceCategorySearch.bottom;
           bottom: parent.bottom
       }
       maximumFlickVelocity: 5000
       model: typeof(widgetsEditorManager) !== "undefined" ? widgetsEditorManager.categories : null//typeof(deviceCategoriesModel) !== "undefined" ? deviceCategoriesModel : null

       delegate: CategoryDelegate {}
    }

    Footer{
        selectedItemsCount: selectedCategoriesCount
        availableItemsCount: (typeof(deviceCategoriesModel) !== "undefined" && deviceCategoriesModel !== null) ? deviceCategoriesModel.length : 0
        width: deviceCategories.width
        opacity: area.containsMouse || closeBtn.containsMouse? 0.3 : deviceCategoriesScroll.opacity * 0.3
        closeBtn.onClicked: {
            selectedCategories = []
            selectedCategoriesCount = 0
            selectedParameters = []
            selectedParametersCount = 0
            curentParameters = []

            /// Обновление списка. Пауза - чтобы возвращение к началу происходило красиво
            deviceCategories.flick(0, deviceCategories.maximumFlickVelocity)
            pause(1000).triggered.connect(function () { deviceCategories.model = deviceCategories.model })

            /// костыль! должно обновиться автоматически
            attributesContainer.visible = false
            fileEdit.text = ""
        }
    }

       ScrollLine {
           id: deviceCategoriesScroll
           height: scrollArea.height;
           width: smallGap
           scrollArea: deviceCategories;
           anchors {
               right: deviceCategories.right;
               top: parent.top;
               bottom: parent.bottom
           }
       }

       ListView {
           id: categoriesParameters

           anchors {
               left: deviceCategories.right; leftMargin: stringHeight
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
                   categoriesParameters.flick(0, categoriesParameters.maximumFlickVelocity)
                   pause(800).triggered.connect(function () { print("triggered " + selectedParameters);categoriesParameters.model = curentParameters })

                   /// костыль!
                   attributesContainer.visible = false
                   fileEdit.text = ""
               }
           }
       }

       ScrollLine {
           id: parametersScroll
           scrollArea: categoriesParameters
           width: smallGap
           anchors {
               right: categoriesParameters.right;
               top: parent.top; bottom: categoriesParameters.bottom
           }
       }

       Item{
           id: attributesContainer

           property bool isEnoughRoomToShow: attributesContainer.width - 150 > bar.height

           visible: selectedParametersCount > 0
           height: 200 // достаточно для расположения всевозможных атрибутов
           anchors{
               right: categoriesParameters.right; left: categoriesParameters.left
               bottom: deviceCategories.bottom
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
               id: attributeTab

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
                top: deviceCategories.top
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

   function onItemClicked(curentItem, selectedItems){

       /// кликнули на пункт - он становится выделенным, если не был, и невыделенным, если был
       with(selectedItems){
           var numberAmongSelected = indexOf(curentItem)
           if(numberAmongSelected >= 0)
               splice(numberAmongSelected, 1)
           else push(curentItem)
           numberAmongSelected = indexOf(curentItem)
           return numberAmongSelected
       }
   }

   function paramsToJson(){

       /// инициализация выходного объекта, делается один раз за одну выборку категорий
       with(JSON){
           if(stringify(outFileContent) === '{}'){
               outFileContent["text_params"] = parse('{}')
               outFileContent["analog_params"] = parse('{}')
               outFileContent["param_icons"] = parse('{}')
           }
       }

       /// выяснение, в режиме редактирования каких параметров мы находимся - текстовых или аналоговых
       var belongsTo = bar.currentIndex === Mode.AttributeRepresentation.TEXT ? outFileContent["text_params"] : outFileContent["analog_params"]
       var notBelongsTo = bar.currentIndex === Mode.AttributeRepresentation.TEXT ? outFileContent["analog_params"] : outFileContent["text_params"]

       for(var i = 0; i < selectedParameters.length; i++){

           /// выяснение, встречается ли параметр в файле, нет - он должен быть дописан, нет - переписан
           var selectedParamName = curentParameters[selectedParameters[i]].name // todo ask superviser wich one must be overriten if several are chosen

           /// добавление в нужную секцию (аналоговую или текстовую) либо переписывание параметров в ней
           belongsTo[attributeIndex + i] = []
           belongsTo[attributeIndex + i][0] = selectedParamName
           belongsTo[attributeIndex + i][1] = attributeSignature

           /// в случае, если  секция аналоговая, еще двух параметров и добавление картинки в секцию картинок
           if(bar.currentIndex === Mode.AttributeRepresentation.ANALOG){
               belongsTo[attributeIndex + i][2] = attributeUpperBondary
               belongsTo[attributeIndex + i][3] = attributeLowerBondary
               if(attributeIcon != "")
               outFileContent["param_icons"][selectedParamName] = attributeIcon

           }

           ///если же текстовая, надо удалить картинки из секции картинок
           else{
               delete outFileContent["param_icons"][selectedParamName]
           }

           /// извлечение из секции, которой атрибут не принадлежит (аналоговой или текстовой)
           for (var keyNotBelong in notBelongsTo){
               delete notBelongsTo[attributeIndex + i]
               console.debug("notBelongsTo Worked")
           }
       }
       fileEdit.text = "ComplexWidget" + JSON.stringify(outFileContent, [], ' ')
   }

   function pause(duration){
       var timer = Qt.createQmlObject("import QtQuick 2.0; Timer {}", editingArea);
       timer.interval = duration;
       timer.repeat = false;
       timer.start()
       return timer
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
