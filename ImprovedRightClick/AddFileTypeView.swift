import SwiftUI

// MARK: - Add screen (no ScrollView — fits in the popover directly)

struct AddScreen: View {
    let onAdd: (FileTypeConfig) -> Void
    let onBack: () -> Void

    @State private var name      = ""
    @State private var ext       = ""
    @State private var icon      = "doc.text"
    @State private var content   = ""
    @State private var showContent = false

    private var canSubmit: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !ext.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            form
            Divider()
            footer
        }
        .frame(width: 320)
    }

    // MARK: Header

    private var header: some View {
        HStack {
            Button(action: onBack) {
                HStack(spacing: 3) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 11, weight: .semibold))
                    Text("Back")
                        .font(.system(size: 12))
                }
                .foregroundColor(.secondary)
            }
            .buttonStyle(.plain)

            Spacer()

            Text("New File Type")
                .font(.system(size: 13, weight: .semibold))

            Spacer()

            // balance spacer
            Text("Back")
                .font(.system(size: 12))
                .opacity(0)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
    }

    // MARK: Form

    private var form: some View {
        VStack(alignment: .leading, spacing: 14) {

            // Name + Extension in one row
            HStack(alignment: .top, spacing: 10) {
                field(label: "Name") {
                    TextField("e.g. TypeScript File", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .font(.system(size: 12))
                }

                field(label: "Extension") {
                    HStack(spacing: 0) {
                        Text(".")
                            .foregroundColor(.secondary)
                            .padding(.leading, 7)
                            .font(.system(size: 13))
                        TextField("ts", text: $ext)
                            .font(.system(size: 13, design: .monospaced))
                            .textFieldStyle(.plain)
                            .padding(.vertical, 4)
                            .padding(.trailing, 6)
                            .onChange(of: ext) { v in
                                if v.hasPrefix(".") { ext = String(v.dropFirst()) }
                            }
                    }
                    .frame(height: 22)
                    .background(Color(NSColor.textBackgroundColor))
                    .overlay(RoundedRectangle(cornerRadius: 5)
                        .stroke(Color(NSColor.separatorColor), lineWidth: 1))
                    .cornerRadius(5)
                }
                .frame(width: 78)
            }

            // Icon grid
            field(label: "Icon") {
                iconGrid
            }

            // Initial content (collapsible)
            VStack(alignment: .leading, spacing: 6) {
                Button {
                    withAnimation(.easeOut(duration: 0.15)) { showContent.toggle() }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 9, weight: .heavy))
                            .rotationEffect(.degrees(showContent ? 90 : 0))
                            .foregroundColor(.secondary)
                        Text("Initial content")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.secondary)
                        Text("· optional")
                            .font(.system(size: 10))
                            .foregroundColor(Color(NSColor.tertiaryLabelColor))
                    }
                }
                .buttonStyle(.plain)

                if showContent {
                    TextEditor(text: $content)
                        .font(.system(size: 11, design: .monospaced))
                        .frame(height: 72)
                        .scrollContentBackground(.hidden)
                        .background(Color(NSColor.textBackgroundColor))
                        .overlay(RoundedRectangle(cornerRadius: 5)
                            .stroke(Color(NSColor.separatorColor), lineWidth: 1))
                        .cornerRadius(5)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
        }
        .padding(14)
    }

    // MARK: Icon grid

    private let icons: [String] = [
        "doc.text",   "doc.richtext",  "doc.fill",   "globe",
        "paintpalette","curlybraces",   "terminal",   "swift",
        "tablecells", "rectangle.on.rectangle", "cpu", "puzzlepiece",
        "photo",      "music.note",    "chevron.left.forwardslash.chevron.right", "film",
    ]

    private var iconGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 5), count: 8), spacing: 5) {
            ForEach(icons, id: \.self) { name in
                Button { icon = name } label: {
                    Image(systemName: name)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(icon == name ? .accentColor : .primary)
                        .frame(width: 30, height: 28)
                        .background(RoundedRectangle(cornerRadius: 6)
                            .fill(icon == name
                                  ? Color.accentColor.opacity(0.14)
                                  : Color.secondary.opacity(0.08)))
                        .overlay(RoundedRectangle(cornerRadius: 6)
                            .stroke(icon == name ? Color.accentColor : Color.clear,
                                    lineWidth: 1.5))
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: Footer

    private var footer: some View {
        HStack {
            Button("Cancel", action: onBack)
                .keyboardShortcut(.cancelAction)

            Spacer()

            Button("Add File Type") {
                onAdd(FileTypeConfig(
                    displayName: name.trimmingCharacters(in: .whitespaces),
                    fileExtension: ext.trimmingCharacters(in: .whitespaces).lowercased(),
                    systemIcon: icon,
                    isEnabled: true,
                    initialContent: content
                ))
            }
            .keyboardShortcut(.defaultAction)
            .disabled(!canSubmit)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
    }

    // MARK: Helpers

    @ViewBuilder
    private func field<Content: View>(label: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.secondary)
            content()
        }
    }
}
