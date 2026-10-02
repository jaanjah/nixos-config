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
          #
          # Related failure mode on the same resume path: if the greeter
          # cannot get a GL context it logs "EGL not available" and the
          # password field stops handing its value to PAM, so a correct
          # password is rejected as empty -- "pam_kwallet5: Couldn't get
          # password (it is empty)" with NO pam_unix authentication failure
          # line. The field still shows the typed characters, so it looks
          # like the account password broke. It did not: absence of
          # "pam_unix(kde:auth): authentication failure" means PAM was never
          # asked to verify anything.
          #
          # Recover with Ctrl+Alt+F3 then `loginctl unlock-sessions`, which
          # bypasses the broken greeter and keeps the session; a hard reboot
          # is not needed. Trigger is rebuilding the desktop stack under a
          # live session, since /run/opengl-driver is a live symlink -- so
          # prefer `nixos-rebuild boot` + reboot for updates that bump
          # kernel, mesa or plasma. Verify the greeter without locking via
          # `kscreenlocker_greet --testing`; success logs pam_sm_setcred.
          # "qmlRegisterType requires absolute URLs" is unrelated noise and
          # appears ~40x on successful unlocks too.
          wayland.enable = true;
        };
      };
    };

    # Chromium and Electron apps default to XWayland here, which costs proper
    # vsync and blurs fractional scaling. Native Wayland also fixes clipboard
    # interop with Wayland-native windows.
    #
    # Firefox keys off MOZ_ENABLE_WAYLAND, which home/programs/firefox.nix pins
    # to 0 for the kwin wl_fixes resume crash -- but it is NOT unaffected by
    # this. Chromium exports GDK_BACKEND=wayland to child processes, so links
    # opened from an Electron app reached Firefox with Wayland forced and it
    # died with "cannot open display". home/programs/firefox.nix clears
    # GDK_BACKEND in its desktop entry to break that inheritance.
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
