{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.jaan.profiles.dev;
in
{
  options.jaan.profiles.dev.enable =
    lib.mkEnableOption "developer tooling (system packages, nix-ld libraries)";

  config = lib.mkIf cfg.enable {
    # Delta (delta.dev) is a prebuilt binary installed under ~/.local. It
    # dlopens Wayland, Vulkan and fontconfig at startup, so ldd reports
    # nothing missing while the GUI panics with NoWaylandLib. Its bundled
    # libxkbcommon resolves keymaps and Compose files from the FHS paths
    # /usr/share/X11/{xkb,locale}, which NixOS never populates; without the
    # variables below it panics again once a key is pressed.
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        alsa-lib
        fontconfig
        freetype
        libxkbcommon
        vulkan-loader
        wayland
      ];
    };

    environment.sessionVariables = {
      XKB_CONFIG_ROOT = "${pkgs.xkeyboard_config}/share/X11/xkb";
      XLOCALEDIR = "${pkgs.libx11}/share/X11/locale";
    };

    environment.systemPackages = with pkgs; [
      binutils
      bun
      claude-code
      gh
      gnumake
      hydra-check
      libgcc
      marksman
      nasm
      nh

      argocd
      fzf
      hcloud
      kubectl
      kubectx
      kubernetes-helm
      stern
      talosctl
    ];
  };
}
