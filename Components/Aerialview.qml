import QtQuick 2.5
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.2
import "./Model"

/*
参数、鸟瞰图information's text的id未加入，should add text behind
输入节点和输出节点框图链接的text的ID为
viewr3_19/viewer3_16/viewer3_13/viewer3_10/viewer3_5/viewr4_19/viewer4_16/viewer4_13/viewer4_10/viewer4_5
加入property int number a\b\c
functon changenumber(){viewer*_**.text=number;}
*/

Item{
    id:aerialview;
    visible: false;
    anchors.fill: parent;
    z:4;

    Rectangle{
        id:ae_openview;
        height: 20;
        width: 20;
        color: "lightgrey";
        anchors.top:aerialview.top;
        anchors.topMargin: 70;
        anchors.left: aerialview.left;
        anchors.leftMargin: 10;
        opacity: 0.5;
        z:4;
        MouseArea{
            anchors.fill: parent;
            hoverEnabled: true;
            onEntered: {
                ae_openview.color="grey";
            }
            onExited: {
                ae_openview.color="lightgrey";
            }
        }
    }

    TextNew {
        id: closeview;
        text: qsTr("-");
        visible: true;
        anchors.centerIn: ae_openview;
        font.pixelSize: 20;
        z:5;
        MouseArea{
            anchors.fill: parent;
            onClicked: {
                closeview.visible=false;openview.visible=true;openviewtext.visible=true;closeviewtext.visible=false;
                viewer.visible=false;
            }
        }
    }

    TextNew {
        id: openview
        text: qsTr("+");
        visible: false;
        anchors.centerIn: ae_openview;
        font.pixelSize: 20;
        z:5;
        MouseArea{
            anchors.fill: parent;
            onClicked: {
                closeview.visible=true;openview.visible=false;openviewtext.visible=false;closeviewtext.visible=true;
                viewer.visible=true;
            }
        }
    }

    TextNew {
        id: openviewtext
        text: qsTr("全部展开");
        visible: false;
        anchors.verticalCenter: ae_openview.verticalCenter;
        anchors.left: ae_openview.right;
        anchors.leftMargin: 5;
        z:4;
    }

    TextNew {
        id: closeviewtext
        text: qsTr("全部收起");
        visible: true;
        anchors.verticalCenter: ae_openview.verticalCenter;
        anchors.left: ae_openview.right;
        anchors.leftMargin: 5;
        z:4;
    }


    Item{                                //鸟瞰框图
        id:viewer;
        visible: true;
        anchors.top: openviewtext.bottom;
        anchors.topMargin: 10;
        anchors.left: openviewtext.left;
//frame1
        Rectangle{
            id:viewer1bg;
            height: 99;
            width: 250;
            color:"lightgrey";
            anchors.top: viewer.top;
            anchors.left: viewer.left;
            opacity: 0.6;
        }
        Rectangle{
            id:viewer1_1;
            height:33;
            width: viewer1bg.width;
            color:"grey";
            anchors.top:viewer1bg.top;
            anchors.left: viewer1bg.left;
            opacity: 0.8;
        }
        TextNew{
            id:viewer1_2;
            text:"全部参数";
            color:"orange";
            anchors.left: viewer1bg.left;
            anchors.leftMargin: 5;
            anchors.verticalCenter: viewer1_1.verticalCenter;
        }
        TextNew{
            id:viewer1_3;
            text:"固化配置";
            color: "orange";
            anchors.right: viewer1bg.right;
            anchors.rightMargin: 5;
            anchors.verticalCenter: viewer1_1.verticalCenter;
        }
        TextNew{
            id:viewer1_4;
            text:"输出节点网线模式:";
            font.pixelSize: 12;
            anchors.left : viewer1bg.left;
            anchors.leftMargin: 5;
            anchors.verticalCenter: viewer1bg.verticalCenter;
        }
        TextNew{
            id:viewer1_5;
            text:"节点频率:";
            font.pixelSize: 12;
            anchors.left : viewer1bg.left;
            anchors.leftMargin: 5;
            anchors.top : viewer1_4.bottom;
            anchors.topMargin: 15;
        }
//frame2
        Rectangle{
            id:viewer2bg;
            height: 99;
            width: 250;
            color:"lightgrey";
            anchors.top: viewer1bg.bottom;
            anchors.topMargin: 15;
            anchors.left: viewer1bg.left;
            opacity: 0.6;
        }
        Rectangle{
            id:viewer2_1;
            height:33;
            width: viewer2bg.width;
            color:"grey";
            anchors.top:viewer2bg.top;
            anchors.left: viewer2bg.left;
            opacity: 0.8;
        }
        TextNew{
            id:viewer2_2;
            text:"鸟瞰图信息";
            color:"orange";
            anchors.left: viewer2bg.left;
            anchors.leftMargin: 5;
            anchors.verticalCenter: viewer2_1.verticalCenter;
        }
        TextNew{
            id:viewer2_3;
            text:"屏幕墙总数:";
            font.pixelSize: 12;
            anchors.left : viewer2bg.left;
            anchors.leftMargin: 5;
            anchors.verticalCenter: viewer2bg.verticalCenter;
        }
        TextNew{
            id:viewer2_4;
            text:"IPC:";
            font.pixelSize: 12;
            anchors.left : viewer2bg.left;
            anchors.leftMargin: 5;
            anchors.top : viewer2_3.bottom;
            anchors.topMargin: 15;
        }
//frame3
        Rectangle{
            id:viewer3bg;
            visible: true;
            height: 132;
            width: 250;
            color:"lightgrey";
            anchors.top: viewer2bg.bottom;
            anchors.topMargin: 15;
            anchors.left: viewer2bg.left;
            opacity: 0.6;
        }
        Rectangle{
            id:viewer3_1;
            height:33;
            width: viewer3bg.width;
            color:"grey";
            anchors.top:viewer3bg.top;
            anchors.left: viewer3bg.left;
            opacity: 0.8;
        }
        TextNew{
            id:viewer3_2;
            text:"输入节点";
            color:"orange";
            anchors.left: viewer3bg.left;
            anchors.leftMargin: 5;
            anchors.verticalCenter: viewer3_1.verticalCenter;
        }
//offline frame
        Rectangle{
            id:viewer3_3;
            height: 99;
            width: 68;
            color:"red";
            anchors.left: viewer3bg.left;
            anchors.top:viewer3_1.bottom;
            opacity: 0.3;
        }
        TextNew{
            id:viewer3_4;
            text:"离线";
            font.pixelSize: 11;
            anchors.horizontalCenter: viewer3_3.horizontalCenter;
            anchors.bottom: viewer3_3.bottom;
            anchors.bottomMargin: 10;
            opacity: 0.8;
        }
        TextNew{
            id:viewer3_5;
            text:"0";
            font.pixelSize: 40;
            font.bold: false;
            anchors.centerIn: viewer3_3;
        }
//online frame
        Rectangle{
            id:viewer3_6;
            height: 30;
            width: 182;
            color:"lightgrey";
            anchors.left: viewer3_3.right;
            anchors.top:viewer3_1.bottom;
            opacity: 0.6;
        }
        TextNew{
            id:viewer3_7;
            text:"在线";
            font.pixelSize: 11;
            anchors.verticalCenter: viewer3_6.verticalCenter;
            anchors.left: viewer3_6.left;
            anchors.leftMargin: 5;
            opacity: 0.8;
        }
//X1frame
        Rectangle{
            id:viewer3_8;
            height: 69;
            width: 44;
            color:"lightgrey";
            anchors.left: viewer3_3.right;
            anchors.leftMargin: 1.5;
            anchors.top:viewer3_6.bottom;
            opacity: 0.2;
        }
        TextNew{
            id:viewer3_9;
            text:"X1";
            font.pixelSize: 11;
            font.bold: false;
            anchors.horizontalCenter: viewer3_8.horizontalCenter;
            anchors.bottom: viewer3_8.bottom;
            anchors.bottomMargin: 2;
            opacity: 0.8;
        }
        TextNew{
            id:viewer3_10;
            text:"0";
            font.pixelSize: 40;
            font.bold: false;
            anchors.centerIn: viewer3_8;
        }
//X2frame
        Rectangle{
            id:viewer3_11;
            height: 69;
            width: 44;
            color:"lightgrey";
            anchors.left: viewer3_8.right;
            anchors.leftMargin: 1.5;
            anchors.top:viewer3_6.bottom;
            opacity: 0.2;
        }
        TextNew{
            id:viewer3_12;
            text:"X2";
            font.pixelSize: 11;
            font.bold: false;
            anchors.horizontalCenter: viewer3_11.horizontalCenter;
            anchors.bottom: viewer3_11.bottom;
            anchors.bottomMargin: 2;
            opacity: 0.8;
        }
        TextNew{
            id:viewer3_13;
            text:"0";
            font.pixelSize: 40;
            font.bold: false;
            anchors.centerIn: viewer3_11;
        }
//X3frame
        Rectangle{
            id:viewer3_14;
            height: 69;
            width: 44;
            color:"lightgrey";
            anchors.left: viewer3_11.right;
            anchors.leftMargin: 2.5;
            anchors.top:viewer3_6.bottom;
            opacity: 0.2;
        }
        TextNew{
            id:viewer3_15;
            text:"X3";
            font.pixelSize: 11;
            font.bold: false;
            anchors.horizontalCenter: viewer3_14.horizontalCenter;
            anchors.bottom: viewer3_14.bottom;
            anchors.bottomMargin: 2;
            opacity: 0.8;
        }
        TextNew{
            id:viewer3_16;
            text:"0";
            font.pixelSize: 40;
            font.bold: false;
            anchors.centerIn: viewer3_14;
        }
//X4frame
        Rectangle{
            id:viewer3_17;
            height: 69;
            width: 44;
            color:"lightgrey";
            anchors.left: viewer3_14.right;
            anchors.leftMargin: 1.5;
            anchors.top:viewer3_6.bottom;
            opacity: 0.2;
        }
        TextNew{
            id:viewer3_18;
            text:"X4";
            font.pixelSize: 11;
            font.bold: false;
            anchors.horizontalCenter: viewer3_17.horizontalCenter;
            anchors.bottom: viewer3_17.bottom;
            anchors.bottomMargin: 2;
            opacity: 0.8;
        }
        TextNew{
            id:viewer3_19;
            text:"0";
            font.pixelSize: 40;
            font.bold: false;
            anchors.centerIn: viewer3_17;
        }
//frame3
        Rectangle{
            id:viewer4bg;
            visible: true;
            height: 132;
            width: 250;
            color:"lightgrey";
            anchors.top: viewer3bg.bottom;
            anchors.topMargin: 15;
            anchors.left: viewer3bg.left;
            opacity: 0.6;
        }
        Rectangle{
            id:viewer4_1;
            height:33;
            width: viewer4bg.width;
            color:"grey";
            anchors.top:viewer4bg.top;
            anchors.left: viewer4bg.left;
            opacity: 0.8;
        }
        TextNew{
            id:viewer4_2;
            text:"输入节点";
            color:"orange";
            anchors.left: viewer4bg.left;
            anchors.leftMargin: 5;
            anchors.verticalCenter: viewer4_1.verticalCenter;
        }
//offlineframe
        Rectangle{
            id:viewer4_3;
            height: 99;
            width: 68;
            color:"red";
            anchors.left: viewer4bg.left;
            anchors.top:viewer4_1.bottom;
            opacity: 0.3;
        }
        TextNew{
            id:viewer4_4;
            text:"离线";
            font.pixelSize: 11;
            anchors.horizontalCenter: viewer4_3.horizontalCenter;
            anchors.bottom: viewer4_3.bottom;
            anchors.bottomMargin: 10;
            opacity: 0.8;
        }
        TextNew{
            id:viewer4_5;
            text:"0";
            font.pixelSize: 40;
            font.bold: false;
            anchors.centerIn: viewer4_3;
        }
//onlineframe
        Rectangle{
            id:viewer4_6;
            height: 30;
            width: 182;
            color:"lightgrey";
            anchors.left: viewer4_3.right;
            anchors.top:viewer4_1.bottom;
            opacity: 0.6;
        }
        TextNew{
            id:viewer4_7;
            text:"在线";
            font.pixelSize: 11;
            font.bold: true;
            color:"white";
            anchors.verticalCenter: viewer4_6.verticalCenter;
            anchors.left: viewer4_6.left;
            anchors.leftMargin: 5;
            opacity: 0.8;
        }
//X1frame
        Rectangle{
            id:viewer4_8;
            height: 69;
            width: 44;
            color:"lightgrey";
            anchors.left: viewer4_3.right;
            anchors.leftMargin: 1.5;
            anchors.top:viewer4_6.bottom;
            opacity: 0.2;
        }
        TextNew{
            id:viewer4_9;
            text:"X1";
            font.pixelSize: 11;
            font.bold: false;
            anchors.horizontalCenter: viewer4_8.horizontalCenter;
            anchors.bottom: viewer4_8.bottom;
            anchors.bottomMargin: 2;
            opacity: 0.8;
        }
        TextNew{
            id:viewer4_10;
            text:"0";
            font.pixelSize: 40;
            font.bold: false;
            anchors.centerIn: viewer4_8;
        }
//X2frame
        Rectangle{
            id:viewer4_11;
            height: 69;
            width: 44;
            color:"lightgrey";
            anchors.left: viewer4_8.right;
            anchors.leftMargin: 1.5;
            anchors.top:viewer4_6.bottom;
            opacity: 0.2;
        }
        TextNew{
            id:viewer4_12;
            text:"X2";
            font.pixelSize: 11;
            font.bold: false;
            anchors.horizontalCenter: viewer4_11.horizontalCenter;
            anchors.bottom: viewer4_11.bottom;
            anchors.bottomMargin: 2;
            opacity: 0.8;
        }
        TextNew{
            id:viewer4_13;
            text:"0";
            font.pixelSize: 40;
            font.bold: false;
            anchors.centerIn: viewer4_11;
        }
//X3frame
        Rectangle{
            id:viewer4_14;
            height: 69;
            width: 44;
            color:"lightgrey";
            anchors.left: viewer4_11.right;
            anchors.leftMargin: 2.5;
            anchors.top:viewer4_6.bottom;
            opacity: 0.2;
        }
        TextNew{
            id:viewer4_15;
            text:"X3";
            font.pixelSize: 11;
            font.bold: false;
            anchors.horizontalCenter: viewer4_14.horizontalCenter;
            anchors.bottom: viewer4_14.bottom;
            anchors.bottomMargin: 2;
            opacity: 0.8;
        }
        TextNew{
            id:viewer4_16;
            text:"0";
            font.pixelSize: 40;
            font.bold: false;
            anchors.centerIn: viewer4_14;
        }
//X4frame
        Rectangle{
            id:viewer4_17;
            height: 69;
            width: 44;
            color:"lightgrey";
            anchors.left: viewer4_14.right;
            anchors.leftMargin: 1.5;
            anchors.top:viewer4_6.bottom;
            opacity: 0.2;
        }
        TextNew{
            id:viewer4_18;
            text:"X4";
            font.pixelSize: 11;
            font.bold: false;
            anchors.horizontalCenter: viewer4_17.horizontalCenter;
            anchors.bottom: viewer4_17.bottom;
            anchors.bottomMargin: 2;
            opacity: 0.8;
        }
        TextNew{
            id:viewer4_19;
            text:"0";
            font.pixelSize: 40;
            font.bold: false;
            anchors.centerIn: viewer4_17;
        }
    }
}

