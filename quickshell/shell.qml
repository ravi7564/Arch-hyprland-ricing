import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "./theme"
import "./components"

ShellRoot {
    id: root

    // --- Global Processes (Launchers & Tools) ---
    Process {
        id: rofiProc
        command: ["sh", "-c", "~/.config/rofi/launchers/type-1/launcher.sh"]
    }

    Process {
        id: powerProc
        command: ["sh", "-c", "~/.config/rofi/powermenu/type-1/powermenu.sh"]
    }

    Process {
        id: notifProc
        command: ["swaync-client", "-t"]
    }

    Variants {
        model: Quickshell.screens

        PanelWindow {
            property var modelData
            screen: modelData

            anchors { top: true; left: true; right: true }
            implicitHeight: 36
            color: "transparent"
            margins { top: 4; left: 6; right: 6; bottom: 0 }

            Rectangle {
                anchors.fill: parent
                radius: 10
                color: Theme.bg
                opacity: 0.95
                border.color: Qt.rgba(0.4, 0.5, 0.7, 0.2)
                border.width: 1

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 6
                    spacing: 8

                    // ==============================
                    // LEFT SECTION: Logo & Workspaces
                    // ==============================
                    Rectangle {
                        Layout.fillHeight: true
                        Layout.preferredWidth: leftContent.width + 16
                        radius: 6
                        color: Theme.bgLight
                        opacity: 0.5

                        RowLayout {
                            id: leftContent
                            anchors.centerIn: parent
                            spacing: 6

                            Item {
                                Layout.preferredWidth: 20; Layout.preferredHeight: 20
                                Text {
                                    text: "󰣇"; color: Theme.cyan; font.pixelSize: 16
                                    font.family: Theme.fontFamily
                                    anchors.centerIn: parent
                                }
                                MouseArea {
                                    anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                    onClicked: rofiProc.running = true
                                }
                            }

                            Rectangle { width: 1; height: 14; color: Theme.muted; opacity: 0.5 }
                            Workspaces {}
                        }
                    }

                    // ======================================
                    // CENTER SECTION: Media & Active Window
                    // ======================================
                    MediaBar {}

                    // ========================================================
                    // RIGHT SECTION: Stats -> Clock -> Notif -> Battery -> Power
                    // ========================================================
                    Rectangle {
                        Layout.fillHeight: true
                        Layout.preferredWidth: rightContent.width + 16
                        radius: 6
                        color: Theme.bgLight
                        opacity: 0.5

                        RowLayout {
                            id: rightContent
                            anchors.centerIn: parent
                            spacing: 10

                            // 1. System Stats (CPU, RAM, Disk, Vol)
                            SystemStats {}

                            Rectangle { width: 1; height: 14; color: Theme.muted; opacity: 0.5 }

                            // 2. Clock Widget (Moved here)
                            Clock {}

                            Rectangle { width: 1; height: 14; color: Theme.muted; opacity: 0.5 }

                            // 3. Notification Button (Before Battery)
                            Item {
                                Layout.preferredWidth: 24; Layout.preferredHeight: 20
                                Text {
                                    text: "󰍡"; color: Theme.purple; font.pixelSize: 16
                                    font.family: Theme.fontFamily
                                    anchors.centerIn: parent
                                }
                                MouseArea {
                                    anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                    onClicked: notifProc.running = true
                                }
                            }

                            // 4. Battery Widget (Before Power)
                            Battery {}

                            Rectangle { width: 1; height: 14; color: Theme.muted; opacity: 0.5 }

                            // 5. Power Button (Last)
                            Item {
                                Layout.preferredWidth: 24; Layout.preferredHeight: 20
                                Text {
                                    text: "⏻"; color: Theme.red; font.pixelSize: 16
                                    font.family: Theme.fontFamily
                                    anchors.centerIn: parent
                                }
                                MouseArea {
                                    anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                    onClicked: powerProc.running = true
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}