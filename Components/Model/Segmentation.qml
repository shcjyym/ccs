import QtQuick 2.5
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.2



//分割模块开始
    ApplicationWindow{
        id:segmentation;
        width: 250;
        height: 200;
        flags:Qt.Dialog;
        title: "屏幕划分";

        property string row_item: row_field.text;
        property string column_item: column_field.text;
        signal text_change();

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
            id: row_text;
            text: "行:";
            font.pixelSize: 20;
            font.bold: false;
            color: "black";
            anchors.right: row_field.left;
            anchors.rightMargin: 5;
            anchors.verticalCenter: row_field.verticalCenter;
        }
        TextNew {
            id: column_text;
            text: "列:";
            font.pixelSize: 20;
            font.bold: false;
            color: "black";
            anchors.right: column_field.left;
            anchors.rightMargin: 5;
            anchors.verticalCenter: column_field.verticalCenter;
        }
        Buttoncolorchange{
            id:confirm;
            height: 30;
            width: 100
            text: "确认";
            anchors.top: column_field.bottom;
            anchors.topMargin : 20;
            anchors.horizontalCenter : seg_back.horizontalCenter;
            MouseArea{
                anchors.fill: parent;
                onClicked: {
                console.debug("row:",row_field.text);
                console.debug("column:",column_field.text);
                create();
                text_change();
                segmentation.close();
                }
            }
         }

         TextFieldNew{
             id:row_field
             anchors.top: seg_back.top;
             anchors.topMargin: 20;
             anchors.horizontalCenter : seg_back.horizontalCenter;
         }

         TextFieldNew{
             id:column_field
             anchors.top: row_field.bottom;
             anchors.topMargin : 20;
             anchors.horizontalCenter : seg_back.horizontalCenter;
         }

}
//分割模块结束
