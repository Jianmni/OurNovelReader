// WF 2023051604037
// 2025-6-19  --  2025-7-8
// 主组件，动态地加载每个界面
/*
tree
|_NovelReader
  |_BookManager(C++)
    |_BookListManager
    |_LoadTxt
  |_ConfigManager(C++)
  |_ListenMainPage
    |_Listen
    |_Navigator
  |_ShlefMainPage
    |_BookListManager(C++)
    |_Search
    |_Shelf
    |_Navigator
  |_ReadMainPage
    |_ReadEngine(C++)
    |_textManager(C++)
    |_ReadControl
    |_ReadManager
    |_CoverPage
    |_TopMenu
    |_BottomMenu
    |_ContentBoard
    |_NoteBoard
    |_ProgressBoard
    |_BrightBoard
    |_FontBoard
  |_UserMainPage
    |_User
    |_Navigator
  |_Icon
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs

import NovelReader

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

    /*
    AndroidPermission {
        id: androidPermission

        onPermissionGranted: function(permission) {
            console.log("权限授予:", permission)
            initStorage()
        }

        onPermissionDenied: function(permission) {
            console.log("权限拒绝:", permission)
        }
    }
    */

    function checkPermissions() {
        var permissions = [
            "android.permission.READ_EXTERNAL_STORAGE",
            "android.permission.WRITE_EXTERNAL_STORAGE"
        ]

        for (var i = 0; i < permissions.length; i++) {
            if (!androidPermission.checkPermission(permissions[i])) {
                androidPermission.requestPermission(permissions[i])
            }
        }
    }


    /************************************* Pages ****************************************/
    // load dynamically
    property color bg: "#FAFAFA"
    property int currentPage: 2

    signal changePage(target: int)
    signal openBook(target: int)
    Component.onCompleted: {
      // checkPermissions()
      manageShelfPage()
    }

    onChangePage: target => {
      switch (target) {
        case 1: manageListenPage(); break;
        case 2: manageShelfPage();  break;
        case 3: manageUserPage();   break;
      }
    }
    onOpenBook: target => {
      manageBook(target)
    }

    ConfigManager {
        id: config
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

    function manageBook(bkID: int) {
      var readConfig = config.getReadConfig()
      var component = Qt.createComponent("ReadControl.qml");
      var object
      if (component.status === Component.Ready)
          object = component.createObject(novelReader, {bookId: bkID, config: readConfig});
      object.quitRead.connect(function() {
        console.log("Quit read")
        changePage(2)
        object.destroy(500)
      }
      )
    }
}
