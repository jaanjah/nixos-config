{
  lib,
  pkgs,
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
      # Nix decompresses NARs through this buffer; the 1 MiB default drains in
      # milliseconds on a fast link and stalls the fetcher waiting on the writer.
      download-buffer-size = 512 * 1024 * 1024;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      http-connections = 50;
      # "auto" resolves to 24 here, and with cores = 0 each job also claims all
      # 24 threads -- a from-source rebuild of the world thrashes and can OOM.
      max-jobs = lib.mkDefault 8;
      max-substitution-jobs = 32;
      # cache.nixos.org is already a module default and these lists concatenate,
      # so listing it again only duplicates every narinfo lookup.
      substituters = [
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
    # Declare any exceptions here, not per-profile: last-write-wins clobbers.
    permittedInsecurePackages = [ ];
  };
  services = {
    xserver = {
      enable = false;
      xkb = {
        layout = "ee";
        variant = "";
      };
    };
  };

  # Restrict the sudo binary to wheel members only (defense-in-depth)
  security.sudo.execWheelOnly = true;
}
