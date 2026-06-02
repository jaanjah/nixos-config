{
  boot = {
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        useOSProber = true;
        memtest86.enable = true;
      };
      efi = {
        canTouchEfiVariables = true;
      };
      # https://github.com/NixOS/nixpkgs/blob/7282cb574e0607e65224d33be8241eae7cfe0979/nixos/modules/system/boot/loader/loader.nix
      timeout = 30;
    };
  };
}
