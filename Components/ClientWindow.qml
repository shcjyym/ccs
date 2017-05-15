import QtQuick 2.5
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.2
import "./Model"

ApplicationWindow {
    id:clientWindow;
    visible: true;
    width: 1280;
    height: 800;
    x: (Screen.width - width) / 2;
    y: (Screen.height - height) / 2;
    flags: Qt.FramelessWindowHint| Qt.WindowSystemMenuHint| Qt.WindowMinimizeButtonHint| Qt.Window;//窗体无边框处理


    Rectangle{
        id:menuline;
        width: parent.width;
        height: 1;
        color: "steelblue";
        anchors.top:parent.top;
        anchors.topMargin: 48;
        anchors.left: parent.left;
        opacity: 0.3;
        z:4;
    }

    Rectangle{
        id:version;
        height:25;
        width: parent.width;
        color: "steelblue";
        anchors.bottom: parent.bottom;
        anchors.left: parent.left;
        opacity: 0.4;
        z:4;
    }
    Text{
        id:versiontext;
        text:"版本信息v1.0.0";
        anchors.centerIn: version;
        font.pixelSize: 15;
        color: "grey";
        z:4;
    }

    Image{                                 //background picture
        id:background1;
        z:1;
        anchors.fill:parent;
        source:"pictures/background2.png";
    }
    readonly property int normalShow : 1;
    readonly property int fullShow : 2;
    readonly property int maxShow : 3;
    readonly property int minShow : 4;
    property int showState: 0;
    Image {                                 //minimize button
        id: minimizeButton;
        anchors.verticalCenter: maximizeButton.verticalCenter;
        anchors.right: maximizeButton.left;
        anchors.rightMargin: 5;
        z:4;
        source: "pictures/Minimize.png";
        MouseArea{
            anchors.fill: minimizeButton;
            hoverEnabled: true;

            onClicked: {
                clientWindow.showMinimized();
                clientWindow.showState = 4;
            }
            onEntered: {
                minimizeButton.source = "pictures/MinimizeHover.png";
            }
            onExited: {
                minimizeButton.source = "pictures/Minimize.png";
            }
        }
    }
    Image {                                 //maximize button
        id: maximizeButton;
        anchors.verticalCenter: closeButton.verticalCenter;
        anchors.right: closeButton.left;
        anchors.rightMargin: 5;
        z:4;
        source: "pictures/Maximize.png";
        MouseArea{
            anchors.fill: maximizeButton;
            hoverEnabled: true;
            property int maximizecount: 0;
            onClicked: {
                if(maximizecount===0){
                    maximizecount=1;
                    maximizeButton.source="pictures/Restore.png";
                }else{
                    maximizecount=0;
                    maximizeButton.source="pictures/Maximize.png";
                }
                if(clientWindow.showState !== 2) {
                    clientWindow.showMaximized();
                    clientWindow.showState = 2;
                } else {
                    clientWindow.showNormal();
                    clientWindow.showState = 1;
                }
            }
            onEntered: {
                if(maximizecount===0){
                    maximizeButton.source="pictures/MaximizeHover.png";
                }else{
                    maximizeButton.source="pictures/RestoreHover.png";
                }
            }
            onExited: {
                if(maximizecount===0){
                    maximizeButton.source="pictures/Maximize.png";
                }else{
                    maximizeButton.source="pictures/Restore.png";
                }
            }
        }
    }
    Image {                                 //close button
        id: closeButton;
        anchors.right:parent.right;
        anchors.rightMargin: 5;
        anchors.top:parent.top;
        anchors.topMargin: 5;
        z:4;
        source: "pictures/Close.png";
        MouseArea{
            anchors.fill: closeButton;
            hoverEnabled: true;
            onClicked: { clientWindow.close(); }
            onEntered: {
                closeButton.source = "pictures/CloseHover.png";
            }
            onExited: {
                closeButton.source = "pictures/Close.png";
            }
        }
    }

    Rectangle{
        id: toolbarWindow;
        width: clientWindow.width;
        height: 50;
        opacity: 0;
        z:3;

        MouseArea {
            // Moving Area,MouseArea :50(height)*Application's width
            anchors.fill: parent;
            property variant previousPosition;
            onPressed: {
                previousPosition = Qt.point(mouseX, mouseY);
            }
            onPositionChanged: {
                if (pressedButtons == Qt.LeftButton) {
                    var dx = mouseX - previousPosition.x;
                    var dy = mouseY - previousPosition.y;
                    clientWindow.x = clientWindow.x + dx;
                    clientWindow.y = clientWindow.y + dy;
                }
            }

        }
    }

}
