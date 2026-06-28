import Foundation

public protocol ProcessListing: Sendable {
    func processSnapshot() throws -> String
}

public struct ShellProcessListing: ProcessListing {
    public init() {}

    public func processSnapshot() throws -> String {
        let process = Process()
        let pipe = Pipe()

        process.executableURL = URL(fileURLWithPath: "/bin/ps")
        process.arguments = ["-axo", "pid=,comm=,args="]
        process.standardOutput = pipe
        process.standardError = Pipe()

        try process.run()
        process.waitUntilExit()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(decoding: data, as: UTF8.self)
    }
}

public struct AgentDetector: Sendable {
    private let processListing: any ProcessListing

    public init(processListing: any ProcessListing = ShellProcessListing()) {
        self.processListing = processListing
    }

    public func detectedAgents() throws -> [DetectedAgent] {
        let snapshot = try processListing.processSnapshot()
        return ProcessSnapshotParser.detectedAgents(from: snapshot)
    }
}
