# Release Checklist

Wake Samurai is distributed outside the App Store as a downloadable macOS app.

## Local Release Build

```bash
./scripts/package.sh
```

Outputs:

- `dist/Wake Samurai.app`
- `dist/WakeSamurai.dmg`

## Manual QA

1. Open `dist/Wake Samurai.app`.
2. Confirm the menu bar item appears.
3. Start Codex or Claude.
4. Confirm Wake Samurai shows the detected agent.
5. Confirm macOS does not idle sleep while the agent process is present.
6. Quit the agent and confirm Wake Samurai releases protection after the next scan.
7. Toggle `Open Wake Samurai at login` and confirm macOS accepts the login item.

## GitHub Release

1. Tag the commit, for example `v0.1.0`.
2. Attach `dist/WakeSamurai.dmg`.
3. Include install instructions from `README.md`.
4. State whether the build is ad hoc signed or Developer ID signed and notarized.
