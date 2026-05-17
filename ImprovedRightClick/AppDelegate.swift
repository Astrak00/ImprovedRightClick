import AppKit
import SwiftUI

final class AppDelegate: NSObject, NSApplicationDelegate {

    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    private var store           = FileTypeStore()
    private var extensionStatus = ExtensionStatus()

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)

        // ── Status item ───────────────────────────────────────────
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            button.image = NSImage(systemSymbolName: "doc.badge.plus",
                                   accessibilityDescription: "File Templates")
            button.image?.isTemplate = true
            button.action = #selector(togglePopover(_:))
            button.target = self
        }

        // ── Popover ───────────────────────────────────────────────
        let root = MenuBarView(store: store, extensionStatus: extensionStatus)
        let hosting = NSHostingController(rootView: root)

        popover = NSPopover()
        popover.contentViewController = hosting
        popover.behavior = .transient
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
