import QtQuick

Rectangle {
    id: topMenu
    height: 50; width: parent.width
    y: -50      // not show
    color: "#F8F8F8"
    z: 2

    // icons
    /* quit */
    signal quitRead
    Rectangle {
        id: quitIc
        anchors.left: parent.left;      anchors.leftMargin: 30
        anchors.verticalCenter: parent.verticalCenter
        height: 40; width: 40
        color: "blue"

        TapHandler {
            onTapped: {
                quitRead()
            }
        }
    }

    /* share book */
    Rectangle {
        id: shareBook
        anchors.right: parent.right;    anchors.rightMargin: 30
        anchors.verticalCenter: parent.verticalCenter
        height: 40; width: 40
        color: "blue"
        TapHandler {
            onTapped: {
                generateSharePic()
            }
        }
    }

    function generateSharePic()
    {
        // ...
    }

    /* operation on book */
    signal showOpBookMenu
    Rectangle {
        id: operBook
        anchors.right: shareBook.left;      anchors.rightMargin: 30
        anchors.verticalCenter: parent.verticalCenter
        height: 40; width: 40
        color: "blue"
        TapHandler {
            onTapped: showOpBookMenu()
        }
    }


    function show()
    {
        showAni.start()
    }
    PropertyAnimation {
        id: showAni
        target: topMenu
        property: "y"
        from: -50
        to: 0
        duration: 200
    }

    function hide() {
        hideAni.start()
    }
    signal handleHide
    PropertyAnimation {
        id: hideAni
        target: topMenu
        property: "y"
        from: 0
        to: -50
        duration: 200
    }
}
