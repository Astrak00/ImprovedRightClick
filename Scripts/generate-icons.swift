#!/usr/bin/env swift
// Run from the project root:  swift Scripts/generate-icons.swift
import AppKit
import Foundation

let outDir = "ImprovedRightClick/Assets.xcassets/AppIcon.appiconset"

// All pixel sizes we need (shared between light and dark)
let pixelSizes = [16, 32, 64, 128, 256, 512, 1024]

// MARK: - Rendering

func renderIcon(pixelSize: Int, dark: Bool) -> Data {
    let pt = CGFloat(pixelSize)

    // Draw into an NSImage so AppKit handles the coordinate system
    let img = NSImage(size: NSSize(width: pt, height: pt))
    img.lockFocus()

    // ── Background ────────────────────────────────────────────────
    // Transparent canvas — macOS composites the icon onto whatever background
    // the system uses, so we just draw the symbol itself.
    NSColor.clear.setFill()
    NSRect(x: 0, y: 0, width: pt, height: pt).fill()

    // ── Symbol ────────────────────────────────────────────────────
    let symbolPt = pt * 0.75
    let cfg = NSImage.SymbolConfiguration(pointSize: symbolPt, weight: .light)
    guard let raw = NSImage(systemSymbolName: "doc.badge.plus", accessibilityDescription: nil)?
            .withSymbolConfiguration(cfg) else {
        img.unlockFocus()
        fatalError("SF Symbol not found")
    }

    // Tint the template image with the desired colour
    let symbolColor: NSColor = dark
        ? NSColor(calibratedWhite: 0.88, alpha: 1)   // light grey in dark mode
        : NSColor(calibratedWhite: 0.0,  alpha: 1)   // black in light mode

    let tinted = NSImage(size: raw.size)
    tinted.lockFocus()
    symbolColor.setFill()
    NSRect(origin: .zero, size: raw.size).fill()
    raw.draw(at: .zero,
             from: NSRect(origin: .zero, size: raw.size),
             operation: .destinationIn,
             fraction: 1.0)
    tinted.unlockFocus()

    // Centre the tinted symbol in the canvas
    let sw = tinted.size.width
    let sh = tinted.size.height
    let ox = (pt - sw) / 2
    let oy = (pt - sh) / 2
    tinted.draw(at: NSPoint(x: ox, y: oy),
                from: NSRect(origin: .zero, size: tinted.size),
                operation: .sourceOver,
                fraction: 1.0)

    img.unlockFocus()

    // Convert to PNG bytes
    guard
        let tiffData = img.tiffRepresentation,
        let bitmapRep = NSBitmapImageRep(data: tiffData),
        let png = bitmapRep.representation(using: .png, properties: [:])
    else { fatalError("PNG conversion failed for size \(pixelSize)") }

    return png
}

// MARK: - Write files

for px in pixelSizes {
    for dark in [false, true] {
        let prefix = dark ? "icon_dark_" : "icon_"
        let filename = "\(prefix)\(px).png"
        let path = "\(outDir)/\(filename)"
        let data = renderIcon(pixelSize: px, dark: dark)
        try! data.write(to: URL(fileURLWithPath: path))
        print("✓ \(filename)")
    }
}

print("\nDone — \(pixelSizes.count * 2) icons written to \(outDir)")
