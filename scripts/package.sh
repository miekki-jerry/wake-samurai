#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP_NAME="WakeUp Samurai"
BINARY_NAME="WakeUpSamurai"
CODESIGN_IDENTITY="${CODESIGN_IDENTITY:--}"
DIST_DIR="$ROOT_DIR/dist"
APP_DIR="$DIST_DIR/$APP_NAME.app"
DMG_ROOT="$DIST_DIR/dmg-root"
CONTENTS_DIR="$APP_DIR/Contents"
MACOS_DIR="$CONTENTS_DIR/MacOS"
RESOURCES_DIR="$CONTENTS_DIR/Resources"

cd "$ROOT_DIR"

swift build -c release --arch arm64

"$ROOT_DIR/scripts/generate-icon.swift"

rm -rf "$APP_DIR"
mkdir -p "$MACOS_DIR" "$RESOURCES_DIR"

cp ".build/arm64-apple-macosx/release/$BINARY_NAME" "$MACOS_DIR/$BINARY_NAME"
cp "Info.plist" "$CONTENTS_DIR/Info.plist"
cp "Resources/WakeUpSamurai.icns" "$RESOURCES_DIR/WakeUpSamurai.icns"
cp "Resources/AppIconSource.png" "$RESOURCES_DIR/AppIconSource.png"
cp "Resources/StatusBarIconTemplate.png" "$RESOURCES_DIR/StatusBarIconTemplate.png"

codesign --force --deep --sign "$CODESIGN_IDENTITY" "$APP_DIR"

echo "Created $APP_DIR"

if command -v hdiutil >/dev/null 2>&1; then
  DMG_PATH="$DIST_DIR/WakeUpSamurai.dmg"
  rm -f "$DMG_PATH"
  rm -rf "$DMG_ROOT"
  mkdir -p "$DMG_ROOT"
  cp -R "$APP_DIR" "$DMG_ROOT/$APP_NAME.app"
  ln -s /Applications "$DMG_ROOT/Applications"
  hdiutil create -volname "WakeUp Samurai" -srcfolder "$DMG_ROOT" -ov -format UDZO "$DMG_PATH"
  echo "Created $DMG_PATH"
fi
