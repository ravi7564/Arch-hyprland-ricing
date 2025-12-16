import "../theme"
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

RowLayout {
    property int batteryPercent: 0
    property string batteryStatus: "Unknown"

    spacing: 4

    Process {
        id: batteryProc

        command: ["sh", "-c", "BAT1=$(ls /sys/class/power_supply | grep -i bat | head -n 1); if [ -n \"$BAT1\" ]; then CAP=$(cat /sys/class/power_supply/$BAT1/capacity); STAT=$(cat /sys/class/power_supply/$BAT1/status); echo \"$CAP|$STAT\"; else echo \"0|Unknown\"; fi"]

        stdout: SplitParser {
            onRead: (data) => {
                if (!data)
                    return ;

                var parts = data.trim().split("|");
                batteryPercent = parseInt(parts[0]) || 0;
                batteryStatus = parts[1] || "Unknown";
            }
        }

    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: batteryProc.running = true
    }

    Text {
        text: {
            if (batteryStatus === "Charging")
                return "󰂄";

            if (batteryPercent >= 80)
                return "󰁹";
            else if (batteryPercent >= 60)
                return "󰂁";
            else if (batteryPercent >= 40)
                return "󰁿";
            else if (batteryPercent >= 20)
                return "󰁽";
            return "󰂎";
        }
        color: Theme.green
        font.pixelSize: 15
        font.family: Theme.fontFamily
    }

    Text {
        text: batteryPercent + "%"
        color: Theme.green
        font.pixelSize: Theme.fontSize - 1
        font.family: Theme.fontFamily
    }

}
