import QtQuick 2.5
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.2

ComboBox{
    id:comboBox;

    style: ComboBoxStyle{
        textColor:"white";
        background: Rectangle{
            implicitHeight: comboBox.height;
            color: "steelblue";
        }
        font:showText.font;
        label: Text {
            anchors.left: parent.left;
            width: parent.width ;
            height: parent.height;
            font: showText.font;
            verticalAlignment: Text.AlignVCenter;
            text: control.currentText;
            color: "white";
        }
    }

    Text{
        id:showText;
        text:"hello world";
        opacity: 0;
        font.family: qsTr("微软雅黑");
        font.pointSize: 12
        color:"white";
    }
}
