// WF 2023051604037
// 2025-7-7 - 2025-7-8
import QtQuick
import QtQuick.Controls

Rectangle {
    id: brightbd
    height: bdHeight
    anchors.left: parent.left;      anchors.right: parent.right
    y: yPos
    color: bg

    property int bdHeight: parent.height / 3
    property int yPos: parent.height
    property color bg: "#FAFAFA"

    Slider {
        id: brightnessSlider
        anchors.top: parent.top;    anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        from: 0
        to: 1.0
        value: 1
        onValueChanged: {
            QtAndroid.callStaticMethod("com/example/BrightnessControl",
                                      "setWindowBrightness",
                                      [QtAndroid.activity, value]);
        }
    }

    function show(){
        showAnimation.start()
    }
    PropertyAnimation {
        id: showAnimation
        target: brightbd
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
        target: brightbd
        property: "y"
        from: yPos - bdHeight
        to: yPos
        duration: 200
    }
}
