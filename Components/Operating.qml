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

    function addOne(){operating_listview.addOne();}
    function deleteOne(){operating_listview.deleteOne();}


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


//右侧框图
    property var oprightx: operating_right_view.x;
    property var oprighty: operating_right_view.y;
    ScrollView{
        id:operating_right;
        width: operating.width-300;
        height: operating.height-180;
        anchors.top: operating_left.top;
        anchors.topMargin: 70;
        anchors.left: operating_left.right;
        anchors.leftMargin: 20;
        visible: true;
        Rectangle{
            id:operating_right_view
            height: 1080;
            width: 1920;
            color: "lightgrey";
            DropArea{
                anchors.fill: parent;
                onDropped: {
                    operating.createImageviewer();
                }
            }
        }
    }

    ScrollView{
        id:operating_right1;
        width: operating.width-300;
        height: operating.height-180;
        anchors.top: operating_left.top;
        anchors.topMargin: 70;
        anchors.left: operating_left.right;
        anchors.leftMargin: 20;
        visible: false;
        Rectangle{
            id:operating_right_view1
            height: 1080;
            width: 1920;
            color: "lightgrey";
            DropArea{
                anchors.fill: parent;
                onDropped: {
                    operating.createImageviewer1();
                }
            }
        }
    }
//
    Rectangle{
        id:signallist;
        height: 30;
        visible: true;
        width: operating_left.width/2;
        anchors.top:operating_left.top;
        anchors.left: operating_left.left;
        color: "darkblue";
        opacity: 0.5;
    }
    TextNew {
        id: signallist_text
        text: "屏幕列表";
        visible: true;
        font.pixelSize: 20;
        font.bold: false;
        anchors.centerIn: signallist;
        MouseArea{
            anchors.fill: parent;
            onClicked: {
                signalsource_listview.visible=false;
                operating_listview.visible=true;
                signallist.color="darkblue";
                sourcelist.color="steelblue";
            }
        }
    }
    Rectangle{
        id:sourcelist;
        height: 30;
        visible: true;
        width: operating_left.width/2;
        anchors.top:operating_left.top;
        anchors.left: signallist.right;
        color: "steelblue";
        opacity: 0.5;
    }
    TextNew {
        id: sourcelist_text
        text: "信号列表";
        visible: true;
        font.pixelSize: 20;
        font.bold: false;
        anchors.centerIn: sourcelist;
        MouseArea{
            anchors.fill: parent;
            onClicked: {
                signalsource_listview.visible=true;
                operating_listview.visible=false;
                sourcelist.color="darkblue";
                signallist.color="steelblue";
            }
        }
    }
//***search function should be perfected***
    Search{
        id:signal_search;
        visible: true;
        anchors.top:signallist.bottom;
        anchors.left: signallist.left;
        anchors.topMargin: 15;
        anchors.leftMargin: 5;
    }
//分割线

//控制条形窗
    Rectangle{
        id:operating_control;
        width: operating_right.width;
        height: 30;
        color: "steelblue";
        anchors.bottom: operating_right.top;
        anchors.left: operating_right.left;

        ComboBoxNew{
            id:windowsize;
            height: operating_control.height;
            width: 50;
            anchors.left: operating_control.left;
            anchors.verticalCenter: operating_control.verticalCenter;
            model:["正常"];
           /* onCurrentIndexChanged: {
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
            }*/
        }
        TextNew{
            id:setting;
            text: "";
            font.bold: false;
            anchors.left: windowsize.right;
            anchors.leftMargin: 40;
            anchors.verticalCenter: operating_control.verticalCenter;
        }
        TextNew{
            id:close;
            text: "修改分辨率";
            font.bold: false;
            anchors.left: setting.right;
            anchors.leftMargin: 20;
            anchors.verticalCenter: operating_control.verticalCenter;
            MouseArea{
                anchors.fill: parent;
                onClicked: {changeResolution.show();}
            }
        }
        TextNew{
            id:size;
            text: "0X0";
            font.bold: false;
            anchors.left: close.right;
            anchors.leftMargin : 40;
            anchors.verticalCenter: operating_control.verticalCenter;
            MouseArea{
                anchors.fill: parent;
                onClicked: {segmentation_dialog.show();}
            }
        }
        TextNew{
            id:window;
            font.bold: false;
            anchors.horizontalCenter: operating_control.horizontalCenter;
            anchors.verticalCenter: operating_control.verticalCenter;
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




    Segmentation{
        id:segmentation_dialog;
        onText_change: {
            size.text=segmentation_dialog.row_item+"X"+segmentation_dialog.column_item;
        }
    }

    Changeresolution{
        id:changeResolution;
    }

//信号源Listview

    ListView{
        id:signalsource_listview;
        width: 250;
        visible: false;
        anchors.top: signal_search.bottom;
        anchors.topMargin: 10;
        anchors.left: operating_left.left;
        anchors.bottom: parent.bottom;
        anchors.bottomMargin: 25;
        delegate: signalsource_delegate;
        model: signalsource_model.createObject(signalsource_listview);
        focus: true;
        highlight: Rectangle{
                opacity:0.5;
                color: "grey";
            }

        property string pictureSource;
        property string resolutionw;
        property string resolutionh;
        onCurrentIndexChanged: {
            if(operating_listview.currentIndex>=0){
                var data=signalsource_listview.model.get(signalsource_listview.currentIndex);
                pictureSource=data.imagesource;
                resolutionw=data.resolution1;
                resolutionw=data.resolution3;
            }else{
                pictureSource="";
            }
        }
    }
//inDelegate
    Component{
        id:signalsource_delegate;
        Item{
            id: wrapper;
            width: parent.width;
            height: 80;
            Drag.active: dragArea.drag.active;
            Drag.dragType: Drag.Automatic;
            property real change_x;
            property real change_y;
            MouseArea{
                id:dragArea;
                anchors.fill: parent;
                onPressed: {
                    change_x=wrapper.x;
                    change_y=wrapper.y;
                }
                onReleased: {
                    parent.Drag.drop();
                    wrapper.x=change_x;
                    wrapper.y=change_y;
                }
                onClicked: {
                    wrapper.ListView.view.currentIndex=index;//获取当前选中的index
                    mouse.accepted=true;
                }
                drag.target: parent;
            }

            RowLayout{
                anchors.verticalCenter: parent.verticalCenter;
                anchors.left: parent.left;
                anchors.leftMargin: 15;
                TextNew{
                    id: wrapper_name;
                    text: name;
                    font.bold: false;
                    anchors.left: parent.left;
                    Layout.preferredWidth: 25;
                }
                TextNew{
                    id: wrapper_order;
                    text: order;
                    font.bold: false;
                    Layout.preferredWidth: 15;
                }
                Rectangle {
                    id: wrapper_picture;
                    height: 60;
                    width: 60;
                    anchors.verticalCenter: parent.verticalCenter;
                    Image {
                        id: wrapper_source
                        source: imagesource;
                        anchors.fill: parent;
                    }
                }
                TextNew{
                    id:wrapper_ip
                    text:ip;
                    font.bold: false;
                    Layout.preferredWidth: 130
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.verticalCenterOffset: 20;
                }
                TextNew{
                    id:wrapper_resolution
                    text:resolution1+resolution2+resolution3;
                    font.bold: false;
                    anchors.left: wrapper_ip.left;
                    anchors.verticalCenter: parent.verticalCenter;
                    anchors.verticalCenterOffset: -20;
                }
            }
        }
    }
//inModel
    Component{
            id:signalsource_model;
            ListModel{
                ListElement{
                    name:"ID1:";
                    order:"(1)"
                    imagesource:"./pictures/background1.jpg"
                    ip:"11.111.11.111"
                    resolution1:"1920"
                    resolution2:"X"
                    resolution3:"1080"
                }
                ListElement{
                    name:"ID1:";
                    order:"(2)"
                    imagesource:"./pictures/background3.jpg";
                    ip:"22.222.22.222"
                    resolution1:"1024"
                    resolution2:"X"
                    resolution3:"768"
                }
                ListElement{
                    name:"ID2:";
                    order:"(1)"
                    imagesource:"./pictures/background4.jpg";
                    ip:"15.155.15.155"
                    resolution1:"640"
                    resolution2:"X"
                    resolution3:"360"
                }
            }
    }
//屏幕墙Listview
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

        onCurrentIndexChanged: {
            if(operating_listview.currentIndex>=0){
                var data=operating_listview.model.get(operating_listview.currentIndex);
                window.text=data.name;
            }else{
                window.text=""
            }
        }

        function addOne(){
            model.append({"name":screenwall.message});
        }
        function deleteOne(){
            model.remove(index);
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
                        operating_right.visible=true;
                        operating_right1.visible=false;
                    }
                    if(index===1){
                        operating_right.visible=false;
                        operating_right1.visible=true;
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
                    name:"屏幕一";
                }
                ListElement{
                    name:"屏幕二";
                }
            }
    }

    //产生行和列   ***此处存在问题，放大窗口后动态产生的组件的长宽位置不发生变化***


        function create(){
            var component = Qt.createComponent("Sgcomponent.qml");
            var object = component.createObject(operating_right_view);
            for(var i=1;i<segmentation_dialog.row_item;i++){
                var component1=Qt.createQmlObject('import QtQuick 2.0; Rectangle {color: "white"; height: 1;opacity:0.4}',
                                             object);
                component1.z=5;
                component1.width=operating_right_view.width;
                component1.x=0;
                component1.y=i*operating_right_view.height/segmentation_dialog.row_item;
            }

            for(var j=1;j<segmentation_dialog.column_item;j++){
                var component2=Qt.createQmlObject('import QtQuick 2.0; Rectangle {color: "white"; width: 1;opacity:0.4}',
                                             object);
                component2.z=5;
                component2.height=operating_right_view.height;
                component2.y=0;
                component2.x=j*operating_right_view.width/segmentation_dialog.column_item;
            }
        }




    //产生行和列  末尾

    function createImageviewer(){
        var component = Qt.createComponent("Imageviewer.qml");
        var object = component.createObject(operating_right_view);
        object.pictureSource=signalsource_listview.pictureSource;
    }

    function createImageviewer1(){
        var component = Qt.createComponent("Imageviewer.qml");
        var object = component.createObject(operating_right_view1);
        object.pictureSource=signalsource_listview.pictureSource;
    }

    function change_resolution(){
        operating_right_view.width=changeResolution.width_item;
        operating_right_view.height=changeResolution.height_item;
    }


}
