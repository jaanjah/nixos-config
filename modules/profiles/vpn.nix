{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.jaan.profiles.vpn;
in
{
  options.jaan.profiles.vpn.enable =
    lib.mkEnableOption "VPN clients (Proton VPN, OpenVPN, WireGuard)";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      openvpn
      proton-vpn
      wireguard-tools
    ];

    # https://wiki.nixos.org/wiki/OpenVPN
    # Cleanup of this empty placeholder is tracked in issue #13.
    services.openvpn.servers = { };

    # ProtonVPN reply packets can fail strict reverse-path checks; "loose" preserves source-IP validation
    networking.firewall.checkReversePath = "loose";
  };
}
