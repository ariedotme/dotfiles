#!/bin/bash

echo "Starting system setup..."

DOTFILES_DIR="$(pwd)/.dotfiles"

echo "Installing main packages..."
sudo pacman -S --noconfirm --needed stow zsh neovim wayland xorg-xwayland dunst base-devel sway swaybg

# Symlink configurations using Stow
echo "Symlinking dotfiles..."
cd "$DOTFILES_DIR" || echo "You should be at the dotfiles folder when executing the script" && exit
stow * -t ~ --override *

touch ~/.zsh_history

if [ "$SHELL" != "/bin/zsh" ]; then
	echo "Changing default shell to Zsh..."
	chsh -s /bin/zsh
fi

echo "Installing AUR helper (yay)..."
if ! command -v yay &>/dev/null; then
	git clone https://aur.archlinux.org/yay.git /tmp/yay
	cd /tmp/yay || return
	makepkg -si --noconfirm
	cd - || return
	rm -rf /tmp/yay
fi

echo "Installing extra packages with yay..."
yay -S --noconfirm --needed gotop yazi less tree file coreutils unzip tar man-db atool tldr bat imagemagick mpv ffmpeg glow w3m libnotify

# echo "Installing and configuring NVidia drivers..."
# sudo yay -S --noconfirm --needed nvidia nvidia-utils

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

echo "Setup complete! Please reboot your system."
