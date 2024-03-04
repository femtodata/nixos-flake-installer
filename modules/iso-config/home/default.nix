{ config, pkgs, ... }:
{
  home.stateVersion = "22.05";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;

    # check if the following are needed with oh-my-zsh
    enableCompletion = true;
    # syntaxHighlighting.enable = true;

    # completion init shadowed by oh-my-zsh
    # completionInit = ''
    #   autoload -U compinit && compinit
    #   autoload -U bashcompinit && bashcompinit
    #   source ${pkgs.distrobox}/completions
    # '';

    history.ignoreDups = true;
    history.ignoreSpace = true;

    initExtraFirst = ''
      export EDITOR='/run/current-system/sw/bin/vim'
      export VISUAL='/run/current-system/sw/bin/vim'
      export PAGER='less -S -R -F'
    '';

    initExtra = ''
      l='ls -lah --color=always'
    '';

    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [
        "direnv"
        "docker"
        "docker-compose"
        "doctl"
        "dotenv"
        "git"
        "python"
        # "tmux"
      ];

      extraConfig = ''
        COMPLETION_WAITING_DOTS="true"
        HIST_STAMPS="yyyy-mm-dd"

        autoload -U compinit && compinit
        autoload -U bashcompinit && bashcompinit
      '';
    };
  };

  programs.tmux = {
    enable = true;
    clock24 = true;
    historyLimit = 100000;
    keyMode = "vi";
    # prefix = "C-a";
    escapeTime = 0;
    disableConfirmationPrompt = true;
    plugins = with pkgs; [
      tmuxPlugins.yank
    ];
    extraConfig = ''
      bind-key M-[ swap-window -t -1
      bind-key M-] swap-window -t +1
      bind-key Up select-pane -U
      bind-key Down select-pane -D
      bind-key Left select-pane -L
      bind-key Right select-pane -R

      unbind-key C-l
      bind-key l select-pane -L
      bind-key k select-pane -U
      bind-key j select-pane -D
      bind-key h select-pane -R

      unbind-key c
      bind-key c new-window -c "#{pane_current_path}"

      unbind-key %
      bind-key % split-window -h -c "#{pane_current_path}"

      unbind-key '"'
      bind-key '"' split-window -v -c "#{pane_current_path}"

      bind-key a last-window

      set -g mouse on

      set -g set-clipboard on
    '';
  };

  programs.fzf = {
    enable = true;
    tmux.enableShellIntegration = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true; # see note on other shells below
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  home.file.config = {
    recursive = true;
    source = ./config;
  };
}
