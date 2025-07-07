// WF 2023051604037
// 2025-7-7 - 2025-7-8
// 阅读时，点击屏幕中央，呼出顶部菜单
// 菜单有： 退出、操作本书、分享本书
// 目前仅实现退出。退出时，保存进度，再发送信号
import QtQuick

Rectangle {
    id: topMenu
    height: 40; width: parent.width
    y: -40      // not show
    color: "#F8F8F8"
    z: 2

    // icons
    /* quit */
    signal quitRead
    Rectangle {
        id: quitIc
        anchors.left: parent.left;      anchors.leftMargin: 30
        anchors.verticalCenter: parent.verticalCenter
        height: 32; width: 32
        color: "#F8F8F8"
        Icon {
            anchors.fill: parent
            color: "#F8F8F8"
            src: "img/ic_quitRead.png"
            bounce: 1.01
        }

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
        height: 32; width: 32
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
        height: 32; width: 32
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
        from: -40
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
        to: -40
        duration: 200
    }
}
