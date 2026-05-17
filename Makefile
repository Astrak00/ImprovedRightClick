.PHONY: generate build install open clean release dmg

APP_NAME    = ImprovedRightClick
SCHEME      = ImprovedRightClick
BUILD_DIR   = build
RELEASE_APP = $(BUILD_DIR)/Build/Products/Release/$(APP_NAME).app
INSTALL_DIR = /Applications

# Version: pass on command line, e.g. make release VERSION=1.0.2
VERSION     ?= 1.0.0
DMG_NAME    = $(APP_NAME)-$(VERSION).dmg
DMG_PATH    = $(BUILD_DIR)/$(DMG_NAME)

# Generate the Xcode project from project.yml
generate:
	xcodegen generate

# Build release binary
build:
	xcodebuild -project $(APP_NAME).xcodeproj \
	           -scheme $(SCHEME) \
	           -configuration Release \
	           -derivedDataPath $(BUILD_DIR) \
	           build

# Build + copy to /Applications + launch
install: build
	@echo "Installing to $(INSTALL_DIR)..."
	@cp -R "$(RELEASE_APP)" "$(INSTALL_DIR)/$(APP_NAME).app"
	@echo "Launching..."
	@pkill -x "$(APP_NAME)" 2>/dev/null || true
	@open "$(INSTALL_DIR)/$(APP_NAME).app"
	@echo "Done. Add it to Login Items to auto-start at login:"
	@echo "  System Settings → General → Login Items → + → $(INSTALL_DIR)/$(APP_NAME).app"

# Open in Xcode
open: generate
	open $(APP_NAME).xcodeproj

# Create a distributable DMG
dmg: build
	@echo "Creating $(DMG_NAME)..."
	@rm -f "$(DMG_PATH)"
	@mkdir -p "$(BUILD_DIR)/dmg-staging"
	@cp -R "$(RELEASE_APP)" "$(BUILD_DIR)/dmg-staging/"
	@ln -sf /Applications "$(BUILD_DIR)/dmg-staging/Applications"
	@hdiutil create \
	    -volname "$(APP_NAME)" \
	    -srcfolder "$(BUILD_DIR)/dmg-staging" \
	    -ov -format UDZO \
	    "$(DMG_PATH)"
	@rm -rf "$(BUILD_DIR)/dmg-staging"
	@echo ""
	@echo "Created: $(DMG_PATH)"
	@echo "SHA-256:"
	@shasum -a 256 "$(DMG_PATH)"

# Full release: build → DMG → print next steps
release: dmg
	@echo ""
	@echo "=== DMG ready for release ==="
	@echo "  1. git tag v$(VERSION) && git push origin v$(VERSION)"
	@echo "  2. gh release create v$(VERSION) '$(DMG_PATH)' --title 'v$(VERSION)'"

clean:
	rm -rf $(APP_NAME).xcodeproj $(BUILD_DIR)/
