.PHONY: generate build install open clean

APP_NAME   = ImprovedRightClick
SCHEME     = ImprovedRightClick
BUILD_DIR  = build
RELEASE_APP = $(BUILD_DIR)/Build/Products/Release/$(APP_NAME).app
INSTALL_DIR = /Applications

# Generate the Xcode project from project.yml
generate:
	xcodegen generate

# Build release binary (no Xcode needed after first generate)
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

clean:
	rm -rf $(APP_NAME).xcodeproj $(BUILD_DIR)/
