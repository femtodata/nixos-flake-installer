{ pkgs, ... }: {

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    lfs.enable = true;
    config = {
      # diff.external = "difft";
      diff.tool = "difftastic";
      difftool.prompt = "false";
      "difftool \"difftastic\"".cmd = "difft \"$LOCAL\" \"$REMOTE\"";
    };
  };

  environment.systemPackages = with pkgs; [

    # terminal
    age
    bat
    bind
    btrfs-progs
    cryptsetup
    curl
    difftastic
    dua
    envsubst
    fzf
    gcc
    inetutils
    jq
    lsof
    nfs-utils
    nix-index
    nix-prefetch-github
    nix-tree
    openssl
    parted
    pwgen
    ripgrep
    rsync
    samba4Full
    silver-searcher
    sops
    ssh-to-age
    sshfs
    sysfsutils
    tmux
    unzip
    wget
    wireguard-tools
    xsel
    yq
    zlib

    # dev
    file
    sqlite-interactive

    # monitoring, stress testing
    bottom
    gotop
    htop
    iotop
    nethogs
    smartmontools

    # backup
    borgbackup

  ];
}


