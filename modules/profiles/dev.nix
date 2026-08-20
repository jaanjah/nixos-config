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
  options.jaan.profiles.dev.enable = lib.mkEnableOption "developer tooling (system packages)";

  config = lib.mkIf cfg.enable {
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
