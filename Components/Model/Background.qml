import QtQuick 2.5
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.2

Item {
    id:background;
    anchors.fill: parent;
    Rectangle{
        id:background_left;
        width: 280;
        height: background.height-85;
        color: "lightgrey";
        anchors.top: background.top;
        anchors.topMargin: 55;
        anchors.left: background.left;
        opacity: 0.3;
    }
    Rectangle{
        id:background_right;
        width: background.width-background_left.width-10;
        height: background.height-85;
        color:"#DA70D6";
        anchors.top:background.top;
        anchors.topMargin: 55;
        anchors.right: background.right;
        anchors.rightMargin: 5;
        opacity: 0.1;
    }
    Rectangle{
        id:right_bottom;
        height:1;
        width: background_right.width-10;
        color: "steelblue";
        anchors.bottom: background_right.bottom;
        anchors.bottomMargin: 5;
        anchors.left: background_right.left;
        anchors.leftMargin: 5;
        opacity: 0.5;
    }
    Rectangle{
        id:right_top;
        height:1;
        width: background_right.width-10;
        color: "steelblue";
        anchors.top: background_right.top;
        anchors.topMargin: 5;
        anchors.left: background_right.left;
        anchors.leftMargin: 5;
        opacity: 0.5;
    }
    Rectangle{
        id:right_left;
        height:background_right.height-10;
        width: 1;
        color: "steelblue";
        anchors.bottom: background_right.bottom;
        anchors.bottomMargin: 5;
        anchors.left: background_right.left;
        anchors.leftMargin: 5;
        opacity: 0.5;
    }
    Rectangle{
        id:right_right;
        height:background_right.height-10;
        width: 1;
        color: "steelblue";
        anchors.bottom: background_right.bottom;
        anchors.bottomMargin: 5;
        anchors.right: background_right.right;
        anchors.rightMargin: 5;
        opacity: 0.5;
    }
    Rectangle{
        id:right_medium;
        height:1;
        width: background_right.width-10;
        color: "steelblue";
        anchors.left: right_left.left;
        anchors.top:right_top.top;
        anchors.topMargin: (background_right.height-10)/4;
        opacity: 0.5;
    }
    Rectangle{
        id:right_medium_up;
        width: background_right.width-20;
        color:"steelblue";
        anchors.left: right_left.left;
        anchors.leftMargin: 5;
        anchors.bottom: right_medium.top;
        anchors.bottomMargin: 5;
        anchors.top: right_medium_upt.bottom;
        anchors.topMargin: 5;
        opacity: 0.3;
    }
    Text {
        id: right_medium_upt;
        text: "DVI-I";
        font.family: qsTr("微软雅黑");
        font.pixelSize: 15;
        color: "white";
        anchors.left: right_left.left;
        anchors.leftMargin: 5;
        anchors.top: right_top.top;
        anchors.topMargin: 5;
    }
    Text {
        id: right_medium_downt;
        text: "功能设置";
        font.family: qsTr("微软雅黑");
        font.pixelSize: 15;
        color: "white";
        anchors.left: right_left.left;
        anchors.leftMargin: 5;
        anchors.top: right_medium.top;
        anchors.topMargin: 5;
    }
}
