#!/bin/bash
# ==============================================================================
# Font Kurulumu ve Yapılandırması
# ==============================================================================
# Bu betik, JetBrains Mono Nerd Font yazı tipini kurar ve font önbelleğini günceller.
# Arch tabanlı dağıtımlarda (CachyOS, Arch, Manjaro vb.) doğrudan resmi
# 'extra/ttf-jetbrains-mono-nerd' paketini kurar.
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
        echo "-> Arch tabanlı dağıtım tespit edildi ($DETECTED_OS)."
        echo "-> 'extra/ttf-jetbrains-mono-nerd' paketi pacman ile kuruluyor..."
        sudo pacman -S --needed --noconfirm ttf-jetbrains-mono-nerd
        ;;
    *)
        echo "-> Dağıtım: $DETECTED_OS. GitHub üzerinden manuel indiriliyor..."
        FONT_DIR_LOCAL="$HOME/.local/share/fonts"
        mkdir -p "$FONT_DIR_LOCAL"

        JETBRAINS_ZIP="$HOME/Downloads/JetBrainsMono.zip"
        JETBRAINS_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.5.0/JetBrainsMono.zip"

        if [ ! -f "$JETBRAINS_ZIP" ]; then
            echo "-> JetBrains Mono Nerd Font indiriliyor..."
            mkdir -p "$HOME/Downloads"
            if command -v curl &>/dev/null; then
                curl -L -o "$JETBRAINS_ZIP" "$JETBRAINS_URL"
            elif command -v wget &>/dev/null; then
                wget -O "$JETBRAINS_ZIP" "$JETBRAINS_URL"
            else
                echo "Hata: İndirmek için ne curl ne de wget bulunamadı."
                exit 1
            fi
        else
            echo "-> JetBrains Mono Nerd Font zip önbellekte bulundu."
        fi

        TEMP_DIR=$(mktemp -d)
        echo "-> Font paketi çıkarılıyor ve kuruluyor..."
        unzip -q -o "$JETBRAINS_ZIP" -d "$TEMP_DIR"
        find "$TEMP_DIR" -name "*.ttf" -exec cp {} "$FONT_DIR_LOCAL/" \;
        rm -rf "$TEMP_DIR"
        ;;
esac

# Font önbelleğini güncelle
echo ":: Font önbelleği güncelleniyor..."
fc-cache -f

echo ":: Font kurulumu tamamlandı!"