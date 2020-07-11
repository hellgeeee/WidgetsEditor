import QtQuick 2.2
import QtGraphicalEffects 1.0 // for ColorOverlay

Rectangle {
    id: delegate

    property real itemSize

    property variant selectedItems: []
    property int numberAmongSelected: -1//ListView.isCurrentItem

    width: itemSize
    height: itemSize
    Image {
        id: categoryIcon
        anchors.fill: parent
        source: "../rs/settings_gears.svg"
        ColorOverlay {
            anchors.fill: parent
            source: parent
            color: "#50ffffff"  // make image like it lays under white glass
        }
    }
    Text {
        id: titleText

        anchors {
            left: parent.left; leftMargin: 20
            right: parent.right; rightMargin: 20
            top: parent.top; topMargin: 20
        }
        wrapMode: Text.WrapAnywhere
        font { pixelSize: 18; bold: true; family: appFont.family }
        text: name + ", index:" + index + ", all:" + selectedItems
        color: selectedItems.indexOf(index) >= 0 ? "#000000" : "#505050"
        scale: selectedItems.indexOf(index) >= 0 ? 1.15 : 1.0
        Behavior on color { ColorAnimation { duration: 150 } }
        Behavior on scale { PropertyAnimation { duration: 300 } }
    }

    BusyIndicator {
        visible: delegate.ListView.isCurrentItem && window.loading
        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
        console.debug(selectedItems + ", cur ind: " + index + ", it's number in array: " + selectedItems.indexOf(index) + ", length:" + selectedItems.length)
            if(selectedItems.indexOf(index) >= 0)
                selectedItems.splice(numberAmongSelected, 1)
            else selectedItems.push(index)
            numberAmongSelected = selectedItems.indexOf(index)

            /// костыль: почему-то не обновляется автоматически
            deviceCategories.selectedItemsCount = selectedItems.length
            titleText.color = selectedItems.indexOf(index) >= 0 ? "#000000" : "#505050"
            titleText.scale = selectedItems.indexOf(index) >= 0 ? 1.15 : 1.0
        }
    }

    /// граница
    Rectangle{anchors.fill: parent; anchors.topMargin: parent.height - smallGap * 0.5}
}
