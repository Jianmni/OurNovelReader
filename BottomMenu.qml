import QtQuick

Rectangle {
    id: bottomMenu
    anchors.left: parent.left;      anchors.right: parent.right
    height: 50
    z: 2
    y: yPos
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
        height: 40; width: 40
        color: "red"
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
        height: 40; width: 40
        color: "green"
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
        height: 40; width: 40
        color: "blue"
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
        height: 40; width: 40
        color: "yellow"
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
        height: 40; width: 40
        color: "gray"
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
        to: yPos - 50
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
        from: yPos - 50
        to: yPos
        duration: 200
    }
}
