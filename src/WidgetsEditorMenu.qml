import QtQuick 2.10

Column{
    id: col

    visible: curentMode === Mode.EditingMode.NONE
    anchors{
        fill: parent
        margins: stringHeight
        leftMargin: window.width * 0.5
    }

    MenuDelegate{
        text: qsTr("Редактирование в графическом режиме")
        mode: Mode.EditingMode.GRAPHIC_EDITING
    }
    MenuDelegate{
        text: qsTr("Редактирование в текстовом режиме")
        mode: Mode.EditingMode.TEXT_EDITING
    }
   MenuDelegate{
       text: qsTr("Настройки файлов ввода и вывода данных")
       mode: Mode.EditingMode.IN_OUT_SETTINGS
   }
   MenuDelegate{
       text: qsTr("Приступая к работе")
       mode: Mode.EditingMode.TUTORIAL
   }
   MenuDelegate{
       text: qsTr("О Виджите")
       mode: Mode.EditingMode.ABOUT
   }

}

