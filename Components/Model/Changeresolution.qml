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
    title: "mac地址更改";
    color:"gray"

    ///property string width_item: width_field.text;
    //property string height_item: height_field.text;

    property string strMac1:""
    property string strMac2:""
    property string strMac3:""
    property string strMac4:""
    property string strMac5:""
    property string strMac6:""
    property string strMac:""

    property int fieldLen:40

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
        anchors.top: mac1.bottom;
        anchors.topMargin : 20;
        anchors.horizontalCenter : seg_back.horizontalCenter;
        MouseArea{
            anchors.fill: parent;
            onClicked: {
            //console.debug("width:",width_field.text);
            //console.debug("height:",height_field.text);
            strMac1 = mac1.text;
            strMac2 = mac2.text
            strMac3 = mac3.text
            strMac4 = mac4.text
            strMac5 = mac5.text
            strMac6 = mac6.text
            strMac = strMac1+"-"+strMac2+"-"+strMac3+"-"+strMac4+"-"+strMac5+"-"+strMac6

            change_resolution();
            changeResolution.close();
            }
        }
     }

     TextFieldNew{
         id:mac1
         anchors.top: seg_back.top;
         anchors.topMargin: 20;
         anchors.left : seg_back.left;
         //anchors.leftMargin: 25;
         width: 40
     }
/*
     TextNew{
         text: "X";
         anchors.left: width_field.right;
         anchors.leftMargin: 12.5;
         anchors.verticalCenter: width_field.verticalCenter;
     }
*/
     TextFieldNew{
         id:mac2
         anchors.top: seg_back.top;
         anchors.topMargin : 20;
         //anchors.left: (40+3)*2;
         x:(40+3);
         //anchors.rightMargin: 25;
         width: 40
     }
     TextFieldNew{
         id:mac3
         anchors.top: seg_back.top;
         anchors.topMargin : 20;
         //anchors.left:(40+3)*3;
         x:(40+3)*2
         //anchors.rightMargin: 25;
         width: 40
     }
     TextFieldNew{
         id:mac4
         anchors.top: seg_back.top;
         anchors.topMargin : 20;
         //anchors.left:mac3.right+3;
         //anchors.rightMargin: 25;
         x:(40+3)*3
         width: 40
     }
     TextFieldNew{
         id:mac5
         anchors.top: seg_back.top;
         anchors.topMargin : 20;
         //anchors.left:(40+3)*4;
         x:(40+3)*4
         //anchors.rightMargin: 25;
         width: 40
     }
     TextFieldNew{
         id:mac6
         anchors.top: seg_back.top;
         anchors.topMargin : 20;
         //anchors.left:(40+3)*5;
         //anchors.rightMargin: 25;
         x:(40+3)*5
         width: 40
     }

}
