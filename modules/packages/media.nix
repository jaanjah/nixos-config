{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    calibre
    jellyfin-desktop
    qbittorrent
    spotify
    stremio-linux-shell
    tidal-hifi
  ];
}
