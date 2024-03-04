{ pkgs, ... }:
{
  users.extraUsers.nixos = {
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-key-goes here"
    ];
  };

  # enable nix search, flake, etc
  nix = {
    # package = pkgs.nixFlakes; # or versioned attributes like nixVersions.nix_2_8
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
   };


  # zsh
  programs.zsh = {
    enable = true;
    histSize = 100000;
    enableBashCompletion = true;

    ohMyZsh = {
      enable = true;
      plugins = [
        "direnv"
        "docker"
        "docker-compose"
        "doctl"
        "dotenv"
        "git"
        "python"
        "tmux"
      ];
      theme = "agnoster";
    };
  };

  networking = {
    wireless.enable = false;
    networkmanager.enable = true;
  };
    

  # tailscale
  services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";

  environment.systemPackages = with pkgs; [
    rsync # missing for some reason
  ];
}
