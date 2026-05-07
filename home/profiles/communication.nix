{
  osConfig,
  lib,
  ...
}:
let
  cfg = osConfig.jaan.profiles.communication;
in
{
  imports = lib.optionals cfg.enable [
    ../programs/nixcord.nix
    ../programs/thunderbird.nix
  ];
}
