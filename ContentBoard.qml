import QtQuick
import QtQuick.Shapes

Rectangle {
    id: cttbd
    anchors.left: parent.left;  anchors.right: parent.right
    height: parent.height - 50
    y: yPos
    property int yPos: parent.height
    property color bg: "#FAFAFA"


    property var contentList: []
    signal goToChapter(cptId: int)
    ListView {
        id: ctt
        anchors.top: tip.bottom;    anchors.topMargin: 20
        anchors.left: parent.left;  anchors.right: parent.right
        anchors.bottom: parent.bottom
        clip: true

        model: cttModel
        delegate: Rectangle {
            required property string cptName
            width: ctt.width
            height: 40
            color: bg
            Text {
                anchors.left: parent.left;  anchors.leftMargin: 20
                anchors.verticalCenter: parent.verticalCenter
                text: parent.cptName
            }
            TapHandler {
                onTapped: {
                    console.log(parent.index)
                    goToChapter(parent.index + 1)
                }
            }
            Shape {
                width: parent.width - 40
                height: 4
                anchors.top: parent.top
                anchors.verticalCenter: parent.verticalCenter
                ShapePath {
                    strokeWidth: 1
                    strokeColor: "#9B9B9B"
                    startX: 0; startY: 0
                    PathLine {
                        x: parent.parent.width
                        y: 0
                    }
                }
            }
        }
    }

    ListModel {
        id: cttModel
    }
    Component.onCompleted: {
        for(var i=0; i<contentList.length; ++i)
            cttModel.append({"cptName" : contentList[i]})
    }

    Rectangle {
        id: tip
        anchors.top: parent.top;        anchors.topMargin: 100
        anchors.horizontalCenter: parent.horizontalCenter
        radius: 10
        Text {
            anchors.centerIn: parent
            text: qsTr("目录")
            font.pixelSize: 14
        }
    }

    property bool atBottom: false
    Text {
        id: navi
        text: (atBottom === false) ? qsTr("↓去底部") :qsTr("↑去顶部")
        anchors.right: parent.right;    anchors.rightMargin: 20
        anchors.verticalCenter: tip.verticalCenter
        font.pixelSize: 14
        TapHandler {
            onTapped: {
                if(atBottom) {
                    atBottom = false
                    content.positionViewAtBeginning()
                }
                else {
                    atBottom = true
                    content.positionViewAtEnd()
                }
            }
        }
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
        target: cttbd
        property: "y"
        from: yPos
        to: 0
        duration: 200
    }

    PropertyAnimation {
        id: hideAnimation
        target: cttbd
        properties: "y"
        from: 0
        to: yPos
        duration: 200
    }
}
