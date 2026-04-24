{
  lib,
  pkgs,
  username,
  ...
}:
{
  time.timeZone = "Europe/Tallinn";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "et_EE.UTF-8";
      LC_IDENTIFICATION = "et_EE.UTF-8";
      LC_MEASUREMENT = "et_EE.UTF-8";
      LC_MONETARY = "et_EE.UTF-8";
      LC_NAME = "et_EE.UTF-8";
      LC_NUMERIC = "et_EE.UTF-8";
      LC_PAPER = "et_EE.UTF-8";
      LC_TELEPHONE = "et_EE.UTF-8";
      LC_TIME = "et_EE.UTF-8";
    };
  };

  console.keyMap = "et";

  fonts = {
    packages = with pkgs; [
      nerd-fonts.caskaydia-mono
      # Add fonts that support chinese/japanese/korean characters
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      # Hopefully fix blurry üõöä characters in some fonts
      noto-fonts-lgc-plus
    ];
  };

  nix = {
    gc = {
      automatic = lib.mkDefault true;
      dates = lib.mkDefault "weekly";
      options = lib.mkDefault "--delete-older-than 30d";
    };
    optimise = {
      automatic = lib.mkDefault true;
    };
    settings = {
      cores = 0;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      max-jobs = lib.mkDefault "auto";
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbKSe1v8fI8XnXjCQQ1rDjfTHk="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      # Needed for libcrypto.so.1.1 to work
      "openssl-1.1.1w"
    ];
  };
  services = {
    desktopManager.plasma6.enable = true;
    displayManager = {
      autoLogin = {
        enable = true;
        user = username;
      };
      sddm.enable = true;
    };
    xserver = {
      enable = false;
      xkb = {
        layout = "ee";
        variant = "";
      };
    };
  };
}
