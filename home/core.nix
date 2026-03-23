{
  config,
  pkgs,
  username,
  ...
}:
let
  rootapp = pkgs.callPackage ../packages/rootapp.nix { };
  xclicker = pkgs.callPackage ../packages/xclicker.nix { };
  dotnetSdk = pkgs.dotnet-sdk_10;
in
{
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    sessionPath = [
      "${config.home.homeDirectory}/.npm-global/bin"
    ];
    sessionVariables = {
      NPM_CONFIG_PREFIX = "${config.home.homeDirectory}/.npm-global";
      DOTNET_ROOT = "${dotnetSdk}/share/dotnet";
    };
    # Read more about lowPrio: https://nixos.org/manual/nixpkgs/stable/#function-library-lib.meta.lowPrio
    packages = with pkgs; [
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

      dotnetSdk

      rootapp
      xclicker
    ];
    stateVersion = "25.05";
  };
  programs.home-manager.enable = true;
}
