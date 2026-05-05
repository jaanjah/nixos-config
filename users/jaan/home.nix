{ inputs, ... }:
{
  imports = [
    ../../home/core.nix

    ../../home/profiles/cli.nix
    ../../home/profiles/communication.nix
    ../../home/profiles/desktop.nix
    ../../home/profiles/dev.nix
    ../../home/profiles/gaming.nix
    ../../home/profiles/media.nix

    inputs.quadlet-nix.homeManagerModules.quadlet
  ];
}
