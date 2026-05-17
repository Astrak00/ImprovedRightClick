import Foundation

struct FileTypeConfig: Codable, Identifiable, Hashable {
    var id: UUID
    var displayName: String
    var fileExtension: String
    var systemIcon: String
    var isEnabled: Bool
    var initialContent: String

    init(id: UUID = UUID(), displayName: String, fileExtension: String,
         systemIcon: String, isEnabled: Bool = true, initialContent: String = "") {
        self.id = id
        self.displayName = displayName
        self.fileExtension = fileExtension
        self.systemIcon = systemIcon
        self.isEnabled = isEnabled
        self.initialContent = initialContent
    }
}

enum FileTypeStorage {
    static let appGroupID = "group.com.improvedrightclick.app"
    static let storageKey = "fileTypes"

    static var sharedDefaults: UserDefaults {
        UserDefaults(suiteName: appGroupID) ?? .standard
    }

    static func load() -> [FileTypeConfig] {
        guard let data = sharedDefaults.data(forKey: storageKey),
              let list = try? JSONDecoder().decode([FileTypeConfig].self, from: data)
        else { return defaultTypes }
        return list
    }

    static func save(_ list: [FileTypeConfig]) {
        guard let data = try? JSONEncoder().encode(list) else { return }
        sharedDefaults.set(data, forKey: storageKey)
    }

    static let defaultTypes: [FileTypeConfig] = [
        .init(displayName: "Text File",          fileExtension: "txt",   systemIcon: "doc.text",               initialContent: ""),
        .init(displayName: "Markdown",           fileExtension: "md",    systemIcon: "doc.richtext",           initialContent: "# Untitled\n\n"),
        .init(displayName: "HTML",               fileExtension: "html",  systemIcon: "globe",                  initialContent: "<!DOCTYPE html>\n<html lang=\"en\">\n<head>\n    <meta charset=\"UTF-8\">\n    <title>Untitled</title>\n</head>\n<body>\n\n</body>\n</html>\n"),
        .init(displayName: "CSS",                fileExtension: "css",   systemIcon: "paintpalette",           initialContent: ""),
        .init(displayName: "JavaScript",         fileExtension: "js",    systemIcon: "doc.text",               initialContent: ""),
        .init(displayName: "JSON",               fileExtension: "json",  systemIcon: "curlybraces",            initialContent: "{}\n"),
        .init(displayName: "Python Script",      fileExtension: "py",    systemIcon: "terminal",               initialContent: "#!/usr/bin/env python3\n\n"),
        .init(displayName: "Shell Script",       fileExtension: "sh",    systemIcon: "terminal",               initialContent: "#!/bin/bash\n\n"),
        .init(displayName: "Swift File",         fileExtension: "swift", systemIcon: "swift",                  initialContent: "import Foundation\n\n"),
        .init(displayName: "Word Document",      fileExtension: "docx",  systemIcon: "doc.fill",               initialContent: ""),
        .init(displayName: "PowerPoint",         fileExtension: "pptx",  systemIcon: "rectangle.on.rectangle", initialContent: ""),
        .init(displayName: "Excel Spreadsheet",  fileExtension: "xlsx",  systemIcon: "tablecells",             initialContent: ""),
    ]
}
