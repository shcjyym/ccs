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

    Rectangle{
        id:screenwall_right;
        width: operating.width-operating_left.width-40;
        height: operating_left.height-40;
        color: "lightgrey";
        anchors.top: operating_left.top;
        anchors.topMargin: 20;
        anchors.left: operating_left.right;
        anchors.leftMargin: 20;
        opacity: 0.3;
    }

    Rectangle{
        id:signallist;
        height: 30;
        width: operating_left.width;
        anchors.top:operating_left.top;
        anchors.left: operating_left.left;
        color: "steelblue";
        opacity: 0.5;
    }
    TextNew {
        id: signallist_text
        text: "信号列表";
        font.pixelSize: 20;
        font.bold: false;
        anchors.centerIn: signallist;
    }

    Search{
        id:signal_search;
        anchors.top:signallist.bottom;
        anchors.left: signallist.left;
        anchors.topMargin: 15;
        anchors.leftMargin: 5;
    }
}
