#!/usr/bin/env swift
// Run from the project root:  swift Scripts/generate-icons.swift
import AppKit
import Foundation

let outDir = "ImprovedRightClick/Assets.xcassets/AppIcon.appiconset"

// Exact pixel sizes required by macOS app icon spec
let pixelSizes = [16, 32, 64, 128, 256, 512, 1024]

func renderIcon(pixels: Int) -> Data {
    let size = CGFloat(pixels)

    // CGBitmapContext renders at exact pixel counts, ignoring display scale
    let ctx = CGContext(
        data: nil,
        width: pixels,
        height: pixels,
        bitsPerComponent: 8,
        bytesPerRow: 0,
        space: CGColorSpaceCreateDeviceRGB(),
        bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
    )!
    ctx.translateBy(x: 0, y: size)
    ctx.scaleBy(x: 1, y: -1)

    let ns = NSGraphicsContext(cgContext: ctx, flipped: true)
    NSGraphicsContext.saveGraphicsState()
    NSGraphicsContext.current = ns

    // ── Background: white rounded square ──────────────────────────
    let pad    = size * 0.04
    let rect   = NSRect(x: pad, y: pad, width: size - pad * 2, height: size - pad * 2)
    let radius = size * 0.22

    if pixels >= 64 {
        let shadow = NSShadow()
        shadow.shadowColor       = NSColor(calibratedWhite: 0, alpha: 0.18)
        shadow.shadowOffset      = NSSize(width: 0, height: -size * 0.015)
        shadow.shadowBlurRadius  = size * 0.04
        shadow.set()
    }

    NSColor.white.setFill()
    NSBezierPath(roundedRect: rect, xRadius: radius, yRadius: radius).fill()
    NSShadow().set()

    // ── Symbol ─────────────────────────────────────────────────────
    let symbolPt = size * 0.54
    let cfg = NSImage.SymbolConfiguration(pointSize: symbolPt, weight: .regular)
    guard let raw = NSImage(systemSymbolName: "doc.badge.plus", accessibilityDescription: nil)?
            .withSymbolConfiguration(cfg) else {
        NSGraphicsContext.restoreGraphicsState()
        fatalError("SF Symbol not found")
    }

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

    let ox = (size - tinted.size.width)  / 2
    let oy = (size - tinted.size.height) / 2
    tinted.draw(at: NSPoint(x: ox, y: oy),
                from: NSRect(origin: .zero, size: tinted.size),
                operation: .sourceOver,
                fraction: 1.0)

    NSGraphicsContext.restoreGraphicsState()

    let cgImage = ctx.makeImage()!
    let rep = NSBitmapImageRep(cgImage: cgImage)
    rep.size = NSSize(width: pixels, height: pixels)
    return rep.representation(using: .png, properties: [:])!
}

// Write each pixel-exact file (same image used for light and dark)
for px in pixelSizes {
    let data = renderIcon(pixels: px)
    try! data.write(to: URL(fileURLWithPath: "\(outDir)/icon_\(px).png"))
    print("✓ icon_\(px).png  (\(px)×\(px) px)")
    try! data.write(to: URL(fileURLWithPath: "\(outDir)/icon_dark_\(px).png"))
    print("✓ icon_dark_\(px).png")
}

print("\nDone — \(pixelSizes.count * 2) files written to \(outDir)")
