import QtQuick
import Quickshell
import Quickshell.Io

FloatingWindow {
    id: fixture

    property string networkStatus: qsTr("Checking interfaces...")
    property string audioStatus: qsTr("Checking audio...")

    title: "phosphor-dev-fixture"
    implicitWidth: 300
    implicitHeight: 180
    color: "#252a30"

    Process {
        id: networkProcess
        command: ["sh", "-c", "nmcli -t -f DEVICE,TYPE,STATE device 2>/dev/null || echo 'NetworkManager unavailable'"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: fixture.networkStatus = text.trim() || qsTr("No NetworkManager devices")
        }
    }

    Process {
        id: audioProcess
        command: ["sh", "-c", "if info=$(pactl info 2>/dev/null); then printf '%s\\n' \"$info\" | grep '^Default Sink:' || echo 'No default audio sink'; else echo 'Audio server unavailable'; fi"]
        running: true
        stdout: StdioCollector {
            onStreamFinished: fixture.audioStatus = text.trim() || qsTr("Audio status unavailable")
        }
    }

    Timer {
        interval: 10000
        running: true
        repeat: true
        onTriggered: {
            if (!networkProcess.running) networkProcess.running = true
            if (!audioProcess.running) audioProcess.running = true
        }
    }

    Column {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8
        Text { color: "#aab2bb"; font.pixelSize: 11; text: qsTr("PHOSPHOR DEV FIXTURE") }
        Text { color: "#aab2bb"; font.pixelSize: 11; text: qsTr("NETWORK") }
        Text { color: "#c2c9d0"; font.pixelSize: 11; text: fixture.networkStatus; textFormat: Text.PlainText }
        Text { color: "#aab2bb"; font.pixelSize: 11; text: qsTr("SOUND") }
        Text { color: "#c2c9d0"; font.pixelSize: 11; text: fixture.audioStatus; textFormat: Text.PlainText; wrapMode: Text.Wrap; width: parent.width }
    }
}
