import QtQuick 2.10
import QtGraphicalEffects 1.0 // for ColorOverlay

Rectangle {
    id: delegate

    property bool selected: selectedCategories.indexOf(index) >= 0
    property color delegateColor: selected ? "#000000" : "#303030"

    visible: widgetsEditorManager.categories[index].name.toLowerCase().indexOf(deviceCategorySearch.text.toLowerCase()) >= 0 || deviceCategorySearch.text === ""
    scale: 0.75
    width: visible ? parent.width: 0
    height: width
    anchors.horizontalCenter: parent.horizontalCenter

    states: State {
        name: "brighter"
        when: selected
        PropertyChanges { target: delegate; color: "ivory"; scale: 1; delegateColor: "#000000" }
    }

    transitions: Transition {
        to: "brighter"
        reversible: true
        ParallelAnimation {
            NumberAnimation {property: "scale"; duration: 500; easing.type: Easing.InQuart}
            ColorAnimation { duration: 500 }
        }
    }

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
        scale: 1/parent.scale
        onClicked: {
            selected = addOrReplace(index, selectedCategories)

            selectedCategoriesCount = selectedCategories.length

            curentParameters = findAvailableParamsIntersection()
            selectedParameters = []
            selectedParametersCount = 0

            // костыль, почему-то не обновляется автоматически
            parametersList.model = []
            parametersList.model = curentParameters
            attributesContainer.opened = false
            fileEdit.text = ""
        }
    }
}
