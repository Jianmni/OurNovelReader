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
