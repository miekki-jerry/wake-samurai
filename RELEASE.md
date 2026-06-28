# Release Checklist

WakeUp Samurai is distributed outside the App Store as a downloadable macOS app.

Current releases are ad hoc signed until the project has a Developer ID certificate. That means Gatekeeper can require `System Settings -> Privacy & Security -> Open Anyway` on first launch.

## Local Release Build

```bash
./scripts/package.sh
```

Outputs:

- `dist/WakeUp Samurai.app`
- `dist/WakeUpSamurai.dmg`

The DMG contains:

- `WakeUp Samurai.app`
- `Applications` alias

Users should drag the app to Applications before opening it.

## Manual QA

1. Open `dist/WakeUpSamurai.dmg`.
2. Drag `WakeUp Samurai.app` to Applications.
3. Open WakeUp Samurai from Applications.
4. If Gatekeeper blocks the ad hoc build, use `System Settings -> Privacy & Security -> Open Anyway`.
5. Confirm the menu bar item appears.
6. Start Codex or Claude.
7. Confirm WakeUp Samurai shows the detected agent.
8. Confirm macOS does not idle sleep while the agent process is present.
9. Quit the agent and confirm WakeUp Samurai releases protection after the next scan.
10. Toggle `Open WakeUp Samurai at login` and confirm macOS accepts the login item.

## GitHub Release

1. Tag the commit, for example `v0.1.0`.
2. Attach `dist/WakeUpSamurai.dmg`.
3. Include install instructions from `README.md`.
4. State whether the build is ad hoc signed or Developer ID signed and notarized.

## Future Notarized Releases

Once a `Developer ID Application` certificate is available, sign the app with hardened runtime, submit the DMG with `xcrun notarytool`, then staple the notarization ticket before publishing.
