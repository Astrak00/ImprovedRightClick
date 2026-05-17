import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    setupSection
                    fileTypesSection
                }
                .padding(24)
            }
        }
        .frame(width: 480, height: 560)
        .background(Color(NSColor.windowBackgroundColor))
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: 14) {
            Image(systemName: "doc.badge.plus")
                .font(.system(size: 36, weight: .light))
                .foregroundColor(.accentColor)
            VStack(alignment: .leading, spacing: 2) {
                Text("Improved Right-Click")
                    .font(.title2.bold())
                Text("Adds \"New File\" to Finder's context menu")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 18)
    }

    // MARK: - Setup

    private var setupSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Setup", systemImage: "gearshape")
                .font(.headline)

            VStack(alignment: .leading, spacing: 10) {
                setupStep(
                    number: 1,
                    title: "Open Extensions preferences",
                    subtitle: "System Settings → Privacy & Security → Extensions"
                )
                setupStep(
                    number: 2,
                    title: "Enable Improved Right-Click",
                    subtitle: "Check the box next to the extension under \"Added Extensions\""
                )
                setupStep(
                    number: 3,
                    title: "Right-click in Finder",
                    subtitle: "You'll see \"New File\" and \"New Folder Here\" in the context menu"
                )
            }
            .padding(14)
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(10)

            Button("Open Extensions Preferences") {
                openExtensionsPreferences()
            }
            .controlSize(.large)
        }
    }

    private func setupStep(number: Int, title: String, subtitle: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Text("\(number)")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: 22, height: 22)
                .background(Color.accentColor)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 2) {
                Text(title).font(.subheadline.weight(.medium))
                Text(subtitle).font(.caption).foregroundColor(.secondary)
            }
        }
    }

    // MARK: - File Types

    private var fileTypesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label("Supported File Types", systemImage: "list.bullet")
                .font(.headline)

            let columns = [GridItem(.flexible()), GridItem(.flexible())]
            LazyVGrid(columns: columns, alignment: .leading, spacing: 8) {
                ForEach(fileTypeRows, id: \.ext) { row in
                    fileTypeRow(row)
                }
            }
            .padding(14)
            .background(Color(NSColor.controlBackgroundColor))
            .cornerRadius(10)
        }
    }

    private func fileTypeRow(_ item: FileTypeInfo) -> some View {
        HStack(spacing: 8) {
            Image(systemName: item.icon)
                .foregroundColor(.accentColor)
                .frame(width: 18)
            VStack(alignment: .leading, spacing: 1) {
                Text(item.name).font(.subheadline)
                Text(".\(item.ext)").font(.caption).foregroundColor(.secondary)
            }
        }
    }

    // MARK: - Helpers

    private func openExtensionsPreferences() {
        let url = URL(string: "x-apple.systempreferences:com.apple.ExtensionsPreferences")!
        NSWorkspace.shared.open(url)
    }
}

struct FileTypeInfo {
    let name: String
    let ext: String
    let icon: String
}

private let fileTypeRows: [FileTypeInfo] = [
    .init(name: "Text File",        ext: "txt",  icon: "doc.text"),
    .init(name: "Markdown",         ext: "md",   icon: "doc.richtext"),
    .init(name: "HTML",             ext: "html", icon: "globe"),
    .init(name: "JavaScript",       ext: "js",   icon: "doc.text"),
    .init(name: "CSS",              ext: "css",  icon: "paintpalette"),
    .init(name: "JSON",             ext: "json", icon: "curlybraces"),
    .init(name: "Python Script",    ext: "py",   icon: "terminal"),
    .init(name: "Shell Script",     ext: "sh",   icon: "terminal"),
    .init(name: "Swift File",       ext: "swift",icon: "swift"),
    .init(name: "Word Document",    ext: "docx", icon: "doc.fill"),
    .init(name: "PowerPoint",       ext: "pptx", icon: "rectangle.on.rectangle"),
    .init(name: "Excel Spreadsheet",ext: "xlsx", icon: "tablecells"),
]

#Preview {
    ContentView()
}
