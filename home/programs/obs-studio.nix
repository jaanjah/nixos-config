{ pkgs, ... }:
# https://wiki.nixos.org/w/index.php?title=OBS_Studio
{
  programs.obs-studio = {
    enable = true;

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi # AMD hardware acceleration
      obs-gstreamer
      obs-vkcapture
    ];
  };
}
