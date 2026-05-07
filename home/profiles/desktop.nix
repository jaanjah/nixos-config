{
  osConfig,
  lib,
  ...
}:
let
  cfg = osConfig.jaan.profiles.desktop;
in
{
  imports = lib.optionals cfg.enable [
    ../programs/firefox.nix
    ../programs/kitty.nix
    ../programs/plasma.nix
  ];
}
