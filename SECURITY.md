# Security Policy

WakeUp Samurai is intentionally small:

- No network access is required.
- No admin privileges are required.
- No API keys, tokens, certificates, or provisioning profiles should be committed.
- Process detection reads local process names and arguments through `/bin/ps`.
- Sleep prevention uses macOS power management APIs.

## Reporting a Vulnerability

Please open a private security advisory on GitHub if the repository supports it. If not, open an issue with minimal reproduction details and avoid posting secrets or private logs.

## Release Signing

Local development builds use ad hoc signing through `codesign -`.

Future public releases should be signed and notarized outside this repository. Keep Developer ID certificates, Apple account credentials, app-specific passwords, and notarization credentials out of git and GitHub Actions logs.
