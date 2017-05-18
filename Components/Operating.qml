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
//左侧动画效果预置
    NumberAnimation {
        id:change_opacity_in;
        target: operating_left;
        property: "opacity";
        from: 0.3
        to: 0;
        duration: 1000;
        running: false;
    }
    NumberAnimation {
        id:change_opacity_in1;
        targets: [signal_search,operating_listview,signallist,signallist_text];
        property: "opacity";
        from: 1;
        to: 0;
        duration: 1500;
        running: false;
    }
    NumberAnimation {
        id:change_opacity_out;
        target: operating_left;
        property: "opacity";
        from: 0
        to: 0.3;
        duration: 1000;
        running: false;
    }
    NumberAnimation {
        id:change_opacity_out1;
        targets: [signal_search,operating_listview,signallist,signallist_text];
        property: "opacity";
        from: 0
        to: 1;
        duration: 1500;
        running: false;
    }
    NumberAnimation {
        id:change_width_in;
        targets: [operating_left,operating_listview];
        property: "width";
        from: 250
        to: 0;
        duration: 1000;
        running: false;
    }
    NumberAnimation {
        id:change_width_in1;
        targets: signal_search;
        property: "width";
        from: 200;
        to: 0;
        duration: 1000;
        running: false;
    }
    NumberAnimation {
        id:change_width_out;
        targets: [operating_left,operating_listview];
        property: "width";
        from: 0
        to: 250;
        duration: 1000;
        running: false;
    }
    NumberAnimation {
        id:change_width_out1;
        target: signal_search;
        property: "width";
        from: 0
        to: 200;
        duration: 1200;
        running: false;
    }
//按钮隐藏左侧视图，拉伸右侧视图
    Rectangle{
        id:operating_left_close;
        width:15;
        height:40;
        anchors.verticalCenter: operating_left.verticalCenter;
        anchors.left: operating_left.right;
        color: "lightgrey";
        opacity: 0.5;
    }
    TextNew {
        id: operating_left_1
        text: "<";
        visible: true;
        anchors.centerIn: operating_left_close;
        MouseArea{
            anchors.fill: parent;
            onClicked: {
                operating_left_1.visible=false;operating_left_2.visible=true;
                signallist.visible=false;signallist_text.visible=false;signal_search.visible=false;operating_listview.visible=false;
                change_opacity_in.running=true;change_opacity_in1.running=true;
                change_width_in.running=true;change_width_in1.running=true;
            }
        }
    }
    TextNew {
        id: operating_left_2
        text: ">";
        visible: false;
        anchors.centerIn: operating_left_close;
        MouseArea{
            anchors.fill: parent;
            onClicked: {
                operating_left_1.visible=true;operating_left_2.visible=false;
                signallist.visible=true;signallist_text.visible=true;signal_search.visible=true;operating_listview.visible=true;
                change_opacity_out.running=true;change_opacity_out1.running=true;
                change_width_out.running=true;change_width_out1.running=true;
            }
        }
    }

//右侧框图
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
        visible: true;
        width: operating_left.width;
        anchors.top:operating_left.top;
        anchors.left: operating_left.left;
        color: "steelblue";
        opacity: 0.5;
    }
    TextNew {
        id: signallist_text
        text: "信号列表";
        visible: true;
        font.pixelSize: 20;
        font.bold: false;
        anchors.centerIn: signallist;
    }
    Search{
        id:signal_search;
        visible: true;
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
            model:["正常","10%","20%","30%","40%","50%","60%","70%","80%","90%"];
            onCurrentIndexChanged: {
                if(currentIndex===0){centralView.height=500;centralView.width=500;}
                if(currentIndex===1){centralView.height=50;centralView.width=50;}
                if(currentIndex===2){centralView.height=100;centralView.width=100;}
                if(currentIndex===3){centralView.height=150;centralView.width=150;}
                if(currentIndex===4){centralView.height=200;centralView.width=200;}
                if(currentIndex===5){centralView.height=250;centralView.width=250;}
                if(currentIndex===6){centralView.height=300;centralView.width=300;}
                if(currentIndex===7){centralView.height=350;centralView.width=350;}
                if(currentIndex===8){centralView.height=400;centralView.width=400;}
                if(currentIndex===9){centralView.height=450;centralView.width=450;}
            }
        }
        TextNew{
            id:setting;
            text: "设置";
            font.bold: false;
            anchors.left: size.right;
            anchors.leftMargin: 40;
            anchors.verticalCenter: operating_control.verticalCenter;
        }
        ComboBoxNew{
            id:close;
            height: operating_control.height;
            width: 30;
            anchors.left: setting.right;
            anchors.leftMargin: 20;
            anchors.verticalCenter: operating_control.verticalCenter;
            currentIndex: 1;
            model:["打开","关闭"];
            onCurrentIndexChanged: {
                if(currentIndex===0){centralView.visible=true;}
                if(currentIndex===1){centralView.visible=false;}
            }
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
        visible: true;
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
                    if(index===0){
                        imageViewer.source= ""
                        centralView.visible=false;
                    }
                    if(index===1){
                        centralView.visible=true;
                        imageViewer.source= "./pictures/background1.jpg";
                    }
                    if(index===2){
                        imageViewer.source= "";
                        centralView.visible=false;
                    }
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
        visible: false;//一开始设置为false，之后在显示图片时加入true属性，避免一进入界面鼠标图标更换的情况
        z:4;
        Image {
            id: imageViewer;
            anchors.fill:parent;
            asynchronous: true;
            z:4;
        }
        Drag.active: dragArea.drag.active
        MouseArea {
            id: dragArea
            cursorShape: pressed?Qt.ClosedHandCursor:Qt.OpenHandCursor;
            height: centralView.height*6/7;
            width: centralView.width*6/7;
            anchors.centerIn : parent;
            drag.target: parent
        }
//**图片拉伸**
        //右下角拉伸
        MouseArea{
            id:change_rb;
            height: centralView.height/14;
            width: centralView.width/14;
            anchors.right: centralView.right;
            anchors.bottom: centralView.bottom;
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
            height: centralView.height/14;
            width: centralView.width/14;
            anchors.right: centralView.right;
            anchors.top: centralView.top;
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
            height: centralView.height/14;
            width: centralView.width/14;
            anchors.left: centralView.left;
            anchors.bottom: centralView.bottom;
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
            height: centralView.height/14;
            width: centralView.width/14;
            anchors.left: centralView.left;
            anchors.top: centralView.top;
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
            height: centralView.height*6/7;
            width: centralView.width/14;
            anchors.left: centralView.left;
            anchors.top: centralView.top;
            anchors.topMargin: centralView.height/14
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
            height: centralView.height*6/7;
            width: centralView.width/14;
            anchors.right: centralView.right;
            anchors.top: centralView.top;
            anchors.topMargin: centralView.height/14
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
            height: centralView.height/14;
            width: centralView.width*6/7;
            anchors.left: centralView.left;
            anchors.top: centralView.top;
            anchors.leftMargin: centralView.height/14
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
            height: centralView.height/14;
            width: centralView.width*6/7;
            anchors.left: centralView.left;
            anchors.bottom: centralView.bottom;
            anchors.leftMargin: centralView.height/14
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

}
