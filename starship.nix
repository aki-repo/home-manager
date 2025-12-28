{ pkgs, ... }

# Starship prompt configuration
  programs.starship = {
    enable = true;
    settings = {
      format = "$directory$git_branch$git_status$line_break$character";

      character = {
        success_symbol = "[❯](bold mauve)";
        error_symbol = "[❯](bold red)";
      };

      directory = {
        style = "bold blue";
        truncate_to_repo = false;
      };

      git_branch = {
        style = "bold purple";
      };
    };
  };
}