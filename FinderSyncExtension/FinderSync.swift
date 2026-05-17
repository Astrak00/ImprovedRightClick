import Cocoa
import FinderSync

class FinderSync: FIFinderSync {

    // Both must be captured inside menu(for:) while the controller context is valid.
    // By the time @objc actions fire, targetedURL() may already return nil.
    private var cachedTargetURL: URL?
    private var pendingConfigs: [Int: FileTypeConfig] = [:]

    override init() {
        super.init()
        FIFinderSyncController.default().directoryURLs = [URL(fileURLWithPath: "/")]
    }

    // MARK: - Menu

    override func menu(for menuKind: FIMenuKind) -> NSMenu? {
        guard menuKind == .contextualMenuForItems || menuKind == .contextualMenuForContainer else {
            return nil
        }

        // Capture now — unavailable once the menu closes and an action fires.
        cachedTargetURL = FIFinderSyncController.default().targetedURL()
        pendingConfigs.removeAll()

        let enabledTypes = FileTypeStorage.load().filter { $0.isEnabled }
        let root = NSMenu(title: "")

        if !enabledTypes.isEmpty {
            let newFileItem = NSMenuItem(title: "New File", action: nil, keyEquivalent: "")
            newFileItem.image = icon("doc.badge.plus")
            let submenu = NSMenu(title: "New File")

            for (index, config) in enabledTypes.enumerated() {
                // Store by index — avoids Swift struct / AnyObject bridging issues
                // that make `representedObject as? FileTypeConfig` silently fail.
                pendingConfigs[index] = config

                let item = NSMenuItem(
                    title: config.displayName,
                    action: #selector(createFile(_:)),
                    keyEquivalent: ""
                )
                item.tag    = index
                item.image  = icon(config.systemIcon)
                item.target = self
                submenu.addItem(item)
            }

            newFileItem.submenu = submenu
            root.addItem(newFileItem)
        }

        return root
    }

    // MARK: - Actions

    @objc private func createFile(_ sender: NSMenuItem) {
        guard let config    = pendingConfigs[sender.tag],
              let targetDir = resolveTargetDir() else { return }

        let name    = uniqueName(base: "untitled", ext: config.fileExtension, in: targetDir)
        let fileURL = targetDir.appendingPathComponent(name)

        do {
            let data = try makeContent(for: config)
            try data.write(to: fileURL, options: .atomic)
            NSWorkspace.shared.selectFile(fileURL.path, inFileViewerRootedAtPath: targetDir.path)
        } catch {
            showError("Could not create \"\(name)\"", detail: error.localizedDescription)
        }
    }

// MARK: - Helpers

    private func resolveTargetDir() -> URL? {
        // Use the URL we captured in menu(for:); fall back to a live call just in case.
        cachedTargetURL ?? FIFinderSyncController.default().targetedURL()
    }

    private func makeContent(for config: FileTypeConfig) throws -> Data {
        switch config.fileExtension.lowercased() {
        case "docx": return try OfficeTemplates.docx()
        case "pptx": return try OfficeTemplates.pptx()
        case "xlsx": return try OfficeTemplates.xlsx()
        default:     return Data(config.initialContent.utf8)
        }
    }

    private func icon(_ name: String) -> NSImage? {
        guard let base = NSImage(systemSymbolName: name, accessibilityDescription: nil) else { return nil }
        let config = NSImage.SymbolConfiguration(paletteColors: [.white])
        let tinted = base.withSymbolConfiguration(config) ?? base
        tinted.isTemplate = false
        return tinted
    }

    private func showError(_ message: String, detail: String) {
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText     = message
            alert.informativeText = detail
            alert.alertStyle      = .warning
            alert.runModal()
        }
    }
}

// MARK: - Unique filename

func uniqueName(base: String, ext: String?, in directory: URL) -> String {
    let fm = FileManager.default
    func candidate(_ suffix: String) -> String {
        ext.map { "\(base)\(suffix).\($0)" } ?? "\(base)\(suffix)"
    }
    if !fm.fileExists(atPath: directory.appendingPathComponent(candidate("")).path) {
        return candidate("")
    }
    var i = 2
    while fm.fileExists(atPath: directory.appendingPathComponent(candidate(" \(i)")).path) { i += 1 }
    return candidate(" \(i)")
}
