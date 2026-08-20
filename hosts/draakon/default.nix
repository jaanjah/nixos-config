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

    ../../modules/packages/core.nix
    ../../modules/profiles
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

  # Release of first install. Do not bump; it gates stateful data migrations.
  system.stateVersion = "25.05";
}
