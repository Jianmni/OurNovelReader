// 2023051604038zzh
// 调整了思路改用直接引用书架上的书籍章节，更和情理，且不会发生可能存在的数据冲突，也节省了步骤
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
//调用封装的选择书籍功能和转语音功能
import bookselector
import TextToSpeech

Rectangle {
    id: user
    anchors.fill: parent
    color: bg
    property color bg: "#FAFAFA"

    signal turnToPage(target: int)

    ColumnLayout{
        anchors.fill: parent
    //创建实例
        BookSelector{
            id:bookSelector
        }
        TextToSpeech {
                id: ttsEngine
            }

        RowLayout {
            spacing: 10

            // 书籍选择//形式上很奇怪但是后面在改
            ColumnLayout {
                Layout.preferredWidth: 200
                Layout.fillHeight: true

                Label {
                    text: "书籍"
                    font.bold: true
                    font.pixelSize: 18
                }

                ListView {
                    id: bookListView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: bookSelector.bookList
                    delegate: ItemDelegate {
                        width: parent.width
                        text: modelData
                        onClicked: bookSelector.selectBook(index)
                    }
                    ScrollBar.vertical: ScrollBar {}
                }
            }

            //  章节选择
            ColumnLayout {
                Layout.preferredWidth: 200
                Layout.fillHeight: true

                Label {
                    text: "章节"
                    font.bold: true
                    font.pixelSize: 18
                }

                ListView {
                    id: chapterListView
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    model: bookSelector.chapterList
                    delegate: ItemDelegate {
                        width: parent.width
                        text: modelData
                        onClicked: bookSelector.selectChapter(index)
                    }
                    ScrollBar.vertical: ScrollBar {}
                }
            }
        }
        // 内容
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Label {
                text: "正文："
                font.bold: true
                font.pixelSize: 18
            }

            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true

                TextArea {
                    id: contentText
                    text: bookSelector.chapterContent
                    wrapMode: Text.Wrap
                    readOnly: true
                    font.pixelSize: 16
                    background: Rectangle {
                        color: "transparent"
                    }
                }
            }
        }
    //播放控件
        //语种
        RowLayout {
            Layout.fillWidth: true

            Label { text: "语种:" }
            ComboBox {
                id: voiceCombo
                model: ["cmn","en"]
                Layout.fillWidth: true
            }
        }
        //语速
        RowLayout {
            Layout.fillWidth: true

            Label { text: "语速:" }
            Slider {
                id: speedSlider
                from: 80
                to: 200
                value: 100
                Layout.fillWidth: true
            }
            Label { text: speedSlider.value.toFixed(0) }
        }
        //音量
        RowLayout {
            Layout.fillWidth: true

            Label { text: "音量:" }
            Slider {
                id: volumeSlider
                from: 0
                to: 200
                value: 100
                Layout.fillWidth: true
            }
            Label { text: volumeSlider.value.toFixed(0) }
        }
        //播放
        Button {
            text: "Speak"
            Layout.fillWidth: true
            onClicked: {
                ttsEngine.setVoice(voiceCombo.currentText)
                ttsEngine.setRate(speedSlider.value)
                ttsEngine.setVolume(volumeSlider.value)
                ttsEngine.speak(bookSelector.chapterContent)
            }

    }

    Navigator {
        id: navi
        page: 1
//        Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
        onNavigate: (target) => {
            if(target !== 1) turnToPage(target)
        }
    }
    }
}
