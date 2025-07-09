// WF 2023051604037
// 2025-7-7 - 2025-7-8
import QtQuick
import QtQuick.Controls

Rectangle {
    id: fontbd
    height: bdHeight
    anchors.left: parent.left;      anchors.right: parent.right
    y: yPos
    z: 2
    color: bg

    property int bdHeight: parent.height / 3
    property int yPos: parent.height
    property color bg: "#FAFAFA"

    property int fontsize: 16
    signal changeFontSize(size: int)
    Slider {
        id: fontSize
        anchors.left: leftA.right;  anchors.leftMargin: 10
        anchors.right: rightA.left; anchors.rightMargin: 10
        anchors.verticalCenter: rightA.verticalCenter
        from: 10
        value: fontsize
        to: 24

        onMoved: {
            console.log("New font size: ", value)
            changeFontSize(value)
        }
    }
    Text {
        id: leftA
        anchors.left: parent.left;  anchors.leftMargin: 20
        anchors.verticalCenter: rightA.verticalCenter
        text: qsTr("A")
        font.pixelSize: 10
    }
    Text {
        id: rightA
        anchors.right: parent.right;anchors.rightMargin: 20
        anchors.top: parent.top;    anchors.topMargin: 10
        text: qsTr("A")
        font.pixelSize: 18
    }


    function show(){
        showAnimation.start()
    }
    PropertyAnimation {
        id: showAnimation
        target: fontbd
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
        target: fontbd
        property: "y"
        from: yPos - bdHeight
        to: yPos
        duration: 200
    }
}
