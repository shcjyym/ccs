import QtQuick 2.5
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.2
import "./Model"

Item {
    id:ipc;
    visible: false;
    anchors.fill: parent;
    z:4;

//上方两个按钮，添加和发现，功能连接文字id
    Buttoncolorchange{
        id:buttoncolor1;
        anchors.left: ipc.left;
        anchors.leftMargin: 20;
        anchors.top: ipc_search.top;
        text: "添加";
    }
    Buttoncolorchange{
        id:buttoncolor2;
        anchors.left: ipc.left;
        anchors.leftMargin: 140;
        anchors.top: ipc_search.top;
        text: "发现";
    }

//右侧查找栏
    Search{
        id:ipc_search;
        anchors.right: ipc.right;
        anchors.rightMargin: 80;
        anchors.top:ipc.top;
        anchors.topMargin: 55;
        placeholdtext: "  请输入";
    }
//四根基准线（边框）
    Rectangle{
        id:ipc_top;
        width:ipc.width-20;
        height: 1;
        color: "steelblue";
        anchors.top:ipc.top;
        anchors.topMargin: 100;
        anchors.left: ipc.left;
        anchors.leftMargin: 10;
        opacity: 0.5;
    }
    Rectangle{
        id:ipc_left;
        width: 1;
        height: ipc.height-140;
        color: "steelblue";
        anchors.top:ipc.top;
        anchors.topMargin: 100;
        anchors.left: ipc.left;
        anchors.leftMargin: 10;
        opacity: 0.5;
    }
    Rectangle{
        id:ipc_bottom;
        width:ipc.width-20;
        height: 1;
        color: "steelblue";
        anchors.bottom:ipc.bottom;
        anchors.bottomMargin: 40;
        anchors.left: ipc.left;
        anchors.leftMargin: 10;
        opacity: 0.5;
    }
    Rectangle{
        id:ipc_right;
        width: 1;
        height: ipc.height-140;
        color: "steelblue";
        anchors.top:ipc.top;
        anchors.topMargin: 100;
        anchors.right: ipc.right;
        anchors.rightMargin: 10;
        opacity: 0.5;
    }
//核心表单文件
    TableView{
        id:ipc_tableview;
        anchors.top: ipc_top.top;
        anchors.left: ipc_left.left;
        anchors.bottom: ipc_bottom.bottom;
        anchors.right:ipc_right.right;
        anchors.topMargin: 10;
        anchors.leftMargin: 10;
        anchors.rightMargin: 10;
        anchors.bottomMargin: 10;
        sortIndicatorVisible: true;
        frameVisible: false;
        backgroundVisible: false;
        alternatingRowColors: true;
        focus: true;

        TableViewColumn{role:"name";title: "名称";width: ipc_tableview.width*3/19;}
        TableViewColumn{role:"ip";title: "IP";width: ipc_tableview.width*3/19;}
        TableViewColumn{role:"protocol";title: "协议";width: ipc_tableview.width/19;}
        TableViewColumn{role:"port";title: "端口";width: ipc_tableview.width/19;}
        TableViewColumn{role:"url";title: "URL";width: ipc_tableview.width*6/19;}
        TableViewColumn{role:"login";title: "登录名";width: ipc_tableview.width*3/19;}
        TableViewColumn{role:"password";title: "密码";width: ipc_tableview.width*2/19;}

        model:ListModel{
            id:ipc_model;
            ListElement{
                name:"example1";
                ip:"122.10.100.22";
                protocol:"TCP/IP";
                port:"2000";
                url:"http://";
                login:"username1";
                password:"1223355";
            }
            ListElement{
                name:"example2";
                ip:"66.66.66.66";
                protocol:"TCP/IP";
                port:"5220";
                url:"http://";
                login:"username2";
                password:"5522666";
            }
        }

        rowDelegate: Rectangle{
            height: 30;
            opacity: 0.5;
            color: "steelblue";
        }

        headerDelegate: Rectangle{
            implicitHeight: 30
            border.width: 1;
            border.color: "lightgrey";
            color: "grey";
            opacity: 0.8;
            Text {
                font.family: qsTr("微软雅黑");
                font.pixelSize: 15;
                anchors.verticalCenter: parent.verticalCenter;
                anchors.horizontalCenter: parent.horizontalCenter;
                text:styleData.value;
            }
        }

        itemDelegate: Item{
            Text {
            font.family: qsTr("微软雅黑");
            font.pixelSize: 15;
            text:styleData.value;
            anchors.centerIn: parent;
            }
        }
    }

}
