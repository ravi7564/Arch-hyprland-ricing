import "../theme"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

RowLayout {
    // --- Processes ---
    // --- UI Layout ---

    // Properties for UI binding
    property int cpuUsage: 0
    property int memUsage: 0
    property int diskUsage: 0
    property int volumeLevel: 0
    // Internal tracking variables
    property var lastCpuIdle: 0
    property var lastCpuTotal: 0

    spacing: 10

    // CPU Process
    Process {
        id: cpuProc

        command: ["sh", "-c", "head -1 /proc/stat"]

        stdout: SplitParser {
            onRead: (data) => {
                if (!data)
                    return ;

                var parts = data.trim().split(/\s+/);
                var user = parseInt(parts[1]) || 0;
                var nice = parseInt(parts[2]) || 0;
                var system = parseInt(parts[3]) || 0;
                var idle = parseInt(parts[4]) || 0;
                var iowait = parseInt(parts[5]) || 0;
                var irq = parseInt(parts[6]) || 0;
                var softirq = parseInt(parts[7]) || 0;
                var total = user + nice + system + idle + iowait + irq + softirq;
                var idleTime = idle + iowait;
                if (lastCpuTotal > 0) {
                    var totalDiff = total - lastCpuTotal;
                    var idleDiff = idleTime - lastCpuIdle;
                    if (totalDiff > 0)
                        cpuUsage = Math.round(100 * (totalDiff - idleDiff) / totalDiff);

                }
                lastCpuTotal = total;
                lastCpuIdle = idleTime;
            }
        }

    }

    // Memory Process
    Process {
        id: memProc

        command: ["sh", "-c", "free | grep Mem"]

        stdout: SplitParser {
            onRead: (data) => {
                if (!data)
                    return ;

                var parts = data.trim().split(/\s+/);
                var total = parseInt(parts[1]) || 1;
                var used = parseInt(parts[2]) || 0;
                memUsage = Math.round(100 * used / total);
            }
        }

    }

    // Disk Process
    Process {
        id: diskProc

        command: ["sh", "-c", "df / | tail -1"]

        stdout: SplitParser {
            onRead: (data) => {
                if (!data)
                    return ;

                var parts = data.trim().split(/\s+/);
                var percentStr = parts[4] || "0%";
                diskUsage = parseInt(percentStr.replace('%', '')) || 0;
            }
        }

    }

    // Volume Process
    Process {
        id: volProc

        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]

        stdout: SplitParser {
            onRead: (data) => {
                if (!data)
                    return ;

                var match = data.match(/Volume:\s*([\d.]+)/);
                if (match)
                    volumeLevel = Math.round(parseFloat(match[1]) * 100);

            }
        }

    }

    // Master Timer
    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            cpuProc.running = true;
            memProc.running = true;
            diskProc.running = true;
            volProc.running = true;
        }
    }

    // CPU
    RowLayout {
        spacing: 4

        Text {
            text: "󰻠"
            color: Theme.yellow
            font.pixelSize: 14
            font.family: Theme.fontFamily
        }

        Text {
            text: cpuUsage + "%"
            color: Theme.yellow
            font.pixelSize: Theme.fontSize - 1
            font.family: Theme.fontFamily
        }

    }

    // Memory
    RowLayout {
        spacing: 4

        Text {
            text: "󰍛"
            color: Theme.cyan
            font.pixelSize: 14
            font.family: Theme.fontFamily
        }

        Text {
            text: memUsage + "%"
            color: Theme.cyan
            font.pixelSize: Theme.fontSize - 1
            font.family: Theme.fontFamily
        }

    }

    // Disk
    RowLayout {
        spacing: 4

        Text {
            text: "󰋊"
            color: Theme.blue
            font.pixelSize: 14
            font.family: Theme.fontFamily
        }

        Text {
            text: diskUsage + "%"
            color: Theme.blue
            font.pixelSize: Theme.fontSize - 1
            font.family: Theme.fontFamily
        }

    }

    // Volume
    RowLayout {
        spacing: 4

        Text {
            text: "󰕾"
            color: Theme.purple
            font.pixelSize: 14
            font.family: Theme.fontFamily
        }

        Text {
            text: volumeLevel + "%"
            color: Theme.purple
            font.pixelSize: Theme.fontSize - 1
            font.family: Theme.fontFamily
        }

    }

}
