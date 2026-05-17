# Improved Right-Click

Adds a **New File** submenu and **New Folder Here** to Finder's right-click context menu — the Windows feature macOS users have always missed.

## Supported file types

| Type | Extension |
|---|---|
| Text File | `.txt` |
| Markdown | `.md` |
| HTML | `.html` |
| CSS | `.css` |
| JavaScript | `.js` |
| JSON | `.json` |
| Python Script | `.py` |
| Shell Script | `.sh` |
| Swift File | `.swift` |
| Word Document | `.docx` |
| PowerPoint | `.pptx` |
| Excel Spreadsheet | `.xlsx` |

New files are named `untitled.ext` (or `untitled 2.ext` if one already exists), matching Finder's convention.

## Requirements

- macOS 12 Monterey or later
- Xcode 15+
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) (`brew install xcodegen`)
- An Apple Developer account (free or paid) for code signing

## Build & install

```bash
# 1. Install XcodeGen if you don't have it
brew install xcodegen

# 2. Generate the Xcode project
make generate

# 3. Open in Xcode, set your Team in Signing & Capabilities, then run
make open
```

> **Important:** Run the **ImprovedRightClick** scheme (not FinderSyncExtension directly). This installs the host app, which registers the extension.

## Enable the extension

1. Launch the app — it shows you the exact steps
2. Open **System Settings → Privacy & Security → Extensions → Added Extensions**
3. Check **Improved Right-Click**
4. Right-click anywhere in Finder — enjoy

## Architecture

```
ImprovedRightClick/          ← Host app (SwiftUI setup UI)
  App.swift
  ContentView.swift

FinderSyncExtension/         ← Finder Sync Extension (the actual menu)
  FinderSync.swift           ← FIFinderSync subclass, menu items, actions
  FileTemplate.swift         ← File type definitions and content generators
  OfficeTemplates.swift      ← Minimal valid OOXML (docx/pptx/xlsx) builders
  MinimalZIPWriter.swift     ← Pure-Swift ZIP writer (no dependencies)
```

### How it works

- A **Finder Sync Extension** (`FIFinderSync` subclass) watches `/` so the menu appears in every Finder window.
- On right-click, `menu(for:)` returns an `NSMenu` with a "New File" submenu and a "New Folder Here" item.
- Text-based files are created from inline Swift string templates.
- Office formats (`.docx`, `.pptx`, `.xlsx`) are minimal-but-valid OOXML ZIP packages, assembled at runtime by a dependency-free ZIP writer. They open without errors in Microsoft Office, LibreOffice, and Apple iWork.

## Distribution (non-App Store)

Build with `Release` configuration and sign with your **Developer ID Application** certificate. Users will need to allow the extension in System Settings the first time.

## App Store distribution

The `com.apple.security.temporary-exception.files.absolute-path.read-write` entitlement used by the extension is not allowed on the App Store. To distribute via the Mac App Store:

1. Remove that entitlement.
2. Use an **XPC service** inside the host app to perform file creation.
3. The extension sends an XPC message with the target path; the host app service (which can have `com.apple.security.files.user-selected.read-write`) creates the file.
