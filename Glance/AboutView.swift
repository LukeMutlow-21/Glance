import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss

    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    private var buildNumber: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }

    private var copyrightYear: String {
        let year = Calendar.current.component(.year, from: Date())
        return "\(year)"
    }

    var body: some View {
        VStack(spacing: 16) {
            if let iconImage = NSImage(named: "AppIcon") {
                Image(nsImage: iconImage)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            } else {
                Image(systemName: "gauge.medium")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.accentColor)
            }

            Text("Glance")
                .font(.title2)
                .fontWeight(.bold)

            Text("Version \(appVersion) (\(buildNumber))")
                .font(.subheadline)
                .foregroundColor(.secondary)

            Text("© \(copyrightYear) Luke Mutlow. All rights reserved.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button("Close") { dismiss() }
                .buttonStyle(.borderedProminent)
                .padding(.top, 4)
        }
        .padding(32)
        .frame(width: 300)
    }
}
