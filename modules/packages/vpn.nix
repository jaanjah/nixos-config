{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    openvpn
    proton-vpn
    wireguard-tools
  ];
}
