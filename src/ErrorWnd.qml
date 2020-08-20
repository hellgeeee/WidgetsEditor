import QtQuick 2.10
import QtQuick.Dialogs 1.1

MessageDialog {
    property bool isQuestion: false

    id: messageDialog

    title: "Действие пока не произведено"
    visible: false
    icon: StandardIcon.Warning

    standardButtons: isQuestion ? (StandardButton.Yes | StandardButton.No) : StandardButton.Ok

    //onYes: choiceDone()
    //onNo: choiceDone()

    function show(msg){
        visible = true
        text = qsTr(msg)
        //if(isQuestion)
        //    warnSound.play()
        //else
        //    errorSound.play()
    }
}
