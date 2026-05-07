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
    # Enable common container config files in /etc/containers
    virtualisation = {
      containers.enable = true;
      quadlet.enable = true;
      podman = {
        enable = true;
        # Create a `docker` alias for podman, to use it as a drop-in replacement
        dockerCompat = true;
        # Required for containers under podman-compose to be able to talk to each other.
        defaultNetwork.settings.dns_enabled = true;
      };
    };

    # Useful container development tools
    environment.systemPackages = with pkgs; [
      dive # look into docker image layers
      podman-tui # status of containers in the terminal
      podman-compose # start group of containers for dev
    ];
  };
}
