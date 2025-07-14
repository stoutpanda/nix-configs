# NixOS Configuration

This repository contains my NixOS system configuration using flakes.

## System Overview

- **Host**: nixos-whitedwarf (ASUS Zephyrus GA402X)
- **CPU**: AMD Ryzen
- **GPU**: NVIDIA RTX 4060 Max-Q + AMD integrated graphics
- **Desktop**: Hyprland (Wayland compositor)

## NVIDIA Graphics (Hybrid Setup)

This configuration uses NVIDIA Prime offload mode for optimal battery life while allowing on-demand GPU usage.

### Using the NVIDIA GPU

To run applications on the NVIDIA GPU, use the `nvidia-offload` command:

```bash
# Run Steam on NVIDIA GPU
nvidia-offload steam

# Run any application with NVIDIA GPU
nvidia-offload <application>

# Examples
nvidia-offload blender
nvidia-offload firefox
nvidia-offload obs
```

The NVIDIA GPU remains powered off until explicitly used with `nvidia-offload`, maximizing battery life.

## Directory Structure

```
.
├── flake.nix                 # Main flake configuration
├── configuration.nix         # Base system configuration
├── hosts/
│   └── nixos-whitedwarf/    # Host-specific configuration
│       ├── configuration.nix # Host settings
│       └── hardware-configuration.nix
└── modules/
    ├── hyprland.nix         # Hyprland window manager
    ├── kde.nix              # KDE Plasma (alternative)
    └── nvidia.nix           # NVIDIA Prime configuration
```

## Key Features

- **Hyprland**: Wayland compositor with modern features
- **NVIDIA Prime Offload**: Hybrid graphics with on-demand GPU switching
- **CachyOS Kernel**: Optimized kernel with SCX scheduler
- **Firewall**: Configured with conditional Steam port opening
- **Encrypted Storage**: LUKS encryption for root and swap
- **F2FS Support**: For microSD card storage

## Building and Switching

```bash
# Build the configuration
sudo nixos-rebuild build --flake .#nixos-whitedwarf

# Switch to the new configuration
sudo nixos-rebuild switch --flake .#nixos-whitedwarf

# Update flake inputs
nix flake update

# Check flake
nix flake check

# Format Nix files
nix fmt
```

## Binary Caches

This configuration uses additional binary caches for faster builds:
- Nix Community cache
- Chaotic-Nyx cache (for CachyOS packages)

These are configured in the flake's `nixConfig` section.

## Notes

- Home Manager configuration is managed separately at [github:stoutpanda/home-manager](https://github.com/stoutpanda/home-manager)
- The system uses bleeding-edge packages from nixos-unstable
- Chaotic-Nyx overlay provides CachyOS kernel and other optimized packages