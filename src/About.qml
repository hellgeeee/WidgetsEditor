import QtQuick 2.10

Column {
    visible: curentMode === Mode.EditingMode.ABOUT
    anchors.fill: parent

    /// верхний отступ
    Item{height: parent.height * 0.25; width: 1}

    Text{
       id: textPrime
       anchors.horizontalCenter: parent.horizontalCenter
       textFormat: Text.StyledText
       text: qsTr(
           '<b>Название компонента:</b>
           Редактор виджетов для ' + Qt.platform.os + '<br><br>
           <b>Контакты разработчика</b>: Ольга Рязанова, olga.riazanova2011@ya.ru<br>'
       )
       onLinkActivated: Qt.openUrlExternally(link)
    }

    Text{
       anchors.left: textPrime.left
       textFormat: Text.StyledText
       text: qsTr(
           '<b>Дата релиза:</b>
            01.08.2020 <br><br>
           <b>Техническое задание:</b>
            <html><style type="text/css"></style>
            <a href="https://prnt.sc/tib7ah">http://wiki.integra-s.com</a></html>'
        )
       onLinkActivated: Qt.openUrlExternally(link)
    }

    Text{
       anchors.left: textPrime.left
       textFormat: Text.StyledText
       text: qsTr(
           '<b>Инструкция:</b>
           <html><style type="text/css"></style>
            <a href="http://wiki.integra-s.com:11111/index.php/%D0%98%D0%BD%D1%82%D0%B5%D0%B3%D1%80%D0%B0-%D0%A1">
            Схема взаимодействия с пользователем</a></html><br>'
       )
       onLinkActivated: Qt.openUrlExternally(link)
    }
}
