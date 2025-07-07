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
    |_textManager(C++)
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


    /************************************ book manager ************************************/
    // manage book's import, load and delete
    BookManager {
        id: fileReader

        onAddFinished: {
            console.log("Add Finished")
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
    // load dynamically
    property color bg: "#FAFAFA"
    property int currentPage: 2

    signal changePage(target: int)
    signal openBook(target: int)
    Component.onCompleted: {
      manageShelfPage()
    }

    onChangePage: target => {
      switch (target) {
        case 1: manageListenPage(); break;
        case 2: manageShelfPage();  break;
        case 3: manageUserPage();   break;
      }
    }

    function manageShelfPage() {
      var component = Qt.createComponent("ShelfMainPage.qml")
      var object
      if (component.status === Component.Ready)
        object = component.createObject(novelReader)

      object.turnToPage.connect(function(target) {
        console.log("Here", target)
        changePage(target)
        object.destroy(500)
      }
      )
      object.openBook.connect(function(target) {
        console.log("Open book", target)
        openBook(target)
        object.destroy(500)
      }
      )
      object.importBook.connect(function() {
        fileDialog.open()
      }
      )
    }


    function manageListenPage() {
      var component = Qt.createComponent("ListenMainPage.qml")
      var object
      if (component.status === Component.Ready)
        object = component.createObject(novelReader)

      object.turnToPage.connect(function(target) {
        console.log("Here", target)
        changePage(target)
        object.destroy(500)
      }
      )
    }


    function manageUserPage() {
      var component = Qt.createComponent("UserMainPage.qml")
      var object
      if (component.status === Component.Ready)
        object = component.createObject(novelReader)

      object.turnToPage.connect(function(target) {
        console.log("Here", target)
        changePage(target)
        object.destroy(500)
      }
      )
    }
}
