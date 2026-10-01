{ config, lib, ... }:
{
  # https://github.com/FlameFlag/nixcord/blob/aa8081c2a02984ce81c2d45eaf4ec40d4e450217/README.md
  programs.nixcord = {
    enable = true;
    discord = {
      enable = false;
    };
    vesktop = {
      enable = true;
    };
    # TODO: Look into Equibop
    config = {
      # https://github.com/FlameFlag/nixcord/blob/aa8081c2a02984ce81c2d45eaf4ec40d4e450217/modules/plugins/shared.nix
      plugins = {
        copyFileContents.enable = true;
        experiments.enable = true;
        fixSpotifyEmbeds.enable = true;
        fixYoutubeEmbeds.enable = true;
        imageZoom.enable = true;
        messageLogger.enable = true;
        noOnboardingDelay.enable = true;
        noUnblockToJump.enable = true;
        permissionsViewer.enable = true;
        showHiddenChannels.enable = true;
        sortFriendRequests.enable = true;
        showHiddenThings.enable = true;
        showTimeoutDuration.enable = true;
        spotifyCrack.enable = true;
        translate.enable = true;
        validReply.enable = true;
        validUser.enable = true;
        whoReacted.enable = true;
        youtubeAdblock.enable = true;
      };
    };
  };

  # Vesktop's own "start with system" toggle writes ~/.config/autostart with the
  # electron binary and app.asar store paths baked in, so the entry dangles after
  # the next update or GC. systemd then logs "executable specified in Exec= does
  # not exist" on every login and Vesktop never starts. Manage it here instead,
  # pointing at nixcord's final (Vencord-patched) package rather than the
  # unpatched programs.nixcord.vesktop.package.
  xdg.configFile."autostart/vesktop.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Vesktop
    Comment=Vesktop autostart
    Exec=${lib.getExe' config.programs.nixcord.finalPackage.vesktop "vesktop"}
    StartupNotify=false
    Terminal=false
  '';

}
