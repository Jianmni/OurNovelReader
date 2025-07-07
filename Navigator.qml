// WF 2023051604037
// this file is a useful component
// 底部导航
// 进入软件时，点击按钮跳转播放、书架、用户界面
import QtQuick

Rectangle {
    height: 60
    anchors.right: parent.right; anchors.left: parent.left
    anchors.bottom: parent.bottom
    radius: 10

    signal navigate(target: int)
    required property int page

    Icon {
        id: listen
        height: 40; width: 34
        anchors.left: parent.left; anchors.leftMargin: parent.width/10
        anchors.verticalCenter: parent.verticalCenter

        src: (page === 1) ? "img/onlitsen.png" : "img/litsen.png"
        bounce: 1.01

        onClicked: {
            navigate(1)
        }
    }

    Icon {
        id: read
        height: 40; width: 34
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        src: (page === 2) ? "img/onread.png" : "img/read.png"
        bounce: 1.01

        onClicked: {
            navigate(2)
        }
    }


    Icon {
        id: user
        height: 40; width: 34
        anchors.right: parent.right; anchors.rightMargin: parent.width/10
        anchors.verticalCenter: parent.verticalCenter

        src: (page === 3) ? "img/onuser.png" : "img/user.png"
        bounce: 1.01

        onClicked: {
            navigate(3)
        }
    }
}
