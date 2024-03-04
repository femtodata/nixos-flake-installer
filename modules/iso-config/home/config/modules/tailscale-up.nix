{ pkgs, ... }:
{
  systemd.services.tailscale-up = let
    authKey = pkgs.writeText "authKey" ''
      <key goes here>
    '';
    tailscaleUp = pkgs.writeShellScriptBin "tailscaleUp" ''
    ${pkgs.tailscale}/bin/tailscale up \
      --login-server https://headscale.femtodata.com \
      --hostname scout \
      --authkey $(cat ${authKey})
  '';
  in {
    enable = true;
    wantedBy = [ "multi-user.target" ];
    description = "tailscale up";
    after = [
      "tailscaled.service"
      "network-online.target"
      "home-manager-nixos.service"
    ];
    requires = [
      "tailscaled.service"
      "network-online.target"
      "home-manager-nixos.service"
    ];
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      RemainAfterExit = "yes";
      ExecStart = "${tailscaleUp}/bin/tailscaleUp";
    };
  };
}
