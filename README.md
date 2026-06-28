# Wake Samurai

Wake Samurai is a small open-source macOS menu bar app that keeps your Mac awake while AI coding agents are working in the background.

The first version watches for Codex and Claude processes. When one is detected, Wake Samurai creates a macOS idle-sleep assertion. When no supported agent is running, the assertion is released.

## Why

Long-running coding agents can stop when macOS goes to sleep. Wake Samurai gives you a visible menu bar status and prevents idle sleep only while supported agents are active.

## Features

- Native macOS menu bar app
- Detects Codex and Claude processes
- Prevents idle sleep only while an agent is running
- Manual pause toggle
- Launch at login checkbox
- Simple off-App-Store packaging

## Requirements

- macOS 13 or newer
- Apple Silicon Mac for the packaged build script
- Xcode command line tools for development builds

## Install From Source

```bash
git clone https://github.com/YOUR_ORG/wake-samurai.git
cd wake-samurai
./scripts/package.sh
open dist/Wake\ Samurai.app
```

For a distributable file:

```bash
open dist/WakeSamurai.dmg
```

Because this is not distributed through the App Store yet, macOS may ask you to confirm that you want to open it.

## Development

Run tests:

```bash
swift test
```

Run locally:

```bash
swift run WakeSamurai
```

Build a release app bundle and DMG:

```bash
./scripts/package.sh
```

## Detection Model

Wake Samurai intentionally starts simple. It scans the local process table and matches supported provider names:

- Codex: `codex`
- Claude: `claude`, `claude-code`

The scanner ignores Wake Samurai's own process. Future providers should be added in `Sources/WakeSamuraiCore/AgentProvider.swift` with focused tests.

## Security

Wake Samurai does not require admin privileges, network access, shell injection, or access to your code. It reads process names and command arguments through `/bin/ps`, then uses macOS power management APIs to prevent idle sleep.

Do not commit signing certificates, provisioning profiles, API keys, or private release credentials to this repository.

## License

MIT. See [LICENSE](LICENSE).
