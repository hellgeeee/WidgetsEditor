import QtQuick 2.10
Item {
    id: tutorial

    visible: curentMode === Mode.EditingMode.TUTORIAL
    anchors.fill: parent
       Text{
           anchors.fill: parent
           anchors.margins: stringHeight
           text: qsTr(
           '<h2>Приступая к работе</h2><br><br>

            <b>Перед началом работы необходимо </b> настроить редактор:
            указать расположение папки «./qml/SensorView»
            указать расположение файла «typedef.json»<br><br>
            Во время запуска редактор должен считать и разобрать 2 файла :
            «views.js», расположенный по пути «./qml/SensorView/scripts»
            «typedef.json», по указанному в настройках пути.<br><br>

            <b>После запуска редактора</b> в регионе «Доступные типы»
            должны отобразятся все типы, собранные
            после разбора файлов. Отображение типов должно будет представлено
            в виде списка с возможностью поиска и многократного выбора записей.
            В  первую очередь Вы взаимодействуете с этим списком,
             выбирая типы, для которых необходимо создать файл виджета отображения.<br><br>

            <b>После выбора типов</b> в регионе интерфейса «Доступные поля» должны отобразиться
            все доступные общие поля для выбранных типов устройств. Представление полей
            будет в виде списка без поиска с возможностью выбирать одно или
            несколько полей, кликнув по ним ЛКМ. После каждого выбора поля
            мышкой в регионе интерфейса «Свойства поля» должны появиться
            варианты отображения поля на виджете с настройкой параметров
            для каждого из вариантов.<br><br>

            <b>Примечание:</b> имя иконки это имя svg файла без расширения,
            расположенного в папке «qml\resources\svg» относительно корневой
            папки программы IntegraPlanetEarth.<br><br>

            Итак, пользователь должен последовательно выбрать и настроить требуемые
            для отображения поля путем выбора мышью и
            последующей настройки свойств поля. <br><br>

            <b>Формирование текста выходного файла</b>
            должно произойдет при нажатии по иконке "сохранить" по строго определенному шаблону.
            Вы увидите результат в правой стороне окна.

            Для того, чтобы редактировать текста выходного файла самостоятельно,
            Вам нужно выбрать "Редактирование в текстовом режиме" в настройках.' )
            textFormat: Text.StyledText
            wrapMode: Text.WordWrap
       }
}
