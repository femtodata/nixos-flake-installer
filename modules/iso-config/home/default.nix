{ config, pkgs, ... }:
{
  home.file.config = {
    recursive = true;
    source = ./config;
  };
}
