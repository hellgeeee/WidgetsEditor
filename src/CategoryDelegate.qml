import QtQuick 2.10
import QtGraphicalEffects 1.0 // for ColorOverlay
import "../rs/Light.js" as Styles

Rectangle {
    id: delegate

    property bool selected: selectedCategories.indexOf(index) >= 0
    property bool hovered: ma.containsMouse
    property color delegateColor: selected ? Styles.Input.textColor : Styles.Button.textColor

    visible: widgetsEditorManager.categories[index].name.toLowerCase().indexOf(deviceCategorySearch.text.toLowerCase()) >= 0 || deviceCategorySearch.text === ""
    scale: 0.75
    width: parent.width
    height: visible ? stringHeight * 2 : 0
    anchors.horizontalCenter: parent.horizontalCenter

    radius: elementsRadius
    border.color: borderColor

    states: [
        State {
        name: "brighter"
        when: selected
        PropertyChanges { target: delegate; color: Styles.Bulges.strongOutColor; scale: 0.95; delegateColor: Styles.Input.textColor }
    },
        State {
        name: "hovered"
        when: hovered
        PropertyChanges { target: delegate; scale: 0.8 }
    }
    ]

    transitions: [
        Transition {
            to: "brighter"
            reversible: true
            ParallelAnimation {
                NumberAnimation {property: "scale"; duration: 500; easing.type: Easing.InQuart}
                ColorAnimation { duration: 500 }
            }
        },
        Transition {
            to: "hovered"
            reversible: true
            ParallelAnimation {
                NumberAnimation {property: "scale"; duration: 300}
            }
    }]

    Image {
        id: categoryIcon

        anchors{
            left: parent.left
            top: parent.top
            bottom: parent.bottom
            margins: smallGap
        }
        width: height
        source:
            widgetsEditorManager.categories[index].image !== "" && status !== Image.Error ?
            ("file:///" + widgetsEditorManager.IPEFolder + "/build_editor/Release_x64/media/sensors/" + widgetsEditorManager.categories[index].image) :
            "file:///" + widgetsEditorManager.IPEFolder + "/qml/resources/svg/" + "no-camera.svg"
        smooth: true
    }

    Text {
        id: titleText

        anchors {
            left: categoryIcon.right; leftMargin: smallGap
            right: parent.right; rightMargin: smallGap
            verticalCenter: parent.verticalCenter
        }
        wrapMode: Text.WrapAnywhere
        font: appFont
        text: "<b>" + widgetsEditorManager.categories[index].name + "</b>"
        color: delegateColor
    }

    MouseArea {
        id: ma

        anchors.fill: parent
        scale: 1/parent.scale
        hoverEnabled: true
        onClicked: {
            selected = addOrReplace(index, selectedCategories)

            selectedCategoriesCount = selectedCategories.length

            var curentParametersOld = curentParameters
            curentParameters = findAvailableParamsIntersection()
            selectedParameters = updateSelectedForNewAvailable(selectedParameters, curentParametersOld, curentParameters)
print("selected parameters recounted: " + selectedParameters)
            selectedParametersCount = selectedParameters.length

            // костыль, почему-то не обновляется автоматически
            parametersList.model = []
            parametersList.model = curentParameters
            attributesContainer.opened = selectedParametersCount > 0
            fileEdit.text = ""
        }
    }

    DropShadow {
        parent: delegate.parent
        anchors.fill: source
        horizontalOffset: 3
        verticalOffset: 3
        radius: Styles.Shadow.fluffyRadius * scale
        samples: Styles.Shadow.samples
        color: Styles.Shadow.slightColor// "#80000000"
        source: delegate
        scale: delegate.scale
    }
}
