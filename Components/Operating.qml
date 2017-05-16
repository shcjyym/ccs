import QtQuick 2.5
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.2
import "./Model"

Item {
    id:operating;
    visible: false;
    anchors.fill: parent;
    z:4;

    Rectangle{
        id:operating_left;
        width: 250;
        height: operating.height-79;
        color: "lightgrey";
        anchors.top: operating.top;
        anchors.topMargin: 52;
        anchors.left: operating.left;
        opacity: 0.3;
    }

    Rectangle{
        id:operating_right;
        width: operating.width-operating_left.width-40;
        height: operating_left.height-80;
        color: "lightgrey";
        anchors.top: operating_left.top;
        anchors.topMargin: 70;
        anchors.left: operating_left.right;
        anchors.leftMargin: 20;
        opacity: 0.3;
    }

    Rectangle{
        id:signallist;
        height: 30;
        width: operating_left.width;
        anchors.top:operating_left.top;
        anchors.left: operating_left.left;
        color: "steelblue";
        opacity: 0.5;
    }
    TextNew {
        id: signallist_text
        text: "信号列表";
        font.pixelSize: 20;
        font.bold: false;
        anchors.centerIn: signallist;
    }
    Search{
        id:signal_search;
        anchors.top:signallist.bottom;
        anchors.left: signallist.left;
        anchors.topMargin: 15;
        anchors.leftMargin: 5;
    }
//分割线
    Rectangle{
        id:twoxtwov;
        height: 1;
        width: operating_right.width;
        color:"white";
        opacity: 0.4;
        anchors.left: operating_right.left;
        anchors.top: operating_right.verticalCenter;
        z:5
    }
    Rectangle{
        id:twoxtwoh;
        height: operating_right.height;
        width: 1;
        color:"white";
        opacity: 0.4;
        anchors.top: operating_right.top;
        anchors.left: operating_right.horizontalCenter;
        z:5
    }
//控制条形窗
    Rectangle{
        id:operating_control;
        width: operating_right.width;
        height: 30;
        color: "steelblue";
        anchors.bottom: operating_right.top;
        anchors.left: operating_right.left;

        ComboBoxNew{
            id:size;
            height: operating_control.height;
            width: 50;
            anchors.left: operating_control.left;
            anchors.verticalCenter: operating_control.verticalCenter;
            model:["10%","20%","40%","50%","60%","70%","80%","90%","1倍","2倍"];
        }
        TextNew{
            id:setting;
            text: "设置";
            font.bold: false;
            anchors.left: size.right;
            anchors.leftMargin: 40;
            anchors.verticalCenter: operating_control.verticalCenter;
        }
        TextNew{
            id:close;
            text: "关闭";
            font.bold: false;
            anchors.left: setting.right;
            anchors.leftMargin: 20;
            anchors.verticalCenter: operating_control.verticalCenter;
        }
        ComboBoxNew{
            id:window;
            height: operating_control.height;
            width: 50;
            anchors.horizontalCenter: operating_control.horizontalCenter;
            anchors.verticalCenter: operating_control.verticalCenter;
            model:["main","1","2"];
        }
        ComboBoxNew{
            id:stage;
            height: operating_control.height;
            width: 150;
            anchors.right: operating_control.right;
            anchors.rightMargin: 20;
            anchors.verticalCenter: operating_control.verticalCenter;
            model:["场景一","场景二","场景三"];
        }
    }
//Listview
    ListView{
        id:operating_listview;
        width: 250;
        anchors.top: signal_search.bottom;
        anchors.topMargin: 10;
        anchors.left: operating_left.left;
        anchors.bottom: parent.bottom;
        anchors.bottomMargin: 25;
        delegate: operating_delegate;
        model: operating_model.createObject(operating_listview);
        focus: true;
        highlight: Rectangle{
                opacity:0.5;
                color: "grey";
            }

    }
//inDelegate
    Component{
        id:operating_delegate;
        Item{
            id: wrapper;
            width: parent.width;
            height: 33;
            MouseArea{
                anchors.fill: parent;
                onClicked: {
                    wrapper.ListView.view.currentIndex=index;//获取当前选中的index
                    mouse.accepted=true;
                    if(index===0){imageViewer.source= ""}
                    if(index===1){imageViewer.source= "./pictures/background1.jpg"}
                    if(index===2){imageViewer.source= ""}
                }
            }

            RowLayout{
                anchors.verticalCenter: parent.verticalCenter;
                anchors.left: parent.left;
                anchors.leftMargin: 15;
                TextNew{
                    id: roll;
                    text: name;
                    font.bold: false;
                    Layout.preferredWidth: 120;
                }
            }
        }
    }
//inModel
    Component{
            id:operating_model;
            ListModel{
                ListElement{
                    name:"picture1";
                }
                ListElement{
                    name:"picture2";
                }
                ListElement{
                    name:"picture3";
                }
            }
    }

//存储照片的中心框，包含拉伸，拖动，缩放
    Item{
        id:centralView;
        x:operating_right.x;
        y:operating_right.y;
        height: 500;
        width: 500;
        z:4
        property var current: null;
        Image {
            id: imageViewer;
            anchors.fill:parent;
            asynchronous: true;
            z:4;
        }
        Drag.active: dragArea.drag.active
        MouseArea {
            id: dragArea
            height: centralView.height*4/5;
            width: centralView.width*4/5;
            anchors.centerIn : parent;
            drag.target: parent
        }
//**图片拉伸**
        //右下角拉伸
        MouseArea{
            id:change_rb;
            height: centralView.height/5;
            width: centralView.width/5;
            anchors.right: centralView.right;
            anchors.bottom: centralView.bottom;
            property point clickPos: "0,0";
            onPressed: {clickPos=Qt.point(mouse.x,mouse.y);}
            onReleased : {
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
            height: centralView.height/5;
            width: centralView.width/5;
            anchors.right: centralView.right;
            anchors.top: centralView.top;
            property point clickPos: "0,0";
            onPressed: {clickPos=Qt.point(mouse.x,mouse.y);}
            onReleased : {
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
            height: centralView.height/5;
            width: centralView.width/5;
            anchors.left: centralView.left;
            anchors.bottom: centralView.bottom;
            property point clickPos: "0,0";
            onPressed: {clickPos=Qt.point(mouse.x,mouse.y);}
            onReleased : {
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
            height: centralView.height/5;
            width: centralView.width/5;
            anchors.left: centralView.left;
            anchors.top: centralView.top;
            property point clickPos: "0,0";
            onPressed: {clickPos=Qt.point(mouse.x,mouse.y);}
            onReleased : {
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
            height: centralView.height*3/5;
            width: centralView.width/5;
            anchors.left: centralView.left;
            anchors.top: centralView.top;
            anchors.topMargin: centralView.height/5
            property point clickPos: "0,0";
            onPressed: {clickPos=Qt.point(mouse.x,mouse.y);}
            onReleased : {
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
            height: centralView.height*3/5;
            width: centralView.width/5;
            anchors.right: centralView.right;
            anchors.top: centralView.top;
            anchors.topMargin: centralView.height/5
            property point clickPos: "0,0";
            onPressed: {clickPos=Qt.point(mouse.x,mouse.y);}
            onReleased : {
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
            height: centralView.height/5;
            width: centralView.width*3/5;
            anchors.left: centralView.left;
            anchors.top: centralView.top;
            anchors.leftMargin: centralView.height/5
            property point clickPos: "0,0";
            onPressed: {clickPos=Qt.point(mouse.x,mouse.y);}
            onReleased : {
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
            height: centralView.height/5;
            width: centralView.width*3/5;
            anchors.left: centralView.left;
            anchors.bottom: centralView.bottom;
            anchors.leftMargin: centralView.height/5
            property point clickPos: "0,0";
            onPressed: {clickPos=Qt.point(mouse.x,mouse.y);}
            onReleased : {
                var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y);
                if(centralView.height+delta.y>50){
                    centralView.height+=delta.y;
                }else{
                    centralView.height=50;
                }
            }
        }
    }



}
