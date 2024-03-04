{
  description = "Host defs";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-23.11;

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{
      self,
      nixpkgs,
      home-manager,
      sops-nix,
      ...
  }:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      defaultModules = [
        inputs.sops-nix.nixosModules.sops
        ./modules/etc_current_system_packages.nix
        ./modules/packages.nix
        ./modules/vim.nix
      ];

      isoModules = defaultModules ++ [
        # install
        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"

        # common modules
        ./modules/iso-config
        # ./modules/iso-config/tailscale-up.nix

        # home-manager
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.nixos = {
            imports = [
              ./modules/home
              ./modules/iso-config/home
            ];
          };
        }
      ];

    in rec {

      nixosConfigurations = {

        iso = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = isoModules ++ [
          ];
        };

        iso-vm = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = isoModules ++ [
            ({...}: {
              boot.kernelParams = [
                "console=tty1"
                "console=ttyS0,115200"
              ];
            })
          ];
        };

      };
    };

}
