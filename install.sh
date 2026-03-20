#!/usr/bin/env bash

set -euo pipefail

echo "Updating system first..."
sudo pacman -Syu --noconfirm


echo "Installing general programs..."
sudo pacman -S --needed \
    firefox visual-studio-code-bin  \
    neovim fastfetch btop \
    discord localsend \
    otf-codenewroman-nerd |

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
    docker docker-compose \
    ghostty \
    ghostty-shell-integration \
    zenity

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
# Install UI packages
# ──────────────────────────────────────────────────────────────────────────────
paru -S --needed --noconfirm \
	hyprlock \
    brightnessctl \
    bluetui \
    playerctl \
	waybar |

curl -fsSL https://vicinae.com/install.sh | bash


# ──────────────────────────────────────────────────────────────────────────────
# AUR PACKAGES
# ──────────────────────────────────────────────────────────────────────────────

echo "Installing AUR packages..."
paru -S --needed --noconfirm \
    claude-code \
    1password \
    zsh-autosuggestions \
    zsh-syntax-highlighting |

if ! command -v opencode &> /dev/null; then
    curl -fsSL https://opencode.ai/install | bash
fi


# ──────────────────────────────────────────────────────────────────────────────
# OH MY ZSH SETUP
# ──────────────────────────────────────────────────────────────────────────────

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi


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

systemctl --user enable --now NetworkManager.service
systemctl --user enable --now bluetooth.service
systemctl --user enable --now docker.service
systemctl --user enable --now docker.service
systemctl --user enable --now vicinae.service
systemctl --user enable --now hyprpolkitagent.service


sudo usermod -aG docker "$USER"
