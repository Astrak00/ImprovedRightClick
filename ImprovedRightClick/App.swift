import SwiftUI

@main
struct ImprovedRightClickApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        // No windows — the entire UI lives in the status-bar popover.
        Settings { EmptyView() }
    }
}
