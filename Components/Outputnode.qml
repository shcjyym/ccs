import QtQuick 2.5
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.2
import "./Model"


Item {
    id:outputnode;
    visible: false;
    anchors.fill: parent;
    z:4;

//background
    Background{
        id:background;
    }
//Text content
    TextNew{
        id:output_ip;
        //函数传递ip信息
        text: "ip:";
        font.bold: false;
        anchors.left: outputnode.left;
        anchors.leftMargin: 315;
        anchors.top: outputnode.top;
        anchors.topMargin: 110;
    }
    TextNew {
        id: output_connect;
        text: "当前链接网口数:";
        font.bold: false;
        anchors.left: output_ip.left;
        anchors.leftMargin: outputnode.width/5;
        anchors.top: output_ip.top;
    }
    TextNew {
        id: output_frequencey;
        text: "输出频率: 50Hz";
        font.bold: false;
        anchors.left: output_ip.left;
        anchors.top: output_ip.bottom;
        anchors.topMargin: outputnode.height/40;
    }
    Text {
        id: outputnode_ip_version
        color:"grey";
        anchors.left: output_ip.left;
        anchors.top: output_frequencey.bottom;
        anchors.topMargin: outputnode.height/40;
        text:"硬件版本:10              固件版本:12.12              固件的编译时间:2017.5.12";
        font.pixelSize: 12;
        font.family: qsTr("微软雅黑");
    }
//add Tabview
    TabView {
        id: tabView;
        width: outputnode.width-350;
        height: 300;
        anchors.left: output_ip.left;
        anchors.top: outputnode.top;
        anchors.topMargin: (outputnode.height-95)/4+120;
//Tab标题内容添加
        Tab{
            title:"音频端口";
            Item{
            }
        }
//Tab样式格式
        style: TabViewStyle {
            tab: Item{
                implicitWidth: Math.max(text.width + 8, 150);
                implicitHeight: 48;
                Rectangle {
                    width: 2;
                    height: parent.height - 4;
                    anchors.top: parent.top;
                    anchors.right: parent.right;
                    visible: styleData.index < control.count - 1;
                    gradient: Gradient {
                        GradientStop{position: 0.0; color: "#404040";}
                        GradientStop{position: 0.5; color: "#707070";}
                        GradientStop{position: 1.0; color: "#404040";}
                    }
                }
                RowLayout {
                    implicitWidth: Math.max(text.width,72);
                    height: 36;
                    anchors.centerIn: parent;
                    TextNew {
                        id: text;
                        text: styleData.title;
                        font.pixelSize: styleData.selected ? 18 :(styleData.hovered ? 18: 15);
                        font.bold: styleData.selected ? true : false;
                        color: styleData.selected ? "darkgrey" : (styleData.hovered ? "lightgrey" : "white");
                    }
                }
            }
            frame:Rectangle{
                color:"steelblue";
                opacity: 0.5;
            }
        }
    }

//List View
    ListView{
        id:outputnode_listview;
        width: 280;
        anchors.top: outputnode_search.bottom;
        anchors.topMargin: 20;
        anchors.left: background.left;
        anchors.bottom: parent.bottom;
        anchors.bottomMargin: 25;
        delegate: inDelegate;
        model: inModel.createObject(outputnode_listview);
        header: inHeader;
        focus: true;
        highlight: Rectangle{
                opacity:0.5;
                color: "grey";
            }

        onCurrentIndexChanged: {
            if(outputnode_listview.currentIndex>=0){
                var data=outputnode_listview.model.get(outputnode_listview.currentIndex);
                output_ip.text="ip:"+data.name;
            }
        }
    }




//Search Box
    Search{
        id:outputnode_search;
        anchors.top: outputnode.top;
        anchors.topMargin: 70;
        anchors.left: background.left;
        anchors.leftMargin: 10;
        placeholdtext: "  请输入";
    }

//inDelegate
    Component{
        id:inDelegate;
        Item{
            id: wrapper;
            width: parent.width;
            height: 33;
            MouseArea{
                anchors.fill: parent;
                onClicked: {
                    wrapper.ListView.view.currentIndex=index;
                    mouse.accepted=true;
                }
            }
            RowLayout{
                anchors.verticalCenter: parent.verticalCenter;
                anchors.left: parent.left;
                anchors.leftMargin: 15;
                TextNew{
                    id: roll;
                    text: name;
                    Layout.preferredWidth: 120;
                }
            }
        }
    }
//inHaeder
    Component{
        id:inHeader;
        Item{
            width: parent.width;
            height: 35;
            Rectangle{
                id:listTitle
                anchors.fill: parent;
                color:"steelblue";
                opacity: 0.7;
            }
           TextNew{
               text:"DVI-I";
               color: "darkgrey";
               font.pixelSize: 25;
               anchors.centerIn: listTitle;
           }
        }
    }
//inModel
    Component{
        id:inModel;
        ListModel{
            ListElement{
                name:"1.121.45.0";
            }
            ListElement{
                name:"128.111.45.1";
            }
            ListElement{
                name:"118.110.45.2";
            }
            ListElement{
                name:"28.1.145.123";
            }
        }
    }
}
