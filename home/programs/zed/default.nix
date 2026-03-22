{
  pkgs,
  ...
}:
{
  programs.zed-editor = {
    enable = true;

    extraPackages = with pkgs; [
      # Nix language server dependencies
      nil
      nixd

      # Go packages
      go
      gopls

      # Package.json language server
      package-version-server
    ];
  };
}
