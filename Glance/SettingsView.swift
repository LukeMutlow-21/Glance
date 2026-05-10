import SwiftUI

struct SettingsView: View {

    @AppStorage("launchAtLogin") private var launchAtLogin = true
    @AppStorage("refreshRate")   private var refreshRate   = 1.0
    @AppStorage("warnThreshold") private var warn          = 60.0
    @AppStorage("critThreshold") private var crit          = 80.0
    @AppStorage("pingHost")      private var pingHost      = "8.8.8.8"

    var body: some View {
        Form {

            // MARK: General
            Section {
                Toggle("Launch at login", isOn: $launchAtLogin)
            } header: {
                Text("General")
            }

            // MARK: Refresh rate
            Section {
                Picker("Update frequency", selection: $refreshRate) {
                    Text("0.5 seconds").tag(0.5)
                    Text("1 second").tag(1.0)
                    Text("2 seconds").tag(2.0)
                    Text("5 seconds").tag(5.0)
                    Text("10 seconds").tag(10.0)
                }
                .pickerStyle(.radioGroup)
            } header: {
                Text("Refresh rate")
            } footer: {
                Text("How often system statistics are updated.")
            }

            // MARK: Colour thresholds
            Section {
                thresholdRow(
                    title: "Amber warning",
                    value: $warn
                )

                thresholdRow(
                    title: "Red warning",
                    value: $crit
                )
            } header: {
                Text("Colour thresholds")
            } footer: {
                Text("Change colours when usage exceeds these values.")
            }

            // MARK: Ping
            Section {
                HStack {
                    Text("Host")
                    Spacer()
                    TextField("e.g. 8.8.8.8", text: $pingHost)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 160)
                }
            } header: {
                Text("Ping")
            } footer: {
                Text("Hostname or IP address to ping each refresh cycle.")
            }
        }
        .formStyle(.grouped)
        .controlSize(.regular)
        .padding(20)
        .frame(width: 400)
    }

    // MARK: - Helpers

    @ViewBuilder
    private func thresholdRow(
        title: String,
        value: Binding<Double>
    ) -> some View {
        HStack {
            Text(title)

            Spacer()

            Text("\(Int(value.wrappedValue))%")
                .foregroundColor(.secondary)
                .monospacedDigit()

            Stepper("", value: value, in: 0...100, step: 5)
                .labelsHidden()
        }
    }
}
