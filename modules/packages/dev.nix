{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    binutils
    bun
    claude-code
    gh
    gnumake
    libgcc
    marksman
    nasm
  ];
}
