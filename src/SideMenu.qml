import QtQuick 2.10

Column{
    id: menu
    property bool opened: false
    anchors{
        top: settingsButton.bottom
        right: parent.right; rightMargin: smallGap
    }
    width: Math.min(220, window.width * 0.25)
    clip: true
    z: 1
    spacing: smallGap * 0.5

    states: State {
        name: "opened"
        when: opened
        PropertyChanges { target: menu; height: stringHeight * 6}
    }

    transitions: Transition {
        to: "opened"
        reversible: true
        ParallelAnimation {
            NumberAnimation {property: "height"; duration: 500; easing.type: Easing.InQuart}
        }
    }

    MenuDelegate{
        text: qsTr("<h4>Редактирование виджета</h4>")
        mode: Mode.EditingMode.GRAPHIC_EDITING
        image: "qrc:/../rs/svg/pencil-edit-button.svg"
    }
   MenuDelegate{
       text: qsTr("<h4>Файлы ввода данных</h4>")
       mode: Mode.EditingMode.IN_OUT_SETTINGS
       image: "qrc:/../rs/svg/file.svg"
   }
   MenuDelegate{
       text: qsTr("<h4>Приступая к работе</h4>")
       mode: Mode.EditingMode.TUTORIAL
       image: "qrc:/../rs/svg/light.svg"
   }
   MenuDelegate{
       text: qsTr("<h4>О Виджите</h4>")
       mode: Mode.EditingMode.ABOUT
       image: "qrc:/../rs/svg/info.svg"
   }
   MenuDelegate{
       text: qsTr("<h4>Change Language</h4>")
       mode: curentMode
       image: "qrc:/../rs/svg/world.svg"
   }

}

