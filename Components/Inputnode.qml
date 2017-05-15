import QtQuick 2.5
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.2
import "./Model"


Item {
    id:inputnode;
    visible: false;
    anchors.fill: parent;
    z:4;


//background
    Background{
        id:background;
    }
//右上方框内内容编辑
    TextNew{
        id:input_ip;
        //函数传递ip信息
        text: "ip:";
        font.bold: false;
        anchors.left: inputnode.left;
        anchors.leftMargin: 315;
        anchors.top: inputnode.top;
        anchors.topMargin: 110;
    }
    TextNew {
        id: input_connect;
        text: "当前链接网口数:";
        font.bold: false;
        anchors.left: input_ip.left;
        anchors.leftMargin: inputnode.width/5;
        anchors.top: input_ip.top;
    }
    TextNew {
        id: input_priority;
        text: "同步优先级:";
        font.bold: false;
        anchors.left: input_ip.left;
        anchors.top: input_ip.bottom;
        anchors.topMargin: inputnode.height/40;
    }
    TextNew {
        id: input_resolution;
        text: "通道分辨率:";
        font.bold: false;
        anchors.left: input_connect.left;
        anchors.top: input_priority.top;
    }
    Text {
        id: inputnode_ip_version
        color:"grey";
        anchors.left: input_ip.left;
        anchors.top: input_priority.bottom;
        anchors.topMargin: inputnode.height/40;
        text:"硬件版本:10              固件版本:12.12              固件的编译时间:2017.5.8";
        font.pixelSize: 12;
        font.family: qsTr("微软雅黑");
    }
//add Tabview
    TabView {
        id: tabView;
        width: inputnode.width-350;
        height: 300;
        anchors.left: input_ip.left;
        anchors.top: inputnode.top;
        anchors.topMargin: (inputnode.height-95)/4+120;
//Tab标题内容添加
        Tab{
            title:"图层";
            Item{
            }
        }
        Tab{
            title:"端口设置";
            Item{
            }
        }
        Tab{
            title:"台标";
            Item{
            }
        }
        Tab{
            title:"接入设备分辨率";
            Item{
            }
        }
        Tab{
            title:"输入源控制";
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
        id:inputnode_listview;
        width: 280;
        anchors.top: inputnode_search.bottom;
        anchors.topMargin: 20;
        anchors.left: background.left;
        anchors.bottom: parent.bottom;
        anchors.bottomMargin: 25;     
        delegate: inDelegate;
        model: inModel.createObject(inputnode_listview);
        header: inHeader;
        focus: true;
        highlight: Rectangle{
                opacity:0.5;
                color: "grey";
            }

        onCurrentIndexChanged: {
            if(inputnode_listview.currentIndex>=0){
                var data=inputnode_listview.model.get(inputnode_listview.currentIndex);
                input_ip.text="ip:"+data.name;
            }
        }
    }




//Search Box
    Search{
        id:inputnode_search;
        anchors.top: inputnode.top;
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
           Text{
               text:"DVI-I";
               color: "darkgrey"
               font.bold: true;
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
                name:"128.1.45.0";
            }
            ListElement{
                name:"128.1.45.1";
            }
            ListElement{
                name:"128.1.45.2";
            }
            ListElement{
                name:"128.1.45.3";
            }
        }
    }
}
