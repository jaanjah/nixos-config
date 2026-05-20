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
      libgcc
      marksman
      nasm

      # Kubernetes / cloud tooling
      argocd
      hcloud
      kubectl
      kubectx
      kubernetes-helm
      stern
      talosctl
    ];
  };
}
