{
  lib,
  appimageTools,
  fetchurl,
}:

# nixpkgs' wowup-cf, at a newer version. Our nixpkgs pin carries 2.23.1, and
# WoW: Forever support (its `_forever_` client folder) only arrived in 2.24.0.
# Drop this file for pkgs.wowup-cf once nixpkgs is at 2.24.0 or later
# (nixos-unstable had 2.25.4 on 2026-11-12).
# Redefined rather than overrideAttrs: the desktop file and icons come from a
# separate extract of `src`, which an override of `src` would leave stale.
let
  pname = "wowup-cf";
  version = "2.25.5";

  src = fetchurl {
    # Check latest here: https://github.com/WowUp/WowUp.CF/releases
    # nix store prefetch-file --json https://github.com/WowUp/WowUp.CF/releases/download/v2.25.5/WowUp-CF-2.25.5.AppImage
    url = "https://github.com/WowUp/WowUp.CF/releases/download/v${version}/WowUp-CF-${version}.AppImage";
    hash = "sha256-OHeSxDwTWd3DXmeBAAoG/w/Dj7VXhdwCmn2X9PE6SDk=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = {
    description = "World of Warcraft addon updater with CurseForge support";
    homepage = "https://wowup.io/";
    downloadPage = "https://github.com/WowUp/WowUp.CF/releases";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "wowup-cf";
    platforms = [ "x86_64-linux" ];
  };
}
