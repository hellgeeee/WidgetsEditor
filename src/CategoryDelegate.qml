import QtQuick 2.10
import QtGraphicalEffects 1.0 // for ColorOverlay

Rectangle {
    id: delegate

    property color delegateColor: selectedCategories.indexOf(index) >= 0 ? "#000000" : "#303030"

    Behavior on scale { PropertyAnimation { duration: 300 } }
    Behavior on delegateColor { ColorAnimation { duration: 150 } }
    Behavior on color { ColorAnimation { duration: 300 } }

    visible: widgetsEditorManager.categories[index].name.toLowerCase().indexOf(deviceCategorySearch.text.toLowerCase()) >= 0 || deviceCategorySearch.text === ""
    scale: selectedCategories.indexOf(index) >= 0 ? 1.0 : 0.75
    width: visible ? parent.width: 0
    height: width
    anchors.horizontalCenter: parent.horizontalCenter
    color: selectedCategories.indexOf(index) >= 0 ? "ivory" : "white"

    Image {
        id: categoryIcon

        height: parent.height
        width: height
        anchors.centerIn: parent
        source:
            widgetsEditorManager.categories[index].image !== "" && status !== Image.Error ?
            ("file:///" + widgetsEditorManager.IPEFolder + "/build_editor/Release_x64/media/sensors/" + widgetsEditorManager.categories[index].image) :
            "file:///" + widgetsEditorManager.IPEFolder + "/qml/resources/svg/" + "no-camera.svg"
        smooth: true

        ColorOverlay {
            anchors.fill: parent
            source: parent
            color:  "#50ffffff"  // make image like it lays under white glass
        }
    }

    Text {
        id: titleText

        anchors {
            left: parent.left; leftMargin: smallGap
            right: parent.right; rightMargin: smallGap
            top: parent.top; topMargin: stringHeight
        }
        wrapMode: Text.WrapAnywhere
        font: appFont
        text: "<b>" + widgetsEditorManager.categories[index].name + "</b>"
        color: delegateColor
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            var isAdded = addOrReplace(index, selectedCategories)
            /// костыль: не обновляется автоматически
            delegateColor = isAdded ? "#000000" : "#303030"
            delegate.scale = isAdded ? 1.0 : 0.75
            delegate.color = isAdded ? "ivory" : "white"
            selectedCategoriesCount = selectedCategories.length

            curentParameters = findAvailableParamsIntersection()
            selectedParameters = []
            selectedParametersCount = 0

            // костыль, почему-то не обновляется автоматически
            parametersList.model = []
            parametersList.model = curentParameters
            attributesContainer.height = 0
            fileEdit.text = ""
        }
    }
}
