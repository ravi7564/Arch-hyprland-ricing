import QtQuick
import QtQuick.Layouts
import "../theme"

RowLayout {
    spacing: 4

    Text {
        text: "󰥔"
        color: Theme.green
        font.pixelSize: 14
        font.family: Theme.fontFamily
    }

    Text {
        id: clockText
        text: Qt.formatDateTime(new Date(), "MMM dd • HH:mm")
        color: Theme.fg
        font.pixelSize: Theme.fontSize
        font.family: Theme.fontFamily
        font.bold: true

        Timer {
            interval: 1000; running: true; repeat: true
            onTriggered: clockText.text = Qt.formatDateTime(new Date(), "MMM dd • HH:mm")
        }
    }
}