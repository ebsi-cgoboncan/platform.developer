{
  description = "Build system";

  inputs = {
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;

    darwin.url = github:lnl7/nix-darwin/master;
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = github:nix-community/home-manager;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, darwin, ... }:
    let
      inherit (darwin.lib) darwinSystem;
      inherit (home-manager) darwinModules;
      inherit (home-manager.lib) homeManagerConfiguration;
      username = "cgoboncan";
      stateVersion = "22.05";
    in
    {
      darwinConfigurations =
        let
          hostname = "HL-MBP-CarlosG";
          system = "aarch64-darwin"; # or x86_64-darwin
        in
        {
          ${hostname} = darwinSystem {
            system = "aarch64-darwin";
            modules = [
              darwinModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.${username} =
                  { pkgs, ... }:
                  {
                    home = {
                      stateVersion = stateVersion;
                      username = username;

                      packages = with pkgs; [
                        nodejs
                      ];
                    };

                    programs = {
                      direnv = {
                        enable = true;
                        nix-direnv.enable = true;
                      };
                      zsh = {
                        enable = true;

                        shellAliases = {
                          "dr-switch" = "darwin-rebuild switch --flake ~/.dotfiles";
                          "emp" = "empyrean";
                        };

                        initExtraFirst = ''
                          hostname=$(scutil --get HostName)
                          if [ -z "$hostname" ]
                          then
                            scutil --set HostName ${hostname}.local
                          fi'';

                        initExtra = ''
                          # your zshrc goes here.
                        '';
                      };
                    };
                  };
                users.users.${username}.home = "/Users/${username}";

                services.nix-daemon.enable = true;

                nix.settings.substituters = [ "https://cache.nixos.org/" ];
                nix.settings.trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" ];
                nix.settings.trusted-users = [ "@admin" ];
                nix.configureBuildUsers = true;
                nix.extraOptions = ''
                  		keep-outputs = true
                      keep-derivations = true
                      auto-optimise-store = true
                      experimental-features = nix-command flakes'';
              }
            ];
          };
        };
      homeConfigurations =
        {
          ${username} =
            homeManagerConfiguration rec {
              pkgs = nixpkgs.legacyPackages.x86_64-linux;
              modules = [
                {
                  home = {
                    stateVersion = stateVersion;
                    username = username;
                    homeDirectory = "/home/${username}";

                    packages = with pkgs; [
                      nodejs
                    ];
                  };

                  programs = {
                    direnv = {
                      enable = true;
                      nix-direnv.enable = true;
                    };
                    home-manager.enable = true;
                  };
                }
              ];
            };
        };
    };
}
