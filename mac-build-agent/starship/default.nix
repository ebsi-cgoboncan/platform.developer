{ pkgs, lib, ... }:
{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      format = lib.concatStrings [
        "[░▒▓](#a3aed2)"
        "$username"
        "[](bg:#769ff0 fg:#a3aed2)"
        "$directory"
        "[](fg:#769ff0 bg:#394260)"
        "$git_branch"
        "$git_status"
        "[](fg:#394260)"
        "$fill"
        "[](fg:#394260)"
        "$nodejs"
        "$dotnet"
        "$lua"
        "$nix_shell"
        "$php"
        "$terraform"
        "[](fg:#212736 bg:#394260)"
        "$time"
        "$line_break"
        "$character"
      ];

      fill = {
        symbol = " ";
      };

      username = {
        show_always = true;
        style_user = "fg:#394260 bg:#a3aed2";
        format = "[ $user ]($style)"; 
      };

      directory = {
        style = "fg:#e3e5e5 bg:#769ff0";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
        substitutions = {
          "Documents" = " ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
        };
      };

      git_branch = {
        symbol = "";
        style = "bg:#394260";
        format = "[[ $symbol $branch ](fg:#769ff0 bg:#394260)]($style)";
      };

      git_status = {
        style = "bg:#394260";
        format = "[[($all_status$ahead_behind )](fg:#769ff0 bg:#394260)]($style)";
        ahead = "⇡$\{count}";
        diverged = "⇡$\{ahead_count}⇣$\{behind_count}";
        behind = "⇣$\{count}";
        untracked = "[?$\{count}](fg:red bg:#394260)";
        modified = "[!$\{count}](fg:yellow bg:#394260)";
        staged = "[+$\{count}](fg:green bg:#394260)";
      };

      nodejs = {
        symbol = "";
        style = "bg:#394260";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#394260)]($style)";
      };

      dotnet = {
        symbol = "";
        style = "bg:#394260";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#394260)]($style)";
      };

      lua = {
        symbol = "";
        style = "bg:#394260";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#394260)]($style)";
      };

      nix_shell = {
        symbol = "";
        style = "bg:#394260";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#394260)]($style)";
      };

      php = {
        symbol = "";
        style = "bg:#394260";
        format = "[[ $symbol ($version) ](fg:#769ff0 bg:#394260)]($style)";
      };

      terraform = {
        symbol = "󱁢";
        style = "bg:#394260";
        format = "[[ $symbol ($version $workspace) ](fg:#769ff0 bg:#394260)]($style)";
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:#1d2230";
        format = "[[  $time ](fg:#a0a9cb bg:#1d2230)]($style)";
      };
    };
  };
}
