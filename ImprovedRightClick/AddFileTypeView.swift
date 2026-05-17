import SwiftUI

struct AddFileTypeView: View {
    let onAdd: (FileTypeConfig) -> Void
    @Environment(\.dismiss) private var dismiss

    @State private var displayName = ""
    @State private var fileExtension = ""
    @State private var selectedIcon = "doc.text"
    @State private var initialContent = ""
    @State private var showInitialContent = false

    private let icons: [String] = [
        "doc.text", "doc.richtext", "doc.fill", "doc.badge.plus",
        "globe", "paintpalette", "curlybraces", "chevron.left.forwardslash.chevron.right",
        "terminal", "swift", "cpu", "puzzlepiece",
        "tablecells", "rectangle.on.rectangle", "photo", "music.note",
    ]

    private var canAdd: Bool {
        !displayName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !fileExtension.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        VStack(spacing: 0) {
            sheetHeader
            Divider()
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    nameAndExtensionRow
                    iconPicker
                    initialContentSection
                }
                .padding(16)
            }
            Divider()
            sheetFooter
        }
        .frame(width: 340)
    }

    // MARK: - Header

    private var sheetHeader: some View {
        HStack {
            Text("Add File Type")
                .font(.system(size: 14, weight: .semibold))
            Spacer()
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 18))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.top, 16)
        .padding(.bottom, 12)
    }

    // MARK: - Name + Extension

    private var nameAndExtensionRow: some View {
        HStack(alignment: .top, spacing: 10) {
            VStack(alignment: .leading, spacing: 5) {
                fieldLabel("Name")
                TextField("e.g. TypeScript File", text: $displayName)
                    .textFieldStyle(.roundedBorder)
            }

            VStack(alignment: .leading, spacing: 5) {
                fieldLabel("Extension")
                extensionField
            }
            .frame(width: 84)
        }
    }

    private var extensionField: some View {
        HStack(spacing: 0) {
            Text(".")
                .font(.system(size: 13))
                .foregroundColor(.secondary)
                .padding(.leading, 7)
            TextField("ts", text: $fileExtension)
                .font(.system(size: 13, design: .monospaced))
                .textFieldStyle(.plain)
                .padding(.vertical, 4)
                .padding(.trailing, 6)
                .onChange(of: fileExtension) { newValue in
                    if newValue.hasPrefix(".") {
                        fileExtension = String(newValue.dropFirst())
                    }
                }
        }
        .background(Color(NSColor.textBackgroundColor))
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color(NSColor.separatorColor), lineWidth: 1)
        )
        .cornerRadius(6)
    }

    // MARK: - Icon Picker

    private var iconPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            fieldLabel("Icon")
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 8),
                spacing: 6
            ) {
                ForEach(icons, id: \.self) { name in
                    iconCell(name)
                }
            }
        }
    }

    private func iconCell(_ name: String) -> some View {
        let selected = selectedIcon == name
        return Button { selectedIcon = name } label: {
            Image(systemName: name)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(selected ? .accentColor : .primary)
                .frame(width: 30, height: 30)
                .background(
                    RoundedRectangle(cornerRadius: 7)
                        .fill(selected
                              ? Color.accentColor.opacity(0.14)
                              : Color.secondary.opacity(0.08))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(selected ? Color.accentColor : Color.clear, lineWidth: 1.5)
                )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Initial Content

    private var initialContentSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            Button {
                withAnimation(.easeOut(duration: 0.15)) {
                    showInitialContent.toggle()
                }
            } label: {
                HStack(spacing: 5) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 9, weight: .bold))
                        .rotationEffect(.degrees(showInitialContent ? 90 : 0))
                        .foregroundColor(.secondary)
                    Text("Initial Content")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.secondary)
                    Text("optional")
                        .font(.system(size: 10))
                        .foregroundColor(Color(NSColor.tertiaryLabelColor))
                }
            }
            .buttonStyle(.plain)

            if showInitialContent {
                TextEditor(text: $initialContent)
                    .font(.system(size: 11, design: .monospaced))
                    .frame(height: 88)
                    .scrollContentBackground(.hidden)
                    .background(Color(NSColor.textBackgroundColor))
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color(NSColor.separatorColor), lineWidth: 1)
                    )
                    .cornerRadius(6)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }

    // MARK: - Footer

    private var sheetFooter: some View {
        HStack {
            Button("Cancel") { dismiss() }
                .keyboardShortcut(.cancelAction)
            Spacer()
            Button("Add File Type") {
                onAdd(FileTypeConfig(
                    displayName: displayName.trimmingCharacters(in: .whitespaces),
                    fileExtension: fileExtension
                        .trimmingCharacters(in: .whitespaces)
                        .lowercased(),
                    systemIcon: selectedIcon,
                    isEnabled: true,
                    initialContent: initialContent
                ))
                dismiss()
            }
            .keyboardShortcut(.defaultAction)
            .disabled(!canAdd)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    // MARK: - Helpers

    private func fieldLabel(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .medium))
            .foregroundColor(.secondary)
    }
}
