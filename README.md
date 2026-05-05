# nixos-config

This repo contains my NixOS config.

## Usage

Available NixOS hosts:

- `draakon`: main computer

```sh
# Rebuild the current host from this checkout
sudo nixos-rebuild switch --flake ~/nixos-config#draakon

# Validate without changing flake.lock
nix flake check --no-write-lock-file

# Update pinned inputs
nix flake update
```

## New machine setup

Clone this repo and create a host directory named after the machine:

```sh
git clone git@github.com:JaanJah/nixos-config.git ~/nixos-config
cd ~/nixos-config

mkdir -p hosts/<hostname>
sudo nixos-generate-config --show-hardware-config > hosts/<hostname>/hardware-configuration.nix
cp hosts/draakon/default.nix hosts/<hostname>/default.nix
```

Edit `hosts/<hostname>/default.nix` for machine-specific modules, users, packages, and hardware choices. Then add the host to `nixosConfigurations` in `flake.nix`:

```nix
<hostname> = mkHost {
  hostname = "<hostname>";
  modules = [
    ./hosts/<hostname>
  ];
};
```

Validate and run the first rebuild:

```sh
nix flake check --no-write-lock-file

sudo nixos-rebuild switch --flake ~/nixos-config#<hostname>
```

If the checkout is a Git repo, new host files must be tracked before Nix can see them:

```sh
git add flake.nix hosts/<hostname>
```

Leave `system.stateVersion` and `home.stateVersion` at the release version used for the first install of that machine or user profile.

## Host-specific files

Keep generated hardware config in the matching host directory:

```sh
hosts/<hostname>/hardware-configuration.nix
```

Keep secrets out of shared modules. Put host-specific secret wiring in `hosts/<hostname>` or use an encrypted secrets path when secrets are added to this repo.

## Git hooks

Setup Git hooks for this repo:

```sh
git config core.hooksPath .githooks
```

The pre-commit hook runs `nixfmt` and `deadnix`. The pre-push hook runs:

```sh
nix flake check --no-write-lock-file
```

Run the hooks manually:

```sh
nix develop -c pre-commit run --all-files
nix develop -c pre-commit run --hook-stage pre-push --all-files
```

## Troubleshooting

If `sudo nixos-rebuild switch` looks for `nixosConfigurations."nixos"` after a host rename, pass the selector explicitly:

```sh
sudo nixos-rebuild switch --flake ~/nixos-config#draakon
```

After that switch, the runtime hostname should match the flake host name.

If Nix says a host path is not tracked by Git, stage or commit the new files:

```sh
git add hosts/<hostname> flake.nix
```

TODO:

- Add separate legacy boot mode and UEFI boot mode config

Personal notes:

- Good structure from https://github.com/ryan4yin/nix-config/tree/i3-kickstarter
