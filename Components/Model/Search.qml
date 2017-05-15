import QtQuick 2.5
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.2


Item {    
        id:component;
        visible: true;
        height: 25;
        width: 200;
        property alias text: search.text
        property alias placeholdtext: placehold.text

        ColorAnimation {
            id:change1;
            target:button;
            property: "color";
            from: "lightgrey"
            to: "grey"
            duration: 200;
            running: false;
        }
        ColorAnimation {
            id:change2;
            target:button;
            property: "color";
            from: "grey"
            to: "lightgrey"
            duration: 200;
            running: false;
        }

        Rectangle{
            anchors.fill: parent
            radius: 6
            opacity: 0.2
        }
        TextInput{
            id:search;
            anchors.fill:parent;
            horizontalAlignment: TextInput.AlignLeft
            verticalAlignment: TextInput.AlignVCenter
            font.pixelSize: 18;
            font.family:  qsTr("微软雅黑");
            color: "white";
            clip: true ;
            Text {
                id: placehold;
                font.family:  qsTr("微软雅黑");
                color: "white";
                opacity: !search.activeFocus;
                Behavior on opacity{
                    NumberAnimation{ duration: 300 ;}
                }
                anchors.fill: parent
                verticalAlignment: TextInput.AlignVCenter
            }
        }
        Rectangle{
            id:button;
            height: 30;
            width: 30;
            color:"lightgrey";
            anchors.left: parent.right;
            anchors.leftMargin: 10;
            anchors.verticalCenter: parent.verticalCenter;
            opacity: 0.2;
            radius: 15;
            MouseArea{
                anchors.fill:parent;
                hoverEnabled: true;
                onClicked: {search.text="";}
                onEntered: {change1.running=true;}
                onExited: {change2.running=true;}
            }
        }
        Image {
            id: button1t
            source:"./picture/search.png"
            anchors.centerIn: button;
        }
}

