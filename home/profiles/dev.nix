{
  osConfig,
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = osConfig.jaan.profiles.dev;
in
{
  imports = lib.optionals cfg.enable [
    ../programs/uv.nix
    ../programs/zed
  ];

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      nodejs_24
      python315
      (lib.meta.lowPrio python314)
      uv

      # Nix language server dependencies
      nil
      nixd

      # Go packages
      go
      gopls

      # Package.json language server
      package-version-server
    ];

    home.sessionPath = [
      "${config.home.homeDirectory}/.npm-global/bin"
    ];

    home.sessionVariables = {
      NPM_CONFIG_PREFIX = "${config.home.homeDirectory}/.npm-global";
    };
  };
}
