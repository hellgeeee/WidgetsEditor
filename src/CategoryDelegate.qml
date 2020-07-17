import QtQuick 2.10
import QtGraphicalEffects 1.0 // for ColorOverlay

Rectangle {
    id: delegate

    property int itemSize
    property int numberAmongSelected: -1 //ListView.isCurrentItem
    property color delegateColor: numberAmongSelected >= 0 ? "#000000" : "#303030"

    Behavior on scale { PropertyAnimation { duration: 300 } }
    Behavior on delegateColor { ColorAnimation { duration: 150 } }

    visible: model.name.toLowerCase().indexOf(deviceCategorySearch.text.toLowerCase()) >= 0 || deviceCategorySearch.text === ""
    scale: numberAmongSelected >= 0 ? 1.0 : 0.75//0.75
    width: visible ? parent.width: 0
    height: width
    anchors.horizontalCenter: parent.horizontalCenter

    Image {
        id: categoryIcon
        anchors.fill: parent
        source: "../rs/settings_gears.svg"
        ColorOverlay {
            anchors.fill: parent
            source: parent
            color:  "#50ffffff"  // make image like it lays under white glass
        }
    }

    Text {
        id: titleText

        anchors {
            left: parent.left; leftMargin: stringHeight
            right: parent.right; rightMargin: stringHeight
            top: parent.top; topMargin: stringHeight
        }
        wrapMode: Text.WrapAnywhere
        font {
            pixelSize: appFont.pixelSize * 1.5;
            family: appFont.family;
            bold: true;
        }
        text: name
        color: delegateColor
    }

    BusyIndicator {
        visible: delegate.ListView.isCurrentItem && window.loading
        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
//
////print(selectedCategories + ", cur ind: " + index + ", it's number in array: " + selectedCategories.indexOf(index) + ", length:" + selectedCategories.length)
            numberAmongSelected = onItemClicked(index, selectedCategories)

            curentParameters = findAvailableParamsIntersection()
            selectedParameters = []

            /// костыль: почему-то не обновляется автоматически
            selectedParametersCount = selectedParameters.length
            selectedCategoriesCount = selectedCategories.length
        }
    }

    /// граница
    //Rectangle{anchors.fill: parent; anchors.topMargin: parent.height - smallGap * 0.5}
}
