import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Controls.Styles 1.3

TextField {
    id:textField;
    implicitWidth: 150;
    implicitHeight: showText.height+10;
    height: showText.height+10;

    style: TextFieldStyle {
        textColor: showText.color;
        background: Rectangle {
            implicitWidth: 100
            implicitHeight: 24
        }
        placeholderTextColor:"#ccc";
        font:showText.font;
    }
    Text{
        id:showText;
        text:"hello world";
        opacity: 0;
        font.family: qsTr("微软雅黑");
        font.pointSize: 15;
    }
}
