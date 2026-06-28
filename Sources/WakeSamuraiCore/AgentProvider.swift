import Foundation

public enum AgentProvider: String, CaseIterable, Codable, Sendable {
    case codex
    case claude

    public var displayName: String {
        switch self {
        case .codex:
            "Codex"
        case .claude:
            "Claude"
        }
    }

    var matchTerms: [String] {
        switch self {
        case .codex:
            ["codex"]
        case .claude:
            ["claude", "claude-code"]
        }
    }
}
