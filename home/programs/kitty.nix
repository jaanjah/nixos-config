{
  programs.kitty = {
    enable = true;
    settings = {
      confirm_os_window_close = 0;
      paste_actions = "quote-urls-at-prompt,confirm-if-large";
      enable_audio_bell = false;
      font_family = "CaskaydiaMono NFM Regular";
      bold_font = "CaskaydiaMono NFM Bold";
      italic_font = "CaskaydiaMono NFM Italic";
      bold_italic_font = "CaskaydiaMono NFM Bold Italic";
    };
  };

  xdg.configFile."kitty/ssh.conf".text = ''
    paste_actions no-op
  '';
}
