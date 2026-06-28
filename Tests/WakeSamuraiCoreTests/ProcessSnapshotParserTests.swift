import Testing
@testable import WakeSamuraiCore

@Test func detectsCodexFromCommandArguments() {
    let output = """
      101 /opt/homebrew/bin/node node /opt/homebrew/bin/codex --ask-for-approval never
      102 /usr/bin/login login -fp user
    """

    let agents = ProcessSnapshotParser.detectedAgents(from: output, currentProcessID: 999)

    #expect(agents == [
        DetectedAgent(id: 101, provider: .codex, command: "node", arguments: "node /opt/homebrew/bin/codex --ask-for-approval never")
    ])
}

@Test func detectsClaudeFromBinaryName() {
    let output = """
      201 /Users/me/.local/bin/claude claude --dangerously-skip-permissions
    """

    let agents = ProcessSnapshotParser.detectedAgents(from: output, currentProcessID: 999)

    #expect(agents.first?.provider == .claude)
    #expect(agents.first?.id == 201)
}

@Test func ignoresCurrentProcessAndWakeSamuraiItself() {
    let output = """
      301 /tmp/WakeSamurai WakeSamurai
      302 /opt/homebrew/bin/codex codex
    """

    let agents = ProcessSnapshotParser.detectedAgents(from: output, currentProcessID: 302)

    #expect(agents.isEmpty)
}
