import QtQuick 2.10
import QtQuick.XmlListModel 2.0
import QtQuick.Window 2.1
import QtQuick.Controls 1.4
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

//todo разбить
Item {//color: "#80f0f000"
    id: editingArea

    property font appFont: deviceCategorySearch.font
    property int prefixWidth: barContainer.width * 0.3

    property string attributeIndex: textTab.attributeIndexValue
    property string attributeSignature: textTab.attributeSignatureValue

    visible: curentMode === Mode.EditingMode.TEXT_EDITING || curentMode === Mode.EditingMode.GRAPHIC_EDITING
    anchors.fill: parent

    TextArea{
        id: deviceCategorySearch

        height: stringHeight
        anchors{
           left: deviceCategories.left; right: deviceCategories.right
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
       anchors { top: deviceCategorySearch.bottom; bottom: parent.bottom}
       model: typeof(deviceCategoriesModel) !== "undefined" ? deviceCategoriesModel : null
       footer: Footer{
           selectedItemsCount: selectedCategoriesCount
           availableItemsCount: typeof(deviceCategoriesModel) !== "undefined" ? deviceCategoriesModel.length : 0
       }

       delegate: CategoryDelegate {}
    }

       ScrollLine {
           height: scrollArea.height;
           width: smallGap
           scrollArea: deviceCategories;
           anchors {
               right: deviceCategories.right;
               top: parent.top; bottom: parent.bottom
           }
       }

       ListView {
           id: parameters

           anchors {
               left: deviceCategories.right; leftMargin: stringHeight
               right: fileEdit.left; rightMargin: stringHeight
               top: parent.top
               bottom: barContainer.isEnoughRoomToShow ? barContainer.top : parent.bottom
           }
           clip: true
           model: curentParameters
           footer: Footer{
               selectedItemsCount: selectedParametersCount
               availableItemsCount: curentParameters.length
           }
           delegate: ParameterDelegate {}
       }

       ScrollLine {
           scrollArea: parameters
           width: smallGap
           anchors {
               right: parameters.right;
               top: parent.top; bottom: parameters.bottom
           }
       }

       Item{
           id: barContainer

           property bool isEnoughRoomToShow: barContainer.width - 150> bar.height

           visible: selectedParameters.length > 0
           height: 200
           anchors{
               right: parameters.right; left: parameters.left
               bottom: deviceCategories.bottom
           }

           TabBar {
              id: bar
              visible: parent.isEnoughRoomToShow
              rotation: 90
              x: (-width + height)/ 2; y: -x
              height: profilesBtn.height
               currentIndex: 0
               font: appFont
               TabButton {
                   id: profilesBtn
                   width: barContainer.height * 0.5
                   height: width * 0.33;
                   text: qsTr("Текстовое")
               }
               TabButton {
                   width: profilesBtn.width
                   id: filtersBtn
                   height: width*0.33;
                   text: qsTr("Аналоговое")
               }

           }
           AttributesTab{
               id: textTab
               anchors {
                   fill: parent
                    leftMargin: bar.height + smallGap
                    topMargin: 8
               }
               property int attributeRepresentation: bar.currentIndex
           }
       }

       TextArea {
        id: fileEdit

        visible: x > deviceCategories.width
        enabled: curentMode === Mode.EditingMode.TEXT_EDITING
        width: window.width * 0.3
        anchors{
            right: parent.right
            top: deviceCategories.top
            bottom: fileNameInput.top
        }
        wrapMode: TextEdit.WrapAnywhere
        placeholderText: qsTr("Пока что пусто")
        font: appFont

        Rectangle{color: "#80804000"; anchors.fill: parent;}
    }

    TextArea { // todo
        id: fileNameInput
        enabled: false
        height: stringHeight
        anchors{
            bottom: parent.bottom
            left: fileEdit.left
            right: fileEdit.right
        }
        placeholderText: qsTr("Название файла")
        wrapMode: TextEdit.WordWrap
        font: appFont
    }

   function onItemClicked(curentItem, selectedItems, numberAmongSelected){

       /// кликнули на пункт - он становится выделенным, если не был, и невыделенным, если был
       with(selectedItems){
           if(indexOf(curentItem) >= 0)
               splice(numberAmongSelected, 1)
           else push(curentItem)
           numberAmongSelected = indexOf(curentItem)
       }
       return numberAmongSelected
   }

   function paramsToJson(){

       /// инициализация выходного объекта, делается один раз за одну выборку категорий
       with(JSON){
           if(stringify(outputFileContent) === '{}'){
               outputFileContent["text_params"] = parse('{}')
               outputFileContent["analog_params"] = parse('{}')
               outputFileContent["param_icons"] = parse('{}')
           }
       }

       /// выяснение, встречается ли параметр в файле, нет - он должен быть дописан, нет - переписан
       var selectedParam = curentParameters[0].name // todo ask superviser wich one must be overriten if several are chosen
       var attrNumberInFile = 1
       var belongsTo = bar.currentIndex === Mode.AttributeRepresentation.TEXT ? outputFileContent["text_params"] : outputFileContent["analog_params"]
       var notBelongsTo = bar.currentIndex === Mode.AttributeRepresentation.TEXT ? outputFileContent["analog_params"] : outputFileContent["text_params"]

       for (var key in belongsTo){
           attrNumberInFile++
           if(selectedParam === belongsTo[key][0])
               console.debug("Worked")
       }
       for (var keyAnalog in notBelongsTo){

       }
       outputFileContent["text_params"][attrNumberInFile] = [3, 4]
       outputFileContent["analog_params"][attrNumberInFile] = [selectedParam, attributeIndex, attributeSignature]
       outputFileContent["param_icons"][attrNumberInFile] = [3, 4]

       var enterInd = 0;
       with(fileEdit){ /// with позволяет заменить fileEdit.text => text
           text = "ComplexWidget" + JSON.stringify(outputFileContent, [], ' ')

           /// приведение к красивому формату (может быть, это и не надо)
           /// далее - оптимизировать! т.к. постоянно делать вставки из строки - очень затратно
           while (enterInd >= 0){
               enterInd = text.substring(enterInd).search(/\[\n( *)/, enterInd);
               text = text.replace(/\[\n( *)/, "[")
               text = text.replace(/\n( *)\]/, "]")
           }

           enterInd = 0;
           while (enterInd >= 0){
               enterInd = text.substring(enterInd).search(/,\n( *)/, enterInd);
               text = text.replace(/,\n( *)/, ",")
           }
       }
       /// конец приведения к красивому формату

       widgetChanged(outputFileContent); /// это сигнал
   }

   function transferParamsToList(){

    }
}
