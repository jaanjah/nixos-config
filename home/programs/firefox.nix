{ pkgs, ... }:
{
  # Firefox 154 + kwin 6.7.4 kill the browser with a wl_fixes protocol error
  # after resume from suspend. Force XWayland until upstream fixes it.
  systemd.user.sessionVariables.MOZ_ENABLE_WAYLAND = "0";

  programs.firefox = {
    enable = true;
    # Electron apps run native Wayland (NIXOS_OZONE_WL=1, see
    # modules/profiles/desktop.nix) and Chromium exports GDK_BACKEND=wayland
    # into every child process it spawns. Clicking a link in an Electron app
    # runs xdg-open -> kde-open -> KIO -> systemd app-*.service, and that
    # variable is inherited the whole way down. Combined with the X11 pin
    # above, Firefox then dies with "Error: cannot open display: :0" and the
    # click silently does nothing -- kde-open still exits 0 and Electron's
    # openExternal promise still resolves, so nothing surfaces anywhere.
    #
    # Clear it in the binary's own wrapper, so every launch path is covered.
    # It used to be an `env -u GDK_BACKEND` prefix on the desktop entry's
    # Exec, but Firefox's default-browser check compares argv[0] of the http
    # handler against its own path. It saw `env`, decided it was not the
    # default, and its "Make default" button wrote a bare
    # ~/.local/share/applications/userapp-Firefox-*.desktop that took over
    # http/https and brought the bug back.
    #
    # Drop this override if MOZ_ENABLE_WAYLAND=0 above ever goes away.
    # @link https://github.com/mozilla-firefox/firefox/blob/main/browser/components/shell/nsGNOMEShellService.cpp
    package = pkgs.firefox.overrideAttrs (old: {
      makeWrapperArgs = old.makeWrapperArgs ++ [
        "--unset"
        "GDK_BACKEND"
      ];
    });
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
