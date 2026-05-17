import SwiftUI

// MARK: - Root

struct MenuBarView: View {
    @ObservedObject var store: FileTypeStore
    @ObservedObject var extensionStatus: ExtensionStatus
    @State private var screen: Screen = .list

    enum Screen { case list, add }

    var body: some View {
        VStack(spacing: 0) {
            if !extensionStatus.isActive {
                ExtensionBanner(onEnable: extensionStatus.openExtensionSettings)
            }

            ZStack {
                if screen == .list {
                    ListView(store: store, onAdd: { screen = .add })
                        .transition(.move(edge: .leading))
                } else {
                    AddScreen(
                        onAdd: { config in
                            store.add(config)
                            screen = .list
                        },
                        onBack: { screen = .list }
                    )
                    .transition(.move(edge: .trailing))
                }
            }
            .animation(.easeInOut(duration: 0.2), value: screen)
        }
        .frame(width: 320)
    }
}

// MARK: - Extension not-active banner

private struct ExtensionBanner: View {
    let onEnable: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 13))
                .foregroundColor(.orange)

            VStack(alignment: .leading, spacing: 1) {
                Text("Finder extension not active")
                    .font(.system(size: 12, weight: .semibold))
                Text("Enable it in System Settings to use right-click.")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button("Enable") { onEnable() }
                .font(.system(size: 11, weight: .medium))
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(Color.orange.opacity(0.08))

        Divider()
    }
}

// MARK: - List screen

private struct ListView: View {
    @ObservedObject var store: FileTypeStore
    let onAdd: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // ── Header ────────────────────────────────────────────
            HStack(spacing: 10) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.accentColor.opacity(0.12))
                    .frame(width: 34, height: 34)
                    .overlay(
                        Image(systemName: "doc.badge.plus")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.accentColor)
                    )

                VStack(alignment: .leading, spacing: 1) {
                    Text("File Templates")
                        .font(.system(size: 13, weight: .semibold))
                    Text("Right-click in Finder to use")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }

                Spacer()

                Button(action: onAdd) {
                    Image(systemName: "plus")
                        .font(.system(size: 12, weight: .bold))
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

            Divider()

            // ── List ──────────────────────────────────────────────
            List {
                ForEach($store.types) { $type in
                    Row(type: $type, onDelete: { store.delete(type) })
                        .listRowInsets(EdgeInsets(top: 2, leading: 10, bottom: 2, trailing: 10))
                        .listRowSeparator(.hidden)
                }
                .onMove(perform: store.move)
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .frame(height: min(CGFloat(store.types.count) * 46, 368))

            Divider()

            // ── Footer ────────────────────────────────────────────
            Button("Reset to Defaults") { store.resetToDefaults() }
                .font(.system(size: 11))
                .foregroundColor(Color(NSColor.tertiaryLabelColor))
                .buttonStyle(.plain)
                .padding(.vertical, 10)
        }
    }
}

// MARK: - Row

private struct Row: View {
    @Binding var type: FileTypeConfig
    let onDelete: () -> Void
    @State private var hovered = false

    var body: some View {
        HStack(spacing: 9) {
            // Icon chip
            RoundedRectangle(cornerRadius: 7)
                .fill(type.isEnabled
                      ? Color.accentColor.opacity(0.1)
                      : Color.secondary.opacity(0.07))
                .frame(width: 30, height: 30)
                .overlay(
                    Image(systemName: type.systemIcon)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(type.isEnabled ? .accentColor : .secondary)
                )

            // Labels
            VStack(alignment: .leading, spacing: 1) {
                Text(type.displayName)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(type.isEnabled ? .primary : .secondary)
                Text(".\(type.fileExtension)")
                    .font(.system(size: 10, design: .monospaced))
                    .foregroundColor(Color(NSColor.tertiaryLabelColor))
            }

            Spacer()

            // Delete (visible on hover)
            Button(action: onDelete) {
                Image(systemName: "minus.circle.fill")
                    .font(.system(size: 14))
                    .foregroundColor(Color(NSColor.tertiaryLabelColor))
            }
            .buttonStyle(.plain)
            .opacity(hovered ? 1 : 0)

            // Toggle
            Toggle("", isOn: $type.isEnabled)
                .toggleStyle(.switch)
                .controlSize(.mini)
                .labelsHidden()
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 5)
        .background(
            RoundedRectangle(cornerRadius: 7)
                .fill(hovered ? Color.secondary.opacity(0.06) : .clear)
        )
        .contentShape(Rectangle())
        .onHover { hovered = $0 }
        .animation(.easeOut(duration: 0.1), value: hovered)
    }
}
