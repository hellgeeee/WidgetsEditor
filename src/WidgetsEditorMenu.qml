import QtQuick 2.10

Column{
    id: col

    visible: curentMode === Mode.EditingMode.SETTINGS
    anchors{
        fill: parent
        margins: stringHeight
        leftMargin: window.width * 0.5
    }

    MenuDelegate{
        text: qsTr("<h2>Редактирование в графическом режиме</h2>")
        mode: Mode.EditingMode.GRAPHIC_EDITING
    }
    MenuDelegate{
        text: qsTr("<h2>Редактирование в текстовом режиме</h2>")
        mode: Mode.EditingMode.TEXT_EDITING
    }
   MenuDelegate{
       text: qsTr("<h2>Настройки файлов ввода и вывода данных</h2>")
       mode: Mode.EditingMode.IN_OUT_SETTINGS
   }
   MenuDelegate{
       text: qsTr("<h2>Приступая к работе</h2>")
       mode: Mode.EditingMode.TUTORIAL
   }
   MenuDelegate{
       text: qsTr("<h2>О Виджите</h2>")
       mode: Mode.EditingMode.ABOUT
   }

}

