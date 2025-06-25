import QtQuick
Rectangle {
    id: manager
    anchors.fill: parent
    property int txtMargin: 20

    // get from parent when init
    property var preChapter: []
    property var curChapter: []
    property var nxtChapter: []
    property int  pageIndex: 0          // change before move
    // read config :
    property bool leftAndRight: true    // false is up-and-down way
    property color readbg: "#FAFAFA"
    property int fontSize: 16           // text pixelSize
    property string fontType: "Helvetica"

    property bool curPageIs0: true        // true is page0, while false is page1
    property bool curPageIsTitle: (pageIndex === 0)     // update automaticly

    // text font info
    property real txtWidth: txtFontInfo.height   // for covert.js
    property int numOfLines: height / txtWidth
    property int numOfChars: (width - txtMargin*2) / txtFontInfo.ascent
    // title font info
    property real titHeight: titleFontInfo.height
    property int  numofTitleCharsInLine: width / titleFontInfo.ascent


    /* signals */
    signal loadNextChapter      // turn to next page
    signal loadPreChapter       // turn to previous page



    /****************** page change operation****************/
    // scroll
    // ...
    // switch

    TapHandler {
        onTapped: eventPoint => {
            // console.log(eventPoint.position)
            var x = eventPoint.position.x
            if( x > (parent.width/2)){    // show next page
                pageIndex++
                switchNext()
            } else {        // show previous page
                pageIndex--
                switchPre()
            }
            curPageIs0 = !curPageIs0
        }
    }

    function switchNext() { // move left
        if(curPageIs0) {        // curPage is page0, move page1 to right and move
            if (page1.x !== width)
            {
                page1.xPos = width

                if (pageIndex < curChapter.length)
                {
                    txt1.text = curChapter[pageIndex]       // change text
                    if (pageIndex === 1)     /* current page is title page in truth */
                    {
                        // titlePage and page1 run together
                        t1MoveLeft.start()
                        return
                    }
                }
                else {          // next page
                    pageIndex = 0
                    txt3.text = nxtChapter[pageIndex]
                    // change chapter array
                    // ...
                    titlePage.xPos = width
                    // page0 and titlePage run together
                    t0MoveLeft.start()
                    return
                }
            }
        }
        else {                  // curPage is page1, move page0 to right and move
            if (page0.x !== width)
            {
                page0.xPos = width
                if (pageIndex < curChapter.length)
                {
                    txt0.text = curChapter[pageIndex]
                    if (pageIndex === 1)     /* current page is title page in truth */
                    {
                        // titlePage and page0 run together
                        // run animation
                        return
                    }
                }
                else
                {
                    pageIndex = 0;
                    txt3.text = nxtChapter[pageIndex]
                    // change chapter
                    // ...
                    titlePage.xPos = width
                    // page0 and titlePage run together
                    // ...
                    return
                }
            }
        }
        moveLeft.start()
    }
    function switchPre() {
        if (curPageIs0)         // curPage = page0, move page1 to left and move
        {
            if (page1.x !== -width)
            {
                page1.xPos = -width
                if (pageIndex === 0)    // next page is the title page
                {
                    txt3.text = curChapter[0]
                    titlePage.xPos = -width
                    // page0 and title page move together
                    t0MoveRight.start()
                }
                else if (pageIndex > 0)
                {
                    txt1.text = curChapter[pageIndex]
                }
                else
                {
                    pageIndex = preChapter.length - 1;  // next page and current page is the title page
                    txt1.text = preChapter[pageIndex]
                    // change chapter array
                    // page1 and titlePage move together
                    t1MoveRight.start()
                    return
                }
            }
        }
        else {                  // curPage = page1, move page0 to left and move
            if (page0.x !== -width)
            {
                page0.xPos = -width
                if (pageIndex === 0)        // next is the title page
                {
                    txt3.text = curChapter[0]
                    titlePage.xPos = -width
                    // page1 and the title page move together
                    // run animation
                }
                else if (pageIndex > 0)
                {
                    txt0.text = curChapter[pageIndex]
                }
                else
                {
                    pageIndex = preChapter.length - 1;  // current is the title page
                    txt0.text = preChapter[pageIndex]
                    // page0 and the title page move together
                    // run animation
                    return
                }
            }
        }
        moveRight.start()
    }

    // scroll next / pre

    // page container
    Rectangle {
        id: page0
        height: parent.height;  width: parent.width
        y:0
        x:xPos // switch
        color: readbg
        property real xPos: 0

        Text {
            id: txt0
            anchors.top: parent.top;     anchors.bottom: parent.bottom
            anchors.left: parent.left;   anchors.leftMargin: txtMargin
            text: "满纸荒唐言"
            font.pixelSize: 16
            font.family: fontType
        }
    }
    Rectangle {
        id: page1
        height: parent.height;  width: parent.width
        y:0
        x:xPos // switch
        color: readbg
        property real xPos: parent.width

        Text {
            id: txt1
            anchors.top: parent.top;     anchors.bottom: parent.bottom
            anchors.left: parent.left;   anchors.leftMargin: txtMargin
            text: "都付笑谈中"
            font.pixelSize: 16
            font.family: fontType
        }
    }
    // this rectangle shows chapter number, title and
    Rectangle {
        id: titlePage
        height: parent.height;  width: parent.width
        y: 0
        x: -xPos
        color: readbg
        property real xPos: parent.width

        Text {
            id: cn
            text: "第1章"
            anchors.top: parent.top;     anchors.topMargin: 100
            anchors.left: parent.left;   anchors.leftMargin: txtMargin
            font.pixelSize: 16
            font.family: fontType
        }
        Text {
            id: ct
            text: "林黛玉别父闹天宫\n西门庆夜会猛张飞"
            anchors.top: cn.top;     anchors.topMargin: 50
            anchors.left: cn.left
            font.pixelSize: 24
            font.family: fontType
        }
        Text {
            id: txt3
            text: "欲知后事如何，且看下回分解。"
            anchors.top: ct.bottom;  anchors.topMargin: 20
            anchors.left: cn.left
            anchors.bottom: parent.bottom
            font.pixelSize: 16
            font.family: fontType
        }
    }

    FontMetrics {
        id: txtFontInfo
        font: txt1.font
    }
    FontMetrics {
        id: titleFontInfo
        font: ct.font
    }

    /********************** animations **********************/
    // page0 and page1 left-and-right switch
    property int pageWidth: width
    property int changetim: 100
    ParallelAnimation {
        id: moveLeft
        PropertyAnimation {
            target: page0
            property: "x"
            to: page0.xPos-pageWidth
            duration: changetim
        }
        PropertyAnimation {
            target: page1
            property: "x"
            to: page1.xPos-pageWidth
            duration: changetim
        }
        onFinished: {
            page0.xPos = page0.x
            page1.xPos = page1.x
        }
    }
    ParallelAnimation {
        id: moveRight
        PropertyAnimation {
            target: page0
            property: "x"
            to: page0.xPos+pageWidth
            duration: changetim
        }
        PropertyAnimation {
            target: page1
            property: "x"
            to: page1.xPos+pageWidth
            duration: changetim
        }
        onFinished: {
            page0.xPos = page0.x
            page1.xPos = page1.x
        }
    }
    // page0 and titlePage left-and-right switch
    ParallelAnimation {
        id: t0MoveLeft
        PropertyAnimation {
            target: page0
            property: "x"
            to: page0.xPos - pageWidth
            duration: changetim
        }
        PropertyAnimation {
            target: titlePage
            property: "x"
            to: titlePage.xPos - pageWidth
            duration: changetim
        }
        onFinished: {
            page0.xPos = page0.x
            titlePage.xPos = titlePage.x
        }
    }
    ParallelAnimation {
        id: t0MoveRight
        PropertyAnimation {
            target: page0
            property: "x"
            to: page0.xPos + pageWidth
            duration: changetim
        }
        PropertyAnimation {
            target: titlePage
            property: "x"
            to: titlePage.xPos + pageWidth
            duration: changetim
        }
        onFinished: {
            page0.xPos = page0.x
            titlePage.xPos = titlePage.x
        }
    }
    // page1 and titlePage left-and-right switch
    ParallelAnimation {
        id: t1MoveLeft
        PropertyAnimation {
            target: page1
            property: "x"
            to: page1.xPos - pageWidth
            duration: changetim
        }
        PropertyAnimation {
            target: titlePage
            property: "x"
            to: titlePage.xPos - pageWidth
            duration: changetim
        }
        onFinished: {
            page1.xPos = page1.x
            titlePage.xPos = titlePage.x
        }
    }
    ParallelAnimation {
        id: t1MoveRight
        PropertyAnimation {
            target: page1
            property: "x"
            to: page1.xPos + pageWidth
            duration: changetim
        }
        PropertyAnimation {
            target: titlePage
            property: "x"
            to: titlePage.xPos + pageWidth
            duration: changetim
        }
        onFinished: {
            page1.xPos = page1.x
            titlePage.xPos = titlePage.x
        }
    }

    /************************* init *************************/
    Component.onCompleted: {
        init()
    }
    function init() {
        txt0.text = curChapter[pageIndex]
    }
}
