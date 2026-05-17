import AppKit
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {

    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    private var store = FileTypeStore()

    func applicationDidFinishLaunching(_ notification: Notification) {
        // Hide from Dock and app switcher — status-bar-only app.
        NSApp.setActivationPolicy(.accessory)

        // ── Status item (the icon in the menu bar) ───────────────
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "doc.badge.plus",
                                   accessibilityDescription: "File Templates")
            button.image?.isTemplate = true      // adapts to light/dark menu bar
            button.action = #selector(togglePopover(_:))
            button.target  = self
        }

        // ── Popover ───────────────────────────────────────────────
        let content = MenuBarView(store: store)
        let hosting = NSHostingController(rootView: content)

        popover = NSPopover()
        popover.contentViewController = hosting
        popover.behavior = .transient   // closes on click-outside automatically
        popover.animates = true
    }

    @objc private func togglePopover(_ sender: NSStatusBarButton) {
        guard let button = statusItem.button else { return }
        if popover.isShown {
            popover.performClose(sender)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            popover.contentViewController?.view.window?.makeKey()
        }
    }
}
