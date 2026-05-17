import Foundation

struct FileTemplate {
    let displayName: String
    let fileExtension: String
    let systemIcon: String
    let makeContent: () throws -> Data

    // All templates shown in the context menu submenu.
    static let all: [FileTemplate] = [
        // ── Plain text ────────────────────────────────────────────────
        .init(
            displayName: "Text File",
            fileExtension: "txt",
            systemIcon: "doc.text"
        ) { Data() },

        .init(
            displayName: "Markdown File",
            fileExtension: "md",
            systemIcon: "doc.richtext"
        ) { Data("# Untitled\n\n".utf8) },

        .init(
            displayName: "HTML File",
            fileExtension: "html",
            systemIcon: "globe"
        ) {
            Data("""
            <!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Untitled</title>
            </head>
            <body>

            </body>
            </html>
            """.utf8)
        },

        .init(
            displayName: "CSS File",
            fileExtension: "css",
            systemIcon: "paintpalette"
        ) { Data() },

        .init(
            displayName: "JavaScript File",
            fileExtension: "js",
            systemIcon: "doc.text"
        ) { Data() },

        .init(
            displayName: "JSON File",
            fileExtension: "json",
            systemIcon: "curlybraces"
        ) { Data("{}\n".utf8) },

        // ── Scripts ───────────────────────────────────────────────────
        .init(
            displayName: "Python Script",
            fileExtension: "py",
            systemIcon: "terminal"
        ) { Data("#!/usr/bin/env python3\n\n".utf8) },

        .init(
            displayName: "Shell Script",
            fileExtension: "sh",
            systemIcon: "terminal"
        ) { Data("#!/bin/bash\n\n".utf8) },

        .init(
            displayName: "Swift File",
            fileExtension: "swift",
            systemIcon: "swift"
        ) { Data("import Foundation\n\n".utf8) },

        // ── Office formats (minimal valid OOXML) ──────────────────────
        .init(
            displayName: "Word Document",
            fileExtension: "docx",
            systemIcon: "doc.fill"
        ) { try OfficeTemplates.docx() },

        .init(
            displayName: "PowerPoint Presentation",
            fileExtension: "pptx",
            systemIcon: "rectangle.on.rectangle"
        ) { try OfficeTemplates.pptx() },

        .init(
            displayName: "Excel Spreadsheet",
            fileExtension: "xlsx",
            systemIcon: "tablecells"
        ) { try OfficeTemplates.xlsx() },
    ]
}
