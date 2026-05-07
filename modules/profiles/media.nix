{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.jaan.profiles.media;
in
{
  options.jaan.profiles.media.enable = lib.mkEnableOption "media role (desktop media apps)";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      calibre
      jellyfin-desktop
      qbittorrent
      spotify
      stremio-linux-shell
      tidal-hifi
    ];
  };
}
