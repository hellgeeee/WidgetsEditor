import QtQuick 2.10
import QtQuick.Controls 2.14
import Qt.labs.platform 1.1
Item {
    id: inOutSettings

    property alias inFileName: inFileNameInput.text
    property alias outFileName: outFileNameInput.text
    property alias widgetsExistFileName: widgetsExistFileNameInput.text
    property int fileChoosingMode

    visible: curentMode === Mode.EditingMode.IN_OUT_SETTINGS
    anchors.fill: parent

    AttributeFieldText{
        id: inFileNameInput

        anchors.centerIn: parent
        anchors.verticalCenterOffset: - stringHeight * 2
        width: window.width * 0.7
        placeholderText: qsTr("Имя входного файла ")

        Image {
            anchors{
                top: parent.top; bottom: parent.bottom
                right: parent.right
                margins: smallGap * 0.5
            }
            width: height
            source: "../rs/file.svg"

            MouseArea {
                id: selectFileButton
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    fileChoosingMode = Mode.FileChoosing.IN_FILE
                    fileDialog.open()
                }
            }

            ToolTip{
                visible: selectFileButton.containsMouse
                text: inFileNameInput.text === "" ? qsTr("Выбрать входной файл") : inFileNameInput.placeholderText + inFileNameInput.text;
                y: stringHeight
            }
        }
    }

    AttributeFieldText{
        id: outFileNameInput

        anchors.centerIn: parent
        width: inFileNameInput.width
        placeholderText: qsTr("Имя выходного файла ")

        Image {
            anchors{
                top: parent.top; bottom: parent.bottom
                right: parent.right
                margins: smallGap * 0.5
            }
            width: height
            source: "../rs/file.svg"

            MouseArea {
                id: outFileButton
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    fileChoosingMode = Mode.FileChoosing.OUT_FILE
                    fileDialog.open()
                }
            }

            ToolTip{
                visible: outFileButton.containsMouse
                text: outFileNameInput.text === "" ? qsTr("Выбрать выходной файл") : outFileNameInput.placeholderText + outFileNameInput.text;
                y: stringHeight
            }
        }

    }

    AttributeFieldText{
        id: widgetsExistFileNameInput

        anchors.centerIn: parent
        anchors.verticalCenterOffset: stringHeight * 2
        width: inFileNameInput.width
        placeholderText: qsTr("Имя файла уже существующих виджетов ")

        Image {
            anchors{
                top: parent.top; bottom: parent.bottom
                right: parent.right
                margins: smallGap * 0.5
            }
            width: height
            source: "../rs/file.svg"

            MouseArea {
                id: widgetsExistFileButton
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    fileChoosingMode = Mode.FileChoosing.EXISTING_WIDGETS_FILE
                    fileDialog.open()
                }
            }

            ToolTip{
                visible: widgetsExistFileButton.containsMouse
                text: outFileNameInput.text === "" ? qsTr("Выбрать файл существующих виджетов ") : outFileNameInput.placeholderText + outFileNameInput.text;
                y: stringHeight
            }
        }

    }

    FileDialog {
        id: fileDialog
        title: qsTr("Выбор текстового файла")
        folder: "../doc"
        nameFilters: [ "Text files (*.txt *.js *json)", "All files (*)" ]
        onAccepted:
            switch(fileChoosingMode){
            case Mode.FileChoosing.IN_FILE:
                inFileNameInput.text = trimUrl(file)
                break
            case Mode.FileChoosing.OUT_FILE:
                outFileNameInput.text = trimUrl(file)
                break
            case Mode.FileChoosing.EXISTING_WIDGETS_FILE:
                widgetsExistFileNameInput.text = trimUrl(file)
                break
            }

        function trimUrl(str){
            if(str === "")
                return ""
            return str.toString().substring(8, file.length)
        }
    }

    Image {
        id: saveButton

        source: "../rs/download-symbol.svg"
        height: stringHeight
        width: height
        rotation: -90
        anchors {
            left: widgetsExistFileNameInput.right
            top:  widgetsExistFileNameInput.bottom
            margins: stringHeight
        }

        MouseArea {
            id: ma
            anchors.fill: parent
            hoverEnabled: true
            onClicked: save()
        }

        ToolTip{
            visible: ma.containsMouse
            text: "Перейти к редактированию";
            y: stringHeight
        }
    }

    function save(){

        /// проверка существования всех файлов ввода-вывода
        if(!doesFileExist(inFileName) || !doesFileExist(outFileName) || (widgetsExistFileName !== "" && !doesFileExist(widgetsExistFileName)) ){ // todo
            errorWnd.show(qsTr("Ошибка, один из файлов не был найден. Пожалуйста проверьте правильность ввода пути и имени файла или создайте такой файл"))
            return
        }

        /// передача имен файлов в c++
        /// внимание, необязательный файл считывается первым. Иначе парс из сеттеров обязательных произойдет без него
        widgetsEditorManager.widgetsExistFileName = widgetsExistFileName
        widgetsEditorManager.inFileName = inFileName /// чтение входного файла мы производим на стороне с++, т.к. скорость важна
        widgetsEditorManager.outFileName = outFileName
        print("qml widgetsExistFileName: " + widgetsEditorManager.widgetsExistFileName)

        /// установка режима редактирования
        curentMode = Mode.EditingMode.GRAPHIC_EDITING
        editingArea.deviceCategoriesModel = widgetsEditorManager.categories

        readOutputFile() /// чтение выходного файла мы производим на стороне qml, т.к. скорость не важна
    }

    function doesFileExist(fileName) {
        var req = new XMLHttpRequest()
        req.open('GET', "file:///" + fileName, false)
        req.send()
        return req.status === 200
    }

    function readOutputFile(){
       var xhr = new XMLHttpRequest
       xhr.open("GET", "file:///" + inOutSettings.outFileName); // set Method and File
       var response
       xhr.onreadystatechange = function () {
           if(xhr.readyState === XMLHttpRequest.DONE){ // if request_status == DONE
               editingArea.outputFileText = xhr.responseText; // todo нехорошо использовать эту переменную здесь (нарушается модульность)
           }
       }
       xhr.send(); // begin the request
   }
}
