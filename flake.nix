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

      username = "cgoboncan";
      hostname = "HL-MBP-CarlosG";
      system = "aarch64-darwin"; # or x86_64-darwin

      # nix-darwin configuration options can be found at:
      # https://daiderd.com/nix-darwin/manual/index.html
      nixDarwinConfig =
        { pkgs, ... }:
        {
          nix.settings.experimental-features = "nix-command flakes";
          nix.extraOptions = ''auto-optimise-store = true'';
          # autoupgrade nix when flake.lock is updated
          nix.package = pkgs.nix;

          nixpkgs.hostPlatform = system;

          networking.localHostName = hostname;

          # required for nix-darwin to manage zshrc files in /etc 
          programs.zsh.enable = true;

          services.nix-daemon.enable = true;

          system.configurationRevision = self.rev or self.dirtyRev or null;
          system.stateVersion = 4;

          users.users.${username} = {
            home = "/Users/${username}";
            shell = pkgs.zsh;
          };
        };

      # home-manager configuration options can be found at:
      # https://nix-community.github.io/home-manager/options.html
      homeManagerConfig =
        { pkgs, ... }:
        {
          home = {
            stateVersion = "23.11";
            username = username;

            # Packages outside of home-manager can be found at:
            # https://search.nixos.org/packages
            packages = with pkgs; [ ];
          };

          programs = {
            direnv = {
              enable = true;
              enableZshIntegration = true;
              nix-direnv.enable = true;
            };

            home-manager = {
              enable = true;
            };

            # this is required to enable direnv integration. 
            zsh = {
              enable = true;

              shellAliases = {
                "dr-switch" = "darwin-rebuild switch --flake ~/.config/nix-darwin";
                # alias for the empyrean cli
                "emp" = "empyrean";
              };

              initExtra = ''
                source $HOME/.config/zsh/default.zsh 
              '';
            };
          };

          xdg.configFile.zsh.source = ./zsh;
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
            home-manager.users.${username} = homeManagerConfig;
          }
        ];
      };
    };
}
