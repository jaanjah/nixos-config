{ pkgs, ... }:
{
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
      openssl_1_1
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
    (bolt-launcher.override {
      # Launch options: /usr/bin/env SDL_VIDEODRIVER=x11 %command%
      # @link https://github.com/Adamcake/Bolt/issues/147#issue-3206473355
      enableRS3 = true;
    })
  ];
}
