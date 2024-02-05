{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;

    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    shellAliases = {
      "dr-switch" = "darwin-rebuild switch --flake ~/workspace/github/platform.developer/mac-build-agent";
      # alias for the empyrean cli
      "emp" = "empyrean";
    };

    initExtra = ''
      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
    '';
  };

  xdg.configFile.zsh.source = ./config;
}
