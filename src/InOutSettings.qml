import QtQuick 2.10
import QtQuick.Controls 2.14
import Qt.labs.platform 1.1
import QtMultimedia 5.12
import Qt.labs.settings 1.0

Item {
    id: inOutSettings

    visible: curentMode === Mode.EditingMode.IN_OUT_SETTINGS
    anchors.fill: parent

    Text{
       anchors{
           bottom: ipeFolderInput.top;
           left: ipeFolderInput.left
       }
       font: appFont
       text: "<small><b>Папка, содержащая файл IntegraPlanetEarth.exe</b></small>"
    }

    AttributeFieldText{
        id: ipeFolderInput

        anchors.centerIn: parent
        anchors.verticalCenterOffset: -height
        width: window.width * 0.8
        placeholderText: qsTr("Введите путь и название либо выбирете из файловой системы")


        Image {
            anchors{
                top: parent.top; bottom: parent.bottom
                right: parent.right
                margins: smallGap * 0.5
            }
            width: height
            source: "qrc:/../rs/svg/file.svg"

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked:
                    folderDialog.open()
                ToolTip.visible: containsMouse
                ToolTip.text: ipeFolderInput.text === "" ? qsTr("Выбрать входной файл") : ipeFolderInput.text
            }

        }
    }

    Text{
       anchors{
           bottom: inFileInput.top;
           left: inFileInput.left
       }
       font: appFont
       text: "<small><b>Файл данных о категориях и их атрибутах</b></small>"
    }

    AttributeFieldText{
        id: inFileInput

        anchors.centerIn: parent
        anchors.verticalCenterOffset: height
        width: ipeFolderInput.width
        placeholderText: qsTr("Введите путь и название либо выбирете из файловой системы")

        Image {
            anchors{
                top: parent.top; bottom: parent.bottom
                right: parent.right
                margins: smallGap * 0.5
            }
            width: height
            source: "qrc:/../rs/svg/file.svg"

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {
                    fileDialog.open()
                }
                ToolTip.visible: containsMouse
                ToolTip.text: inFileInput.text === "" ? qsTr("Выбрать файл существующих виджетов ") : inFileInput.text
            }

        }

    }

    FolderDialog {
        id: folderDialog
        title: qsTr("Выбор папки приложения Integra Planet Earth")
        folder: typeof(widgetsEditorManager) !== "undefined" ? "file:///" + widgetsEditorManager.curDir : ""
        onAccepted:{
            ipeFolderInput.text = trimUrl(folder)
        }
    }

    FileDialog {
        id: fileDialog
        title: qsTr("Выбор текстового файла")
        folder: typeof(widgetsEditorManager) !== "undefined" ? "file:///" + widgetsEditorManager.curDir : ""
        nameFilters: [ "Text files (*.txt *.js *json)", "All files (*)" ]
        onAccepted:
            inFileInput.text = trimUrl(file)
    }

    Image {
        id: saveButton

        source: "qrc:/../rs/svg/download-symbol.svg"
        height: stringHeight
        width: height
        rotation: -90
        anchors {
            left: inFileInput.right
            top:  inFileInput.bottom
            margins: stringHeight
        }

        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            onClicked: save()            
            ToolTip.visible: containsMouse
            ToolTip.text: "Перейти к редактированию"
        }
    }

    Settings {
        property alias inFileName: ipeFolderInput.text
        property alias widgetsExistFileName: inFileInput.text
    }

    function save(){
        /// проверка существования всех файлов ввода-вывода
        if(!doesFileExist(ipeFolderInput.text + "/IntegraPlanetEarth.exe") || !doesFileExist(inFileInput.text) ){
            errorWnd.show(qsTr("Ошибка, один из файлов не был найден. Пожалуйста проверьте правильность ввода пути и имени файла или создайте такой файл"))
            return
        }

        /// передача имен файлов в c++, важно: сначала передаем директорию
        widgetsEditorManager.IPEFolder = ipeFolderInput.text
        widgetsEditorManager.inFileName = inFileInput.text /// чтение входного файла мы производим на стороне с++, т.к. скорость важна

        /// установка режима редактирования
        curentMode = Mode.EditingMode.GRAPHIC_EDITING
        editingArea.deviceCategoriesList.model = widgetsEditorManager.categories

        doneSound.play()
    }

    function doesFileExist(fileName) {
        var req = new XMLHttpRequest()
        req.open('GET', "file:///" + fileName, false)
        req.send()
        return req.status === 200
    }

    // раскомментить в случае, если будете считывать файл из qml,  а не из с++
    /*function readOutputFile(){
       var xhr = new XMLHttpRequest
       xhr.open("GET", "file:///" + widgetsEditorManager.IPEFolder + "../../" +  fileName); // set Method and File
       var response
       xhr.onreadystatechange = function () {
           if(xhr.readyState === XMLHttpRequest.DONE){ // if request_status == DONE
               editingArea.outputFileText = xhr.responseText; // todo нехорошо использовать эту переменную здесь (нарушается модульность)
           }
       }
       xhr.send(); // begin the request
   }*/
}
