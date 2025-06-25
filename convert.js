// WF 2023051604037
// text font info
// property real txtWidth: txtFontInfo.height   // for covert.js
// property int numOfLines: height / txtWidth
// property int numOfChars: (width - txtMargin*2) / txtFontInfo.ascent
// title font info
// property real titHeight: titleFontInfo.height
// property int  numofTitleCharsInLine: width / titleFontInfo.ascent

// used is PageManager
// pages include title page and text page
function covertArrayToPages(arr) {
    var ret
    var pages   // start with page 0
    // first page
    var num = arr[0]
    pages.push(num)
    var tit = arr[1]
    var rest = numOfLines - (170/txtWidth)
    if (tit.length > numofTitleCharsInLine)
    {
        rest -= (tit.length / titHeight)
    }
    else pages.push(tit)

}


function processLine(line) {
    var ret

}
