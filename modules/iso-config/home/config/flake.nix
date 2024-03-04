{
  description = "Host defs";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-23.11;
  };

  outputs = inputs@{
      self,
      nixpkgs,
      home-manager,
      ...
  }:
  let
    system = "x86_64-linux";
  in rec {
    nixosConfigurations = {
      host = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          ./extra-config.nix

          ./modules/vim.nix
        ];
      };
    };
  };
}
