{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  cfg = config.jaan.profiles.desktop;
in
{
  options.jaan.profiles.desktop = {
    enable = lib.mkEnableOption "Plasma 6 desktop with SDDM";
    autologin = lib.mkEnableOption "SDDM autologin (single-user convenience)";
  };

  config = lib.mkIf cfg.enable {
    services = {
      desktopManager.plasma6.enable = true;
      displayManager = {
        autoLogin = lib.mkIf cfg.autologin {
          enable = true;
          user = username;
        };
        sddm.enable = true;
      };
    };

    environment.systemPackages = with pkgs; [
      bitwarden-desktop
      google-chrome
      kdePackages.kate
      kdePackages.okular
      kitty
      qdigidoc
      rocketchat-desktop
    ];
  };
}
