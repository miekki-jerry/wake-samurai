import Foundation

public struct DetectedAgent: Identifiable, Equatable, Sendable {
    public let id: Int32
    public let provider: AgentProvider
    public let command: String
    public let arguments: String
    public let isCoding: Bool

    public init(id: Int32, provider: AgentProvider, command: String, arguments: String, isCoding: Bool = true) {
        self.id = id
        self.provider = provider
        self.command = command
        self.arguments = arguments
        self.isCoding = isCoding
    }

    public var title: String {
        command.isEmpty ? provider.displayName : command
    }
}
