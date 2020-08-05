import QtQuick 2.10
import QtGraphicalEffects 1.0 // for ColorOverlay

Rectangle {
    id: delegate

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
        source: "qrc:/../rs/svg/settings_gears.svg"
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
        font: appFont
        text: "<h1>" + widgetsEditorManager.categories[index].name + "</h1>"
        color: delegateColor
    }

    BusyIndicator {
        visible: delegate.ListView.isCurrentItem && window.loading
        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            var isAdded = addOrReplace(index, selectedCategories)
            /// костыль: не обновляется автоматически
            delegateColor = isAdded ? "#000000" : "#303030"
            delegate.scale = isAdded ? 1.0 : 0.75
            selectedCategoriesCount = selectedCategories.length

            curentParameters = findAvailableParamsIntersection()
            selectedParameters = []
            selectedParametersCount = 0

            // костыль, почему-то не обновляется автоматически
            parametersList.model = curentParameters
        }
    }
}
