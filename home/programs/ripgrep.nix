{
  programs.ripgrep = {
    enable = true;
    # TODO: fill in your personal rg defaults. Each string becomes one line
    # in ~/.config/ripgrep/ripgreprc. Common picks:
    #   "--smart-case"        case-insensitive unless the pattern has uppercase
    #   "--hidden"            search dotfiles too
    #   "--follow"            follow symlinks
    #   "--max-columns=200"   skip absurdly long lines (minified JS, lockfiles)
    #   "--glob=!.git/*"      never descend into .git
    #   "--glob=!node_modules/*"
    arguments = [
      "--smart-case"
      "--hidden"
      "--glob=!.git/*"
      "--max-columns=200"
    ];
  };
}
