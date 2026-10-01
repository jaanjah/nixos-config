{
  config,
  lib,
  pkgs,
  ...
}:
let
  vencordSettings = "${config.programs.nixcord.vesktop.configDir}/settings/settings.json";
in
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

  # nixcord installs the Vencord settings as a read-only store symlink, so
  # Vencord's own writes fail. It force-enables its required plugins on every
  # start, and each attempt logs "EROFS: read-only file system" -- the journal
  # had ~339 of them. Anything toggled in Discord's UI also silently reverts.
  # nixcord already installs writable copies for its legcord, goofcord and
  # discord-mod specs (modules/lib/files.nix sets writable = true there but not
  # in mkSettingsSpecs), so mirror that behaviour here.
  #
  # force = true lets the next activation put its symlink back before this
  # script runs, so the plugin set declared above is still re-seeded on every
  # rebuild and nix stays the source of truth.
  home.file.${vencordSettings}.force = true;
  home.activation.vencordWritableSettings = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
    dest=${lib.escapeShellArg vencordSettings}
    if [ -L "$dest" ]; then
      src="$(${lib.getExe' pkgs.coreutils "readlink"} -f "$dest")"
      $DRY_RUN_CMD rm -f "$dest"
      $DRY_RUN_CMD ${lib.getExe' pkgs.coreutils "install"} -Dm644 "$src" "$dest"
    fi
  '';

}
