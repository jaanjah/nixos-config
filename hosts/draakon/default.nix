# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  lib,
  hostname,
  ...
}:
{
  imports = [
    ../../modules/amd.nix
    ../../modules/audio.nix
    ../../modules/boot.nix
    ../../modules/network.nix
    #../../modules/nvidia.nix
    #../../modules/printer.nix
    ../../modules/system.nix
    #../../modules/touchpad.nix

    # Package role profiles
    ../../modules/packages/core.nix

    # Option-driven role profiles (added incrementally; jaan.profiles.*)
    ../../modules/profiles

    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  jaan.profiles = {
    communication.enable = true;
    desktop = {
      enable = true;
      autologin = true;
    };
    dev.enable = true;
    gaming.enable = true;
    libvirt.enable = true;
    media.enable = true;
    podman.enable = true;
    vpn.enable = true;
  };

  networking.hostName = hostname;

  users.users.jaan = {
    isNormalUser = true;
    description = "jaan";
    extraGroups = [
      "networkmanager"
      "wheel"
    ]
    ++ lib.optionals config.jaan.profiles.libvirt.enable [
      "libvirtd"
      "kvm"
    ];
  };
  programs.ssh.startAgent = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
