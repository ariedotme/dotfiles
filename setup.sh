#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
    echo "Please run this script with sudo."
    exit 1
fi

# Exit on error
set -e

echo "Starting system setup..."

# Define dotfiles directory
DOTFILES_DIR="$(pwd)/.dotfiles"

# Install essential packages
echo "Installing main packages..."
sudo pacman -S --noconfirm --needed stow zsh neovim kitty xorg-server xorg-xinit awesome lightdm lightdm-gtk-greeter picom dunst arc-gtk-theme papirus-icon-theme
sudo pacman -S --noconfirm --needed base-devel

echo "Enabling lightdm..."
sudo systemctl enable lightdm

# Symlink configurations using Stow
echo "Symlinking dotfiles..."
cd "$DOTFILES_DIR"
stow * -t ~ --override=*

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

echo "Installing extra packages with yay..."
yay -S --noconfirm --needed gotop nnn github-cli less tree file coreutils unzip tar man-db atool bat imagemagick mpv ffmpegthumbnailer ffmpeg glow w3m libnotify rofi xbindkeys
chmod +x ~/.config/eww/scripts/workspaces.sh

echo "Installing and configuring NVidia drivers..."
sudo yay -S --noconfirm --needed nvidia nvidia-utils
sudo mkdir -p /etc/X11/xorg.conf.d/
sudo bash -c 'cat > /etc/X11/xorg.conf.d/20-nvidia.conf <<EOF
Section "Device"
    Identifier "NVIDIA GPU"
    Driver "nvidia"
    Option "Coolbits" "4" # Allows GPU overclocking and fan control (optional)
EndSection
EOF'

echo "Making .temp folder..."
mkdir ~/.temp

echo "Installing development tools..."
# Go
sudo yay -S --noconfirm --needed go

# JDK 21
sudo yay -S --noconfirm --needed jdk-openjdk

# Node.js and npm
sudo yay -S --noconfirm --needed nodejs npm

# Bun
curl -fsSL https://bun.sh/install | bash

# Elixir
sudo yay -S --noconfirm --needed elixir

# Tools for C/C++ Development
sudo yay -S --noconfirm --needed clang cmake make gdb lldb valgrind ninja gcc clang-tools-extra

# Rust
sudo yay -S --noconfirm -needed rustup
rustup default nightly

echo "Installing cargo packages..."
cargo install neocmakelsp

echo "Setup complete! Please reboot your system. Run `gh auth login` after the reboot."
