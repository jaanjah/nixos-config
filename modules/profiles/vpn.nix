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

    # ProtonVPN replies fail strict rp_filter; loose still validates source IP.
    networking.firewall.checkReversePath = "loose";
  };
}
