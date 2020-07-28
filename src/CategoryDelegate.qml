import QtQuick 2.10
import QtGraphicalEffects 1.0 // for ColorOverlay

Rectangle {
    id: delegate

    property int numberAmongSelected: -1 //ListView.isCurrentItem
    property color delegateColor: selectedCategories.indexOf(index) >= 0 ? "#000000" : "#303030"

    Behavior on scale { PropertyAnimation { duration: 300 } }
    Behavior on delegateColor { ColorAnimation { duration: 150 } }

    visible: widgetsEditorManager.categories[index].name.toLowerCase().indexOf(deviceCategorySearch.text.toLowerCase()) >= 0 || deviceCategorySearch.text === ""
    scale: selectedCategories.indexOf(index) >= 0 ? 1.0 : 0.75
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
        text: widgetsEditorManager.categories[index].name
        color: delegateColor
    }

    BusyIndicator {
        visible: delegate.ListView.isCurrentItem && window.loading
        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            numberAmongSelected = onItemClicked(index, selectedCategories)

            /// костыль: не обновляется автоматически
            delegateColor = numberAmongSelected >=0 ? "#000000" : "#303030"
            delegate.scale = numberAmongSelected >= 0 ? 1.0 : 0.75
            selectedCategoriesCount = selectedCategories.length

            curentParameters = findAvailableParamsIntersection()
            selectedParameters = []
            selectedParametersCount = 0

            // костыль
            categoriesParameters.model = curentParameters
            attributesContainer.visible = curentParameters.length > 0
        }
    }

    /// граница
    //Rectangle{anchors.fill: parent; anchors.topMargin: parent.height - smallGap * 0.5}
}
