import QtQuick

Rectangle {
    id: search
    height: 40
    anchors.top: parent.top;     anchors.topMargin: 15
    anchors.left: parent.left;   anchors.leftMargin: 20
    anchors.right: parent.right; anchors.rightMargin: 20
    radius: 10
    color: "#EAEAEA"

    signal turnToPage(target: int)

    Icon {
        id: srchIc
        src: "img/ic_search.png"
        height: 18; width: 14
        x: 11; y:11
        color: "#EAEAEA"
        bounce: 1.02
    }

    Text {
        id: srchText
        text: qsTr("搜索")
        anchors.left: srchIc.right; anchors.leftMargin: 5
        anchors.verticalCenter: srchIc.verticalCenter
        font.pointSize: 12
    }

    Text {
        text: qsTr(" | 书架书籍")
        anchors.left: srchText.right
        anchors.verticalCenter: srchText.verticalCenter
        font.pointSize: 10
        color: "#757575"
    }

    TapHandler {
        onTapped: turnToPage(22)
    }
}
