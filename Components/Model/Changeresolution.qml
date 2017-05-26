import QtQuick 2.5
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.2


ApplicationWindow{
    id:changeResolution;
    width: 250;
    height: 150;
    flags:Qt.Dialog;
    title: "屏幕划分";

    property string width_item: width_field.text;
    property string height_item: height_field.text;

    Rectangle{
        id:seg_back;
        anchors.fill: parent;
        opacity: 0;
    }

    Buttoncolorchange{
        id:confirm;
        height: 30;
        width: 100
        text: "确认";
        anchors.top: width_field.bottom;
        anchors.topMargin : 20;
        anchors.horizontalCenter : seg_back.horizontalCenter;
        MouseArea{
            anchors.fill: parent;
            onClicked: {
            console.debug("width:",width_field.text);
            console.debug("height:",height_field.text);
            change_resolution();
            changeResolution.close();
            }
        }
     }

     TextFieldNew{
         id:width_field
         anchors.top: seg_back.top;
         anchors.topMargin: 20;
         anchors.left : seg_back.left;
         anchors.leftMargin: 25;
         width: 80
     }

     TextNew{
         text: "X";
         anchors.left: width_field.right;
         anchors.leftMargin: 12.5;
         anchors.verticalCenter: width_field.verticalCenter;
     }

     TextFieldNew{
         id:height_field
         anchors.top: seg_back.top;
         anchors.topMargin : 20;
         anchors.right:seg_back.right;
         anchors.rightMargin: 25;
         width: 80
     }

}
