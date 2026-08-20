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
        sddm = {
          enable = true;
          # Keep the DRM-master handoff in Wayland end-to-end. With X11 SDDM
          # + Wayland Plasma, kwin sometimes failed to re-acquire
          # /dev/dri/card0 on resume from S3, freezing the lockscreen with
          # no keyboard or pointer input. Don't disable without verifying
          # the upstream regression is fixed.
          wayland.enable = true;
        };
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
