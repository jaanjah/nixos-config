{ inputs, ... }:
{
  imports = [
    ../../home/core.nix
    ../../home/profiles/cli.nix

    ../../home/profiles

    inputs.quadlet-nix.homeManagerModules.quadlet
  ];
}
