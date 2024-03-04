{ pkgs, lib, ... }:
let
  hostname = "<HOSTNAME>";
  username = "<USERNAME GOES HERE>";
  # hostId = "<get from head -c 8 /etc/machine-id>";
in
{

  # boot.loader.grub.device = "/dev/sda";
  # boot.supportedFilesystems = ["zfs"];
  # boot.zfs.requestEncryptionCredentials = true;

  # networking.hostId = hostId;

  # ZFS services

  # services.zfs.autoSnapshot.enable = true;
  # services.zfs.autoScrub.enable = true;


  # enable nix search, flake, etc
  nix = {
    # package = pkgs.nixFlakes; # or versioned attributes like nixVersions.nix_2_8
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };


  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";

  services.openssh.enable = true;

  # # vm console
  # boot.kernelParams = [
  #   "console=tty1"
  #   "console=ttyS0,115200"
  # ];

  users.users = {
    "${username}" = {
      isNormalUser = true;
      shell = pkgs.zsh;
      extraGroups = [ "wheel" "docker" "udev" "input" "plugdev" "wheel" ];
      openssh.authorizedKeys.keys = [
        "ssh-keys-go-here"
      ];
      # hashedPassword = "password-hashed-with-mkpassword";
    };
  };

  security.sudo.wheelNeedsPassword = false;

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

  nix.settings.trusted-users = [ "root" "${username}" ];

  # packagekit is terrible
  services.packagekit.enable = lib.mkForce false;

  # # sops
  # sops.defaultSopsFile = ./secrets.yaml;
  # sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  # tailscale
  services.tailscale.enable = true;
  networking.firewall.checkReversePath = "loose";

  environment.systemPackages = with pkgs; [
    gitFull
    tmux
  ];
}
