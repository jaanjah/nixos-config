{
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  cfg = osConfig.jaan.profiles.gaming;
  xclicker = pkgs.callPackage ../../packages/xclicker.nix { };
  # WoW: Forever addons. Add the client as
  # ~/Faugus/battlenet/drive_c/Program Files (x86)/World of Warcraft/_forever_/Wow.exe
  wowup-cf = pkgs.callPackage ../../packages/wowup-cf.nix { };
in
{
  config = lib.mkIf cfg.enable {
    home.packages = [
      xclicker
      wowup-cf
    ];
  };
}
