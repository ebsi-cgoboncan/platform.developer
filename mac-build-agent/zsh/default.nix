{ pkgs, ... }: 
{
  programs.zsh = {
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

  xdg.configFile.zsh.source = ./config;
}
