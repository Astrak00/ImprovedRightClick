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

## How to install it

1. Download the DMG from the GitHub releases page
2. Open the DMG and drag the app to Applications
3. Remove the quarantine flag (one-time):
   ```bash
   xattr -dr com.apple.quarantine /Applications/ImprovedRightClick.app
   ```
4. Launch the app and enable the Finder extension when the banner appears


## Requirements

- macOS 12 Monterey or later
- Xcode 15+
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) (`brew install xcodegen`) _not available yet_



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
