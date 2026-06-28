#!/usr/bin/env swift

import AppKit
import Foundation

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let iconsetURL = root.appendingPathComponent("Resources/WakeSamurai.iconset", isDirectory: true)
let icnsURL = root.appendingPathComponent("Resources/WakeSamurai.icns")

try? FileManager.default.removeItem(at: iconsetURL)
try FileManager.default.createDirectory(at: iconsetURL, withIntermediateDirectories: true)

struct IconImage {
    let filename: String
    let pixels: Int
}

let images = [
    IconImage(filename: "icon_16x16.png", pixels: 16),
    IconImage(filename: "icon_16x16@2x.png", pixels: 32),
    IconImage(filename: "icon_32x32.png", pixels: 32),
    IconImage(filename: "icon_32x32@2x.png", pixels: 64),
    IconImage(filename: "icon_128x128.png", pixels: 128),
    IconImage(filename: "icon_128x128@2x.png", pixels: 256),
    IconImage(filename: "icon_256x256.png", pixels: 256),
    IconImage(filename: "icon_256x256@2x.png", pixels: 512),
    IconImage(filename: "icon_512x512.png", pixels: 512),
    IconImage(filename: "icon_512x512@2x.png", pixels: 1024)
]

for image in images {
    let size = NSSize(width: image.pixels, height: image.pixels)
    let outputURL = iconsetURL.appendingPathComponent(image.filename)
    let rendered = NSImage(size: size)

    rendered.lockFocus()
    drawIcon(in: NSRect(origin: .zero, size: size))
    rendered.unlockFocus()

    guard
        let tiff = rendered.tiffRepresentation,
        let bitmap = NSBitmapImageRep(data: tiff),
        let png = bitmap.representation(using: .png, properties: [:])
    else {
        fatalError("Could not render \(image.filename)")
    }

    try png.write(to: outputURL)
}

let process = Process()
process.executableURL = URL(fileURLWithPath: "/usr/bin/iconutil")
process.arguments = ["-c", "icns", iconsetURL.path, "-o", icnsURL.path]
try process.run()
process.waitUntilExit()

guard process.terminationStatus == 0 else {
    fatalError("iconutil failed")
}

print("Created \(icnsURL.path)")

private func drawIcon(in rect: NSRect) {
    let scale = rect.width / 1024
    let bounds = rect
    let radius = 210 * scale

    let basePath = NSBezierPath(roundedRect: bounds.insetBy(dx: 28 * scale, dy: 28 * scale), xRadius: radius, yRadius: radius)
    NSGradient(colors: [
        NSColor(calibratedRed: 0.06, green: 0.07, blue: 0.09, alpha: 1),
        NSColor(calibratedRed: 0.09, green: 0.11, blue: 0.15, alpha: 1),
        NSColor(calibratedRed: 0.02, green: 0.03, blue: 0.05, alpha: 1)
    ])?.draw(in: basePath, angle: 135)

    let glowPath = NSBezierPath(ovalIn: NSRect(x: 622 * scale, y: 586 * scale, width: 210 * scale, height: 210 * scale))
    NSColor(calibratedRed: 0.96, green: 0.73, blue: 0.25, alpha: 0.95).setFill()
    glowPath.fill()

    let smallCut = NSBezierPath(ovalIn: NSRect(x: 572 * scale, y: 630 * scale, width: 210 * scale, height: 210 * scale))
    NSColor(calibratedRed: 0.08, green: 0.10, blue: 0.14, alpha: 1).setFill()
    smallCut.fill()

    let blade = NSBezierPath()
    blade.move(to: NSPoint(x: 260 * scale, y: 292 * scale))
    blade.line(to: NSPoint(x: 718 * scale, y: 748 * scale))
    blade.lineWidth = 78 * scale
    blade.lineCapStyle = .round
    NSColor(calibratedRed: 0.86, green: 0.93, blue: 0.98, alpha: 1).setStroke()
    blade.stroke()

    let edge = NSBezierPath()
    edge.move(to: NSPoint(x: 312 * scale, y: 334 * scale))
    edge.line(to: NSPoint(x: 756 * scale, y: 778 * scale))
    edge.lineWidth = 22 * scale
    edge.lineCapStyle = .round
    NSColor(calibratedRed: 0.37, green: 0.82, blue: 0.93, alpha: 0.95).setStroke()
    edge.stroke()

    let guardPath = NSBezierPath()
    guardPath.move(to: NSPoint(x: 260 * scale, y: 430 * scale))
    guardPath.line(to: NSPoint(x: 404 * scale, y: 286 * scale))
    guardPath.lineWidth = 58 * scale
    guardPath.lineCapStyle = .round
    NSColor(calibratedRed: 0.95, green: 0.63, blue: 0.20, alpha: 1).setStroke()
    guardPath.stroke()

    let handle = NSBezierPath()
    handle.move(to: NSPoint(x: 188 * scale, y: 220 * scale))
    handle.line(to: NSPoint(x: 326 * scale, y: 358 * scale))
    handle.lineWidth = 92 * scale
    handle.lineCapStyle = .round
    NSColor(calibratedRed: 0.14, green: 0.17, blue: 0.22, alpha: 1).setStroke()
    handle.stroke()

    let border = NSBezierPath(roundedRect: bounds.insetBy(dx: 32 * scale, dy: 32 * scale), xRadius: radius, yRadius: radius)
    border.lineWidth = 18 * scale
    NSColor.white.withAlphaComponent(0.14).setStroke()
    border.stroke()
}
