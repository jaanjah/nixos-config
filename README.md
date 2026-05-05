# nixos-config

This repo contains my NixOS config.

## Usage

Available NixOS hosts:

- `draakon`: main computer

```sh
# Rebuild draakon from this checkout
sudo nixos-rebuild switch --flake ~/nixos-config#draakon
# Update flake.lock
nix flake update
```

## New machine setup

Clone this repo, create a host directory, add the generated hardware config, then run the first rebuild:

```sh
git clone git@github.com:JaanJah/nixos-config.git ~/nixos-config
cd ~/nixos-config

mkdir -p hosts/<hostname>
sudo nixos-generate-config --show-hardware-config > hosts/<hostname>/hardware-configuration.nix
$EDITOR hosts/<hostname>/default.nix

sudo nixos-rebuild switch --flake ~/nixos-config#<hostname>
```

Add the new host to `nixosConfigurations` in `flake.nix` with `mkHost`. Keep host-specific hardware in `hosts/<hostname>/hardware-configuration.nix`; keep host-specific secrets out of shared modules and put them under the matching host directory or an encrypted secrets path.

Leave `system.stateVersion` and `home.stateVersion` at the release version used for the first install of that machine or user profile.

## Validation

```sh
nix flake check --no-write-lock-file
```

## pre-commit hooks

Setup pre-commit hooks for this repo:

```sh
git config core.hooksPath .githooks
```

TODO:

- Add docs for troubleshooting
- Add separate legacy boot mode and UEFI boot mode config

Personal notes:

- Good structure from https://github.com/ryan4yin/nix-config/tree/i3-kickstarter
