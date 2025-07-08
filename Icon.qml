// WF 2023051604037
// this file is a component of BookModel.qml
// used to conveniently build icon
// 图标，可调用来便捷地展示图标
import QtQuick

Rectangle {
    required property string src
    property real bounce: 1.05
    signal clicked

    Image {
        id: listenImg
        source: src
        anchors.fill: parent
        fillMode: Image.PreserveAspectFit
    }
    Rectangle {
        id: mask
        anchors.fill: parent
        color: "black"
        opacity: 0
    }

    TapHandler {
        onTapped: {
            clickAnimation.start()
            clicked()
        }
    }

    SequentialAnimation {
        id: clickAnimation
        ParallelAnimation {
            PropertyAnimation {
                target: mask
                property: "opacity"
                to: 0.4
                duration: 150
            }
            PropertyAnimation {
                target: parent
                property: "scale"
                to: bounce
                duration: 150
            }
        }
        ParallelAnimation {
            PropertyAnimation {
                target: mask
                property: "opacity"
                to: 0
                duration: 350
            }
            PropertyAnimation {
                target: parent
                property: "scale"
                to: 1
                duration: 350
            }
        }
    }
}
