import QtQuick 2.5
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.2
import "./Model"

Item {
    id:screenwall;
    visible: false;
    anchors.fill: parent;
    z:4;

    property string message:dialog.myItem
    property int index: wall_listview.currentIndex

    Rectangle{
        id:screenwall_left;
        width: 220;
        height: screenwall.height-79;
        color: "lightgrey";
        anchors.top: screenwall.top;
        anchors.topMargin: 52;
        anchors.left: screenwall.left;
        opacity: 0.3;
    }

    property var wallrighth: screenwall_right.height;
    property var wallrightw: screenwall_right.width;
    property var wallrightx: screenwall_right.x;
    property var wallrighty: screenwall_right.y;
    Rectangle{
        id:screenwall_right;
        width: screenwall.width-screenwall_left.width-60;
        height: screenwall_left.height-100;
        color: "lightgrey";
        anchors.top: screenwall_left.top;
        anchors.topMargin: 70;
        anchors.left: screenwall_left.right;
        anchors.leftMargin: 30;
        opacity: 0.3;
    }


//List View
    ListView{
        id:wall_listview;
        width: 220;
        anchors.top: screenwall_left.top;
        anchors.left: screenwall_left.left;
        anchors.bottom: parent.bottom;
        anchors.bottomMargin: 25;
        delegate: wall_delegate;
        model: wall_model.createObject(wall_listview);
        header: wall_header;
        focus: true;
        highlight: Rectangle{
                opacity:0.5;
                color: "grey";
            }

        onCurrentIndexChanged: {
            if(wall_listview.currentIndex>=0){
                var data=wall_listview.model.get(wall_listview.currentIndex);
                mainwall.text="主墙:"+data.name;
            }else{
                mainwall.text="主墙:"
            }
        }
        function addOne(){
            model.append({"name":dialog.myItem})
        }
        function deleteOne(){
            model.remove(currentIndex);
        }
        function renameOne(){
            var data=wall_listview.model.get(wall_listview.currentIndex);
            data.name=rename_dialog.message;
            mainwall.text="主墙:"+data.name;
        }
    }

//弹出窗口输入文字确认后返回
    ApplicationWindow{
        id:dialog;
        width: 300;
        height: 80;
        title: "请输入名称";
        flags:Qt.Dialog;
        property string myItem:field.text;
        Component.onCompleted: {
            // at begin of window load, the key focus was in window
            dialog.requestActivate();
        }

        Rectangle{
            id:background;
            anchors.fill: parent;
            opacity: 0;
        }
        Buttoncolorchange{
            id:change;
            height: 30;
            width: 100
            text: "确认";
            anchors.right: background.right;
            anchors.rightMargin: 20
            anchors.verticalCenter: background.verticalCenter;
            MouseArea{
                anchors.fill: parent;
                onClicked: {
                console.debug("create tags:",field.text);
                wall_listview.addOne();
                operating.addOne();
                field.text="";
                dialog.close();
                }
            }
         }

         TextFieldNew{
             id:field
             anchors.left: background.left;
             anchors.leftMargin: 20;
             anchors.verticalCenter: background.verticalCenter;
             focus:true;
             Keys.onPressed:
                 if(event.key === Qt.Key_Escape){
                     event.accepted = true;
                     dialog.close();
                 }
         }
}
//build a new screen wall
    Rectangle{
        id:wall_add;
        height: 30;
        color:"steelblue";
        opacity: 0.7;
        width: screenwall_left.width;
        anchors.bottom: parent.bottom;
        anchors.bottomMargin: 55;
        anchors.left: screenwall_left.left;
        MouseArea{
            anchors.fill: parent;
            onClicked: {dialog.show();}//跳出弹框，新建屏幕墙，取名确认后弹回
        }
    }

    TextNew{
        anchors.centerIn: wall_add;
        font.pixelSize: 15;
        text: "新建屏幕墙";
    }

//delete the screen wall(currrent index)
    Rectangle{
        id:wall_delete;
        height: 30;
        color:"steelblue";
        opacity: 0.7;
        width: screenwall_left.width;
        anchors.bottom: parent.bottom;
        anchors.bottomMargin: 25;
        anchors.left: screenwall_left.left;
        MouseArea{
            anchors.fill: parent;
            onClicked: {
                wall_listview.deleteOne();
                operating.deleteOne();
            }
        }
    }

    TextNew{
        anchors.centerIn: wall_delete;
        font.pixelSize: 15;
        text: "删除屏幕墙";
    }
//inDelegate
    Component{
        id:wall_delegate;
        Item{
            id: wrapper;
            width: parent.width;
            height: 33;
            MouseArea{
                anchors.fill: parent;
                onClicked: {
                    wrapper.ListView.view.currentIndex=index;//获取当前选中的index
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
                    font.bold: false;
                    Layout.preferredWidth: 120;
                }
            }
        }
    }
//inHaeder
    Component{
        id:wall_header;
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
               text:"主墙";
               color: "darkgrey";
               font.bold: true;
               font.pixelSize: 25;
               anchors.centerIn: listTitle;
           }
        }
    }
//inModel
    Component{
            id:wall_model;
            ListModel{
                ListElement{
                    name:"屏幕一";
                }
                ListElement{
                    name:"屏幕二";
                }
            }
        }


    Rectangle{
        id:screenwall_control;
        width: screenwall_right.width;
        height: 30;
        color: "steelblue";
        anchors.bottom: screenwall_right.top;
        anchors.left: screenwall_right.left;

        TextNew{
            id:mainwall;
            text: "主墙:";
            width: 120;
            font.bold: false;
            anchors.left: screenwall_control.left;
            anchors.leftMargin: 5;
            anchors.verticalCenter: screenwall_control.verticalCenter;
        }
        TextNew{
            id:openwall;
            text: "开窗";
            font.bold: false;
            anchors.left: mainwall.right;
            anchors.leftMargin: 20;
            anchors.verticalCenter: screenwall_control.verticalCenter;
            MouseArea{
                anchors.fill: parent
                onClicked: {}
            }
        }
        TextNew{
            id:rename;
            text: "改名";
            font.bold: false;
            anchors.left: openwall.right;
            anchors.leftMargin: 10;
            anchors.verticalCenter: screenwall_control.verticalCenter;
            MouseArea{
                anchors.fill: parent;
                onClicked: {rename_dialog.show();}
            }
        }
        TextNew{
            id:bottompicture;
            text: "底图";
            font.bold: false;
            anchors.right: mode.left;
            anchors.rightMargin: 20;
            anchors.verticalCenter: screenwall_control.verticalCenter;
        }
        ComboBoxNew{
            id:mode;
            height: screenwall_control.height;
            width: 50;
            anchors.right: changeresolution.left;
            anchors.rightMargin: 20;
            anchors.verticalCenter: screenwall_control.verticalCenter;
            model:["LCD","LED"];
        }
        ComboBoxNew{
            id:changeresolution;
            height: screenwall_control.height;
            width: 100;
            anchors.right: screenwall_control.right;
            anchors.rightMargin: 20;
            anchors.verticalCenter: screenwall_control.verticalCenter;
            model:["更改分辨率","1920X1080","800X600"];
        }

    }

    Rename{
        id:rename_dialog;
        property string message;
        onRename_clicked: {
            message=msg;
            wall_listview.renameOne();
        }
    }
}
