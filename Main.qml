//written by wuxingqiang2023051604057
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import Qt.labs.platform

Window {
    id: rootWindow
    width: 412
    height: 817
    minimumWidth: 360
    minimumHeight: 640
    visible: true
    title: qsTr("小说阅读器 v%1").arg(appVersion)

    property string novelFilePath: ""
    property string storagePath: appStoragePath
    property bool isSearching: false

    Component.onCompleted: {
        console.log("Storage path set:", storagePath)
        // 检查存储路径可访问性
        checkStorageAccess()
    }

    function checkStorageAccess() {
        const dir = Qt.createQmlObject(`
            import Qt.labs.platform;
            Folder {
                path: storagePath
            }`, rootWindow, "StorageFolderChecker")

        if (!dir || !dir.exists()) {
            console.error("Storage directory not accessible:", storagePath)
            statusText.text = "无法访问存储目录"
            statusText.color = "red"
        }
    }

    function searchNovel(novelName) {
        if (isSearching || !novelName.trim()) return

        isSearching = true
        resultsModel.clear()
        statusText.text = qsTr("搜索: %1...").arg(novelName)
        statusText.color = "#666"

        Qt.callLater(function() {
            try {
                if (!storagePath) {
                    throw new Error("存储路径未设置")
                }

                const dir = Qt.createQmlObject(`
                    import Qt.labs.platform;
                    Folder {
                        path: storagePath
                    }`, rootWindow, "DynamicFolder")

                if (!dir || !dir.exists()) {
                    throw new Error("存储目录不存在")
                }

                const files = dir.entryList(["*.txt"], Folder.Files)
                const matchedFiles = files.filter(file =>
                    file.toLowerCase().includes(novelName.toLowerCase())
                )

                if (matchedFiles.length > 0) {
                    matchedFiles.forEach(file => {
                        resultsModel.append({
                            title: file.replace(".txt", ""),
                            author: qsTr("未知作者"),
                            intro: qsTr("本地存储的小说文件"),
                            filePath: storagePath + file
                        })
                    })
                    statusText.text = qsTr("找到 %1 个结果").arg(matchedFiles.length)
                } else {
                    statusText.text = qsTr("未找到匹配的小说")
                }
            } catch (error) {
                console.error("搜索错误:", error)
                statusText.text = error.message
                statusText.color = "red"
            } finally {
                isSearching = false
            }
        })
    }

    function readFileContent(filePath) {
        try {
            const file = Qt.createQmlObject(`
                import Qt.labs.platform;
                File {
                    filePath: "file://${filePath}"
                }`, rootWindow, "DynamicFileReader")

            if (file && file.exists()) {
                return file.readAll()
            }
            return ""
        } catch (error) {
            console.error("读取文件错误:", error)
            return ""
        }
    }

    ListModel { id: resultsModel }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        RowLayout {
            Layout.fillWidth: true
            Layout.margins: 15
            spacing: 10

            TextField {
                id: searchInput
                Layout.fillWidth: true
                placeholderText: qsTr("输入小说名称")
                focus: true
                selectByMouse: true

                Keys.onReturnPressed: searchNovel(text)
                Keys.onEnterPressed: searchNovel(text)
            }

            Button {
                text: qsTr("搜索")
                enabled: !isSearching && searchInput.text.trim()
                onClicked: searchNovel(searchInput.text)
            }
        }

        Text {
            id: statusText
            Layout.alignment: Qt.AlignHCenter
            text: qsTr("请输入小说名称搜索")
            color: "#666"
        }

        ScrollView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            ListView {
                id: resultsView
                model: resultsModel
                spacing: 10
                boundsBehavior: Flickable.StopAtBounds

                delegate: Rectangle {
                    width: resultsView.width
                    height: contentColumn.height + 20
                    color: index % 2 === 0 ? "#f8f8f8" : "#ffffff"

                    ColumnLayout {
                        id: contentColumn
                        width: parent.width - 20
                        anchors.centerIn: parent
                        spacing: 5

                        Text {
                            Layout.fillWidth: true
                            text: model.title
                            font.bold: true
                            font.pixelSize: 18
                            elide: Text.ElideRight
                        }

                        Text {
                            Layout.fillWidth: true
                            text: qsTr("作者: %1").arg(model.author)
                            font.pixelSize: 14
                            color: "#555"
                        }

                        Text {
                            Layout.fillWidth: true
                            text: model.intro
                            wrapMode: Text.WordWrap
                            maximumLineCount: 3
                            elide: Text.ElideRight
                            font.pixelSize: 14
                            color: "#444"
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 1
                            color: "#eee"
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            rootWindow.novelFilePath = model.filePath
                            readerWindow.show()
                        }
                    }
                }

                Label {
                    anchors.centerIn: parent
                    visible: resultsModel.count === 0 && !isSearching
                    text: qsTr("无搜索结果")
                    color: "#999"
                }
            }
        }
    }
}
