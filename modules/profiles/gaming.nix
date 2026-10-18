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
    # gamescope 3.16.31 instead of the 3.16.29 this nixpkgs pins. Upstream
    # 3.16.31 carries "vblankmanager: catch up to the next vblank in one step",
    # which replaces an iterative walk -- the fix for CS2 frame pacing
    # degrading the longer a session runs (judder at a steady 200fps, onset
    # after ~20min, persisting until the game restarts).
    # The nixpkgs expression is byte-identical between the two versions apart
    # from version+hash, so this is the same build master does.
    # @link https://github.com/ValveSoftware/gamescope/compare/3.16.29...3.16.31
    nixpkgs.overlays = [
      (_: prev: {
        gamescope = prev.gamescope.overrideAttrs (_: {
          version = "3.16.31";
          src = prev.fetchFromGitHub {
            owner = "ValveSoftware";
            repo = "gamescope";
            tag = "3.16.31";
            fetchSubmodules = true;
            hash = "sha256-mCCf/CfKBqxNvmRbaAJsOMrnnRutPr9nEePHmAq/PUM=";
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
