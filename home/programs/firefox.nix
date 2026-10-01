{ config, pkgs, ... }:
let
  # Electron apps run native Wayland (NIXOS_OZONE_WL=1, see
  # modules/profiles/desktop.nix) and Chromium exports GDK_BACKEND=wayland into
  # every child process it spawns. Clicking a link in an Electron app runs
  # xdg-open -> kde-open -> KIO -> systemd app-firefox@.service, and that
  # variable is inherited the whole way down. Combined with the X11 pin below,
  # Firefox then dies with "Error: cannot open display: :0" and the click
  # silently does nothing -- kde-open still exits 0 and Electron's openExternal
  # promise still resolves, so nothing surfaces anywhere.
  #
  # Clear it here so Firefox chooses its backend from MOZ_ENABLE_WAYLAND alone.
  # Drop this override if MOZ_ENABLE_WAYLAND=0 below ever goes away.
  launch =
    args:
    "${pkgs.coreutils}/bin/env -u GDK_BACKEND ${config.programs.firefox.finalPackage}/bin/firefox ${args}";
in
{
  # Firefox 154 + kwin 6.7.4 kill the browser with a wl_fixes protocol error
  # after resume from suspend. Force XWayland until upstream fixes it.
  systemd.user.sessionVariables.MOZ_ENABLE_WAYLAND = "0";

  xdg.desktopEntries.firefox = {
    name = "Firefox";
    genericName = "Web Browser";
    exec = launch "--name firefox %U";
    icon = "firefox";
    terminal = false;
    startupNotify = true;
    categories = [
      "Network"
      "WebBrowser"
    ];
    mimeType = [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "application/vnd.mozilla.xul+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
    ];
    settings.StartupWMClass = "firefox";
    actions = {
      new-private-window = {
        name = "New Private Window";
        exec = launch "--private-window %U";
      };
      new-window = {
        name = "New Window";
        exec = launch "--new-window %U";
      };
      profile-manager-window = {
        name = "Profile Manager";
        exec = launch "--ProfileManager";
      };
    };
  };

  programs.firefox = {
    enable = true;
    configPath = ".config/mozilla/firefox";
    policies = {
      ExtensionSettings =
        with builtins;
        let
          extension = shortId: uuid: {
            name = uuid;
            value = {
              install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
              installation_mode = "normal_installed";
            };
          };
        in
        # Find id in about:support#addons
        listToAttrs [
          (extension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
          (extension "imagus" "{00000f2a-7cde-4f20-83ed-434fcb420d71}")
          (extension "tampermonkey" "firefox@tampermonkey.net")
          (extension "ublock-origin" "uBlock0@raymondhill.net")
          (extension "web-scrobbler" "{799c0914-748b-41df-a25c-22d008f9e83f}")
          (extension "steamlevels-steam-enhancer" "{27ef8309-55ec-435e-9447-e8d3308b965a}")
          (extension "csgofloat" "{194d0dc6-7ada-41c6-88b8-95d7636fe43c}")
        ];
    };
  };
}
