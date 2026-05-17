import Cocoa
import FinderSync

class FinderSync: FIFinderSync {

    override init() {
        super.init()
        // Watch the entire filesystem so the menu appears in any Finder window.
        FIFinderSyncController.default().directoryURLs = [URL(fileURLWithPath: "/")]
    }

    // MARK: - Context Menu

    override func menu(for menuKind: FIMenuKind) -> NSMenu? {
        guard menuKind == .contextualMenuForItems || menuKind == .contextualMenuForContainer else {
            return nil
        }

        let root = NSMenu(title: "")

        // "New File" with a submenu of file types
        let newFileItem = NSMenuItem(title: "New File", action: nil, keyEquivalent: "")
        newFileItem.image = icon("doc.badge.plus")
        let submenu = NSMenu(title: "New File")
        for template in FileTemplate.all {
            let item = NSMenuItem(
                title: template.displayName,
                action: #selector(createFile(_:)),
                keyEquivalent: ""
            )
            item.representedObject = template
            item.image = icon(template.systemIcon)
            item.target = self
            submenu.addItem(item)
        }
        newFileItem.submenu = submenu
        root.addItem(newFileItem)

        // "New Folder Here" as a direct action
        let folderItem = NSMenuItem(
            title: "New Folder Here",
            action: #selector(createFolder(_:)),
            keyEquivalent: ""
        )
        folderItem.image = icon("folder.badge.plus")
        folderItem.target = self
        root.addItem(folderItem)

        return root
    }

    // MARK: - Actions

    @objc private func createFile(_ sender: NSMenuItem) {
        guard
            let template = sender.representedObject as? FileTemplate,
            let targetDir = targetDirectory()
        else { return }

        let name = uniqueName(base: "untitled", ext: template.fileExtension, in: targetDir)
        let fileURL = targetDir.appendingPathComponent(name)

        do {
            let data = try template.makeContent()
            try data.write(to: fileURL, options: .atomic)
            reveal(fileURL, in: targetDir)
        } catch {
            presentError(error)
        }
    }

    @objc private func createFolder(_ sender: NSMenuItem) {
        guard let targetDir = targetDirectory() else { return }

        let name = uniqueName(base: "untitled folder", ext: nil, in: targetDir)
        let folderURL = targetDir.appendingPathComponent(name)

        do {
            try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: false)
            reveal(folderURL, in: targetDir)
        } catch {
            presentError(error)
        }
    }

    // MARK: - Helpers

    private func targetDirectory() -> URL? {
        // targetedURL() returns the Finder folder that was right-clicked.
        let target = FIFinderSyncController.default().targetedURL()
        return target
    }

    private func reveal(_ url: URL, in directory: URL) {
        NSWorkspace.shared.selectFile(url.path, inFileViewerRootedAtPath: directory.path)
    }

    private func presentError(_ error: Error) {
        DispatchQueue.main.async {
            let alert = NSAlert(error: error)
            alert.runModal()
        }
    }

    private func icon(_ name: String) -> NSImage? {
        NSImage(systemSymbolName: name, accessibilityDescription: nil)
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
    while fm.fileExists(atPath: directory.appendingPathComponent(candidate(" \(i)")).path) {
        i += 1
    }
    return candidate(" \(i)")
}
