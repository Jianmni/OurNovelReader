// WF 2023051604037
// this file is a component of BookModel.qml
// used to conveniently build icon
import QtQuick

Rectangle {
    required property string src
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
        PropertyAnimation {
            target: mask
            property: "opacity"
            to: 0.4
            duration: 150
        }
        PropertyAnimation {
            target: mask
            property: "opacity"
            to: 0
            duration: 350
        }
    }
}
