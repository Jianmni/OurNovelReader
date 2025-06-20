// WF 2023051604037
// this file builds the UI of read interface
import QtQuick
import QtQuick.Controls

Rectangle {
    id: bookshelf
    anchors.top: parent.top
    anchors.left: parent.left;  anchors.right: parent.right
    color: bg    // bg
    property color bg: "#FAFAFA"

    signal openBook(id: int)
    signal search

    //search
    Rectangle {
        id: search
        height: 40
        anchors.top: parent.top;     anchors.topMargin: 15
        anchors.left: parent.left;   anchors.leftMargin: 20
        anchors.right: parent.right; anchors.rightMargin: 20
        radius: 10
        color: "#EAEAEA"

        Icon {
            id: srchIc
            src: "img/ic_search.png"
            height: 18; width: 14
            x: 11; y:11
            color: "#EAEAEA"
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
    }

    // select
    Rectangle {
        id: select
        anchors.top: search.bottom; anchors.topMargin: 14
        anchors.right: search.right
        color: bg    // bg
        height: 20; width: sltText.width + 24

        Text {
            id: sltText
            text: qsTr("选择")
            anchors.right: parent.right
            font.pixelSize: 15
        }
        Icon {
            src: "img/ic_select.png"
            anchors.right: sltText.left;  anchors.rightMargin: 4
            anchors.verticalCenter: sltText.verticalCenter
            height: 20; width: 20
            color: bg    // bg
        }
    }

    // import
    Rectangle {
        id: imprt
        anchors.top: select.top
        anchors.right: select.left;    anchors.rightMargin: 30
        color: bg    // bg
        height: 20; width: iptText.width + 24

        Text {
            id: iptText
            text: qsTr("导入")
            anchors.right: parent.right
            font.pixelSize: 15
        }
        Icon {
            src: "img/ic_import.png"
            anchors.right: iptText.left;  anchors.rightMargin: 4
            anchors.verticalCenter: iptText.verticalCenter
            height: 20; width: 20
            color: bg    // bg
        }
    }

    // choice bar
    Rectangle {
        id: choices
        anchors.left: search.left;  anchors.leftMargin: 8
        anchors.top: select.bottom; anchors.topMargin: 14
        color: bg
        height: 20; width: history.width + join.width + progress.width

        Text {
            id: history
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            text: qsTr("阅读历史")
            font.pixelSize: 15
            color: "black"

            TapHandler {
                onTapped: {
                    parent.color = "black"
                    choices.doSwitch(0);
                }
            }
        }
        Text {
            id: join
            anchors.bottom: parent.bottom
            anchors.left: history.right; anchors.leftMargin: 15
            text: qsTr("加入时间")
            font.pixelSize: 15
            color: "#5A5A5A"
            TapHandler {
                onTapped: {
                    parent.color = "black"
                    choices.doSwitch(1);
                }
            }
        }
        Text {
            id: progress
            anchors.bottom: parent.bottom
            anchors.left: join.right; anchors.leftMargin: 15
            text: qsTr("进度")
            font.pixelSize: 15
            color: "#5A5A5A"

            TapHandler {
                onTapped: {
                    parent.color = "black"
                    choices.doSwitch(2);
                }
            }
        }

        property int last: 0
        function doSwitch(sender: int) {
            if (sender !== last)
            {
                switch (sender) {
                    case 0: {
                        join.color = "#5A5A5A"; progress.color = "#5A5A5A" ;
                        break;
                    }
                    case 1: {
                        history.color = "#5A5A5A"; progress.color = "#5A5A5A" ;
                        break;
                    }
                    case 2: {
                        join.color = "#5A5A5A"; history.color = "#5A5A5A" ;
                        break;
                    }
                }
                last = sender
            }
        }
    }

    // group
    Rectangle {
        id: group
        anchors.top: choices.top
        anchors.right: parent.right;    anchors.rightMargin: 28
        color: bg
        height: 20

        Icon {
            id: downArrow
            src: "img/ic_downArrow.png"
            height: 8;  width: 23
            anchors.right: parent.right
            anchors.verticalCenter: grp.verticalCenter
            color: bg
        }
        Text {
            id: grp
            text: qsTr("分组")
            anchors.bottom: parent.bottom
            anchors.right: downArrow.left;  anchors.rightMargin: 4
            font.pixelSize: 15
            color: "black"
        }
    }

    // shelf
    GridView {
        id: shelf
        anchors.top: choices.bottom;    anchors.topMargin: 10
        anchors.left: search.left;      anchors.right: search.right
        anchors.bottom: parent.bottom
        clip: true

        cellHeight: 90;    cellWidth: 120
        model: bookModel
        delegate: Column {
            id: settype
            required property int bookId
            required property string bkname
            Image {
                id: cover
                source: "img/0.jpg"
                height: 140     // 3:4

                property string bkImg
                bkImg: "books/" + bookId + "/0.jpg"
            }
            Rectangle {
                height: 6
                gradient: Gradient {
                    GradientStop {position: 0; color: "#1E1E1E"}
                    GradientStop {position: 1; color: "#E0E0E0"}
                }
                opacity: 0.2
            }
            Text {
                text: bkname
                font.pixelSize: 16
                color: "#636363"
            }
            TapHandler {
                onTapped: bookshelf.openBook(bookId)
            }
        }
        property real itemWidth: (parent.width - 40) / 3
        property real itemHeight: itemWidth / 3 * 4
    }
    ListModel {
        id: bookModel
    }

    // test
    Component.onCompleted:  {
        bookModel.append({"bookId":1, "bkname":"笔记簿"})
    }
}
