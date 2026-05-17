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

### Brew
```bash
brew install astrak00/tap/improved-right-click
```
Remove the quarantine flag (one-time):
   ```bash
   xattr -dr com.apple.quarantine /Applications/ImprovedRightClick.app
   ```
Launch the app and enable the Finder extension when the banner appears


### Manual

1. Download the latest release from the [Releases](https://github.com/Astrak00/ImprovedRightClick/releases) page:
2. Open the DMG and drag the app to Applications
3. Remove the quarantine flag (one-time):
   ```bash
   xattr -dr com.apple.quarantine /Applications/ImprovedRightClick.app
   ```
4. Launch the app and enable the Finder extension when the banner appears



## Enable the extension

1. Launch the app — it shows you the exact steps
2. Open **System Settings → Privacy & Security → Extensions → Added Extensions**
3. Check **Improved Right-Click**
4. Right-click anywhere in Finder — enjoy