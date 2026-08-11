{ pkgs, ... }:
{
  environment = {
    localBinInPath = true;
    systemPackages = with pkgs; [
      age
      bc
      dig
      dmidecode
      efibootmgr
      git-lfs
      ncdu
      nixfmt
      sops
      tree
      unzip
    ];
  };
}
