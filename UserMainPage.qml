// WF 2023051604037
// 2025-7-7 - 2025-7-8
import QtQuick

Rectangle {
    id: user
    anchors.fill: parent
    color: bg
    property color bg: "#FAFAFA"

    signal turnToPage(target: int)
    User {
        id: info
        anchors.bottom: Navigator.top
    }

    Navigator {
        id: navi
        page: 3
        onNavigate: (target) => {
            if(target !== 3) turnToPage(target)
        }
    }
}
