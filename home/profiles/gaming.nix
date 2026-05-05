{ pkgs, ... }:
let
  xclicker = pkgs.callPackage ../../packages/xclicker.nix { };
in
{
  home.packages = [
    xclicker
  ];
}
