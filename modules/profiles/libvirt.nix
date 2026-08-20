{
  config,
  lib,
  ...
}:
let
  cfg = config.jaan.profiles.libvirt;
in
{
  options.jaan.profiles.libvirt.enable =
    lib.mkEnableOption "libvirt + virt-manager (KVM/QEMU virtualisation)";

  config = lib.mkIf cfg.enable {
    virtualisation.libvirtd = {
      enable = true;
      sshProxy = false;
      qemu = {
        runAsRoot = true;
        swtpm.enable = true; # Windows 11 requires a TPM
      };
      # Allow internet connection inside VM
      allowedBridges = [ "virbr0" ];
    };

    networking.firewall.interfaces."virbr0" = {
      allowedUDPPorts = [
        67
        68
      ];
    };

    virtualisation.spiceUSBRedirection.enable = true;
    programs.virt-manager.enable = true;
  };
}
