import QtQuick 2.5
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.2
import "./Model"


Item{
    id:alarm;
    visible: false;
    anchors.fill: parent;
    z:4;

    Rectangle{
        id:alarm_tip;
        height: 40;
        width: 100;
        color: "lightgrey";
        anchors.top: alarm.top;
        anchors.topMargin: 55;
        anchors.left: alarm.left;
        anchors.leftMargin: 10;
        opacity: 0.5;
        radius: 10;
        z:4;
    }
    TextNew {
        id: alarm_tiptext;
        text: "当前警告";
        font.pixelSize: 20;
        anchors.centerIn: alarm_tip;
    }
//四根基准线（边框）
    Rectangle{
        id:alarm_top;
        width:alarm.width-20;
        height: 1;
        color: "steelblue";
        anchors.top:alarm.top;
        anchors.topMargin: 100;
        anchors.left: alarm.left;
        anchors.leftMargin: 10;
        opacity: 0.5;
    }
    Rectangle{
        id:alarm_left;
        width: 1;
        height: alarm.height-140;
        color: "steelblue";
        anchors.top:alarm.top;
        anchors.topMargin: 100;
        anchors.left: alarm.left;
        anchors.leftMargin: 10;
        opacity: 0.5;
    }
    Rectangle{
        id:alarm_bottom;
        width:alarm.width-20;
        height: 1;
        color: "steelblue";
        anchors.bottom:alarm.bottom;
        anchors.bottomMargin: 40;
        anchors.left: alarm.left;
        anchors.leftMargin: 10;
        opacity: 0.5;
    }
    Rectangle{
        id:alarm_right;
        width: 1;
        height: alarm.height-140;
        color: "steelblue";
        anchors.top:alarm.top;
        anchors.topMargin: 100;
        anchors.right: alarm.right;
        anchors.rightMargin: 10;
        opacity: 0.5;
    }
//tableview显示当前网口节点出现的警告情况
    TableView{
        id:alarm_tableview;
        anchors.top: alarm_top.top;
        anchors.left: alarm_left.left;
        anchors.bottom: alarm_bottom.bottom;
        anchors.right:alarm_right.right;
        anchors.topMargin: 10;
        anchors.leftMargin: 10;
        anchors.rightMargin: 10;
        anchors.bottomMargin: 10;
        sortIndicatorVisible: true;
        frameVisible: false;
        backgroundVisible: false;
        alternatingRowColors: true;
        focus: true;

        TableViewColumn{role:"number";title: "序号";width: alarm_tableview.width/20;}
        TableViewColumn{role:"grade";title: "级别";width: alarm_tableview.width/20;}
        TableViewColumn{role:"name";title: "名称";width: alarm_tableview.width*3/20;}
        TableViewColumn{role:"time";title: "产生时间";width: alarm_tableview.width*3/20;}
        TableViewColumn{role:"source";title: "告警发生源";width: alarm_tableview.width*3/10;}
        TableViewColumn{role:"detail";title: "详情";width: alarm_tableview.width*3/10;}

        model:ListModel{
            id:alarm_model;
            ListElement{
                number:"1";
                grade:"三级";
                name:"固件版本未验证";
                time:"2017-05-10";
                source:"输入节点122.10.100.22";
                detail:"节点固件版本***经过验证的版本有**.**";
            }
            ListElement{
                number:"2";
                grade:"三级";
                name:"固件版本未验证";
                time:"2017-05-10";
                source:"输入节点66.66.88.88";
                detail:"节点固件版本***经过验证的版本有**.**";
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
            TextNew {
                color: "black";
                font.bold: false;
                anchors.verticalCenter: parent.verticalCenter;
                anchors.horizontalCenter: parent.horizontalCenter;
                text:styleData.value;
            }
        }


        itemDelegate: Item{
            TextNew {
            font.bold: false;
            color: "black";
            text:styleData.value;
            anchors.centerIn: parent;
            }
        }
    }
}

