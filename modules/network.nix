{ config, ... }:
{
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  services.tailscale = {
    enable = true;
    # Accept subnet routes advertised by other tailnet nodes (Hetzner VMs etc.).
    # Also flips net.ipv4.conf.all.src_valid_mark=1 so rp_filter doesn't drop them.
    useRoutingFeatures = "client";
  };
  services.resolved = {
    enable = true;
    # Disabled: Tailscale + systemd-resolved breaks DNS resolution on wake-from-suspend
    # when DNSSEC validation is on. Re-enable once verified the upstream interaction is fixed.
    settings.Resolve.DNSSEC = "false";
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
      allowedUDPPorts = [ config.services.tailscale.port ];
    };
  };

  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];

  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;

  # network-online.target is passive - it only activates if some unit wants it,
  # and nothing here did, so it never came up. NetworkManager-wait-online being
  # "enabled" is not enough: that only means WantedBy=network-online.target,
  # making it the target's dependent rather than its trigger. Podman's user unit
  # podman-user-wait-network-online.service polls the target until it goes
  # active, so it burned its full 90s timeout on every boot and delayed all
  # rootless containers by that long. Pulling the target into the boot
  # transaction activates NetworkManager-wait-online and resolves the wait.
  systemd.targets.network-online.wantedBy = [ "multi-user.target" ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
