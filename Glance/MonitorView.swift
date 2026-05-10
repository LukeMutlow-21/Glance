import SwiftUI
import AppKit

struct MonitorView: View {

    @StateObject private var stats = SystemStats()

    @AppStorage("warnThreshold") private var warnThreshold = 60.0
    @AppStorage("critThreshold") private var critThreshold = 80.0

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            header

            StatRow(
                icon: "cpu",
                label: "CPU",
                value: String(format: "%.1f%%", stats.cpuUsage),
                color: colorFor(stats.cpuUsage)
            )

            StatRow(
                icon: "memorychip",
                label: "RAM",
                value: String(
                    format: "%.1f / %.0f GB",
                    stats.ramUsed,
                    stats.ramTotal
                ),
                color: colorFor(
                    (stats.ramUsed / max(stats.ramTotal, 1)) * 100
                )
            )

            StatRow(
                icon: "internaldrive",
                label: "Storage",
                value: String(format: "%.0f GB free", stats.diskFree)
            )

            StatRow(
                icon: "arrow.down.circle",
                label: "Network ↓",
                value: String(format: "%.0f KB/s", stats.netDownload)
            )

            StatRow(
                icon: "arrow.up.circle",
                label: "Network ↑",
                value: String(format: "%.0f KB/s", stats.netUpload)
            )

            StatRow(
                icon: "network",
                label: "Ping",
                value: pingLabel(stats.pingMs),
                color: pingColor(stats.pingMs)
            )

            Divider()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.plain)
            .foregroundColor(.secondary)
            .frame(maxWidth: .infinity)
        }
        .padding()
        .frame(width: 260)
    }

    // MARK: - Header

    private var header: some View {
        HStack {
            Image(systemName: "gauge.medium")
                .foregroundColor(.accentColor)

            Text("Glance")
                .font(.headline)

            Spacer()

            SettingsLink {
                Image(systemName: "gearshape")
            }
            .buttonStyle(.plain)

            Button(action: openAbout) {
                Image(systemName: "info.circle")
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Helpers

    private func openAbout() {
        NSApp.sendAction(
            #selector(NSApplication.orderFrontStandardAboutPanel(_:)),
            to: nil,
            from: nil
        )
    }

    private func colorFor(_ value: Double) -> Color {
        if value >= critThreshold { return .red }
        if value >= warnThreshold { return .orange }
        return .primary
    }

    private func pingLabel(_ ms: Double?) -> String {
        guard let ms else { return "—" }
        if ms < 0 { return "Timeout" }
        return String(format: "%.0f ms", ms)
    }

    private func pingColor(_ ms: Double?) -> Color {
        guard let ms, ms >= 0 else { return .secondary }
        if ms >= 200 { return .red }
        if ms >= 80  { return .orange }
        return .primary
    }
}

// MARK: - StatRow

struct StatRow: View {
    let icon: String
    let label: String
    let value: String
    var color: Color = .primary

    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 20)
                .foregroundColor(.accentColor)

            Text(label)
                .foregroundColor(.secondary)

            Spacer()

            Text(value)
                .monospacedDigit()
                .fontWeight(.medium)
                .foregroundColor(color)
        }
    }
}
