#!/usr/bin/env swift
// Run from the project root:  swift Scripts/generate-icons.swift
import AppKit
import Foundation

let outDir = "ImprovedRightClick/Assets.xcassets/AppIcon.appiconset"
let pixelSizes = [16, 32, 64, 128, 256, 512, 1024]

// Light-themed icon:
//   • White rounded-square background
//   • Dark blue symbol (consistent in both light & dark system modes)

func renderIcon(pixelSize: Int) -> Data {
    let pt  = CGFloat(pixelSize)
    let img = NSImage(size: NSSize(width: pt, height: pt))
    img.lockFocus()

    // ── Background: white rounded square ─────────────────────────
    let pad    = pt * 0.04
    let rect   = NSRect(x: pad, y: pad, width: pt - pad * 2, height: pt - pad * 2)
    let radius = pt * 0.22          // matches macOS icon rounding

    // Soft drop shadow (skip at tiny sizes — too small to matter)
    if pt >= 64 {
        let shadow = NSShadow()
        shadow.shadowColor  = NSColor(calibratedWhite: 0, alpha: 0.18)
        shadow.shadowOffset = NSSize(width: 0, height: -pt * 0.015)
        shadow.shadowBlurRadius = pt * 0.04
        shadow.set()
    }

    NSColor.white.setFill()
    NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius).fill()

    // Reset shadow so it doesn't bleed onto the symbol
    NSShadow().set()

    // ── Symbol ────────────────────────────────────────────────────
    let symbolPt = pt * 0.54
    let cfg = NSImage.SymbolConfiguration(pointSize: symbolPt, weight: .regular)
    guard let raw = NSImage(systemSymbolName: "doc.badge.plus", accessibilityDescription: nil)?
            .withSymbolConfiguration(cfg) else {
        img.unlockFocus()
        fatalError("SF Symbol not found")
    }

    // Dark-blue tint — visible on the white background in any system mode
    let symbolColor = NSColor(calibratedRed: 0.13, green: 0.33, blue: 0.73, alpha: 1)

    let tinted = NSImage(size: raw.size)
    tinted.lockFocus()
    symbolColor.setFill()
    NSRect(origin: .zero, size: raw.size).fill()
    raw.draw(at: .zero,
             from: NSRect(origin: .zero, size: raw.size),
             operation: .destinationIn,
             fraction: 1.0)
    tinted.unlockFocus()

    let sw = tinted.size.width
    let sh = tinted.size.height
    let ox = (pt - sw) / 2
    let oy = (pt - sh) / 2
    tinted.draw(at: NSPoint(x: ox, y: oy),
                from: NSRect(origin: .zero, size: tinted.size),
                operation: .sourceOver,
                fraction: 1.0)

    img.unlockFocus()

    guard
        let tiff   = img.tiffRepresentation,
        let bitmap = NSBitmapImageRep(data: tiff),
        let png    = bitmap.representation(using: .png, properties: [:])
    else { fatalError("PNG conversion failed for size \(pixelSize)") }

    return png
}

// MARK: - Write files
// One icon used for both light and dark system appearances (light-themed always)

for px in pixelSizes {
    let data = renderIcon(pixelSize: px)

    // Write the shared file once, referenced by both light and dark entries in Contents.json
    let path = "\(outDir)/icon_\(px).png"
    try! data.write(to: URL(fileURLWithPath: path))
    print("✓ icon_\(px).png")

    // Overwrite the dark variant with the same image
    let darkPath = "\(outDir)/icon_dark_\(px).png"
    try! data.write(to: URL(fileURLWithPath: darkPath))
    print("✓ icon_dark_\(px).png (same, light-themed)")
}

print("\nDone — \(pixelSizes.count * 2) files written to \(outDir)")
