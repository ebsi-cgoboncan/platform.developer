{ config, pkgs, lib, ... }:

{
  programs.tmux.baseIndex = 1;
  programs.tmux.enable = true;
  programs.tmux.customPaneNavigationAndResize = true;
  programs.tmux.keyMode = "vi";
  programs.tmux.shortcut = "a";
  programs.tmux.terminal = "tmux-256color";
  programs.tmux.escapeTime = 0;
  programs.tmux.historyLimit = 10000;
  programs.tmux.extraConfig = ''
    set -g mouse on

    set-option -gas terminal-overrides "*:Tc" # true color support
    set-option -gas terminal-overrides "*:RGB" # true color support
    set -as terminal-overrides ',*:Smulx=\E[4::%p1%dm'  # undercurl support
    set -as terminal-overrides ',*:Setulc=\E[58::2::%p1%{65536}%/%d::%p1%{256}%/%{255}%&%d::%p1%{255}%&%d%;m'  # underscore colours - needs tmux-3.0
    set-environment -g COLORTERM "truecolor"

    set-option -g renumber-windows on

    bind -n M-k clear-history 


    # key bindings for tmux.nvim
    is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"

    # navigation
    bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h' { if -F '#{pane_at_left}' ${"''"} 'select-pane -L' }
    bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j' { if -F '#{pane_at_bottom}' ${"''"} 'select-pane -D' }
    bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k' { if -F '#{pane_at_top}' ${"''"} 'select-pane -U' }
    bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l' { if -F '#{pane_at_right}' ${"''"} 'select-pane -R' }

    bind-key -T copy-mode-vi 'C-h' if -F '#{pane_at_left}' ${"''"} 'select-pane -L'
    bind-key -T copy-mode-vi 'C-j' if -F '#{pane_at_bottom}' ${"''"} 'select-pane -D'
    bind-key -T copy-mode-vi 'C-k' if -F '#{pane_at_top}' ${"''"} 'select-pane -U'
    bind-key -T copy-mode-vi 'C-l' if -F '#{pane_at_right}' ${"''"} 'select-pane -R'

    # pane resizing
    bind -n 'M-h' if-shell "$is_vim" 'send-keys M-h' 'resize-pane -L 1'
    bind -n 'M-j' if-shell "$is_vim" 'send-keys M-j' 'resize-pane -D 1'
    bind -n 'M-k' if-shell "$is_vim" 'send-keys M-k' 'resize-pane -U 1'
    bind -n 'M-l' if-shell "$is_vim" 'send-keys M-l' 'resize-pane -R 1'

    bind-key -T copy-mode-vi M-h resize-pane -L 1
    bind-key -T copy-mode-vi M-j resize-pane -D 1
    bind-key -T copy-mode-vi M-k resize-pane -U 1
    bind-key -T copy-mode-vi M-l resize-pane -R 1

    # open new splits using current working directory
    bind '"' split-window -v -c "#{pane_current_path}"
    bind % split-window -h -c "#{pane_current_path}"

    # This tmux statusbar config was created by tmuxline.vim
    # on Tue, 23 Jun 2020
  
    fg_dark="#a9b1d6" # 169, 177, 213
    fg_color="#c0caf5" # 192, 202, 245
    bg_color="#414868" # 65, 72, 104
    bg="#24283b" # 36, 40, 59
    blue="#7aa2f7" # 122, 162, 247
    fg_gutter="#3b4261" # 59, 66, 97
    purple="#9d7cd8" # 157, 124, 216
    bg_dark="#1f2335" # rgb 31, 35, 53
  
    set -g status-justify "left"
    set -g status "on"
    set -g status-left-style "none"
    set -g message-command-style "fg=#{fg_color},bg=#{bg_color}"
    set -g status-right-style "none"
    set -g pane-active-border-style "fg=#{blue}"
    set -g status-style "none,bg=#{bg_dark}"
    set -g message-style "fg=#{fg_color},bg=#{bg_color}"
    set -g pane-border-style "fg=#{bg_color}"
    set -g status-right-length "100"
    set -g status-left-length "100"
    setw -g window-status-activity-style "none"
    setw -g window-status-separator ""
  
    setw -g window-status-style "none,fg=#{purple},bg=#{fg_gutter}"
  
    set -g status-left "\
    #[fg=#{bg_dark},bg=#{blue}] #S \
    #[fg=#{blue},bg=#{bg_dark}]"
  
    set -g status-right "\
    #[fg=#{bg_color},bg=#{bg_dark}] %v \
    #[fg=#{fg_gutter},bg=#{bg}]\
    #[fg=#{blue},bg=#{fg_gutter}] %l:%M %p \
    #[fg=#{blue},bg=#{fg_gutter}]\
    #[fg=#{bg_dark},bg=#{blue}] #(echo $USER)@#h "
  
    setw -g window-status-format "\
    #[fg=#{bg_color},bg=#{bg_dark}] #I \
    #[fg=#{bg_color},bg=#{bg_dark}] #W "
  
    setw -g window-status-current-format "\
    #[fg=#{bg_dark},bg=#{fg_gutter}]\
    #[fg=#{fg_dark},bg=#{fg_gutter}] #I \
    #[fg=#{fg_dark},bg=#{fg_gutter}] #W \
    #[fg=#{fg_gutter},bg=#{bg_dark}]"
  '';

  programs.tmux.plugins = [
    {
      plugin = pkgs.tmuxPlugins.resurrect;
      extraConfig = "set -g @resurrect-strategy-nvim 'session'";
    }
    {
      plugin = pkgs.tmuxPlugins.continuum;
      extraConfig = ''
        set -g @continuum-restore 'on'
        set -g @continuum-save-interval '15' # minutes
      '';
    }
  ];
}

