import QtQuick 2.10

Column{

    visible: height > 0
    anchors{
        top: settingsButton.bottom
        right: parent.right; rightMargin: smallGap
    }
    width: Math.min(220, window.width * 0.25)
    height: 0
    clip: true
    z: 1

    Behavior on height {
        PropertyAnimation {
            duration: 500;
            easing.type: Easing.InQuart
        }
    }

    MenuDelegate{
        text: qsTr("<h4>Редактирование виджета</h4>")
        mode: Mode.EditingMode.GRAPHIC_EDITING
    }
   MenuDelegate{
       text: qsTr("<h4>Файлы ввода данных</h4>")
       mode: Mode.EditingMode.IN_OUT_SETTINGS
   }
   MenuDelegate{
       text: qsTr("<h4>Приступая к работе</h4>")
       mode: Mode.EditingMode.TUTORIAL
   }
   MenuDelegate{
       text: qsTr("<h4>О Виджите</h4>")
       mode: Mode.EditingMode.ABOUT
   }

}

