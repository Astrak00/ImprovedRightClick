import AppKit
import Combine

/// Tracks whether the FinderSyncExtension process is actively running.
/// The extension launches automatically when the host app runs and the user
/// has enabled it in System Settings → Privacy & Security → Extensions.
final class ExtensionStatus: ObservableObject {
    static let extensionBundleID = "com.improvedrightclick.app.FinderSyncExtension"

    @Published private(set) var isActive: Bool = false

    private var timer: AnyCancellable?

    init() {
        refresh()
        // Poll every 2 s so the banner disappears as soon as the user enables it.
        timer = Timer.publish(every: 2, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.refresh() }
    }

    private func refresh() {
        isActive = NSWorkspace.shared.runningApplications.contains {
            $0.bundleIdentifier == Self.extensionBundleID
        }
    }

    /// Opens the macOS Extensions preferences pane so the user can enable the extension.
    func openExtensionSettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.ExtensionsPreferences") {
            NSWorkspace.shared.open(url)
        }
    }
}
