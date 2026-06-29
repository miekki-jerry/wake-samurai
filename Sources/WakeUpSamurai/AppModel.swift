import WakeUpSamuraiCore
import Combine
import Foundation

@MainActor
final class AppModel: ObservableObject {
    @Published var detectedAgents: [DetectedAgent] = []
    @Published var lastUpdated: Date?
    @Published var isProtectionEnabled = true {
        didSet {
            updateSleepAssertion()
        }
    }
    @Published var startsAtLogin = LoginItemController.isEnabled {
        didSet {
            LoginItemController.isEnabled = startsAtLogin
        }
    }

    private let detector = AgentDetector()
    private let sleepAssertion = SleepAssertionController()
    private var timer: Timer?

    var codingAgents: [DetectedAgent] {
        detectedAgents.filter(\.isCoding)
    }

    var isKeepingAwake: Bool {
        isProtectionEnabled && !codingAgents.isEmpty && sleepAssertion.isActive
    }

    var statusTitle: String {
        if isKeepingAwake {
            "Keeping Mac awake"
        } else if codingAgents.isEmpty {
            "No active agents"
        } else {
            "Protection paused"
        }
    }

    func start() {
        guard timer == nil else { return }
        refresh()
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.refresh()
            }
        }
    }

    func refresh() {
        do {
            detectedAgents = try detector.detectedAgents()
            lastUpdated = Date()
            updateSleepAssertion()
        } catch {
            NSLog("WakeUpSamurai detection failed: \(error.localizedDescription)")
        }
    }

    private func updateSleepAssertion() {
        sleepAssertion.setActive(
            isProtectionEnabled && !codingAgents.isEmpty,
            reason: "WakeUp Samurai detected an active AI coding agent."
        )
    }
}
