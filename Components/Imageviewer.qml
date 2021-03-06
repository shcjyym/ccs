import QtQuick 2.5
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.2
import "./Model"

Item{
    id:centralView
    //x:bbb.oprightx;
    //y:bbb.oprighty;
    //z:4
    //anchors.fill: parent

    visible: true;
    property string pictureSource;
    property int id: -1
    //Operating{id:bbb;}

    property int order: 0
    property string ip: ""
    property string mac:""
    property int configScale : 0

    signal objectDelete(var object);

    Rectangle{
        anchors.fill: centralView;
        color: "grey";
    }
    Image {
        id: imageViewer;
        parent: centralView
        x:parent.x;
        y:parent.y;
        asynchronous: true;
        source: pictureSource;

        anchors.fill:  centralView
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
        drag.target: centralView;
        acceptedButtons: Qt.LeftButton | Qt.RightButton;
        onClicked: {
            if(mouse.button===Qt.RightButton){
                centralView.objectDelete(centralView);
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
            if(centralView.width+delta.x>50){
            centralView.width+=delta.x;
            }else{
                centralView.width=50;
            }
            if(centralView.height+delta.y>50){
            centralView.height+=delta.y;
            }else{
                centralView.height=50;
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
            if(centralView.width+delta.x>50){
                centralView.width+=delta.x;
            }else{
                centralView.width=50;
            }
            if(centralView.height-delta.y>50){
                centralView.height-=delta.y;
                centralView.y+=delta.y;
            }else{
                centralView.height=50;
                centralView.y+=deltay;
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
            if(centralView.width-delta.x>50){
                centralView.width-=delta.x;
                centralView.x+=delta.x;
            }else{
                centralView.width=50;
                centralView.x+=deltax;
            }
            if(centralView.height+delta.y>50){
                centralView.height+=delta.y;
            }else{
                centralView.height=50;
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
            var deltax= centralView.width-50;
            var deltay= centralView.height-50;
            if(centralView.width-delta.x>50){
                centralView.width-=delta.x;
                centralView.x+=delta.x;
            }else{
                centralView.width=50;
                centralView.x+=deltax;
            }
            if(centralView.height-delta.y>50){
            centralView.height-=delta.y;
            centralView.y+=delta.y;
            }else{
                centralView.height=50;
                centralView.y+=deltay;
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
            var deltax= centralView.width-50;
            if(centralView.width-delta.x>50){
                centralView.width-=delta.x;
                centralView.x+=delta.x;
            }else{
                centralView.width=50;
                centralView.x+=deltax;
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
            if(centralView.width+delta.x>50){
                centralView.width+=delta.x;
            }else{
                centralView.width=50;
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
            var deltay= centralView.height-50;
            if(centralView.height-delta.y>50){
                centralView.height-=delta.y;
                centralView.y+=delta.y;
            }else{
                centralView.height=50;
                centralView.y+=deltay;
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
            if(centralView.height+delta.y>50){
                centralView.height+=delta.y;
            }else{
                centralView.height=50;
            }
        }
    }
}
