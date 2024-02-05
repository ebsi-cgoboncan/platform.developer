{ pkgs, lib, ... }:
{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  xdg.configFile."direnv/direnvrc".text = builtins.readFile ./direnvrc;
}

