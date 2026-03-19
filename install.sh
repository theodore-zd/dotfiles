#!/usr/bin/env bash

set -euo pipefail

echo "Updating system first..."
sudo pacman -Syu --noconfirm


echo "Installing general programs..."
sudo pacman -S --needed \
    firefox code \
    neovim fastfetch btop \
    discord localsend |

# ──────────────────────────────────────────────────────────────────────────────
# DEV DEPENDENCIES
# ──────────────────────────────────────────────────────────────────────────────

echo "Installing dev dependencies..."

sudo pacman -S --needed \
    ripgrep \
    dust \
    zoxide \
    go \
    bun \
    nodejs npm \
    python python-pip python-poetry \
    docker docker-compose

# ──────────────────────────────────────────────────────────────────────────────
# INSTALL PARU (AUR HELPER)
# ──────────────────────────────────────────────────────────────────────────────

if ! command -v paru &> /dev/null; then
    echo "Installing paru AUR helper..."
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    cd /tmp/paru
    makepkg -si --noconfirm
    cd -
    rm -rf /tmp/paru
fi

curl -fsSL https://opencode.ai/install | bash

# ──────────────────────────────────────────────────────────────────────────────
# AUR PACKAGES
# ──────────────────────────────────────────────────────────────────────────────

echo "Installing AUR packages..."
paru -S --needed --noconfirm \
    claude-code,
    1password


# ──────────────────────────────────────────────────────────────────────────────
# FLATPAK SETUP
# ──────────────────────────────────────────────────────────────────────────────

echo "Installing Flatpak and setting up Flathub..."

sudo pacman -S --needed flatpak

# Add Flathub repo if not already added
if ! flatpak remote-list | grep -q flathub; then
    sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
fi

# Install Gear Lever (AppImage manager)
flatpak install -y flathub it.mijorus.gearlever

# ──────────────────────────────────────────────────────────────────────────────
# POST-INSTALL SETUP
# ──────────────────────────────────────────────────────────────────────────────

echo "Setting up services..."

sudo systemctl enable --now NetworkManager
sudo systemctl enable --now bluetooth
sudo systemctl enable --now docker

sudo usermod -aG docker "$USER"
