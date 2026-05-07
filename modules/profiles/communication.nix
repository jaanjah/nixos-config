{ lib, ... }:
{
  options.jaan.profiles.communication.enable = lib.mkEnableOption "communication apps (chat, email)";
  # No system-level config; this profile only affects home-manager.
}
