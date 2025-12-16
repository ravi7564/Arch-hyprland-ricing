import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import "../theme"

RowLayout {
    spacing: 6

    Repeater {
        model: 9
        Rectangle {
            Layout.preferredWidth: 26
            Layout.preferredHeight: 20
            Layout.alignment: Qt.AlignVCenter
            radius: 5

            property var workspace: Hyprland.workspaces.values.find(ws => ws.id === index + 1) ?? null
            property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
            property bool hasWindows: workspace !== null

            color: isActive ? Theme.cyan : (hasWindows ? Theme.bgLight : "transparent")
            opacity: isActive ? 0.25 : (hasWindows ? 0.4 : 0)

            Behavior on opacity { NumberAnimation { duration: 150 } }
            Behavior on color { ColorAnimation { duration: 150 } }

            Text {
                anchors.centerIn: parent
                text: index + 1
                color: parent.isActive ? Theme.cyan : (parent.hasWindows ? Theme.fg : Theme.muted)
                font.pixelSize: Theme.fontSize
                font.family: Theme.fontFamily
                font.bold: parent.isActive
            }

            // Active Indicator line
            Rectangle {
                width: parent.isActive ? 10 : 0
                height: 2
                radius: 1
                color: Theme.purple
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                Behavior on width { NumberAnimation { duration: 150 } }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch("workspace " + (index + 1))
            }
        }
    }
}