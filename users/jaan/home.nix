{ inputs, ... }:
{
  imports = [
    ../../home/core.nix
    ../../home/profiles/cli.nix

    # Option-driven role profiles (added incrementally; reads osConfig.jaan.profiles.*)
    ../../home/profiles

    inputs.quadlet-nix.homeManagerModules.quadlet
  ];
}
