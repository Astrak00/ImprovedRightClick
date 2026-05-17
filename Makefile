.PHONY: generate build open clean

# Generate the Xcode project from project.yml
generate:
	xcodegen generate

# Build for debug (requires generated project)
build:
	xcodebuild -project ImprovedRightClick.xcodeproj \
	           -scheme ImprovedRightClick \
	           -configuration Debug \
	           build

# Open in Xcode
open: generate
	open ImprovedRightClick.xcodeproj

clean:
	rm -rf ImprovedRightClick.xcodeproj build/
