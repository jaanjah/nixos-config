{
  programs.direnv = {
    enable = true;
    # nix-direnv adds use_flake / use_nix that root the built dev shell as
    # a GC root, so repeat loads are instant and survive nix-collect-garbage.
    nix-direnv.enable = true;

    config.global = {
      # Default 5s is too tight for cold flake builds with many inputs.
      warn_timeout = "30s";
      # The +VAR/-VAR table on every load is noisy and rarely useful.
      hide_env_diff = true;
    };
  };
}
