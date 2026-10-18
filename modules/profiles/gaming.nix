{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.jaan.profiles.gaming;
in
{
  options.jaan.profiles.gaming.enable =
    lib.mkEnableOption "gaming role (Steam, gaming launchers, nix-ld libraries)";

  config = lib.mkIf cfg.enable {
    # Our own gamescope: upstream 3.16.31 plus one commit, instead of the
    # 3.16.29 this nixpkgs pins.
    #
    # 3.16.31 carries "vblankmanager: catch up to the next vblank in one step",
    # which replaces an iterative walk -- the suspected cause of frame pacing
    # degrading the longer a session runs (CS2 judder at steady 200fps, onset
    # after ~20min, persists until the game restarts).
    #
    # feat/host-to-guest-clipboard then teaches the Wayland backend to listen
    # for the host's selection, so text copied on the desktop can be pasted
    # into CS2 chat. gamescope has only ever bridged the clipboard outward;
    # upstream has three open attempts at the other direction and has merged
    # none of them. Branched off the 3.16.31 tag, so the clipboard commit is
    # the only delta from what was already running here.
    #
    # Pinned by rev, not branch: a branch would silently change what gets
    # built whenever the fork moves.
    # @link https://github.com/ValveSoftware/gamescope/issues/1935
    # @link https://github.com/jaanjah/gamescope/tree/feat/host-to-guest-clipboard
    nixpkgs.overlays = [
      (_: prev: {
        gamescope = prev.gamescope.overrideAttrs (_: {
          version = "3.16.31-clipboard";
          src = prev.fetchFromGitHub {
            owner = "jaanjah";
            repo = "gamescope";
            rev = "a7920982b1e94573d141e07ccc6e9ba04e8db055";
            fetchSubmodules = true;
            hash = "sha256-TqtSTYG6aSsxjLxklO5nLdVzx94EyiSgjNXAnQZIqqc=";
          };
        });
      })
    ];

    programs.steam = {
      enable = true;
      # Proton-GE, exposed via STEAM_EXTRA_COMPAT_TOOLS_PATHS rather than
      # extracted into ~/.steam/root/compatibilitytools.d. Tracks nixpkgs, so
      # it can trail upstream by a point release until flake.lock is bumped.
      # @link https://github.com/GloriousEggroll/proton-ge-custom
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };

    # Nested compositor. The game renders into gamescope's virtual display, so
    # alt-tabbing never triggers KWin's direct-scanout <-> composited switch --
    # the transition where dcn32_program_compbuf_size has stalled on this GPU.
    # @link https://github.com/ValveSoftware/gamescope
    programs.gamescope = {
      enable = true;
      # Must stay false. CAP_SYS_NICE would let gamescope request realtime
      # scheduling priority, but the capability wrapper makes Steam fail with
      # "failed to inherit capabilities: Operation not permitted" and the game
      # never launches. Tested 2026-10-16.
      capSysNice = false;
      # Keep the pointer locked to the game. Without this the cursor escapes
      # onto the second monitor mid-round on a multi-head setup.
      args = [
        "--force-grab-cursor"
        # NB: "--backend" "sdl" was tried 2026-10-17 to work around gamescope
        # pacing frames off a timerfd instead of real vblank. It fails outright
        # with "Failed to create backend." -- do not re-add.
      ];
    };

    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        cairo
        gdk-pixbuf
        glib
        gtk2
        libcap
        libglvnd
        libICE
        libSM
        libX11
        libXxf86vm
        mesa
        pango
        sdl2-compat
      ];
    };

    environment.systemPackages = with pkgs; [
      jdk11
      prismlauncher
      runelite
      wineWow64Packages.stable
      winetricks
      # Launch options: /usr/bin/env SDL_VIDEODRIVER=x11 %command%
      # @link https://github.com/Adamcake/Bolt/issues/147#issue-3206473355
      # No enableRS3: RS3 needs openssl_1_1, removed from nixpkgs 2026-07-24.
      # https://github.com/jaanjah/nixos-config/issues/28
      bolt-launcher
    ];
  };
}
