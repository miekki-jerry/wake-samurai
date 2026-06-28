import Foundation
import ServiceManagement

@MainActor
enum LoginItemController {
    static var isEnabled: Bool {
        get {
            SMAppService.mainApp.status == .enabled
        }
        set {
            do {
                if newValue {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                NSLog("WakeSamurai login item update failed: \(error.localizedDescription)")
            }
        }
    }
}
