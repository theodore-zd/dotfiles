#!/usr/bin/env bash

set -euo pipefail

echo "Updating system first..."
sudo pacman -Syu --noconfirm

echo "Installing core dependencies..."
sudo pacman -S --needed \
    git base-devel wget curl \
    xdg-desktop-portal-hyprland xdg-desktop-portal \
    polkit polkit-gnome \
    pipewire pipewire-pulse wireplumber pipewire-alsa pipewire-jack \
    alsa-utils pavucontrol \
    networkmanager blueman bluez bluez-utils \
    brightnessctl

echo "Installing Hyprland + essential companions..."
sudo pacman -S --needed \
    hyprland hyprpaper hyprlock hypridle \
    waybar wofi kitty \
    dunst cliphist \
    grim slurp swappy \
    thunar thunar-archive-plugin ffmpegthumbnailer tumbler

echo "Installing fonts..."
sudo pacman -S --needed \
    ttf-jetbrains-mono-nerd noto-fonts noto-fonts-emoji \
    ttf-font-awesome otf-font-awesome

echo "Installing general programs..."
sudo pacman -S --needed \
    firefox code \
    neovim fastfetch btop

# ──────────────────────────────────────────────────────────────────────────────
# DEV DEPENDENCIES
# ──────────────────────────────────────────────────────────────────────────────

echo "Installing dev dependencies..."

sudo pacman -S --needed \
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

# ──────────────────────────────────────────────────────────────────────────────
# AUR PACKAGES
# ──────────────────────────────────────────────────────────────────────────────

echo "Installing AUR packages..."

paru -S --needed --noconfirm \
    opencode-bin \
    claude-code

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

echo "Done!"
echo "IMPORTANT:"
echo "- Log out and back in (docker group, environment updates)"
echo "- Run: flatpak update"
echo "- Configure API keys for claude-code/opencode if needed"