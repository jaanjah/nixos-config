{
  osConfig,
  lib,
  ...
}:
let
  cfg = osConfig.jaan.profiles.media;
in
{
  imports = lib.optionals cfg.enable [
    ../programs/gallery-dl.nix
    ../programs/mpv.nix
    ../programs/obs-studio.nix
    ../programs/yt-dlp.nix

    ../../virtualisation/containers/wallos.nix
  ];
}
