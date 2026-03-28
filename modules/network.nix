{ config, ... }:
{
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  services.tailscale.enable = true;
  services.resolved = {
    enable = true;
    dnssec = "false";
  };
  networking = {
    nftables.enable = true;
    # Enable networking
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
    firewall = {
      enable = true;
      trustedInterfaces = [ "tailscale0" ];
      # Needed for protonvpn
      checkReversePath = false;
      # jellyfin
      allowedTCPPorts = [ 8096 ];
      allowedUDPPorts = [ config.services.tailscale.port ];
    };
  };

  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];

  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
