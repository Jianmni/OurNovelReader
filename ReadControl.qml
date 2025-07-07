// WF 2023051604037
// 2025-6-?  -- 2025-7-8
// show contexts of a book
// it's header shows chapter's id and name
// it's footer shows curret time and read progress(current page/total page)
// it's body shows contexts, chapter id and name
// 阅读控制
// 根据配置，加载文本、调用程序格式化文本，传递数据
import QtQuick

import NovelReader

Rectangle {
    id: pages
    anchors.fill: parent
    color: bg
    property int readWidth: width

    signal quitRead

    // config
    property color bg: "#FAFAFA"
    property string fontType: "Helvetica"
    property bool leftAndRight: true
    property int fontSize: 16
    property int edgeMargin: 20
    property bool autoRead: false
    property int autoReadSpeed: 0

    /* book's id is need */
    required property int bookId
    required property var config

    property string chapterName: "第1章"
    property string bkName: "未知书籍"
    property string auName: "佚名"
    property string intro: "无简介"
    property var content: []
    property int readHour: 0
    property int readMinu: 0
    property int readSeco: 0

    /* context of chapters */
    property int tolChapterNum: 0
    property var curChapter: []         // QList<QString>, delete after init
    property var preChapter: []
    property var nxtChapter: []
    /* chapter index */
    property int curReadChapter: 0
    property int curChapterId: 0        // if 0, show cover
    /* page indexes */
    property int tolPageNum:  0
    property int curReadPage: 0         // current read page in current chapter

    property int pageChangeStyle: 1     // 1 by a left-and-right way, 2 by a up-and-down way

    Component.onCompleted: {
        init()
    }

    /* handle page switch */
    property var readState: ["coverToRead","readToCover","readToMenu","MenuToRead"]
    function changeState(targetState: string)
    {
        if(targetState === readState[0])
        {
            cover.hide()
            pageManager.canSwitch = true
        }
        else if(targetState === readState[1])
        {
            pageManager.canSwitch = false
            cover.show()
        }
        else if(targetState === readState[2])
        {
            pageManager.canSwitch = false
            opMenu = true
            // show top and bottom menu
            // botMenu.show()
            showTopAndBotMenu.start()
        }
        else
        {
            // hide top and bottom menu
            opMenu = false
            topMenu.handleHide()
            botMenu.handleHide()
            pageManager.canSwitch = true
        }
    }

    // read page
    PageManager {
        id: pageManager
        anchors.top: head.bottom;   anchors.topMargin: 15
        anchors.bottom: foot.top;   anchors.bottomMargin: 15

        chapterIndex: curReadChapter
        pageIndex: curReadPage
        txtMargin: edgeMargin
        leftAndRight: parent.leftAndRight
        fontSize: parent.fontSize
        fontType: parent.fontType
        readbg: bg

        Component.onCompleted: {
            textManager.changeInfo(numOfChars, numofTitleCharsInLine)

            curCptTxt = textManager.formulaTxt(curChapter)
            preCptTxt = (preChapter === []) ? [] : textManager.formulaTxt(preChapter)
            nxtCptTxt = (nxtChapter === []) ? [] : textManager.formulaTxt(nxtChapter)
            curChapter = []
            preChapter = []
            nxtChapter = []
            initPages()
        }

        onLoadNextChapter: {    // after title page changed
            console.log("Load nxt")
            if(chapterIndex < tolChapterNum)
            {
                var tmp = readEngin.loadChapter(chapterIndex+1)
                nxtCptTxt = (tmp === []) ? [] : textManager.formulaTxt(tmp)
            }
            else nxtCptTxt = []
            curReadChapter = chapterIndex

            switchChapter2Nxt()
            initNxtPages()
        }
        onLoadPreChapter: {
            if(chapterIndex !== 1)
            {
                var tmp = readEngin.loadChapter(chapterIndex-1)
                preCptTxt = (tmp === []) ? [] : textManager.formulaTxt(tmp)
            }
            else preCptTxt = []
            curReadChapter = chapterIndex

            switchChapter2Pre()
            initPrePages()
        }

        onShowCover: {
            changeState(readState[1])   // read to cover
        }
        onShowEnd: {
            // ...
        }
        onShowMenu: {
            changeState(readState[2])
        }
    }
    TextManager {
        id: textManager
    }
    ReadEngin {
        id: readEngin
    }

    // head
    Rectangle {
        id: head
        anchors.top: parent.top
        anchors.left: parent.left;  anchors.right: parent.right
        height: 40
        color: bg

        Text {
            id: chapterNameInfo
            anchors.bottom: parent.bottom
            anchors.left: parent.left;  anchors.leftMargin: 30
            anchors.right: parent.right
            color: "#535353"
            font.pixelSize: 10
            elide: Text.ElideRight

            text: content[curReadChapter-1]
        }
    }
    // foot
    property int calSec: readSeco
    property string currentTime: "05:20"
    property int realPageIndex: pageManager.pageIndex + 1
    property string currentProgress: realPageIndex + "/" + pageManager.curPageSum
    Rectangle {
        id: foot
        anchors.bottom: parent.bottom
        anchors.right: parent.right;    anchors.left: parent.left
        height: 40
        color: bg

        Text {
            id: timeInfo
            anchors.left: parent.left;  anchors.leftMargin: 80
            anchors.verticalCenter: parent.verticalCenter
            color: "#535353"
            font.pixelSize: 10

            text: currentTime
        }

        Text {
            id: progressInfo
            anchors.right: parent.right;  anchors.rightMargin: 80
            anchors.verticalCenter: parent.verticalCenter
            color: "#535353"
            font.pixelSize: 10

            text: currentProgress
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
                // calSec++
                if(++calSec % 60 === 0)
                {
                    calSec = 0
                    console.log("One minute")
                    if(++readMinu % 60 === 0)
                    {
                        readMinu = 0
                        readHour++
                    }
                }
            }
        }
    }

    // cover page
    CoverPage {
        id:cover
        bkname: parent.bkName
        auname: parent.auName

        onNextPage: {
            changeState(readState[0])
        }
    }

    // end

    /* menu */
    property bool opMenu: false
    property real leftEdge: parent.width / 3
    property real rightEdge: parent.width / 3 * 2
    property real topEdge: 70
    property real bottomEdge: height - 70
    TapHandler{
        enabled: opMenu
        onTapped: eventPoint=> {
            var x = eventPoint.position.x;
            var y = eventPoint.position.y;
            if (x >= leftEdge && x <= rightEdge)
                if(y >= topEdge && y <= bottomEdge)
                {
                    console.log("Close menu", x, y)
                    changeState(readState[3])   // menu to read
                }
        }
    }

    // top menu
    TopMenu{
        id: topMenu
        onQuitRead: {
            save()
            parent.quitRead()
        }
        onHandleHide: {
            hide()
        }
    }
    BottomMenu {
        id: botMenu
        onShowContent: {
            console.log("Show content")
            if(contentIsShow){
                contentIsShow = false
                topMenu.show()
                ctt.hide()
            }
            else{
                contentIsShow = true
                topMenu.hide()
                ctt.show()
            }
        }
        onShowNote: {
            if(noteIsShow) {
                noteIsShow = false
                topMenu.show()
                notebd.hide()
            }
            else {
                noteIsShow = true
                topMenu.hide()
                notebd.show()
            }
        }
        onShowProgressInfo: {
            if(progressIsShow) {
                progressIsShow = false
                topMenu.show()
                prgbd.hide()
            }
            else {
                progressIsShow = true
                topMenu.hide()
                prgbd.show()
            }
        }
        onShowBrightMenu: {
            if(brightnessIsShow) {
                brightnessIsShow = false
                topMenu.show()
                brtbd.hide()
            }
            else {
                brightnessIsShow = true
                topMenu.hide()
                brtbd.show()
            }
        }
        onShowFontMenu: {
            if(fontIsShow) {
                fontIsShow = false
                topMenu.show()
                fontbd.hide()
            }
            else {
                fontIsShow = true
                topMenu.hide()
                fontbd.show()
            }
        }

        onHandleHide: {
            hideAll()
            hide()
        }

        function hideAll() {
            if(contentIsShow)   {ctt.hide();    contentIsShow = false}
            if(noteIsShow)      {notebd.hide(); noteIsShow = false}
            if(progressIsShow)  {prgbd.hide();  progressIsShow = false}
            if(brightnessIsShow){brtbd.hide();  brightnessIsShow = false}
            if(fontIsShow)      {fontbd.hide(); fontIsShow = false}
        }
    }
    // show menu
    property int ht: height
    ParallelAnimation{
        id: showTopAndBotMenu
        PropertyAnimation {
            target: topMenu
            property: "y"
            from: -50
            to: 0
            duration: 200
        }
        PropertyAnimation {
            target: botMenu
            property: "y"
            from: ht
            to: ht-50
            duration: 200
        }
    }

    // bottom-content
    ContentBoard {
        id: ctt
        contentList: content
    }
    // bottom-note
    NoteBoard {
        id: notebd
    }
    // bottom-progress
    ProgressBoard {
        id: prgbd
        tolChapterNum: parent.tolChapterNum
        curReadChapter: pageManager.chapterIndex
        rdh: readHour
        rdm: readMinu
    }
    // bottom-brightness
    BrightBoard {
        id: brtbd
    }
    // bottom-font
    FontBoard {
        id:fontbd
    }

    function init() {
        // get config
        var i = 0;
        bg = config[i++]
        fontType = config[i++]
        leftAndRight = (config[i++] === "left-and-right")
        fontSize = config[i++]
        edgeMargin = config[i++]
        autoRead = config[i++]
        autoReadSpeed = config[i]

        // get txt
        i = 0
        var info = readEngin.loadBookReadInfo(bookId);  // load book read infomations
        console.log(info)
        curReadChapter  = info[i++];    // current reading chapter
        curReadPage   = info[i++];    // current reading page in chapter
        tolChapterNum = info[i++];    // total number of chapters
        bkName        = info[i++];    // book's name
        auName        = info[i++];    // author' name
        readHour      = info[i++];
        readMinu      = info[i++];
        readSeco      = info[i++];
        while(i < info.length)
            intro = intro + info[i++] + '\n';

        content = readEngin.loadBookContent()
        if (curReadChapter === 0)
            curReadChapter = 1
        else
            changeState(readState[0])       // cover to read

        preChapter = (curReadChapter === 1) ? [] : readEngin.loadChapter(curReadChapter-1)
        curChapter = readEngin.loadChapter(curReadChapter)   // load chapter 1
        nxtChapter = (curReadChapter === tolChapterNum) ? [] : readEngin.loadChapter(curReadChapter+1)
    }

    function save()
    {
        readEngin.writeProgress(pageManager.chapterIndex, pageManager.pageIndex,
                                readHour, readMinu, calSec)
    }
}
