import SwiftUI

@main
struct GlanceApp: App {

    var body: some Scene {

        MenuBarExtra("Glance", systemImage: "gauge.medium") {
            MonitorView()
        }
        .menuBarExtraStyle(.window)

        Settings {
            SettingsView()
        }
    }
}
