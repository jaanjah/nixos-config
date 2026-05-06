{ pkgs, ... }:
{
  environment = {
    localBinInPath = true;
    systemPackages = with pkgs; [
      age
      bc
      dig
      git-lfs
      ncdu
      nixfmt
      sops
      tree
      unzip
    ];
  };
}
