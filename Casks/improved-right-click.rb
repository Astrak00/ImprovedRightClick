cask "improved-right-click" do
  version "1.0.0"
  sha256 "657703524a2c22563b006e092ed1bd94841db59501204faeeb89915ab32ba457"

  url "https://github.com/Astrak00/ImprovedRightClick/releases/download/v#{version}/ImprovedRightClick-#{version}.dmg",
      verified: "github.com/Astrak00/ImprovedRightClick/"
  name "Improved Right Click"
  desc "Bring the right click > create new file to Finder"
  homepage "https://github.com/Astrak00/ImprovedRightClick"

  depends_on macos: :ventura

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
