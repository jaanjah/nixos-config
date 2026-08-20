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
    programs.steam.enable = true;

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
