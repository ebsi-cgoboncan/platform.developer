How are the CLI keys generated?

- look at the table app_cli_keys, check columns, compare app_key value with mine.
- Keys look like a random generated password, subject is just a label to identify who the key was issued to. We think the rows are manually entered, but there is route in the api
  that exposes adding a key.

# Setup:

- Created standard user on hw-mbmdev (appmanagerengineer), used letters and numbers to generate password.
- Logged into account and skipped over AppleID login
- Enabled Remote Login and added appmanagerengineer to the allowed list
- Setup nix-darwin and home-manager for appmanagerengineer via svc_teamcityagent's configuration. (login with svc_teamcityagent, ran `dr-switch`)
- Cloned platform.developer repo into Users/appmanagerengineer/workspace/platform.developer
- Added GitHub `ebsi-teamcity` PAT (repo, read_packages) for `AppManagerEngineer Nix PAT`
- Created Shortcut SOC ticket to add CLI key,
- Added build secrets to `appmanagereingineer` OSX keychain (must be done through macos GUI), set cli_api_key, fastlane.admin@enspire.me, fastlane.it@enspire.me, google_maps_key, maven_token.
- Created Gitlab PAT (read_repository) via `cgoboncan-ebsi`.
- Configure git to store credientals in osxkeychain. `git config --global credentials.helper osxkeychain`
- Created ios appyhour app, cd'ed into directory and ran `pod install`. Used `cgoboncan-ebsi` and Gitlab PAT when prompted (must be done through macos GUI).
- Authenticated to Apple Developer Program by `fastlane spaceship -u admin@enspire.me` (must be done through macos GUI, requires 2fa code).
- Confirmed fastlane_session with `cli fastlane auth admin@enspire.me`.

# Build iOS App

- `ssh` into `hw-mbmdev` with `appmanagerengineer`'s credientals.
- `cd` into `~/workspace/platform.developer/app-manager-engineer/build` folder.
- Run `cli app create apple <client_id> <folder_name>`. e.g. `cli app create apple appyhour appyhour-2024-02-05`
- Run `cli app upload apple <client_id> <folder_name>`. e.g. `cli app upload apple appyhour appyhour-2024-02-05`
