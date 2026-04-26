{
  programs.fish = {
    enable = true;
    shellAliases = {
      ssh = "kitten ssh";
      claude = "claude --model claude-opus-4-6 --effort max";
    };
  };
}
