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

    # Chromium and Electron apps default to XWayland here, which costs proper
    # vsync and blurs fractional scaling. Native Wayland also fixes clipboard
    # interop with Wayland-native windows.
    #
    # Firefox is deliberately unaffected: it keys off MOZ_ENABLE_WAYLAND, which
    # home/programs/firefox.nix pins to 0 for the kwin wl_fixes resume crash.
    # Revert this if Electron apps start hitting that same class of bug.
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    environment.systemPackages = with pkgs; [
      bitwarden-desktop
      google-chrome
      kdePackages.kate
      kdePackages.okular
      kitty
      qdigidoc
      rocketchat-desktop
      wl-clipboard
    ];
  };
}
