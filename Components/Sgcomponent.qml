import QtQuick 2.0
import "./Model"

Item {
    id:viewer;
    width: aaa.wallrightw;
    height: aaa.wallrighth;
    x:bbb.oprightx;
    y:bbb.oprighty;
    z:5
    Screenwall{id:aaa;}
    Operating{id:bbb;}
    TextNew {
        id: close;
        text: "重置网格视图";
        font.bold: false;
        x:-aaa.wallrightw/2;
        y:-25;
        MouseArea{
            anchors.fill: parent;
            onClicked: {
                viewer.destroy();
            }
        }
    }
}
