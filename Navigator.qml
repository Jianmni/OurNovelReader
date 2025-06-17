// WF 2023051604037
// this file is a use full component
import QtQuick

Rectangle {
    id:navigator
    height: 60
    anchors.right: parent.right; anchors.left: parent.left
    anchors.bottom: parent.bottom
    radius: 10

    Icon {
        id: listen
        height: 40; width: 34
        anchors.left: parent.left; anchors.leftMargin: parent.width/10
        anchors.verticalCenter: parent.verticalCenter
        src: "img/listen.png"
        onClicked: console.log("listen")
    }

    Icon {
        id: read
        height: 40; width: 34
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        src: "img/read.png"
        onClicked: console.log("read")
    }


    Icon {
        id: user
        height: 40; width: 34
        anchors.right: parent.right; anchors.rightMargin: parent.width/10
        anchors.verticalCenter: parent.verticalCenter
        src: "img/user.png"
        onClicked: console.log("user")
    }
}
