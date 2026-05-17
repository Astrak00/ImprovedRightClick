cask "improved-right-click" do
  version "1.0.0"
  # Run `shasum -a 256 ImprovedRightClick-<version>.dmg` and paste here:
  sha256 "REPLACE_WITH_SHA256_OF_DMG"

  # Replace with the actual GitHub release URL after you publish it:
  url "https://github.com/YOUR_GITHUB_USERNAME/improved-right-click/releases/download/v#{version}/ImprovedRightClick-#{version}.dmg"

  name "Improved Right Click"
  desc "Adds a 'New File' submenu to Finder's right-click context menu"
  homepage "https://github.com/YOUR_GITHUB_USERNAME/improved-right-click"

  depends_on macos: ">= :ventura"

  app "ImprovedRightClick.app"

  postflight do
    system_command "/usr/bin/open",
                   args: ["-a", "ImprovedRightClick"]
  end

  uninstall quit: "com.improvedrightclick.app"

  zap trash: [
    "~/Library/Group Containers/group.com.improvedrightclick.app",
    "~/Library/Preferences/com.improvedrightclick.app.plist",
  ]
end
