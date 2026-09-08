#!/bin/bash
set -e

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
cd "$DOTFILES_DIR"

if ! command -v stow &>/dev/null; then
    echo "⚠️ 'stow' bulunamadı. Kuruluyor..."
    sudo pacman -S --needed --noconfirm stow
fi

PACKAGES=(
    btop
    fastfetch
    fish
    ghostty
    hypr
    kitty
    mango
    niri
    nvim
    ssh
    starship
    sunshine
    systemd
    user-dirs
    vivaldi
    zshrc.d
)

echo ":: Dotfiles 'stow' ile ana dizine bağlanıyor ($HOME)..."
stow -R -t "$HOME" "${PACKAGES[@]}"

if [ -f "$DOTFILES_DIR/fastfetch/.config/fastfetch/update-logo.sh" ]; then
    bash "$DOTFILES_DIR/fastfetch/.config/fastfetch/update-logo.sh" "$HOME/.config/fastfetch/logo" 2>/dev/null || true
fi

echo "✅ 'stow' işlemi tamamlandı."
