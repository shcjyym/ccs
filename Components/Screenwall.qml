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
                    name:"试例墙";
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
            anchors.right: size.left;
            anchors.rightMargin: 20;
            anchors.verticalCenter: screenwall_control.verticalCenter;
            model:["LCD","LED"];
        }
        TextNew{
            id:size;
            text: "0X0";
            font.bold: false;
            anchors.right: changeresolution.left;
            anchors.rightMargin: 20;
            anchors.verticalCenter: screenwall_control.verticalCenter;
            MouseArea{
                anchors.fill: parent;
                onClicked: {segmentation_dialog.show();}
            }
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
//产生行和列   ***此处存在问题，放大窗口后动态产生的组件的长宽位置不发生变化***


    function create(){
        var component = Qt.createComponent("Screenwallcomponent.qml");
        var object = component.createObject(screenwall);
        for(var i=1;i<segmentation_dialog.row_item;i++){
            var component1=Qt.createQmlObject('import QtQuick 2.0; Rectangle {color: "white"; height: 1;opacity:0.4}',
                                         object);
            component1.z=5;
            component1.width=screenwall_right.width;
            component1.x=0;
            component1.y=i*screenwall_right.height/segmentation_dialog.row_item;
        }

        for(var j=1;j<segmentation_dialog.column_item;j++){
            var component2=Qt.createQmlObject('import QtQuick 2.0; Rectangle {color: "white"; width: 1;opacity:0.4}',
                                         object);
            component2.z=5;
            component2.height=screenwall_right.height;
            component2.y=0;
            component2.x=j*screenwall_right.width/segmentation_dialog.column_item;
        }
    }




//产生行和列  末尾

    Segmentation{
        id:segmentation_dialog;
        onText_change: {
            size.text=segmentation_dialog.row_item+"X"+segmentation_dialog.column_item;
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

    /*Rectangle{
        id:twoxtwo1;
        height: 1;
        width: screenwall_right.width;
        color:"white";
        opacity: 0.4;
        anchors.left: screenwall_right.left;
        anchors.top: screenwall_right.verticalCenter;
        z:5
    }
    Rectangle{
        id:twoxtwo2;
        height: screenwall_right.height;
        width: 1;
        color:"white";
        opacity: 0.4;
        anchors.top: screenwall_right.top;
        anchors.left: screenwall_right.horizontalCenter;
        z:5
    }*/

 //存储照片的中心框，包含拉伸，拖动，缩放
     Item{
         id:centralView;
         x:screenwall_right.x;
         y:screenwall_right.y;
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
