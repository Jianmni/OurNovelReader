import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import BookManager

ApplicationWindow {
    id: novelReader
    width: 330
    height: 680
    visible: true
    title: qsTr("小说阅读")

    // 闲逛: shelf, radio, info
    signal ramble(target: int)
    // radio
    signal playChanged
    signal changeBook
    signal bookChanged(id: int)
    signal playVolumeChanged(idensity: int)
    signal playVelocityChanged(idensity: int)
    signal playOrderChanged(type: int)
    // ...

    // shelf
    // ...

    // info
    // ...


    // book manager
    // manage bool' import, load and delete
    BookManager {
        id: fileReader

        onAddFinished: {
            console.log("Finished")
        }
    }

    FileDialog {
        id: fileDialog
        title: "Select a text file"
        nameFilters: ["Text files (*.txt)", "All files (*)"]
        onAccepted: {
            console.log(selectedFile)
            let path = selectedFile.toString()
            fileReader.loadLocalFile(path)
        }
    }

    StackView {
        id: screenView
        anchors.fill: parent
        initialItem: shelf

        pushEnter: Transition {
            PropertyAnimation {
                property: "x"
                from: screenView.width  // 从右侧进入
                to: 0
                duration: 250
            }
        }

        pushExit: Transition {
            PropertyAnimation {
                property: "x"
                from: 0
                to: -screenView.width  // 向左退出
                duration: 250
            }
        }

        popEnter: Transition {
            PropertyAnimation {
                property: "x"
                from: -screenView.width  // 从左侧进入
                to: 0
                duration: 250
            }
        }

        popExit: Transition {
            PropertyAnimation {
                property: "x"
                from: 0
                to: screenView.width  // 向右退出
                duration: 250
            }
        }
    }


    /************************************* Pages ****************************************/
    // shelf pages
    Component {
        id: shelf
        Page {
            id: page
            Shelf {
                id: body
                anchors.bottom: shelfNavi.top

                // signals
                onImportBooks: fileDialog.open()
            }
            Navigator {
                id: shelfNavi
                page: 2
                onNavigate: (target) => {
                    switch (target) {
                        case 1: break;
                        case 2: break;
                        case 3: screenView.push(info);break;
                    }
                }
            }
        }
    }

    // info pages
    Component {
        id: info
        Page {
            Info {
                id: body
                anchors.bottom: infoNavi.bottom
            }
            Navigator {
                id: infoNavi
                page: 3
                onNavigate: (target) => {
                    switch (target) {
                        case 1: break;
                        case 2: screenView.push(shelf);break;
                        case 3: break;
                  }
                }
            }
        }
    }
}
