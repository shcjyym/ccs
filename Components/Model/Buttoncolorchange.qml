import QtQuick 2.5
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.2

Item {
    id:button_colorchange;
    visible: true;
    property alias text: button_colortext.text;
    ColorAnimation {
        id:change1;
        target: button_color
        property: "color";
        from: "lightgrey"
        to: "grey"
        duration: 200;
        running: false;
    }
    ColorAnimation {
        id:change2;
        target: button_color
        property: "color";
        from: "grey"
        to: "lightgrey"
        duration: 200;
        running: false;
    }
    Rectangle{
        id:button_color;
        height: 30;
        width: 100;
        color:"lightgrey";
        opacity: 0.5;
        radius: 10;
        MouseArea{
            anchors.fill:parent;
            hoverEnabled: true;
            onEntered:{change1.running=true;}
            onExited:{change2.running=true;}
        }
    }
    TextNew {
        id: button_colortext;
        anchors.centerIn: button_color;
        font.pixelSize: 20;
        }
}

