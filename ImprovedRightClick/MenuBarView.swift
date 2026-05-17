import SwiftUI

struct MenuBarView: View {
    @StateObject private var store = FileTypeStore()
    @State private var showingAdd = false

    var body: some View {
        VStack(spacing: 0) {
            HeaderView(onAdd: { showingAdd = true })
            Divider()
            fileList
            Divider()
            FooterView(onReset: { withAnimation { store.resetToDefaults() } })
        }
        .frame(width: 320)
        .sheet(isPresented: $showingAdd) {
            AddFileTypeView { store.add($0) }
        }
    }

    private var fileList: some View {
        List {
            ForEach($store.types) { $type in
                FileTypeRow(type: $type) {
                    withAnimation { store.delete(type) }
                }
                .listRowInsets(EdgeInsets(top: 3, leading: 10, bottom: 3, trailing: 10))
                .listRowSeparator(.hidden)
            }
            .onMove(perform: store.move)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .frame(maxHeight: 390)
    }
}

// MARK: - Header

private struct HeaderView: View {
    let onAdd: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.accentColor.opacity(0.12))
                    .frame(width: 34, height: 34)
                Image(systemName: "doc.badge.plus")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.accentColor)
            }

            VStack(alignment: .leading, spacing: 1) {
                Text("File Templates")
                    .font(.system(size: 13, weight: .semibold))
                Text("Right-click in Finder to create files")
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button(action: onAdd) {
                Image(systemName: "plus")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.secondary)
                    .frame(width: 26, height: 26)
                    .background(Color.secondary.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 7))
            }
            .buttonStyle(.plain)
            .help("Add custom file type")
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }
}

// MARK: - Footer

private struct FooterView: View {
    let onReset: () -> Void

    var body: some View {
        HStack {
            Spacer()
            Button("Reset to Defaults", action: onReset)
                .font(.system(size: 11))
                .foregroundColor(Color(NSColor.tertiaryLabelColor))
                .buttonStyle(.plain)
            Spacer()
        }
        .padding(.vertical, 9)
    }
}

// MARK: - Row

private struct FileTypeRow: View {
    @Binding var type: FileTypeConfig
    let onDelete: () -> Void
    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 10) {
            iconView
            labelView
            Spacer()
            deleteButton
            toggleView
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 5)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(isHovered ? Color.secondary.opacity(0.07) : Color.clear)
        )
        .contentShape(Rectangle())
        .onHover { isHovered = $0 }
        .animation(.easeOut(duration: 0.12), value: isHovered)
    }

    private var iconView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 7)
                .fill(type.isEnabled
                      ? Color.accentColor.opacity(0.1)
                      : Color.secondary.opacity(0.08))
                .frame(width: 30, height: 30)
            Image(systemName: type.systemIcon)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(type.isEnabled ? .accentColor : .secondary)
        }
    }

    private var labelView: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(type.displayName)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(type.isEnabled ? .primary : .secondary)
            Text(".\(type.fileExtension)")
                .font(.system(size: 10, design: .monospaced))
                .foregroundColor(.secondary)
        }
    }

    private var deleteButton: some View {
        Button(action: onDelete) {
            Image(systemName: "minus.circle.fill")
                .font(.system(size: 15))
                .foregroundColor(.secondary.opacity(0.6))
        }
        .buttonStyle(.plain)
        .opacity(isHovered ? 1 : 0)
        .animation(.easeOut(duration: 0.12), value: isHovered)
        .help("Remove")
    }

    private var toggleView: some View {
        Toggle("", isOn: $type.isEnabled)
            .toggleStyle(.switch)
            .controlSize(.mini)
            .labelsHidden()
    }
}
