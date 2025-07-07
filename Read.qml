// WF 2023051604037
// show contexts of a book
// it's header shows chapter's id and name
// it's footer shows curret time and read progress(current page/total page)
// it's body shows contexts, chapter id and name
import QtQuick
import QtQuick.Shapes

import ReadEngin
import TextManager

Rectangle {
    id: pages
    anchors.fill: parent
    color: defaultbg
    property color defaultbg: "#FAFAFA"
    property int readWidth: width

    /* book's id is need */
    property int bookId

    property string chapterName: "第1章"
    property string bkName: "未知书籍"
    property string auName: "佚名"
    property string intro: "无简介"
    property var content: []

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

    onBookIdChanged : {
        init()
    }

    function init() {
        var info = readEngin.loadBookReadInfo(bookId);  // load book read infomations
        var i = 0;
        curReadChapter  = info[i++];    // current reading chapter
        curReadPage   = info[i++];    // current reading page in chapter
        tolChapterNum = info[i++];    // total number of chapters
        // console.log(tolChapterNum, " total chapter num")
        bkName        = info[i++];    // book's name
        auName        = info[i++];    // author' name
        while(i < info.length)
            intro = intro + info[i++] + '\n';

        content = readEngin.loadBookContent()
        if (curReadChapter === 0)
            curReadChapter = 1
        else
            coverGoLeft.start()       // hide cover

        preChapter = (curReadChapter === 1) ? [] : readEngin.loadChapter(curReadChapter-1)
        curChapter = readEngin.loadChapter(curReadChapter)   // load chapter 1
        nxtChapter = (curReadChapter === tolChapterNum) ? [] : readEngin.loadChapter(curReadChapter+1)
    }

    /* handle page switch */
    property int pageState: 0           // 0 is cover, 2 is end and 1 is in book
    TapHandler {
        onTapped: eventPoint => {
            // console.log("ddd", eventPoint.position.x)
            var x = eventPoint.position.x
            if (x >= (parent.width/2))      // switch to next page
            {
                if (pageState === 1)
                    pageManager.switchNext()
                else if (pageState === 0)
                {
                    coverGoLeft.start()
                    pageState = 1
                }
                // at end do nothing
            }
            else {                           // switch to previous page
                if (pageState === 1)
                    pageManager.switchPre()
                else if(pageState === 2)
                {
                    pageState = 1
                    coverGoRight.start()
                }
                // at cover do nothing
          }
        }
    }

    // read page
    PageManager {
        id: pageManager
        anchors.top: head.bottom;   anchors.topMargin: 15
        anchors.bottom: foot.top;   anchors.bottomMargin: 15
        anchors.left: parent.left
        anchors.right: parent.right

        chapterIndex: curReadChapter
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

        pageIndex: curReadPage
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
            pageState = 0
            coverGoRight.start()
        }
        onShowEnd: {
            pageState = 2
            // ...
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
        height: 30
        color: defaultbg

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
    property string currentTime: "05:20"
    property int realPageIndex: pageManager.pageIndex + 1
    property string currentProgress: realPageIndex + "/" + pageManager.curPageSum
    Rectangle {
        id: foot
        anchors.bottom: parent.bottom
        anchors.right: parent.right;    anchors.left: parent.left
        height: 30
        color: defaultbg

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
            font.pixelSize: 12

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
            }
        }
    }

    // cover
    Rectangle {
        y:0;    x:0
        id: cover
        anchors.fill: parent
        color: defaultbg

        Rectangle{
            id: wrap
            anchors.top: parent.top;        anchors.topMargin: 60
            anchors.horizontalCenter: parent.horizontalCenter
            height: 146;    width: 111
            color: "lightgray"
            Rectangle {
                anchors.centerIn: parent
                height: 144;    width: 109
                color: defaultbg
                Rectangle {
                    anchors.centerIn: parent
                    height: 140;    width: 105
                    Image {
                        anchors.fill: parent
                        source: "img/0.png"
                    }
                }
            }
        }

        Text {
            id: name
            anchors.top: wrap.bottom;       anchors.topMargin: 30
            anchors.horizontalCenter: parent.horizontalCenter
            text: bkName
            font.pixelSize: 20
        }

        Rectangle {
            id: author
            anchors.top: name.bottom;       anchors.topMargin: 40
            anchors.horizontalCenter: parent.horizontalCenter
            width: 300; height: 100
            color: defaultbg
            Text {
                id: auTxt
                anchors.top: parent.top;    anchors.topMargin: 15
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("作者")
                font.pixelSize: 14
                color: "#9B9B9B"
            }

            Shape {
                id: sep
                anchors.top: auTxt.bottom;    anchors.bottomMargin: 5
                anchors.horizontalCenter: auTxt.horizontalCenter
                height: 5;  width: 200
                ShapePath {
                    strokeColor: "#9B9B9B"
                    strokeWidth: 1
                    fillColor: "transparent"
                    capStyle: ShapePath.RoundCap

                    property int joinStyleIndex: 0

                    property variant styles: [
                        ShapePath.BevelJoin,
                        ShapePath.MiterJoin,
                        ShapePath.RoundJoin
                    ]

                    joinStyle: styles[joinStyleIndex]

                    startX: 0
                    startY: 3
                    PathLine { x: 200; y: 3 }
                }
            }

            Rectangle {
                anchors.top: sep.bottom;        anchors.topMargin: 5
                anchors.horizontalCenter: parent.horizontalCenter
                color: defaultbg
                height: 30
                Text {
                    id: aunm
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("佚名")
                    font.pixelSize: 18
                }

                // docrate
                Image {// left
                    height: 21; width: 21
                    source: "img/ic_drtNameLeft.png"
                    fillMode: Image.PreserveAspectFit
                    anchors.verticalCenter: aunm.verticalCenter
                    anchors.right: aunm.left;    anchors.rightMargin: 20
                }
                Image {
                    height: 21; width: 21
                    source: "img/ic_drtNameRight.png"
                    fillMode: Image.PreserveAspectFit
                    anchors.verticalCenter: aunm.verticalCenter
                    anchors.left: aunm.right;    anchors.leftMargin: 20
                }
            }
        }

        Rectangle {
            id: tip
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom;      anchors.bottomMargin: 100
            height: 21;     width: 200
            color: defaultbg

            Text {
                id: tipTxt
                anchors.centerIn: parent
                text: "点击屏幕右侧开始阅读"
                font.pixelSize: 14
                color: "#7C7C7C"
            }

            Image {
                height: 21; width: 21
                source: "img/ic_tip.png"
                fillMode: Image.PreserveAspectFit
                anchors.verticalCenter: tipTxt.verticalCenter
                anchors.left: tipTxt.right;    anchors.leftMargin: 20
            }
            Image {
                height: 21; width: 21
                source: "img/ic_tip.png"
                fillMode: Image.PreserveAspectFit
                anchors.verticalCenter: tipTxt.verticalCenter
                anchors.right: tipTxt.left;    anchors.rightMargin: 20
            }
        }
    }
    PropertyAnimation {
        id:coverGoLeft
        target: cover
        property: "z"
        to: -1
        duration: 100
    }
    PropertyAnimation {
        id: coverGoRight
        target: cover
        property: "z"
        to: 0
        duration: 100
    }
    // end
}
