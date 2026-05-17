import SwiftUI

@main
struct ImprovedRightClickApp: App {
    var body: some Scene {
        MenuBarExtra {
            MenuBarView()
        } label: {
            Image(systemName: "doc.badge.plus")
        }
        .menuBarExtraStyle(.window)
    }
}
