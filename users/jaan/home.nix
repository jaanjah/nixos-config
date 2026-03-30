{ inputs, ... }:
{
  # This file should only include imports
  imports = [
    ../../home/core.nix

    ../../home/programs

    inputs.quadlet-nix.homeManagerModules.quadlet

    ### VIRTUALISATION ###
    ## NETWORKS ##
    # systemctl --user status <network>-network.service
    # podman network ls
    # podman network inspect <network>
    ../../virtualisation/networks/media.nix

    ## CONTAINERS ##
    # systemctl --user restart <container>.service
    # journalctl --user -u <container>.service -f
    # podman pause <container>
    # podman unpause <container>
    # podman ps --all | grep paused
    # http://localhost:8096 / http://jellyfin:8096
    ../../virtualisation/containers/jellyfin.nix
    # http://localhost:5055 / http://seerr:5055
    ../../virtualisation/containers/seerr.nix
    # http://localhost:7878 / http://radarr:7878
    ../../virtualisation/containers/radarr.nix
    # http://localhost:8989 / http://sonarr:8989
    ../../virtualisation/containers/sonarr.nix
    # http://localhost:8080 / http://qbittorrent:8080
    # http://localhost:6881 / http://qbittorrent:6881
    ../../virtualisation/containers/qbittorrent.nix
    # http://localhost:8191 / http://flaresolverr:8191
    ../../virtualisation/containers/flaresolverr.nix
    # http://localhost:9696 / http://prowlarr:9696
    ../../virtualisation/containers/prowlarr.nix
    # http://localhost:8282
    ../../virtualisation/containers/wallos.nix
  ];
}
