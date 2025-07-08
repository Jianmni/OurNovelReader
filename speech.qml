import QtQuick
import QtQuick.Controls
Item {
    width: 400
    height: 600
    visible: true

    Button{
        text: "导入"
        //直接利用其他组件
    }


    StackView {
        id: stackView
        initialItem: mainPage  // 需要指向一个有效的初始页面
        anchors.fill: parent

    //定义切入动画
        pushEnter: Transition {
                    PropertyAnimation {
                        property: "y"
                        from: stackView.height
                        to: 0
                        duration: 300
                        easing.type: Easing.OutQuad
                    }
                    PropertyAnimation {
                        property: "opacity"
                        from: 0.5
                        to: 1
                        duration: 300
                    }
                }

                // 自定义从上到下的返回动画
                popExit: Transition {
                    PropertyAnimation {
                        property: "y"
                        from: 0
                        to: stackView.height
                        duration: 300
                        easing.type: Easing.InQuad
                    }
                    PropertyAnimation {
                        property: "opacity"
                        from: 1
                        to: 0.5
                        duration: 300
                    }
                }
    }

    // 定义初始页面组件
    Component {
        id: mainPage
        Page {
            Rectangle {
                anchors.fill: parent
                Button {
                    text: "播放"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    onClicked: {
                        stackView.push("speechblock.qml")
                    }
                }
            }
        }
    }

}
