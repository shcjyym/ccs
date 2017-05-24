import QtQuick 2.0
import "./Model"

Item {
    id:viewer;
    width: aaa.wallrightw;
    height: aaa.wallrighth;
    x:aaa.wallrightx;
    y:aaa.wallrighty;
    z:5
    Screenwall{id:aaa;}

    TextNew {
        id: close;
        text: "重置网格视图";
        font.bold: false;
        x:-aaa.wallrightw/2+100;
        y:-25;
        MouseArea{
            anchors.fill: parent;
            onClicked: {
                viewer.destroy();
            }
        }
    }
}
