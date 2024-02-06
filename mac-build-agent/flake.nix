{
  description = "Build system";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;

    darwin.url = github:lnl7/nix-darwin/master;
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = github:nix-community/home-manager;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, darwin, ... }:
    let
      inherit (darwin.lib) darwinSystem;
      inherit (home-manager) darwinModules;
      inherit (home-manager.lib) homeManagerConfiguration;

      teamcityUsername = "svc_teamcityagent";
      appmanagerengineerUsername = "appmanagerengineer";
      hostname = "hw-mbmdev";
      system = "x86_64-darwin";

      # nix-darwin configuration options can be found at:
      # https://daiderd.com/nix-darwin/manual/index.html
      nixDarwinConfig =
        { pkgs, ... }:
        {
          fonts.fontDir.enable = true;
          fonts.fonts = with pkgs; [
            recursive
            (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "NerdFontsSymbolsOnly" ]; })
          ];

          nix.settings.experimental-features = "nix-command flakes";
          nix.extraOptions = ''auto-optimise-store = true'';
          # autoupgrade nix when flake.lock is updated
          nix.package = pkgs.nix;

          nixpkgs.hostPlatform = system;

          # required for nix-darwin to manage zshrc files in /etc 
          programs.zsh.enable = true;

          services.nix-daemon.enable = true;

          system.configurationRevision = self.rev or self.dirtyRev or null;
          system.stateVersion = 4;

          users.users = {
            "${teamcityUsername}" = {
              home = "/Users/${teamcityUsername}";
              shell = pkgs.zsh;
            };
            "${appmanagerengineerUsername}" = {
              home = "/Users/${appmanagerengineerUsername}";
              shell = pkgs.zsh;
            };
          };
        };

      # home-manager configuration options can be found at:
      # https://nix-community.github.io/home-manager/options.html
      teamcityConfig =
        { pkgs, lib, config, ... }:
        {
          home = {
            stateVersion = "23.11";
            username = teamcityUsername;

            # Packages outside of home-manager can be found at:
            # https://search.nixos.org/packages
            packages = with pkgs; [
              yarn
              nodejs_18
              jdk17
              gradle
            ];
          };

          imports = [
            ./direnv
            ./nvim
            ./starship
            ./tmux
            ./zsh
          ];

          programs = {
            home-manager = {
              enable = true;
            };
          };
        };

      appManagerConfig =
        { pkgs, lib, config, ... }:
        {
          home = {
            stateVersion = "23.11";
            username = "${appmanagerengineerUsername}";

            packages = with pkgs; [ ];
          };

          imports = [
            ./direnv
            ./nvim
            ./starship
            ./tmux
            ./zsh
          ];

          programs = {
            home-manager = {
              enable = true;
            };
          };
        };
    in
    {
      darwinConfigurations.${hostname} = darwinSystem {
        system = system;
        modules = [
          nixDarwinConfig
          darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "nix-backup";
            home-manager.users.${teamcityUsername} = teamcityConfig;
            home-manager.users.${appmanagerengineerUsername} = appManagerConfig;
          }
        ];
      };
    };
}
