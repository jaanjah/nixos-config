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
        # Plugins
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
}
