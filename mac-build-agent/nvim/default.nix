{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    extraConfig = ''
	    lua require('init')
	  '';
    plugins = with pkgs.vimPlugins; [
      nvim-tree-lua
      tokyonight-nvim
      vim-surround
      which-key-nvim
    ];
  };

	xdg.configFile."nvim/lua".source = ./lua;
}
