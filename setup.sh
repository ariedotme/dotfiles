#!/bin/bash

# Exit on error
set -e

echo "Starting system setup..."

# Define dotfiles directory
DOTFILES_DIR="$(pwd)/.dotfiles"

# Install essential packages
echo "Installing additional essential packages..."
sudo pacman -S --noconfirm stow zsh neovim kitty
sudo pacman -S --noconfirm --needed base-devel

# Symlink configurations using Stow
echo "Symlinking dotfiles..."
cd "$DOTFILES_DIR"
stow .

# Set Zsh as the default shell
if [ "$SHELL" != "/bin/zsh" ]; then
    echo "Changing default shell to Zsh..."
    chsh -s /bin/zsh
fi

# Install AUR helper (yay)
echo "Installing AUR helper (yay)..."
if ! command -v yay &> /dev/null; then
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd -
    rm -rf /tmp/yay
fi

echo "Installing AUR packages with yay..."
yay -S gotop nnn

echo "Setup complete! Please reboot your system."
