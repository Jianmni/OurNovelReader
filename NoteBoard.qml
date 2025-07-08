// WF 2023051604037
// 2025-7-7 - 2025-7-8
import QtQuick

Rectangle {
    id: notebd
    anchors.left: parent.left;  anchors.right: parent.right
    height: parent.height - 50
    y: yPos
    property int yPos: parent.height
    property color bg: "#FAFAFA"

    Text {
        anchors.top: parent.top;    anchors.topMargin: 50
        anchors.horizontalCenter: parent.horizontalCenter
        text: qsTr("暂无笔记")
    }


    function show()
    {
        showAnimation.start()
    }
    function hide()
    {
        hideAnimation.start()
    }

    PropertyAnimation {
        id: showAnimation
        target: notebd
        property: "y"
        from: yPos
        to: 0
        duration: 200
    }

    PropertyAnimation {
        id: hideAnimation
        target: notebd
        properties: "y"
        from: 0
        to: yPos
        duration: 200
    }
}
