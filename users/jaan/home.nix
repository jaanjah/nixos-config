{ inputs, ... }:
{
  imports = [
    ../../home/core.nix
    ../../home/profiles/cli.nix

    # Explicit profile imports remain until each migrates to the option-driven aggregator below.
    ../../home/profiles/communication.nix
    ../../home/profiles/desktop.nix
    ../../home/profiles/dev.nix
    ../../home/profiles/media.nix

    # Option-driven role profiles (added incrementally; reads osConfig.jaan.profiles.*)
    ../../home/profiles

    inputs.quadlet-nix.homeManagerModules.quadlet
  ];
}
