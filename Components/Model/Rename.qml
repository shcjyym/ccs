import QtQuick 2.5
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.2

ApplicationWindow{
    id:rename;
    width: 250;
    height: 150;
    flags:Qt.Dialog;
    title: "改名";

    property string text_item;
    signal rename_clicked(string msg)

    Component.onCompleted: {
        // at begin of window load, the key focus was in window
        dialog.requestActivate();
    }
    Rectangle{
        id:seg_back;
        anchors.fill: parent;
        opacity: 0;
    }
    TextNew {
        id: text;
        text: "名称:";
        font.pixelSize: 20;
        font.bold: false;
        color: "black";
        anchors.left: seg_back.left;
        anchors.leftMargin : 10;
        anchors.top: seg_back.top;
        anchors.topMargin: 20
    }

    Buttoncolorchange{
        id:confirm;
        height: 30;
        width: 100
        text: "确认";
        anchors.top: text_field.bottom;
        anchors.topMargin : 20;
        anchors.horizontalCenter: seg_back.horizontalCenter ;
        MouseArea{
            anchors.fill: parent;
            onClicked: {
                text_item=text_field.text;
                rename.rename_clicked(text_field.text);
                rename.close();
            }
        }
     }

     TextFieldNew{
         id:text_field
         anchors.left: text.right;
         anchors.leftMargin : 10;
         anchors.verticalCenter: text.verticalCenter;
     }

}
