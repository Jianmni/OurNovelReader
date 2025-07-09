// WF 2023051604037
// 2025-7-7 - 2025-7-8
import QtQuick

Rectangle {
    id: prgbd
    height: bdHeight
    anchors.left: parent.left;      anchors.right: parent.right
    y: yPos
    z: 2
    color: bg

    property int bdHeight: parent.height / 3
    property int yPos: parent.height
    property color bg: "#FAFAFA"

    property int tolChapterNum: 0
    property int curReadChapter: 0
    property string prgstr: curReadChapter + "/" + tolChapterNum
    Text {
        id: progress
        anchors.left: parent.left;  anchors.leftMargin: 30
        anchors.top: parent.top;    anchors.topMargin: 30
        text: prgstr
        font.pixelSize: 18
        Text {
            anchors.top: parent.bottom;    anchors.topMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("阅读进度")
            font.pixelSize: 10
        }
    }
    property int rdh: 0
    property int rdm: 0
    property string rdtstr: rdh + "时" + rdm + "分"
    Text {
        id: readTime
        anchors.verticalCenter: progress.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        text: rdtstr
        font.pixelSize: 18
        Text {
            anchors.top: parent.bottom;    anchors.topMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("阅读时长")
            font.pixelSize: 10
        }
    }
    property int notesum: 0
    property string ntstr: notesum + "条"
    Text {
        id: note
        anchors.right: parent.right;    anchors.rightMargin: 30
        anchors.verticalCenter: progress.verticalCenter
        text: ntstr
        font.pixelSize: 18
        Text {
            anchors.top: parent.bottom;    anchors.topMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr("阅读笔记")
            font.pixelSize: 10
        }
    }

    function show(){
        showAnimation.start()
    }
    PropertyAnimation {
        id: showAnimation
        target: prgbd
        property: "y"
        from: yPos
        to: yPos - bdHeight
        duration: 200
    }
    function hide(){
        hideAnimation.start()
    }
    PropertyAnimation {
        id: hideAnimation
        target: prgbd
        property: "y"
        from: yPos - bdHeight
        to: yPos
        duration: 200
    }
}
