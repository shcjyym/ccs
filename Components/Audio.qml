import QtQuick 2.5
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.2
import QtQuick.Dialogs 1.2
import "./Model"

Item {
    id:audio;
    visible: false;
    anchors.fill: parent;
    z:4;

    Rectangle {
        width: 200; height: 200
        color: "red"
        z:4
        Drag.active: dragArea.drag.active


        MouseArea {
            id: dragArea
            anchors.fill: parent
            drag.target: parent
        }
    }
}
