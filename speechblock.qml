import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: speechblock
//    width: 400
//    height: 600

    Column {
        anchors.fill: parent
        spacing: 10
//返回按钮
        Button {
                    text: "返回"
                    anchors.right: parent.right
                    anchors.leftMargin: 10
                    onClicked: {
                        // 假设使用StackView导航，返回上一页
                        if (typeof stackView !== "undefined") {
                            stackView.pop()
                        }
                    }
                }
        Text {
            id: speechbooknm
            text: qsTr("书名\n第0章")
            font.pixelSize: 24
            anchors.left: parent.left
        }

        Rectangle {
            id:bookImageRec
            width: 300
            height: 200
            anchors.horizontalCenter: parent.horizontalCenter
            color: "lightgray"  // 背景色

            Image {
                id: bookImage
                source: ""  // 设置实际图片路径
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
            }
        }
    //正在阅读的句子展示,在QListQstring可行的情况下使用
//        Text {
//            id: cts
//            anchors.horizontalCenter: parent.horizontalCenter
//
//            text: qsTr("text")
//        }
    //语种，在这里没有什么用，但可能成为需求
        RowLayout {
            Layout.fillWidth: true

            Label { text: "Voice:" }
            ComboBox {
                id: voiceCombo
                model: ["cmn","en"]
                Layout.fillWidth: true
            }
        }
    //语速
        RowLayout {
            Layout.fillWidth: true

            Label { text: "Speed:" }
            Slider {
                id: speedSlider
                from: 80
                to: 400
                value: 160
                Layout.fillWidth: true
            }
            Label { text: speedSlider.value.toFixed(0) }
        }
    //音量
        RowLayout {
            Layout.fillWidth: true

            Label { text: "Volume:" }
            Slider {
                id: volumeSlider
                from: 0
                to: 200
                value: 100
                Layout.fillWidth: true
            }
            Label { text: volumeSlider.value.toFixed(0) }
        }


        Row{
            id:btnplaySet
            anchors.horizontalCenter: parent.horizontalCenter
            Button {
                id: last

                icon.source: ""
                width: 40
                height: 40
            }

            Button {
                id: pause
                icon.source: ""
                width: 40
                height: 40
//                onClicked: speak(pause)
            }

            Button {
                id: next
                icon.source: ""
                width: 40
                height: 40
            }
        }
    }
}
