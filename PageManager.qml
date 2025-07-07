import QtQuick
Rectangle {
    id: manager
    anchors.left: parent.left
    anchors.right: parent.right

    // get from parent when init
    property var preCptTxt: []
    property var curCptTxt: []
    property var nxtCptTxt: []
    property int cptSum: 1             // check show end or not
    property int chapterIndex:  1      // check show cover or not
    property int pageIndex: 0          // change before move
    // read config :
    property int txtMargin: 20
    property bool leftAndRight: true    // false is up-and-down way
    property color readbg: "#FAFAFA"
    property int fontSize: 16           // text pixelSize
    property string fontType: "Helvetica"

    // 处理后，得到以下内容
    // 只保存前一章、当前章和后一章三章内容
    // 每章的章节号
    property string curNum: ""
    property string nxtNum: ""
    property string preNum: ""      // for exchange
    // 每章的标题
    property string curTitle: ""
    property string nxtTitle: ""
    property string preTitle: ""    // for exchange
    // 每章的第一页内容
    property string curFirstPage: ""
    property string nxtFirstPage: ""
    property string preFirstPage: ""
    // pages 保存的内容实际是从每章第二页开始
    property var curPages: ["",]       // QList<QString>, first page is empty, show title page
    property var prePages: ["",]
    property var nxtPages: ["",]
    // for parent to use
    property int prePageSum: 0
    property int curPageSum: 0
    property int nxtPageSum: 0

    // text font info
    property int numOfLines: height / txtFontInfo.height
    property int numOfChars: (width - txtMargin*2) / txtFontInfo.ascent
    // title font info
    property real titHeight: titleFontInfo.height
    property int  numofTitleCharsInLine: width / titleFontInfo.ascent


    /* signals */
    signal loadNextChapter      // turn to next page
    signal loadPreChapter       // turn to previous page
    signal showCover            // should show cover
    signal showEnd              // should show end

    /****************** page change operation****************/
    property bool canSwitch: false
    property real leftEdge: parent.width / 3
    property real rightEdge: parent.width / 3 * 2
    property real topEdge: parent.height / 5
    property real bottomEdge: parent.height / 5 * 4
    signal showMenu
    TapHandler {
        enabled: canSwitch
        onTapped: eventPoint => {
            var x = eventPoint.position.x
            var y = eventPoint.position.y
            if(leftAndRight)
                if(x >= rightEdge)   // go to next page
                {
                    switchNext()
                }
                else if (x <= leftEdge)
                {
                    switchPre()
                }
                else showMenu()
            else
                if(y >= bottomEdge || x >= rightEdge)
                {
                    // ...
                }
                else if(y <= topEdge || x <= leftEdge)
                {
                    // ...
                }
                else showMenu()
        }
    }

    property bool curPageIs0: true        // true is page0, while false is page1
    property bool curPageIsTitle: (pageIndex === 0)     // update automaticly
    // scroll
    // ...
    // switch
    function switchNext() { // move left
        pageIndex++         // to next page's index
        if (pageIndex === curPageSum && (chapterIndex+1) === cptSum) // showEnd() or on end
        {
            pageIndex--;    // at last page
            console.log("end")
            showEnd()
            return
        }

        if(page0.x === 0) {        // curPage is page0, move page1 to right and move
            if (page1.x !== pageWidth)
            {
                if(pageIndex === curPageSum)    /**** next chapter ****/
                {
                    pageIndex = 0
                    cn.text = nxtNum
                    ct.text = nxtTitle
                    txt3.text = nxtFirstPage

                    titlePage.x = pageWidth
                    titlePage.xPos = pageWidth
                    // titlePage and current page page0 run together
                    console.log("1")
                    t0MoveLeft.start()

                    chapterIndex++
                    loadNextChapter()
                    return
                }

                page1.x = pageWidth
                page1.xPos = pageWidth
                txt1.text = curPages[pageIndex]       // change text
            }
        }
        else if (page1.x === 0){    // curPage is page1, move page0 to right and move
            if (page0.x !== pageWidth)
            {
                if(pageIndex === curPageSum)    /**** next chapter ****/
                {
                    pageIndex = 0
                    cn.text = nxtNum
                    ct.text = nxtTitle
                    txt3.text = nxtFirstPage

                    titlePage.x = pageWidth
                    titlePage.xPos = pageWidth
                    // titlePage and current page page0 run together
                    t1MoveLeft.start()

                    chapterIndex++
                    loadNextChapter()
                    return
                }

                page0.x = pageWidth
                page0.xPos = pageWidth
                txt0.text = curPages[pageIndex]
            }
        }
        else if(titlePage.x === 0)
        {      // current page is the title page
            page1.x = pageWidth
            page1.xPos = pageWidth
            txt1.text = curPages[pageIndex]       // change text

            t1MoveLeft.start()
            return
        }
        moveLeft.start()
    }
    function switchPre() {
        pageIndex--         // to next page's index
        if (pageIndex < 0 && (chapterIndex-1) === 0)   // showCover() or on cover
        {
            pageIndex++
            console.log("cover")
            showCover()
            return
        }

        if (page0.x === 0)          // curPage = page0, move page1 to left and move
        {
            if (pageIndex === 0)    // previous is the title page
            {
                cn.text = curNum
                ct.text = curTitle
                txt3.text = curFirstPage

                titlePage.x = -pageWidth
                titlePage.xPos = -pageWidth
                // page0 and title page move together
                t0MoveRight.start()
                return
            }

            page1.x = -pageWidth
            page1.xPos = -pageWidth
            txt1.text = curPages[pageIndex]
            // previous chapter impossible
        }
        else if(page1.x === 0)
        {                           // curPage = page1, move page0 to left and move
            if (pageIndex === 0)    // next is the title page
            {
                cn.text = curNum
                ct.text = curTitle
                txt3.text = curFirstPage

                titlePage.x = -pageWidth
                titlePage.xPos = -pageWidth
                // page1 and title page move together
                t1MoveRight.start()
                return
            }
            page0.x = -pageWidth
            page0.xPos = -pageWidth
            txt0.text = curPages[pageIndex]
            // previous chapter impossible
        }
        else if(titlePage.x === 0)
        {
            pageIndex = prePageSum - 1
            txt1.text = prePages[pageIndex]
            page1.x = -pageWidth
            page1.xPos = -pageWidth
            t1MoveRight.start()

            --chapterIndex
            loadPreChapter()
            return
        }
        moveRight.start()
    }


    // scroll next / pre

    // page container
    Rectangle {
        id: page0
        height: parent.height;  width: parent.width
        y:0
        x:-pageWidth*2 // switch
        color: readbg
        property real xPos: x

        Text {
            id: txt0
            anchors.top: parent.top;     anchors.bottom: parent.bottom
            anchors.left: parent.left;   anchors.leftMargin: txtMargin
            text: "满纸荒唐言"
            font.pixelSize: fontSize
            font.family: fontType
        }
    }
    Rectangle {
        id: page1
        height: parent.height;  width: parent.width
        y:0
        x:-pageWidth*2 // switch
        color: readbg
        property real xPos: x

        Text {
            id: txt1
            anchors.top: parent.top;     anchors.bottom: parent.bottom
            anchors.left: parent.left;   anchors.leftMargin: txtMargin
            text: "都付笑谈中"
            font.pixelSize: fontSize
            font.family: fontType
        }
    }
    // this rectangle shows chapter number, title and
    Rectangle {
        id: titlePage
        height: parent.height;  width: parent.width
        y: 0
        x: -pageWidth*2
        color: readbg
        property real xPos: x

        Text {
            id: cn
            text: "第1章"
            anchors.top: parent.top;     anchors.topMargin: 100
            anchors.left: parent.left;   anchors.leftMargin: txtMargin
            font.pixelSize: fontSize
            font.family: fontType
        }
        Text {
            id: ct
            text: "林黛玉别父闹天宫\n西门庆夜会猛张飞"
            anchors.top: cn.top;     anchors.topMargin: 50
            anchors.left: cn.left
            font.pixelSize: fontSize + 8
            font.family: fontType
        }
        Text {
            id: txt3
            text: "欲知后事如何，且看下回分解。"
            anchors.top: ct.bottom;  anchors.topMargin: 50
            anchors.left: cn.left
            anchors.bottom: parent.bottom
            font.pixelSize: fontSize
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

    /************************* init *************************/
    function setPage()      // after initPages()
    {
        if (pageIndex === 0)    // curPageIsTitle = true
        {
            cn.text = curNum
            ct.text = curTitle
            txt3.text = curFirstPage
            titlePage.x = 0     // show title page
        }
        else
        {
            txt0.text = curPages[pageIndex]
            page0.x = 0
        }
    }

    function initPages() {
        initCurPages()
        initPrePages()
        setPage()
        initNxtPages()
    }

    function initCurPages()
    {
        var i=0
        // chapter number
        curNum = curCptTxt[i++]

        let tmp = ""
        // chapter title
        let lineCount = 0
        var len = curCptTxt.length
        while(i<len && curCptTxt[i] !== "#")
        {
            tmp = tmp + curCptTxt[i] + '\n'
            ++i
            ++lineCount
        }
        curTitle = tmp
        ++i     // skip '#

        tmp = ""
        // text in first page
        var firstLine = numOfLines - lineCount*2 - 10
        if (firstLine < 0) firstLine = 0
        while(i<len && firstLine)
        {
            tmp = tmp + curCptTxt[i] + '\n'
            ++i
            --firstLine
        }
        curFirstPage = tmp

        curPageSum++
        tmp = ""
        // pages
        lineCount = 0
        while(i<len)
        {
            tmp = tmp + curCptTxt[i] + '\n'
            ++lineCount
            if (lineCount === numOfLines)
            {
                curPages.push(tmp)
                curPageSum++
                tmp = ""
                lineCount = 0
            }
            ++i
        }
        if (lineCount !== 0)
        {
            curPages.push(tmp)
            curPageSum++
        }
        console.log("cur OK", curNum)
    }
    function initPrePages()
    {
        /* prepare */
        prePageSum = 0
        prePages = ["",]

        if (preCptTxt[0] === undefined)
        {
            console.log("pre no content")
            return
        }
        var i=0
        // chapter number
        preNum = preCptTxt[i++]

        let tmp = ""
        // chapter title
        let lineCount = 0
        var len = preCptTxt.length
        while(i<len && preCptTxt[i] !== "#")
        {
            tmp = tmp + preCptTxt[i] + '\n'
            ++i
            ++lineCount
        }
        preTitle = tmp
        ++i     // skip '#

        tmp = ""
        // text in first page
        var firstLine = numOfLines - lineCount*2 - 10
        if (firstLine < 0) firstLine = 0
        while(i<len && firstLine)
        {
            tmp = tmp + preCptTxt[i] + '\n'
            ++i
            --firstLine
        }
        preFirstPage = tmp

        prePageSum++
        tmp = ""
        // pages
        lineCount = 0
        while(i<len)
        {
            tmp = tmp + preCptTxt[i] + '\n'
            ++lineCount
            if (lineCount === numOfLines)
            {
                prePages.push(tmp)
                prePageSum++
                tmp = ""
                lineCount = 0
            }
            ++i
        }
        if (lineCount !== 0)
        {
            prePages.push(tmp)
            prePageSum++
        }
        console.log("pre OK", preNum)
    }
    function initNxtPages()
    {
        /* prepare */
        nxtPageSum = 0
        nxtPages = ["",]

        if (nxtCptTxt[0] === undefined)
        {
            console.log("nxt no content")
            return
        }
        var i=0
        // chapter number
        nxtNum = nxtCptTxt[i++]

        let tmp = ""
        // chapter title
        let lineCount = 0
        var len = nxtCptTxt.length
        while(i<len && nxtCptTxt[i] !== "#")
        {
            tmp = tmp + nxtCptTxt[i] + '\n'
            ++i
            ++lineCount
        }
        nxtTitle = tmp
        ++i     // skip '#

        tmp = ""
        // text in first page
        var firstLine = numOfLines - lineCount*2 - 10
        if (firstLine < 0) firstLine = 0
        while(i<len && firstLine)
        {
            tmp = tmp + nxtCptTxt[i] + '\n'
            ++i
            --firstLine
        }
        nxtFirstPage = tmp

        nxtPageSum++
        tmp = ""
        // pages
        lineCount = 0
        while(i<len)
        {
            tmp = tmp + nxtCptTxt[i] + '\n'
            ++lineCount
            if (lineCount === numOfLines)
            {
                nxtPages.push(tmp)
                nxtPageSum++
                tmp = ""
                lineCount = 0
            }
            ++i
        }
        if (lineCount !== 0)
        {
            nxtPages.push(tmp)
            nxtPageSum++
        }
        console.log("nxt OK", nxtNum, nxtPageSum)
    }

    function switchChapter2Nxt()
    {
        prePages = curPages
        curPages = nxtPages

        preNum = curNum
        preTitle = curTitle
        preFirstPage = curFirstPage
        prePageSum = curPageSum

        curNum = nxtNum
        curTitle = nxtTitle
        curFirstPage = nxtFirstPage
        curPageSum = nxtPageSum
        console.log("switchChapter2Nxt OK")
    }

    function switchChapter2Pre()
    {
        nxtPages = curPages
        curPages = prePages

        nxtNum = curNum
        nxtTitle = curTitle
        nxtFirstPage = curFirstPage
        nxtPageSum = curPageSum

        curNum = preNum
        curTitle = preTitle
        curFirstPage = preFirstPage
        curPageSum = prePageSum
        console.log("switchChapter2Pre OK")
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

}
