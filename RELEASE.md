# Publishing a Release

Distribute via GitHub Releases. No paid Apple Developer account required.

---

## Prerequisites

- Xcode installed with your free Apple ID signed in (Settings → Accounts)
- [GitHub CLI](https://cli.github.com) — `brew install gh && gh auth login`
- A public GitHub repository for this project

---

## One-time setup: create the GitHub repo

```bash
gh repo create improved-right-click --public --source=. --remote=origin --push
```

Or create it at github.com and add the remote manually:
```bash
git remote add origin https://github.com/Astrak00/ImprovedRightClick.git
git push -u origin main
```

---

## Cutting a release

### 1. Build and package

```bash
make release VERSION=1.0.0
```

This builds a signed Release binary, wraps it in a DMG with an Applications shortcut, and prints the file path and SHA-256.

### 2. Commit and tag

```bash
git add -A
git commit -m "Release v1.0.0"
git tag v1.0.0
git push origin main --tags
```

### 3. Publish to GitHub Releases

```bash
gh release create v1.0.0 \
  "build/ImprovedRightClick-1.0.0.dmg" \
  --title "v1.0.0" \
  --notes "$(cat <<'EOF'
## Install

1. Download `ImprovedRightClick-1.0.0.dmg` and open it
2. Drag **ImprovedRightClick** to Applications
3. Run this command to allow the app (required because it is not notarized):
   ```
   xattr -dr com.apple.quarantine /Applications/ImprovedRightClick.app
   ```
4. Open the app — enable the Finder extension when prompted

## Notes
- macOS 13 Ventura or later required
- After enabling the extension in System Settings → Privacy & Security → Extensions, right-click any folder in Finder to see **New File**
EOF
)"
```

That's it. The DMG is now publicly downloadable from your GitHub releases page.

---

## What users do to install

1. Download the DMG from the GitHub releases page
2. Open the DMG and drag the app to Applications
3. Remove the quarantine flag (one-time):
   ```bash
   xattr -dr com.apple.quarantine /Applications/ImprovedRightClick.app
   ```
4. Launch the app and enable the Finder extension when the banner appears

---

## Updating to a new version

```bash
make release VERSION=1.0.1
git add -A && git commit -m "Release v1.0.1"
git tag v1.0.1 && git push origin main --tags
gh release create v1.0.1 "build/ImprovedRightClick-1.0.1.dmg" --title "v1.0.1"
```

---

## Optional: Homebrew cask

If you want `brew install` support, create a separate `homebrew-tap` repo on GitHub and add `Casks/improved-right-click.rb` to it (template already in this repo). Update `sha256` with the value printed by `make release`, set your GitHub username in the `url` field, then push.

Users install with:
```bash
brew tap YOUR_USERNAME/tap
brew install --cask improved-right-click
```

The cask's `postflight` block already handles the quarantine removal automatically.
