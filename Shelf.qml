// WF 2023051604037
// this file builds the UI of read interface
import QtQuick
import QtQuick.Controls
import NovelReader

Rectangle {
    id: bookshelf
    anchors.left: parent.left;  anchors.right: parent.right
    color: bg    // bg
    property color bg: "#FAFAFA"

    states: [
        State {
            name: "history"
        },
        State {
            name: "joinTime"
        },
        State {
            name: "progress"
        }
    ]

    signal openBook(bkId: int)
    signal importBooks
    signal selectBooks
    signal bookOrderChanged(type: int)

    // shelf
    GridView {
        id: shelf
        anchors.top: choices.bottom;    anchors.topMargin: 10
        anchors.left: parent.left;   anchors.leftMargin: 20
        anchors.right: parent.right; anchors.rightMargin: 20
        anchors.bottom: parent.bottom
        clip: true

        cellHeight: itemHeight;    cellWidth: itemWidth
        model: bookModel
        delegate: Rectangle {
            id: settype
            height: shelf.itemHeight; width: shelf.itemWidth
            color: bg

            required property int bookId
            required property string bkname
            Icon {
                id: cover
                anchors.top: parent.top
                width: parent.width - 5*2
                height: width / 3 * 4
                src: "img/0.jpg"
                bounce: 1.01
                onClicked: {
                    bookshelf.openBook(bookId)
                }
            }

            Rectangle {
                height: 6
                anchors.top: cover.bottom
                anchors.right: cover.right;    anchors.left: cover.left
                gradient: Gradient {
                    GradientStop {position: 0; color: "#1E1E1E"}
                    GradientStop {position: 1; color: "#E0E0E0"}
                }
                opacity: 0.2
            }

            Text {
                id: bookname
                anchors.bottom: parent.bottom
                anchors.right: cover.right;    anchors.left: cover.left
                text: settype.bkname
                font.pixelSize: 14
                elide: Text.ElideRight
                color: "#636363"
            }
        }
        property int itemWidth: shelf.width / 3
        property int itemHeight: itemWidth / 3 * 4 + 20
    }

    ListModel {
        id: bookModel
    }
    // select
    Rectangle {
        id: select
        anchors.top: parent.top; anchors.topMargin: 14
        anchors.right: parent.right; anchors.rightMargin: 20
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
            id: icon
            src: "img/ic_import.png"
            anchors.right: iptText.left;  anchors.rightMargin: 4
            anchors.verticalCenter: iptText.verticalCenter
            height: 20; width: 20
            color: bg    // bg
        }

        TapHandler {
            onTapped: bookshelf.importBooks()
        }
    }

    // choice bar
    Rectangle {
        id: choices
        anchors.left: parent.left;   anchors.leftMargin: 20
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
        anchors.right: parent.right;    anchors.rightMargin: 15
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


    // init
    function initShelf() {
        // bookModel.append({"bookId":1, "bkname":"笔记簿"})
        bookModel.clear()
        bookHome.load()
        var data = bookHome.getReadOrder()
        addBookToShelf(data)
    }

    Component.onCompleted: initShelf()

    function updateShelf() {    // after books' add or delete operation finished
        console.log("Update bookshelf")
        if (state === "history")
            initShelf();
    }

    function addBookToShelf(data: var) {
        for (var i=0; i < data.length; ++i)
        {
            var bkname, bookId;     // 1,笔记簿,2,BookName
            bookId = Number(data[i])
            i += 1;
            bkname = String(data[i])
            // console.log("字符串:", bkname, "id:", bookId)
            bookModel.append({"bookId" : bookId, "bkname" : bkname })
        }
    }

    BookListManager {
        id: bookHome
    }
}

/*
    property string bkImg
    bkImg: appPath + "/books/" + bookId + "/0.jpg"
    Icon {
        anchors.fill: parent
        src: Qt.url("file:///" + cover.bkImg)
        bounce: 1.01
    }
*/
