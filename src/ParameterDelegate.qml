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

Item {
    id: delegateCont

    property int numberAmongSelected: -1//ListView.isCurrentItem
    property var parameter: curentParameters[index]

    property int parameterIndex: 0
    property string parameterSignature: ""

    width: parent.width;
    height: 100 // todo make width dependent on content

    Column {
        anchors.fill: parent
        spacing: smallGap

        Item { height: smallGap; width: parent.width }

        Row {
            width: parent.width
            spacing: 8

            Column {
                Item {
                    width: smallGap * 0.5
                    height: titleText.font.pixelSize * 0.25
                }

                Image {
                    id: titleImage
                    visible: source !== ""
                    source: parameter.image !== "" ? parameter.image : ""
                }
            }

            Text {
                id: titleText
                anchors.leftMargin: stringHeight
                color: numberAmongSelected >= 0 ? "#000000" : "#303030"
                scale: numberAmongSelected >= 0 ? 1.5 : 1.0
                text: parameter.name
                wrapMode: Text.WordWrap
                font {pixelSize: appFont.pixelSize; bold: true}
                Behavior on color { ColorAnimation { duration: 150 } }
                Behavior on scale { PropertyAnimation { duration: 300 } }
            }
        }

        Text {
            width: parent.width
            font.pixelSize: appFont.pixelSize * 0.8
            textFormat: Text.RichText
            font.italic: true
            text: qsTr("Поле" + " с индексом " + parameterIndex + " и подписью \"" + parameterSignature + "\" ")
        }

        Text {
            text: "Текстовое"
            width: parent.width
            wrapMode: Text.WordWrap
            font.pixelSize: 14
            textFormat: Text.StyledText
            horizontalAlignment: Qt.AlignLeft
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            numberAmongSelected = onItemClicked(index, selectedParameters)
            barContainer.visible = (selectedParameters.length > 0)

            /// костыль
            selectedParametersCount = selectedParameters.length
        }
    }

 //   function getNameAndSignature(){
 //       for(var param in outputFileContent["analog_params"]){
 //           if(param.val)
 //           outputFileContent["analog_params"][attrNumberInFile] = [selectedParam, barContainer.attributeIndex, barContainer.attributeSignature]
 //       }
 //   }
}