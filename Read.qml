// WF 2023051604037
// show contexts of a book
// it's header shows chapter's id and name
// it's footer shows curret time and read progress(current page/total page)
// it's body shows contexts, chapter id and name
import QtQuick
import ReadEngin

Rectangle {
    id: pages
    anchors.fill: parent
    color: defaultbg
    property color defaultbg: "#FAFAFA"

    required property int bookId

    // context
    property string chapterName: "封面"

    // book info
    property string bkName: "未知书籍"
    property string auName: "佚名"
    property string intro: "无简介"
    property var content: []

    // context of chapters
    property int tolChapterNum: 0
    property var preChapter: []
    property var curChapter: []
    property var nxtChapter: []
    // chapter index
    property int preReadChapter: 0
    property int curReadChapter: 0  // if 0, show cover
    property int nxtReadChapter: 0
    // page indexes
    property int tolPageNum:  0
    property int preReadPage: 0
    property int curReadPage: 0
    property int nxtReadPage: 0

    Component.onCompleted: {
        init()
    }

    function init() {
        var info = readEngin.loadBookReadInfo(bookId);  // load book read infomations
        var i = 0;
        curReadChapter = info[i++];    // current reading chapter
        curReadPage    = info[i++];    // current reading page in chapter
        tolChapterNum  = info[i++];    // total number of chapters
        tolPageNum     = info[i++];    // total page of book, init when first open book
        bkName         = info[i++];    // book's name
        auName         = info[i++];    // author' name
        while(i < info.length)
            intro = intro + info[i++] + '\n';

        content = readEngin.loadBookContent(bookId)
    }

    property int pageChangeStyle: 1     // 1 by a left-and-right way, 2 by a up-and-down way
    Rectangle {
        id: context
        anchors.top: head.bottom;   anchors.topMargin: 15
        anchors.bottom: foot.top;   anchors.bottomMargin: 15
        anchors.left: parent.left
        anchors.right: parent.right
        PageManager {}
    }
    ReadEngin {
        id: readEngin
    }

    // head
    property bool showHead: true
    Rectangle {
        id: head
        anchors.top: parent.top
        anchors.left: parent.left;  anchors.right: parent.right
        height: 30

        Text {
            id: chapterNameInfo
            anchors.bottom: parent.bottom
            anchors.left: parent.left;  anchors.leftMargin: 30
            anchors.right: parent.right
            color: "#535353"
            font.pixelSize: 10
            elide: Text.ElideRight
            visible: showHead

            text: "第" + chapterId + "章，" + chapterName
        }
    }

    // foot
    property string currentTime: "HH:MM"
    property string currentProgress: "1/???"
    property bool showFoot: true
    Rectangle {
        id: foot
        anchors.bottom: parent.bottom
        anchors.right: parent.right;    anchors.left: parent.left
        height: 30

        Text {
            id: timeInfo
            anchors.left: parent.left;  anchors.leftMargin: 80
            anchors.verticalCenter: parent.verticalCenter
            color: "#535353"
            font.pixelSize: 10
            visible: showFoot

            text: currentTime
        }

        Text {
            id: progressInfo
            anchors.right: parent.left;  anchors.rightMargin: 80
            anchors.verticalCenter: parent.verticalCenter
            color: "#535353"
            font.pixelSize: 12
            visible: showFoot

            text: currentTime
        }

        Timer {
            interval: 1000 // 每秒更新一次
            running: true
            repeat: true
            onTriggered: {
                var date = new Date()
                var hours = date.getHours()
                var minutes = date.getMinutes()
                currentTime = Qt.formatTime(date, "HH:mm") // 或者自己格式化
                // 或者: timeText.currentTime = hours + ":" + (minutes < 10 ? "0" + minutes : minutes)
            }
        }
    }
}
