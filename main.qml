import QtQuick 2.5
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1
import "./Components" as Resources
import "./Components/Model"


Resources.ClientWindow{
    id:mainWindow;
    visible: true;
    //    FontLoader { id: aFont; source: "file:///D:/qtworkspace/font/Source.ttf" }  字体无法载入，一直处于加载状态
    Resources.Operating{id:operating;}
    Resources.Aerialview{id:aerialview;}
    Resources.Alarm{id:alarm;}
    Resources.Audio{id:audio;}
    Resources.Inputnode{id:inputnode;}
    Resources.Outputnode{id:outputnode;}
    Resources.IPC{id:ipc;}
    Resources.Screenwall{id:screenwall;}
    Image {
        id: menuButton;
        source: "./Components/pictures/menu.png";
        height: 30;
        width: 30;
        anchors.top:parent.top;
        anchors.topMargin: 5;
        anchors.left: parent.left;
        anchors.leftMargin: 5;
        z:4;

        MouseArea{                            //menu botton,using pictures to make it easy to change it into logo type
            anchors.fill: menuButton;
            hoverEnabled: true;
            onClicked: {
                operating.visible=false;
                aerialview.visible=false;
                alarm.visible=false;
                audio.visible=false;
                inputnode.visible=false;
                outputnode.visible=false;
                ipc.visible=false;
                screenwall.visible=false;
                logo.visible=true;
                count=0;
                operatingWindow.source="./Components/pictures/Operating.png";
                aerialviewWindow.source="./Components/pictures/Aerialview.png";
                alarmWindow.source="./Components/pictures/Alarm.png";
                audioWindow.source="./Components/pictures/Audio.png";
                inputnodeWindow.source="./Components/pictures/Inputnode.png";
                outputnodeWindow.source="./Components/pictures/Outputnode.png";
                ipcWindow.source="./Components/pictures/IPC.png";
                screenwallWindow.source="./Components/pictures/Screenwall.png";
            }
            onEntered: {
                menuButton.source = "./Components/pictures/menuHover.png";
            }
            onExited: {
                menuButton.source = "./Components/pictures/menu.png";
            }
        }
    }
    Image {
        id: logo;
        source: "./Components/pictures/LOGO.png";    //pictures with texts
        visible: true;
        height: mainWindow.height/5.3;
        width:mainWindow.width/2.6;
        anchors.centerIn: parent;
        z:3;
    }
    property int count: 0;
    //Enter Operating
    Image {
        id: operatingWindow;
        source: "./Components/pictures/Operating.png";
        visible: true;
        height: 50;
        width: 85;
        anchors.left: menuButton.right;
        anchors.leftMargin: mainWindow.width/10;
        anchors.verticalCenter: menuButton.verticalCenter;
        z:3;
        MouseArea{
            anchors.fill: parent;
            hoverEnabled: true;
            onClicked: {
                operating.visible=true;
                aerialview.visible=false;
                alarm.visible=false;
                audio.visible=false;
                inputnode.visible=false;
                outputnode.visible=false;
                ipc.visible=false;
                screenwall.visible=false;
                logo.visible=false;
                operatingWindow.source="./Components/pictures/OperatingHover.png";
                aerialviewWindow.source="./Components/pictures/Aerialview.png";
                alarmWindow.source="./Components/pictures/Alarm.png";
                audioWindow.source="./Components/pictures/Audio.png";
                inputnodeWindow.source="./Components/pictures/Inputnode.png";
                outputnodeWindow.source="./Components/pictures/Outputnode.png";
                ipcWindow.source="./Components/pictures/IPC.png";
                screenwallWindow.source="./Components/pictures/Screenwall.png";
                count=1;
            }
            onEntered: {
                operatingWindow.source="./Components/pictures/OperatingHover.png";
            }
            onExited: {
                if(count===1){operatingWindow.source="./Components/pictures/OperatingHover.png";}
                else{operatingWindow.source="./Components/pictures/Operating.png";}
            }
        }
    }
    //Enter Aerialview
    Image {
        id: aerialviewWindow;
        source: "./Components/pictures/Aerialview.png";
        visible: true;
        height: 50;
        width: 85;
        anchors.left: operatingWindow.right;
        anchors.leftMargin: mainWindow.width/30;
        anchors.verticalCenter: menuButton.verticalCenter;
        z:3;
        MouseArea{
            anchors.fill: parent;
            hoverEnabled: true;
            onClicked: {
                operating.visible=false;
                aerialview.visible=true;
                alarm.visible=false;
                audio.visible=false;
                inputnode.visible=false;
                outputnode.visible=false;
                ipc.visible=false;
                screenwall.visible=false;
                logo.visible=false;
                operatingWindow.source="./Components/pictures/Operating.png";
                aerialviewWindow.source="./Components/pictures/AerialviewHover.png";
                alarmWindow.source="./Components/pictures/Alarm.png";
                audioWindow.source="./Components/pictures/Audio.png";
                inputnodeWindow.source="./Components/pictures/Inputnode.png";
                outputnodeWindow.source="./Components/pictures/Outputnode.png";
                ipcWindow.source="./Components/pictures/IPC.png";
                screenwallWindow.source="./Components/pictures/Screenwall.png";
                count=2;
            }
            onEntered: {
                aerialviewWindow.source="./Components/pictures/AerialviewHover.png";
            }
            onExited: {
                if(count===2){aerialviewWindow.source="./Components/pictures/AerialviewHover.png";}
                else{aerialviewWindow.source="./Components/pictures/Aerialview.png";}
            }
        }
    }
    //Enter Alarm
    Image {
        id: alarmWindow;
        source: "./Components/pictures/Alarm.png";
        visible: true;
        height: 50;
        width: 85;
        anchors.left: aerialviewWindow.right;
        anchors.leftMargin: mainWindow.width/30;
        anchors.verticalCenter: menuButton.verticalCenter;
        z:3;
        MouseArea{
            anchors.fill: parent;
            hoverEnabled: true;
            onClicked: {
                operating.visible=false;
                aerialview.visible=false;
                alarm.visible=true;
                audio.visible=false;
                inputnode.visible=false;
                outputnode.visible=false;
                ipc.visible=false;
                screenwall.visible=false;
                logo.visible=false;
                operatingWindow.source="./Components/pictures/Operating.png";
                aerialviewWindow.source="./Components/pictures/Aerialview.png";
                alarmWindow.source="./Components/pictures/AlarmHover.png";
                audioWindow.source="./Components/pictures/Audio.png";
                inputnodeWindow.source="./Components/pictures/Inputnode.png";
                outputnodeWindow.source="./Components/pictures/Outputnode.png";
                ipcWindow.source="./Components/pictures/IPC.png";
                screenwallWindow.source="./Components/pictures/Screenwall.png";
                count=3;
            }
            onEntered: {
                alarmWindow.source="./Components/pictures/AlarmHover.png";
            }
            onExited: {
                if(count===3){alarmWindow.source="./Components/pictures/AlarmHover.png";}
                else{alarmWindow.source="./Components/pictures/Alarm.png";}
            }
        }
    }
    //Enter Audio
    Image {
        id: audioWindow;
        source: "./Components/pictures/Audio.png";
        visible: true;
        height: 50;
        width: 85;
        anchors.left: ipcWindow.right;
        anchors.leftMargin: mainWindow.width/30;
        anchors.verticalCenter: menuButton.verticalCenter;
        z:3;
        MouseArea{
            anchors.fill: parent;
            hoverEnabled: true;
            onClicked: {
                operating.visible=false;
                aerialview.visible=false;
                alarm.visible=false;
                audio.visible=true;
                inputnode.visible=false;
                outputnode.visible=false;
                ipc.visible=false;
                screenwall.visible=false;
                logo.visible=false;
                operatingWindow.source="./Components/pictures/Operating.png";
                aerialviewWindow.source="./Components/pictures/Aerialview.png";
                alarmWindow.source="./Components/pictures/Alarm.png";
                audioWindow.source="./Components/pictures/AudioHover.png";
                inputnodeWindow.source="./Components/pictures/Inputnode.png";
                outputnodeWindow.source="./Components/pictures/Outputnode.png";
                ipcWindow.source="./Components/pictures/IPC.png";
                screenwallWindow.source="./Components/pictures/Screenwall.png";
                count=4;
            }
            onEntered: {
                audioWindow.source="./Components/pictures/AudioHover.png";
            }
            onExited: {
                if(count===4){audioWindow.source="./Components/pictures/AudioHover.png";}
                else{audioWindow.source="./Components/pictures/Audio.png";}
            }
        }
    }
    //Enter Inputnode
    Image {
        id: inputnodeWindow;
        source: "./Components/pictures/Inputnode.png";
        visible: true;
        height: 50;
        width: 85;
        anchors.left: screenwallWindow.right;
        anchors.leftMargin: mainWindow.width/30;
        anchors.verticalCenter: menuButton.verticalCenter;
        z:3;
        MouseArea{
            anchors.fill: parent;
            hoverEnabled: true;
            onClicked: {
                operating.visible=false;
                aerialview.visible=false;
                alarm.visible=false;
                audio.visible=false;
                inputnode.visible=true;
                outputnode.visible=false;
                ipc.visible=false;
                screenwall.visible=false;
                logo.visible=false;
                operatingWindow.source="./Components/pictures/Operating.png";
                aerialviewWindow.source="./Components/pictures/Aerialview.png";
                alarmWindow.source="./Components/pictures/Alarm.png";
                audioWindow.source="./Components/pictures/Audio.png";
                inputnodeWindow.source="./Components/pictures/InputnodeHover.png";
                outputnodeWindow.source="./Components/pictures/Outputnode.png";
                ipcWindow.source="./Components/pictures/IPC.png";
                screenwallWindow.source="./Components/pictures/Screenwall.png";
                count=5;
            }
            onEntered: {
                inputnodeWindow.source="./Components/pictures/InputnodeHover.png";
            }
            onExited: {
                if(count===5){inputnodeWindow.source="./Components/pictures/InputnodeHover.png";}
                else{inputnodeWindow.source="./Components/pictures/Inputnode.png";}
            }
        }
    }
    //Enter Outputnode
    Image {
        id: outputnodeWindow;
        source: "./Components/pictures/Outputnode.png";
        visible: true;
        height: 50;
        width: 85;
        anchors.left: inputnodeWindow.right;
        anchors.leftMargin: mainWindow.width/30;
        anchors.verticalCenter: menuButton.verticalCenter;
        z:3;
        MouseArea{
            anchors.fill: parent;
            hoverEnabled: true;
            onClicked: {
                operating.visible=false;
                aerialview.visible=false;
                alarm.visible=false;
                audio.visible=false;
                inputnode.visible=false;
                outputnode.visible=true;
                ipc.visible=false;
                screenwall.visible=false;
                logo.visible=false;
                operatingWindow.source="./Components/pictures/Operating.png";
                aerialviewWindow.source="./Components/pictures/Aerialview.png";
                alarmWindow.source="./Components/pictures/Alarm.png";
                audioWindow.source="./Components/pictures/Audio.png";
                inputnodeWindow.source="./Components/pictures/Inputnode.png";
                outputnodeWindow.source="./Components/pictures/OutputnodeHover.png";
                ipcWindow.source="./Components/pictures/IPC.png";
                screenwallWindow.source="./Components/pictures/Screenwall.png";
                count=6;
            }
            onEntered: {
                outputnodeWindow.source="./Components/pictures/OutputnodeHover.png";
            }
            onExited: {
                if(count===6){outputnodeWindow.source="./Components/pictures/OutputnodeHover.png";}
                else{outputnodeWindow.source="./Components/pictures/Outputnode.png";}
            }
        }
    }
    //Enter IPC
    Image {
        id: ipcWindow;
        source: "./Components/pictures/IPC.png";
        visible: true;
        height: 50;
        width: 85;
        anchors.left: outputnodeWindow.right;
        anchors.leftMargin: mainWindow.width/30;
        anchors.verticalCenter: menuButton.verticalCenter;
        z:3;
        MouseArea{
            anchors.fill: parent;
            hoverEnabled: true;
            onClicked: {
                operating.visible=false;
                aerialview.visible=false;
                alarm.visible=false;
                audio.visible=false;
                inputnode.visible=false;
                outputnode.visible=false;
                ipc.visible=true;
                screenwall.visible=false;
                logo.visible=false;
                operatingWindow.source="./Components/pictures/Operating.png";
                aerialviewWindow.source="./Components/pictures/Aerialview.png";
                alarmWindow.source="./Components/pictures/Alarm.png";
                audioWindow.source="./Components/pictures/Audio.png";
                inputnodeWindow.source="./Components/pictures/Inputnode.png";
                outputnodeWindow.source="./Components/pictures/Outputnode.png";
                ipcWindow.source="./Components/pictures/IPCHover.png";
                screenwallWindow.source="./Components/pictures/Screenwall.png";
                count=7;
            }
            onEntered: {
                ipcWindow.source="./Components/pictures/IPCHover.png";
            }
            onExited: {
                if(count===7){ipcWindow.source="./Components/pictures/IPCHover.png";}
                else{ipcWindow.source="./Components/pictures/IPC.png";}
            }
        }
    }
    //Enter Screenwall
    Image {
        id: screenwallWindow;
        source: "./Components/pictures/Screenwall.png";
        visible: true;
        height: 50;
        width: 85;
        anchors.left: alarmWindow.right;
        anchors.leftMargin: mainWindow.width/30;
        anchors.verticalCenter: menuButton.verticalCenter;
        z:3;
        MouseArea{
            anchors.fill: parent;
            hoverEnabled: true;
            onClicked: {
                operating.visible=false;
                aerialview.visible=false;
                alarm.visible=false;
                audio.visible=false;
                inputnode.visible=false;
                outputnode.visible=false;
                ipc.visible=false;
                screenwall.visible=true;
                logo.visible=false;
                operatingWindow.source="./Components/pictures/Operating.png";
                aerialviewWindow.source="./Components/pictures/Aerialview.png";
                alarmWindow.source="./Components/pictures/Alarm.png";
                audioWindow.source="./Components/pictures/Audio.png";
                inputnodeWindow.source="./Components/pictures/Inputnode.png";
                outputnodeWindow.source="./Components/pictures/Outputnode.png";
                ipcWindow.source="./Components/pictures/IPC.png";
                screenwallWindow.source="./Components/pictures/ScreenwallHover.png";
                count=8;
            }
            onEntered: {
                screenwallWindow.source="./Components/pictures/ScreenwallHover.png";
            }
            onExited: {
                if(count===8){screenwallWindow.source="./Components/pictures/ScreenwallHover.png";}
                else{screenwallWindow.source="./Components/pictures/Screenwall.png";}
            }
        }
    }
}
