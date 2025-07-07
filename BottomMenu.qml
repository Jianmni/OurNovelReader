// WF 2023051604037
// 2025-7-7 - 2025-7-8
// 阅读时，点击屏幕中央，呼出底部菜单
// 菜单有：目录、笔记、进度、亮度、文字
// 目前仅实现展示目录
import QtQuick

Rectangle {
    id: bottomMenu
    anchors.left: parent.left;      anchors.right: parent.right
    height: 40
    z: 2
    y: yPos
    color: "#F8F8F8"
    property int yPos: parent.height

    // operations
    property real offset: parent.width / 5
    property real firstIcX: (offset-40) / 2
    /* content */
    signal showContent
    property bool contentIsShow: false
    Rectangle {
        id: content
        anchors.left: parent.left;  anchors.leftMargin: firstIcX
        anchors.verticalCenter: parent.verticalCenter
        height: 32; width: 32
        color: "#F8F8F8"
        Icon {
            anchors.fill: parent
            color: "#F8F8F8"
            src: "img/ic_content.png"
            bounce: 1.01
        }

        TapHandler {
            onTapped: {
                showContent()
            }
        }
    }

    /* note */
    signal showNote
    property bool noteIsShow: false
    Rectangle {
        id: note
        anchors.left: content.left;  anchors.leftMargin: offset
        anchors.verticalCenter: parent.verticalCenter
        height: 32; width: 32
        color: "#F8F8F8"
        Icon {
            anchors.fill: parent
            color: "#F8F8F8"
            src: "img/ic_note.png"
            bounce: 1.01
        }
        TapHandler {
            onTapped: {
                showNote()
            }
        }
    }

    /* progress */
    signal showProgressInfo
    property bool progressIsShow: false
    Rectangle {
        id: progress
        anchors.left: note.left;  anchors.leftMargin: offset
        anchors.verticalCenter: parent.verticalCenter
        height: 32; width: 32
        color: "#F8F8F8"
        Icon {
            anchors.fill: parent
            color: "#F8F8F8"
            src: "img/ic_progress.png"
            bounce: 1.01
        }
        TapHandler {
            onTapped: {
                showProgressInfo()
            }
        }
    }

    /* brightness */
    signal showBrightMenu
    property bool brightnessIsShow: false
    Rectangle {
        id: brightness
        anchors.left: progress.left;  anchors.leftMargin: offset
        anchors.verticalCenter: parent.verticalCenter
        height: 32; width: 32
        color: "#F8F8F8"
        Icon {
            anchors.fill: parent
            color: "#F8F8F8"
            src: "img/ic_brightness.png"
            bounce: 1.01
        }
        TapHandler {
            onTapped: {
                showBrightMenu()
            }
        }
    }

    /* font */
    signal showFontMenu
    property bool fontIsShow: false
    Rectangle {
        id: textFont
        anchors.left: brightness.left;  anchors.leftMargin: offset
        anchors.verticalCenter: parent.verticalCenter
        height: 32; width: 32
        color: "#F8F8F8"
        Icon {
            anchors.fill: parent
            color: "#F8F8F8"
            src: "img/ic_font.png"
            bounce: 1.01
        }
        TapHandler {
            onTapped: {
                showFontMenu()
            }
        }
    }

    function show()
    {
        showAnimation.start()
    }
    PropertyAnimation {
        id: showAnimation
        target: bottomMenu
        property: "y"
        from: yPos
        to: yPos - 40
        duration: 200
    }

    signal handleHide
    function hide()
    {
        console.log("bottom menu hide")
        hideAnimation.start()
    }
    PropertyAnimation {
        id: hideAnimation
        target: bottomMenu
        property: "y"
        from: yPos - 40
        to: yPos
        duration: 200
    }
}
