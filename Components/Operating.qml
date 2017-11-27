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
    property int signalId: 1

    function addOne(){operating_listview.addOne();}
    function deleteOne(){operating_listview.deleteOne();}

    property string macSel: ""

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

    Screenwall{id:refer;}
    property var oprightx: operating_right_view.x;
    property var oprighty: operating_right_view.y;



    Button{
        id:generateFile
        anchors.right: operating_right.right
        anchors.top: operating_left.top
        text: qsTr("生成配置文件")

        height: 35
        width:100

        onClicked: {
            //调用C++计算接口
            console.log("operating_right:"+operating_right_view.width+" "+operating_right_view.height);
            CCalcPosGenConfigFile.clearAllExists();//先清理以前内存中数据
            CCalcPosGenConfigFile.startGetOneScreenInfo(0);
            CCalcPosGenConfigFile.getScreenWH(operating_right_view.width,
                                              operating_right_view.height)
            var data=operating_listview.model.get(0);
            for(var i=0;i<operating_right.dynamicWindow.length;i++)
            {
                console.log("i:"+i+" "+operating_right.dynamicWindow[i].ip+" "+
                            operating_right.dynamicWindow[i].configScale+" "+
                            operating_right.dynamicWindow[i].x+" "+
                            operating_right.dynamicWindow[i].y+" "+
                            operating_right.dynamicWindow[i].width+" "+
                            operating_right.dynamicWindow[i].height+" ");
                CCalcPosGenConfigFile.getSignalConfigInfo(operating_right.dynamicWindow[i].x,
                                                          operating_right.dynamicWindow[i].y,
                                                          operating_right.dynamicWindow[i].width,
                                                          operating_right.dynamicWindow[i].height,
                                                          operating_right.dynamicWindow[i].ip,
                                                          operating_right.dynamicWindow[i].configScale,
                                                          operating_right.dynamicWindow[i].id,
                                                          data.mac);

            }

            CCalcPosGenConfigFile.stopGetOneScreenInfo(0);
            {
                var data1=operating_listview.model.get(1);
                CCalcPosGenConfigFile.startGetOneScreenInfo(1);
                CCalcPosGenConfigFile.getScreenWH(operating_right_view1.width,
                                                  operating_right_view1.height)
                for(var i=0;i<operating_right1.dynamicWindow.length;i++)
                {
                    console.log("i:"+i+" "+operating_right1.dynamicWindow[i].ip+" "+
                                operating_right1.dynamicWindow[i].configScale+" "+
                                operating_right1.dynamicWindow[i].x+" "+
                                operating_right1.dynamicWindow[i].y+" "+
                                operating_right1.dynamicWindow[i].width+" "+
                                operating_right1.dynamicWindow[i].height+" ");
                    CCalcPosGenConfigFile.getSignalConfigInfo(operating_right1.dynamicWindow[i].x,
                                                              operating_right1.dynamicWindow[i].y,
                                                              operating_right1.dynamicWindow[i].width,
                                                              operating_right1.dynamicWindow[i].height,
                                                              operating_right1.dynamicWindow[i].ip,
                                                              operating_right1.dynamicWindow[i].configScale,
                                                              operating_right1.dynamicWindow[i].id,
                                                              data1.mac);

                }
                CCalcPosGenConfigFile.stopGetOneScreenInfo(1);
            }
            CCalcPosGenConfigFile.calcAndGenConfigFile();
        }
    }

    ScrollView{
        id:operating_right;
        width: operating.width-300;
        height: operating.height-180;
        anchors.top: operating_left.top;
        anchors.topMargin: 70;
        anchors.left: operating_left.right;
        anchors.leftMargin: 20;
        visible: true;
        property var dynamicWindow: new Array();

        Rectangle{
            id:operating_right_view
            height: 1080;
            width: 1920;
            color: "lightgrey";
            DropArea{
                anchors.fill: parent;
                onDropped: {

                    var ip= drop.getDataAsString("ip")
                    var mac=drop.getDataAsString("mac")
                    var configScale=parseInt(drop.getDataAsString("configScale"))
                    var rwidth=parseInt(drop.getDataAsString("rwidth"))
                    var rheight=parseInt(drop.getDataAsString("rheight"))
                    var object=operating.createImageviewer(operating_right_view);
                    object.ip=ip
                    object.configScale=configScale
                    object.width=rwidth
                    object.height=rheight
                    object.mac=mac
                    object.objectDelete.connect(deleteSignalInScreen);
                    //object.objectDelete(object);
                    operating_right.dynamicWindow[operating_right.dynamicWindow.length]=object;

                }
            }
        }
    }



    ScrollView{
        id:operating_right1;
        width: refer.wallrightw;
        height: refer.wallrighth;
        anchors.top: operating_left.top;
        anchors.topMargin: 70;
        anchors.left: operating_left.right;
        anchors.leftMargin: 20;
        visible: false;
        property var dynamicWindow: new Array();

        Rectangle{
            id:operating_right_view1
            height: 1080;
            width: 1920;
            color: "lightgrey";
            DropArea{
                anchors.fill: parent;
                onDropped: {
                    var ip= drop.getDataAsString("ip")
                    var configScale=parseInt(drop.getDataAsString("configScale"))
                    var rwidth=parseInt(drop.getDataAsString("rwidth"))
                    var rheight=parseInt(drop.getDataAsString("rheight"))
                    var object=operating.createImageviewer(operating_right_view1);
                    object.ip=ip
                    object.configScale=configScale
                    object.width=rwidth
                    object.height=rheight
                    object.objectDelete.connect(deleteSignalInScreen);
                    //object.objectDelete(object);
                    operating_right1.dynamicWindow[operating_right1.dynamicWindow.length]=object;
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
            model:["正常","10%","20%","30%","40%","50%","60%","70%","80%","90%"];

        }
        TextNew{
            id:setting;
            text: "设置";
            font.bold: false;
            anchors.left: windowsize.right;
            anchors.leftMargin: 40;
            anchors.verticalCenter: operating_control.verticalCenter;
        }
        TextNew{
            id:close;
            text: "修改MAC地址";
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
            anchors.rightMargin: 20
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
                resolutionw=data.rwidth;
                resolutionw=data.rheight;
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
            Drag.mimeData: {"ip":ip,"configScale":configScale,"rwidth":rwidth,"rheight":rheight,"mac":mac}

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
                    //text: name;
                    font.bold: false;
                    anchors.left: parent.left;
                    Layout.preferredWidth: 25;
                }
                /*
                TextNew{
                    id: wrapper_order;
                    font.bold: false;
                    Layout.preferredWidth: 15;
                }*/
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
                    text:rwidth+resolution2+rheight;
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
                    //name:"ID1:";
                    imagesource:"./pictures/background5.jpg"
                    ip:"208.0.1.1"
                    configScale:0
                    rwidth:1920
                    resolution2:"X"
                    rheight:1080
                    mac:"FFFFFFFFFFFF"
                }
                ListElement{
                    //name:"ID1:";
                    imagesource:"./pictures/background3.jpg";
                    ip:"208.0.1.2"
                    configScale:0
                    rwidth:1920
                    resolution2:"X"
                    rheight:1080
                    mac:"EEEEEEEEEEEE"
                }
                /*
                ListElement{
                    //name:"ID2:";
                    imagesource:"./pictures/background4.jpg";
                    ip:"208.0.1.3"
                    configScale:0
                    rwidth:1920
                    resolution2:"X"
                    rheight:1080
                }*/
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
                macSel = data.mac
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
                    text: name+"  mac:"+mac;
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
                    mac:"11-11-11-11-11-11"
                }
                ListElement{
                    name:"屏幕二";
                    mac:"22-22-22-22-22-22"
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
    function createImageviewer(myParent){
        var mycomponent = Qt.createComponent("Imageviewer.qml");
        var object;
        if(mycomponent.status === Component.Ready){
            console.log("createImageviewer:"+myParent)
            object = mycomponent.createObject(myParent);
            object.pictureSource=signalsource_listview.pictureSource;
            object.id=signalId;
            ++signalId;
            return object;
        }
    }

    function change_resolution(){
        //operating_right_view.width=changeResolution.width_item;
        //operating_right_view.height=changeResolution.height_item;
        operating_listview.model.get(operating_listview.currentIndex).mac=changeResolution.strMac
        console.log("change_resolution:"+operating_listview.model.get(operating_listview.currentIndex).mac+"   "+
                    changeResolution.strMac+"  "+operating_listview.currentIndex)
        operating_listview.update()
    }

    function deleteSignalInScreen(object){
        //这里还需要通知后台的计算程序，告知signal的排序有变化
        console.log("deleteSignalInScreen "+object)
        for(var i=0;i<operating_right.dynamicWindow.length;i++)
        {
            console.log("deleteSignalInScreen"+i+" "+operating_right.dynamicWindow[i])
            if(object===operating_right.dynamicWindow[i])
            {
                console.log("i:"+i+" "+operating_right.dynamicWindow[i].ip+" "+
                            operating_right.dynamicWindow[i].configScale+" "+
                            operating_right.dynamicWindow[i].x+" "+
                            operating_right.dynamicWindow[i].y+" "+
                            operating_right.dynamicWindow[i].width+" "+
                            operating_right.dynamicWindow[i].height+" ");
                for(var j=i;j<operating_right.dynamicWindow.length-1;++j)
                {
                    operating_right.dynamicWindow[j]=operating_right.dynamicWindow[j+1]
                }
                operating_right.dynamicWindow.pop();
                return;
            }
        }
        for(var i=0;i<operating_right1.dynamicWindow.length;i++)
        {
            console.log("deleteSignalInScreen"+i+" "+operating_right1.dynamicWindow[i])
            if(object===operating_right1.dynamicWindow[i])
            {
                console.log("i:"+i+" "+operating_right1.dynamicWindow[i].ip+" "+
                            operating_right1.dynamicWindow[i].configScale+" "+
                            operating_right1.dynamicWindow[i].x+" "+
                            operating_right1.dynamicWindow[i].y+" "+
                            operating_right1.dynamicWindow[i].width+" "+
                            operating_right1.dynamicWindow[i].height+" ");
                for(var j=i;j<operating_right1.dynamicWindow.length-1;++j)
                {
                    operating_right1.dynamicWindow[j]=operating_right1.dynamicWindow[j+1]
                }
                operating_right1.dynamicWindow.pop();
                return;
            }
        }
    }


}
