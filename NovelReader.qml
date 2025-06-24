// WF 2023051604037
/*
tree
|_NovelReader
  |_BookManager(C++)
    |_BookListManager
    |_LoadTxt
  |_Listen
    |_Listen
    |_Navigator
  |_Shlef
    |_BookListManager(C++)
    |_Search
    |_Shelf
    |_Navigator
  |_Read
    |_ReadEngine(C++)
    |_ReadPage
    |_ReadManager
  |_User
    |_Info
    |_Navigator
    |_Edit (info)
*/
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


    /************************************ book manager ************************************/
    // manage book's import, load and delete
    BookManager {
        id: fileReader

        onAddFinished: {
            console.log("Add Finished")
            shelfBody.updateShelf()
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


    /************************************* Pages ****************************************/
    property color bg: "#FAFAFA"
    property int currentPage: 2
    // shelf pages
    Rectangle {
        id: shelf
        anchors.fill: parent
        color: bg
        opacity: (currentPage === 2)
        Behavior on opacity { NumberAnimation { duration: 100 } }
        Search {
            id: searchBox
        }
        Shelf {
            id: shelfBody
            anchors.top: searchBox.bottom
            anchors.bottom: shelfNavi.top

            // signals
            onImportBooks: fileDialog.open()
        }
        Navigator {
            id: shelfNavi
            page: 2
            onNavigate: (target) => {
                switch (target) {
                    case 1: currentPage = 1;break;
                    case 2: break;
                    case 3: currentPage = 3;break;
                }
            }
        }
    }

    Rectangle {
        id: read
        anchors.fill: parent
        color: bg
        opacity: (currentPage === 21)
        Behavior on opacity { NumberAnimation { duration: 100 } }
    }
    Rectangle {
        id: search
        anchors.fill: parent
        color: bg
        opacity: (currentPage === 22)
        Behavior on opacity { NumberAnimation { duration: 100 } }
    }

    // info pages
    Rectangle {
        id: user
        anchors.fill: parent
        color: bg
        opacity: (currentPage === 3)
        Behavior on opacity { NumberAnimation { duration: 100 } }
        Info {
            id: infoBody
            anchors.bottom: infoNavi.bottom
        }
        Navigator {
            id: infoNavi
            page: 3
            onNavigate: (target) => {
                switch (target) {
                    case 1: currentPage = 1;break;
                    case 2: currentPage = 2;break;
                    case 3: break;
              }
            }
        }
    }
    Rectangle {
        id: edit
        anchors.fill: parent
        color: bg
        opacity: (currentPage === 31)
        Behavior on opacity { NumberAnimation { duration: 100 } }
    }

    // listen pages
    Rectangle {
        id: listen
        anchors.fill: parent
        color: bg
        opacity: (currentPage === 1)
        Behavior on opacity { NumberAnimation { duration: 100 } }
        Navigator {
            id: listenNavi
            page: 1
            onNavigate: (target) => {
                switch (target) {
                    case 1: break;
                    case 2: currentPage = 2;break;
                    case 3: currentPage = 3;break;
              }
           }
        }
    }
}
