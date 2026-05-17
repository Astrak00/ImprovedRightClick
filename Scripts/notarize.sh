#!/usr/bin/env bash
# Usage: bash Scripts/notarize.sh <path-to-dmg> <app-name>
# Required env vars (set in your shell or a .env file you source manually):
#   APPLE_ID        — your Apple ID email
#   APPLE_TEAM_ID   — your 10-char Team ID (e.g. XP64L9JZD6)
#   APPLE_APP_PASSWORD — app-specific password from appleid.apple.com
set -euo pipefail

DMG="$1"
APP_NAME="$2"

if [[ -z "${APPLE_ID:-}" || -z "${APPLE_TEAM_ID:-}" || -z "${APPLE_APP_PASSWORD:-}" ]]; then
  echo "Error: set APPLE_ID, APPLE_TEAM_ID, and APPLE_APP_PASSWORD before running."
  echo "  export APPLE_ID=you@example.com"
  echo "  export APPLE_TEAM_ID=XP64L9JZD6"
  echo "  export APPLE_APP_PASSWORD=xxxx-xxxx-xxxx-xxxx"
  exit 1
fi

echo "==> Submitting $DMG for notarization..."
xcrun notarytool submit "$DMG" \
  --apple-id    "$APPLE_ID" \
  --team-id     "$APPLE_TEAM_ID" \
  --password    "$APPLE_APP_PASSWORD" \
  --wait

echo "==> Stapling notarization ticket to $DMG..."
xcrun stapler staple "$DMG"

echo "==> Verifying..."
spctl -a -vv --type install "$DMG"

echo "==> Done. $DMG is notarized and ready for distribution."
