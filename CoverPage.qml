import QtQuick
import QtQuick.Shapes

// cover
Rectangle {
    y:0;    x:0
    z: 3
    anchors.fill: parent
    color: bg
    property color bg: "#FAFAFA"

    property string bkname: "无名书"
    property string auname: "佚名"

    Rectangle{
        id: wrap
        anchors.top: parent.top;        anchors.topMargin: 60
        anchors.horizontalCenter: parent.horizontalCenter
        height: 146;    width: 111
        color: "lightgray"
        Rectangle {
            anchors.centerIn: parent
            height: 144;    width: 109
            color: bg
            Rectangle {
                anchors.centerIn: parent
                height: 140;    width: 105
                Image {
                    anchors.fill: parent
                    source: "img/0.png"
                }
            }
        }
    }

    Text {
        id: name
        anchors.top: wrap.bottom;       anchors.topMargin: 30
        anchors.horizontalCenter: parent.horizontalCenter
        text: bkname
        font.pixelSize: 20
    }

    Rectangle {
        id: author
        anchors.top: name.bottom;       anchors.topMargin: 40
        anchors.horizontalCenter: parent.horizontalCenter
        width: 300; height: 100
        color: bg
        Text {
            id: auTxt
            anchors.top: parent.top;    anchors.topMargin: 15
            anchors.horizontalCenter: parent.horizontalCenter
            text: auname
            font.pixelSize: 14
            color: "#9B9B9B"
        }

        Shape {
            id: sep
            anchors.top: auTxt.bottom;    anchors.bottomMargin: 5
            anchors.horizontalCenter: auTxt.horizontalCenter
            height: 5;  width: 200
            ShapePath {
                strokeColor: "#9B9B9B"
                strokeWidth: 1
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap

                property int joinStyleIndex: 0

                property variant styles: [
                    ShapePath.BevelJoin,
                    ShapePath.MiterJoin,
                    ShapePath.RoundJoin
                ]

                joinStyle: styles[joinStyleIndex]

                startX: 0
                startY: 3
                PathLine { x: 200; y: 3 }
            }
        }

        Rectangle {
            anchors.top: sep.bottom;        anchors.topMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
            color: bg
            height: 30
            Text {
                id: aunm
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("佚名")
                font.pixelSize: 18
            }

            // docrate
            Image {// left
                height: 21; width: 21
                source: "img/ic_drtNameLeft.png"
                fillMode: Image.PreserveAspectFit
                anchors.verticalCenter: aunm.verticalCenter
                anchors.right: aunm.left;    anchors.rightMargin: 20
            }
            Image {
                height: 21; width: 21
                source: "img/ic_drtNameRight.png"
                fillMode: Image.PreserveAspectFit
                anchors.verticalCenter: aunm.verticalCenter
                anchors.left: aunm.right;    anchors.leftMargin: 20
            }
        }
    }

    Rectangle {
        id: tip
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom;      anchors.bottomMargin: 100
        height: 21;     width: 200
        color: bg

        Text {
            id: tipTxt
            anchors.centerIn: parent
            text: "点击屏幕右侧开始阅读"
            font.pixelSize: 14
            color: "#7C7C7C"
        }

        Image {
            height: 21; width: 21
            source: "img/ic_tip.png"
            fillMode: Image.PreserveAspectFit
            anchors.verticalCenter: tipTxt.verticalCenter
            anchors.left: tipTxt.right;    anchors.leftMargin: 20
        }
        Image {
            height: 21; width: 21
            source: "img/ic_tip.png"
            fillMode: Image.PreserveAspectFit
            anchors.verticalCenter: tipTxt.verticalCenter
            anchors.right: tipTxt.left;    anchors.rightMargin: 20
        }
    }

    function show() {
        coverGoRight.start()
    }
    function hide() {
        coverGoLeft.start()
    }

    PropertyAnimation {
        id:coverGoLeft
        target: cover
        property: "z"
        to: -1
        duration: 100
    }
    PropertyAnimation {
        id: coverGoRight
        target: cover
        property: "z"
        to: 3
        duration: 100
    }

    signal nextPage
    TapHandler{
        enabled: parent.z > -1
        onTapped: eventPoint => {
            var x = eventPoint.position.x
            if(x > parent.width/3*2)
            {
                nextPage()
            }
        }
    }
}
