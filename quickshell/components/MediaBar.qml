import "../theme"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

Item {
    // --- Processes ---
    // --- UI Layout ---

    property string activeWindow: "Desktop"
    property string mediaTitle: ""
    property string mediaArtist: ""
    property string mediaStatus: ""
    property bool isMediaPlaying: false

    // Allows this component to fill the center space
    Layout.fillWidth: true
    Layout.fillHeight: true

    // Active Window Logic
    Process {
        id: windowProc

        command: ["sh", "-c", "hyprctl activewindow -j | jq -r 'if .workspace.id == -1 or .address == \"0x0\" then \"empty\" else .title // \"empty\" end'"]

        stdout: SplitParser {
            onRead: (data) => {
                if (data && data.trim()) {
                    var title = data.trim();
                    if (title === "qs" || title === "Quickshell" || title === "" || title === "empty")
                        activeWindow = "Desktop";
                    else
                        activeWindow = title;
                } else {
                    activeWindow = "Desktop";
                }
            }
        }

    }

    // Media Metadata Logic
    Process {
        id: mediaProc

        command: ["sh", "-c", "playerctl metadata --format '{{status}}|{{title}}|{{artist}}' 2>/dev/null || echo 'Stopped||'"]

        stdout: SplitParser {
            onRead: (data) => {
                if (!data) {
                    isMediaPlaying = false;
                    return ;
                }
                var parts = data.trim().split('|');
                mediaStatus = parts[0] || "";
                mediaTitle = parts[1] || "";
                mediaArtist = parts[2] || "";
                isMediaPlaying = (mediaStatus === "Playing" || mediaStatus === "Paused") && mediaTitle !== "";
            }
        }

    }

    Process {
        id: mediaPlayPauseProc

        command: ["playerctl", "play-pause"]
    }

    // Timers & Connections
    Timer {
        interval: 200
        running: true
        repeat: true
        onTriggered: windowProc.running = true
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: mediaProc.running = true
    }

    Connections {
        function onRawEvent(event) {
            windowProc.running = true;
        }

        target: Hyprland
    }

    RowLayout {
        anchors.fill: parent
        spacing: 6

        // 1. Active Window Section
        Rectangle {
            Layout.fillWidth: isMediaPlaying ? false : true
            Layout.preferredWidth: isMediaPlaying ? parent.width / 2 - 3 : parent.width
            Layout.fillHeight: true
            radius: 6
            color: Theme.bgLight
            opacity: 0.5

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                spacing: 6

                Text {
                    text: "󱂬"
                    color: Theme.purple
                    font.pixelSize: 15
                    font.family: Theme.fontFamily
                }

                Text {
                    text: activeWindow
                    color: Theme.fg
                    font.pixelSize: Theme.fontSize
                    font.family: Theme.fontFamily
                    font.bold: true
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }

            }

        }

        // 2. Media Player Section
        Rectangle {
            visible: isMediaPlaying
            Layout.preferredWidth: isMediaPlaying ? parent.width / 2 - 3 : 0
            Layout.fillHeight: true
            radius: 6
            color: Theme.bgLight
            opacity: isMediaPlaying ? 0.5 : 0

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 10
                anchors.rightMargin: 10
                spacing: 8

                Text {
                    text: "󰎈"
                    color: Theme.green
                    font.pixelSize: 14
                    font.family: Theme.fontFamily
                }

                Text {
                    text: {
                        if (mediaTitle && mediaArtist)
                            return mediaTitle + " - " + mediaArtist;
                        else if (mediaTitle)
                            return mediaTitle;
                        else
                            return "No Media";
                    }
                    color: Theme.fg
                    font.pixelSize: Theme.fontSize - 1
                    font.family: Theme.fontFamily
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }

                // Play/Pause Button
                Rectangle {
                    Layout.preferredWidth: 24
                    Layout.preferredHeight: 24
                    radius: 4
                    color: Theme.cyan
                    opacity: 0.2

                    Text {
                        text: mediaStatus === "Playing" ? "󰏤" : "󰐊"
                        color: Theme.cyan
                        font.pixelSize: 14
                        font.family: Theme.fontFamily
                        anchors.centerIn: parent
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: mediaPlayPauseProc.running = true
                    }

                }

            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                }

            }

        }

    }

}
