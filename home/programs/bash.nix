{
  pkgs,
  ...
}:
{
  programs.bash = {
    enable = true;
    initExtra = ''
      # https://wiki.nixos.org/wiki/Fish#Setting_fish_as_default_shell
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
      then
        shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
        exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
      fi
      if [[ $- == *i* ]]; then
          bind 'set enable-bracketed-paste off'
      fi
    '';
  };
}
