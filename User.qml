import QtQuick

Rectangle {
    id: info
    anchors.top: parent.top
    anchors.left: parent.left;  anchors.right: parent.right
    color: bg    // bg
    property color bg: "#FAFAFA"

    // 邮箱
    Rectangle {
        id: envelope
        anchors.top: parent.top;    anchors.topMargin: 20   // y:20
        anchors.left: parent.left;  anchors.leftMargin: 15
        height: 36; width: 25
        color: bg
        Icon {
            src: "img/ic_evlp.png"
            height: parent.height;  width: parent.width
            color: bg
        }
    }

    // 设置
    Rectangle {
        id: sets
        anchors.top: envelope.top
        anchors.right: parent.right; anchors.rightMargin: 15
        height: 36; width: 25
        color: bg
        Icon {
            src: "img/ic_set.png"
            height: parent.height;  width: parent.width
            color: bg
        }
    }

    // 用户信息： 头像、用户名、签名
    Rectangle {
        id: user
        height: 80
        anchors.top: sets.bottom;      anchors.topMargin: 26      // y:80
        anchors.right: parent.right;    anchors.rightMargin: 20
        anchors.left: parent.left;      anchors.leftMargin: 20

        Item {
            id: portrait
            height: 80; width: 80
            anchors.top: parent.top;  anchors.left: parent.left
            clip: true
            Rectangle {
                anchors.fill: parent
                radius: width/2
                opacity: 0
            }
            Image {
                id: head
                source: "img/head.jpg"
                sourceClipRect: Qt.rect(7, 3, 80, 80);
                anchors.fill: parent
            }
        }

        Text {
            id: name
            anchors.top: parent.top;    anchors.topMargin: 10   // y:90
            anchors.left: portrait.right; anchors.leftMargin: 5
            text: qsTr("Jager")
            font.pixelSize: 12
            color: "#BD0303"
        }
        Text {
            id:sign
            anchors.top: name.bottom;      anchors.topMargin: 8
            anchors.left: name.left
            text: qsTr("认真对待阅读的每一分钟")
            font.pixelSize: 12
            color: "#A9A9A9"
        }

        Icon {
            id: edit
            src: "img/ic_editInfo.png"
            anchors.verticalCenter: portrait.verticalCenter
            anchors.right: parent.right; anchors.rightMargin: 10
            height: 25; width: 25
            color: bg
            bounce: 1.01
        }
    }

}
