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
      stateVersion = "23.11";
    in
    {
      darwinConfigurations =
        {
          "HL-MBP-CarlosG" = darwinSystem {
            system = "aarch64-darwin";
            modules = [
              darwinModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.${username} = { pkgs, ... }:
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
                    };
                  };
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
