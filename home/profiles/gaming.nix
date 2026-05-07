{
  osConfig,
  lib,
  pkgs,
  ...
}:
let
  cfg = osConfig.jaan.profiles.gaming;
  xclicker = pkgs.callPackage ../../packages/xclicker.nix { };
in
{
  config = lib.mkIf cfg.enable {
    home.packages = [ xclicker ];
  };
}
