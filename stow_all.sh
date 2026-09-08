#!/bin/bash
set -e

DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
cd "$DOTFILES_DIR"

if ! command -v stow &>/dev/null; then
    echo "⚠️ 'stow' bulunamadı. Kuruluyor..."
    DETECTED_OS=""
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DETECTED_OS="$ID"
    fi
    case "$DETECTED_OS" in
        arch|manjaro|endeavouros|artix|cachyos)
            sudo pacman -S --needed --noconfirm stow
            ;;
        fedora|rhel|centos|rocky|almalinux)
            sudo dnf install -y stow
            ;;
        ubuntu|debian|linuxmint|pop|elementary)
            sudo apt update && sudo apt install -y stow
            ;;
        *)
            echo "⚠️ Dağıtım için otomatik stow kurulumu desteklenmiyor ($DETECTED_OS). Lütfen 'stow' paketini manuel kurun."
            exit 1
            ;;
    esac
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
