{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.jaan.profiles.podman;
in
{
  options.jaan.profiles.podman.enable = lib.mkEnableOption "Podman + Quadlet container runtime";

  config = lib.mkIf cfg.enable {
    # https://nixos.wiki/wiki/Podman
    virtualisation = {
      containers.enable = true;
      quadlet.enable = true;
      podman = {
        enable = true;
        dockerCompat = true;
        # Lets podman-compose containers resolve each other by name.
        defaultNetwork.settings.dns_enabled = true;
      };
    };

    environment.systemPackages = with pkgs; [
      dive
      podman-tui
      podman-compose
    ];
  };
}
