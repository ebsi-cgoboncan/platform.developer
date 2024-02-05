{ pkgs, ... }: 
{
  programs.zsh = {
    enable = true;

    shellAliases = {
      "dr-switch" = "darwin-rebuild switch --flake ~/workspace/github/platform.developer/mac-build-agent";
       # alias for the empyrean cli
       "emp" = "empyrean";
    };

    initExtra = ''
	    source $HOME/.config/zsh/default.zsh
    '';
  };

  xdg.configFile.zsh.source = ./config;
}
