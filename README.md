# nixos-flake-installer

- To enable install over ssh, edit `modules/iso-config/default.nix`, add ssh key to nixos user.

- To enable tailscale, edit `modules/iso-config/tailscale-up.nix` providing authkey, and optionally changing `login-server` if running your own headscale instance. If using this option, authkey should probably be reusable, and acls.json setup to isolate the install user / namespace.

- For the installed system, set `hostname` and `username` in `modules/iso-config/home/config/extra-config.nix`. Optionally set `hashedPassword` in the user definition section.

- To build the iso:
  ```
  nix build \.#nixosConfigurations.iso.config.system.build.isoImage -o iso
  ```
  or
  ```
  nix build \.#nixosConfigurations.iso-vm.config.system.build.isoImage -o iso
  ```
  
  The vm variant is suitable for headless libvirt / qemu vms, console output will be visible on bootup.
