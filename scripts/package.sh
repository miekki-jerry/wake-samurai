#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_NAME="Wake Samurai"
BINARY_NAME="WakeSamurai"
DIST_DIR="$ROOT_DIR/dist"
APP_DIR="$DIST_DIR/$APP_NAME.app"
CONTENTS_DIR="$APP_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"

cd "$ROOT_DIR"

swift build -c release --arch arm64

rm -rf "$APP_DIR"
mkdir -p "$MACOS_DIR" "$RESOURCES_DIR"

cp ".build/arm64-apple-macosx/release/$BINARY_NAME" "$MACOS_DIR/$BINARY_NAME"
cp "Info.plist" "$CONTENTS_DIR/Info.plist"

codesign --force --deep --sign - "$APP_DIR"

echo "Created $APP_DIR"

if command -v hdiutil >/dev/null 2>&1; then
  DMG_PATH="$DIST_DIR/WakeSamurai.dmg"
  rm -f "$DMG_PATH"
  hdiutil create -volname "Wake Samurai" -srcfolder "$APP_DIR" -ov -format UDZO "$DMG_PATH"
  echo "Created $DMG_PATH"
fi
