/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.2
import QtQuick.Controls 2.10

Item {
    id: delegate

    property int parameterIndex: 0
    property string description:
        curentParameters[index].indexCur !== -1 ?
            qsTr("Параметр" + (curentParameters[index].representType === 0 ? " текстовый" : " аналоговый") +
            " с индексом " + curentParameters[index].indexCur +
            " и подписью \"" + curentParameters[index].signatureCur + "\" ") :
            ""
    property url image:
        curentParameters[index].imageCur !== "" ?
            Qt.resolvedUrl("../rs/svg/" + curentParameters[index].imageCur + ".svg") :
            ""
    width: 100
    height: 50 // todo make width dependent on content

    scale: selectedParameters.indexOf(index) >= 0 ? 1 : 0.75
    Behavior on scale { PropertyAnimation { duration: 300 } }

    Column {
        anchors.fill: parent

        Row {
            width: parent.width
            spacing: smallGap

            Image {
                id: descriptionImage

                visible: source !== ""
                height: parent.height
                width: height
                source: image
            }

            Text {
                id: titleText

                anchors.leftMargin: stringHeight
                color: selectedParameters.indexOf(index) >= 0 ? "#000000" : "#303030"
                text: typeof(curentParameters[index]) !== "undefined" ? curentParameters[index].name : ""
                wrapMode: Text.WordWrap
                font {pixelSize: appFont.pixelSize * 1.5; bold: true}
                Behavior on color { ColorAnimation { duration: 150 } }
            }
        }

       Text {
            id: descriptionText

            width: parent.width
            font.pixelSize: appFont.pixelSize * 0.8
            textFormat: Text.RichText
            font.italic: true
            text: description
        }
    }

    MouseArea {
        anchors.fill: parent
        scale: 1.5
        onClicked: {
            /// параметр не был выделен - стал, был - выделение сбросилось
            var isAdded = addOrReplace(index, selectedParameters)

            /// панель атрибутов показываем лишь тогда, когда есть выбранные параметры
            attributesContainer.visible = (selectedParameters.length > 0)

            /// если параметр выделен, яркий цвет и размер, сброшен - размер уменьшается и цвет блеклый
            titleText.color = isAdded >= 0 ? "#000000" : "#303030"
            delegate.scale = isAdded ? 1.0 : 0.75
            description = qsTr(isAdded ? "<b>Редактируется в данный момент</b>" : "Выделение сброшено")

            selectedParametersCount = selectedParameters.length

            /// если произошел выбор параметра кликом (а не сброс), то тому, который был выбран до него (предпоследнему выбранному, получается),
            /// присваиваются значения атрибутов из табы атрибутов
            if(isAdded && selectedParametersCount > 1)
                writeParamFromGui(selectedParameters[selectedParametersCount - 2])

            /// если произошел сброс параметра
            else
                resetParam(index)
        }
    }
}
