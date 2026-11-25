import Quickshell
import Quickshell.Io
import QtQuick

FloatingWindow {
    id: fixture
    title: "phosphor-dev-fixture"
    implicitWidth: 300
    implicitHeight: 180
    color: "#252a30"

    property string network_status: qsTr("Checking interfaces...")
    property string audio_status: qsTr("Checking audio...")

    Process {
        id: network_process
        command: ["sh", "-c", "nmcli -t -f DEVICE,TYPE,STATE device 2>/dev/null || echo 'NetworkManager unavailable'"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: fixture.network_status = text.trim() || qsTr("No NetworkManager devices")
        }
    }

    Process {
        id: audio_process
        command: ["sh", "-c", "if info=$(pactl info 2>/dev/null); then printf '%s\\n' \"$info\" | grep '^Default Sink:' || echo 'No default audio sink'; else echo 'Audio server unavailable'; fi"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: fixture.audio_status = text.trim() || qsTr("Audio status unavailable")
        }
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: {
            if (!network_process.running) network_process.running = true
            if (!audio_process.running) audio_process.running = true
        }
    }

    Column {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8
        Text { color: "#aab2bb"; font.pixelSize: 11; text: qsTr("PHOSPHOR DEV FIXTURE") }
        Text { color: "#aab2bb"; font.pixelSize: 11; text: qsTr("NETWORK") }
        Text { color: "#c2c9d0"; font.pixelSize: 11; text: fixture.network_status }
        Text { color: "#aab2bb"; font.pixelSize: 11; text: qsTr("SOUND") }
        Text { color: "#c2c9d0"; font.pixelSize: 11; text: fixture.audio_status; wrapMode: Text.Wrap; width: parent.width }
    }
}
