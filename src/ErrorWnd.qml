import QtQuick 2.10
import QtQuick.Dialogs 1.1

MessageDialog {
    id: messageDialog

    title: "Действие не произведено"
    visible: false

    onAccepted: visible = false
    Component.onCompleted: visible = false

    function show(msg){
        visible = true
        text = msg
    }
}
