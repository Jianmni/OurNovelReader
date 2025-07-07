// WF 2023051604037
// 2025-7-7 - 2025-7-8
import QtQuick

Rectangle {
    id: bookshelf
    anchors.fill: parent
    color: bg
    property color bg: "#FAFAFA"

    signal turnToPage(target: int)
    signal openBook(target: int)
    signal importBook
    // signal selectBook

    Search {
        id: searchbd
        onTurnToPage: (target) => parent.turnToPage(target)
    }

    Shelf {
        id: shelf
        anchors.top: searchbd.bottom
        anchors.bottom: navi.top

        onOpenBook: (target) => parent.openBook(target)
        onImportBooks: parent.importBook()
    }

    Navigator {
        id: navi
        page: 2
        onNavigate: (target) => {
            if(target !== 2) turnToPage(target)
        }
    }
}
