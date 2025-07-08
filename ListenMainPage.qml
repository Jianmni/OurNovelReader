// WF 2023051604037
// 2025-7-7 - 2025-7-8
import QtQuick

Rectangle {
    id: user
    anchors.fill: parent
    color: bg
    property color bg: "#FAFAFA"

    signal turnToPage(target: int)

    Text {
        id: warn
        text: qsTr("功能暂未实现")
        anchors.centerIn: parent
        font.pixelSize: 24
    }

    Navigator {
        id: navi
        page: 1
        onNavigate: (target) => {
            if(target !== 1) turnToPage(target)
        }
    }
}
