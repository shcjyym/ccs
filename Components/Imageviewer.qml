import QtQuick 2.5
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.2
import "./Model"

Item{
    id:centralView
    x:bbb.oprightx;
    y:bbb.oprighty;
    z:4;

    visible: true;
    property string pictureSource;
    Operating{id:bbb;}


    Rectangle{
        anchors.fill: parent;
        color: "grey";
    }
    Image {
        id: imageViewer;
        x:parent.x;
        y:parent.y;
        asynchronous: true;
        source: pictureSource;
        z:4;
    }
    //Drag.active: centraldragArea.drag.active
    MouseArea {
        id: centraldragArea
        cursorShape: pressed?Qt.ClosedHandCursor:Qt.OpenHandCursor;
        height: imageViewer.height*6/7;
        width: imageViewer.width*6/7;
        anchors.right: imageViewer.right;
        anchors.rightMargin: imageViewer.width/14;
        anchors.bottom: imageViewer.bottom;
        anchors.bottomMargin: imageViewer.height/14
        drag.target: imageViewer;
        acceptedButtons: Qt.LeftButton | Qt.RightButton;
        onClicked: {
            if(mouse.button===Qt.RightButton){
                centralView.destroy();
            }
        }
        onDoubleClicked: {
            centralView.x=operating_right.x;
            centralView.y=operating_right.y;
            centralView.height=operating_right.height;
            centralView.width=operating_right.width;
        }
    }
//**图片拉伸**
    //右下角拉伸
    MouseArea{
        id:change_rb;
        height: imageViewer.height/14;
        width: imageViewer.width/14;
        anchors.right: imageViewer.right;
        anchors.bottom: imageViewer.bottom;
        property point clickPos: "0,0";
        cursorShape: Qt.SizeFDiagCursor;
        onPressed: {clickPos=Qt.point(mouse.x,mouse.y);}
        onPositionChanged : {
            var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y);
            if(imageViewer.width+delta.x>50){
            imageViewer.width+=delta.x;
            }else{
                imageViewer.width=50;
            }
            if(imageViewer.height+delta.y>50){
            imageViewer.height+=delta.y;
            }else{
                imageViewer.height=50;
            }
        }
    }
    //右上角拉伸
    MouseArea{
        id:change_rt;
        height: imageViewer.height/14;
        width: imageViewer.width/14;
        anchors.right: imageViewer.right;
        anchors.top: imageViewer.top;
        property point clickPos: "0,0";
        cursorShape: Qt.SizeBDiagCursor;
        onPressed: {clickPos=Qt.point(mouse.x,mouse.y);}
        onPositionChanged : {
            var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y);
            var deltay= centralView.height-50;
            if(imageViewer.width+delta.x>50){
                imageViewer.width+=delta.x;
            }else{
                imageViewer.width=50;
            }
            if(imageViewer.height-delta.y>50){
                imageViewer.height-=delta.y;
                imageViewer.y+=delta.y;
            }else{
                imageViewer.height=50;
                imageViewer.y+=deltay;
            }
        }
    }
    //左下角拉伸
    MouseArea{
        id:change_lb;
        height: imageViewer.height/14;
        width: imageViewer.width/14;
        anchors.left: imageViewer.left;
        anchors.bottom: imageViewer.bottom;
        property point clickPos: "0,0";
        cursorShape: Qt.SizeBDiagCursor;
        onPressed: {clickPos=Qt.point(mouse.x,mouse.y);}
        onPositionChanged : {
            var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y);
            var deltax= centralView.width-50;
            if(imageViewer.width-delta.x>50){
                imageViewer.width-=delta.x;
                imageViewer.x+=delta.x;
            }else{
                imageViewer.width=50;
                imageViewer.x+=deltax;
            }
            if(imageViewer.height+delta.y>50){
                imageViewer.height+=delta.y;
            }else{
                imageViewer.height=50;
            }
        }
    }
    //左上角拉伸
    MouseArea{
        id:change_lt;
        height: imageViewer.height/14;
        width: imageViewer.width/14;
        anchors.left: imageViewer.left;
        anchors.top: imageViewer.top;
        property point clickPos: "0,0";
        cursorShape: Qt.SizeFDiagCursor;
        onPressed: {clickPos=Qt.point(mouse.x,mouse.y);}
        onPositionChanged : {
            var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y);
            var deltax= imageViewer.width-50;
            var deltay= imageViewer.height-50;
            if(imageViewer.width-delta.x>50){
                imageViewer.width-=delta.x;
                imageViewer.x+=delta.x;
            }else{
                imageViewer.width=50;
                imageViewer.x+=deltax;
            }
            if(imageViewer.height-delta.y>50){
            imageViewer.height-=delta.y;
            imageViewer.y+=delta.y;
            }else{
                imageViewer.height=50;
                imageViewer.y+=deltay;
            }
        }
    }
    //左边拉伸
    MouseArea{
        id:change_l;
        height: imageViewer.height*6/7;
        width: imageViewer.width/14;
        anchors.left: imageViewer.left;
        anchors.top: imageViewer.top;
        anchors.topMargin: imageViewer.height/14
        property point clickPos: "0,0";
        cursorShape: Qt.SizeHorCursor;
        onPressed: {clickPos=Qt.point(mouse.x,mouse.y);}
        onPositionChanged : {
            var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y);
            var deltax= imageViewer.width-50;
            if(imageViewer.width-delta.x>50){
                imageViewer.width-=delta.x;
                imageViewer.x+=delta.x;
            }else{
                imageViewer.width=50;
                imageViewer.x+=deltax;
            }
        }
    }
    //右边拉伸
    MouseArea{
        id:change_r;
        height: imageViewer.height*6/7;
        width: imageViewer.width/14;
        anchors.right: imageViewer.right;
        anchors.top: imageViewer.top;
        anchors.topMargin: imageViewer.height/14
        property point clickPos: "0,0";
        cursorShape: Qt.SizeHorCursor;
        onPressed: {clickPos=Qt.point(mouse.x,mouse.y);}
        onPositionChanged : {
            var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y);
            if(imageViewer.width+delta.x>50){
                imageViewer.width+=delta.x;
            }else{
                imageViewer.width=50;
            }
        }
    }
    //上边拉伸
    MouseArea{
        id:change_t;
        height: imageViewer.height/14;
        width: imageViewer.width*6/7;
        anchors.left: imageViewer.left;
        anchors.top: imageViewer.top;
        anchors.leftMargin: imageViewer.height/14
        property point clickPos: "0,0";
        cursorShape: Qt.SizeVerCursor;
        onPressed: {clickPos=Qt.point(mouse.x,mouse.y);}
        onPositionChanged : {
            var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y);
            var deltay= imageViewer.height-50;
            if(imageViewer.height-delta.y>50){
                imageViewer.height-=delta.y;
                imageViewer.y+=delta.y;
            }else{
                imageViewer.height=50;
                imageViewer.y+=deltay;
            }
        }
    }
    //下边拉伸
    MouseArea{
        id:change_b;
        height: imageViewer.height/14;
        width: imageViewer.width*6/7;
        anchors.left: imageViewer.left;
        anchors.bottom: imageViewer.bottom;
        anchors.leftMargin: imageViewer.height/14
        property point clickPos: "0,0";
        cursorShape: Qt.SizeVerCursor;
        onPressed: {clickPos=Qt.point(mouse.x,mouse.y);}
        onPositionChanged : {
            var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y);
            if(imageViewer.height+delta.y>50){
                imageViewer.height+=delta.y;
            }else{
                imageViewer.height=50;
            }
        }
    }
}
