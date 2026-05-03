{ ... }:
{
  # Virtualisation
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      runAsRoot = true;
      swtpm.enable = true; # TPM emulation (needed for Windows 11)
    };
  };
  # Allow internet connection inside VM
  virtualisation.libvirtd.allowedBridges = [ "virbr0" ];
  networking.firewall.interfaces."virbr0" = {
    allowedUDPPorts = [
      67
      68
    ];
  };

  virtualisation.spiceUSBRedirection.enable = true;
  programs.virt-manager.enable = true;
}
