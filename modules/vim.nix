{ pkgs, ... }: {
  environment.variables = { EDITOR = "nvim"; };

  environment.systemPackages = with pkgs; [
    ((vim_configurable.override { }).customize {
      name = "vim";
      vimrcConfig.customRC = (builtins.readFile ./vimrc);
      # Use the default plugin list shipped with nixpkgs
      vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
        start = [
          syntastic
          ctrlp-vim
          vim-nix
        ];
        opt = [];
      };
    })

    neovide
    neovim-qt
  ];

  programs.neovim = {
    enable = true;
    configure = {
      customRC = (builtins.readFile ./vimrc);
      packages.myVimPackages = with pkgs.vimPlugins; {
        start = [
          syntastic
          ctrlp
          vim-nix
        ];
      };
    };
  };
}

