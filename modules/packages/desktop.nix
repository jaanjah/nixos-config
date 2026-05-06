{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bitwarden-desktop
    google-chrome
    kdePackages.kate
    kdePackages.okular
    kitty
    qdigidoc
    rocketchat-desktop
  ];
}
