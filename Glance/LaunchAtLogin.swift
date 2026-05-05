import Foundation
import Combine
import ServiceManagement

class LaunchAtLogin: ObservableObject {
    @Published var isEnabled: Bool {
        didSet {
            if isEnabled {
                try? SMAppService.mainApp.register()
            } else {
                try? SMAppService.mainApp.unregister()
            }
        }
    }

    init() {
        isEnabled = SMAppService.mainApp.status == .enabled
    }
}
