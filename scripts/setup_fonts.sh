#!/bin/bash
# ==============================================================================
# Font Kurulumu ve Yapılandırması
# ==============================================================================
# Bu betik, JetBrains Mono Nerd Font yazı tipini kurar ve font önbelleğini günceller.
# Arch tabanlı dağıtımlarda (CachyOS, Arch, Manjaro vb.) resmi paketi kurar.
# Diğer dağıtımlarda GitHub üzerinden en güncel sürümü indirerek kurar.

set -e

echo ":: Font kurulumu başlıyor..."

# OS Tespiti
DETECTED_OS=""
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DETECTED_OS="$ID"
fi

case "$DETECTED_OS" in
    arch|manjaro|endeavouros|artix|cachyos)
        sudo pacman -S --needed --noconfirm ttf-jetbrains-mono-nerd
        ;;
    *)
        FONT_DIR="$HOME/.local/share/fonts"
        mkdir -p "$FONT_DIR"
        echo ":: JetBrains Mono Nerd Font GitHub'dan indiriliyor..."
        TEMP_DIR=$(mktemp -d)
        curl -fsSL -o "$TEMP_DIR/JetBrainsMono.tar.xz" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
        tar -xf "$TEMP_DIR/JetBrainsMono.tar.xz" -C "$FONT_DIR"
        rm -rf "$TEMP_DIR"
        ;;
esac

# Font önbelleğini güncelle
echo ":: Font önbelleği güncelleniyor..."
fc-cache -f

echo ":: Font kurulumu tamamlandı!"