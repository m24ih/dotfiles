#!/bin/bash
# ==============================================================================
# Font Kurulumu ve Yapılandırması
# ==============================================================================
# Bu betik, JetBrains Mono Nerd Font gibi yazı tiplerini kurar ve font önbelleğini günceller.
# Eğer JetBrains Mono Nerd Font zip'i ~/Downloads'ta yoksa, indirir.

set -e

echo ":: Font kurulumu başlıyor..."

# Font dizinlerini oluştur
FONT_DIR_LOCAL="$HOME/.local/share/fonts"
FONT_DIR_SYSTEM="/usr/local/share/fonts"

mkdir -p "$FONT_DIR_LOCAL"
sudo mkdir -p "$FONT_DIR_SYSTEM"

# JetBrains Mono Nerd Font kurulumu
JETBRAINS_ZIP="$HOME/Downloads/JetBrainsMono.zip"
JETBRAINS_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.5.0/JetBrainsMono.zip"

if [ -f "$JETBRAINS_ZIP" ]; then
    echo "-> JetBrains Mono Nerd Font önbellekte bulundu."
else
    echo "-> JetBrains Mono Nerd Font önbellekte bulunamadı. İndiriliyor..."
    # Create downloads directory if it doesn't exist
    mkdir -p "$HOME/Downloads"
    # Download the font zip
    if command -v curl &>/dev/null; then
        curl -L -o "$JETBRAINS_ZIP" "$JETBRAINS_URL"
    elif command -v wget &>/dev/null; then
        wget -O "$JETBRAINS_ZIP" "$JETBRAINS_URL"
    else
        echo "Hata: İndirmek için ne curl ne de wget bulunamadı."
        exit 1
    fi
    # Check if download was successful
    if [ ! -f "$JETBRAINS_ZIP" ]; then
        echo "Hata: JetBrains Mono Nerd Font indirilemedi."
        exit 1
    fi
    echo "  -> JetBrains Mono Nerd Font indirildi."
fi

# Geçici dizin oluştur
TEMP_DIR=$(mktemp -d)

# Zip dosyasını çıkar
echo "-> Font paketi çıkarılıyor..."
unzip -q "$JETBRAINS_ZIP" -d "$TEMP_DIR"

# TTF dosyalarını font dizinine kopyala
echo "-> Font dosyaları kuruluyor..."
find "$TEMP_DIR" -name "*.ttf" -exec cp {} "$FONT_DIR_LOCAL/" \;

# Geçici dizini temizle
rm -rf "$TEMP_DIR"

echo "  -> JetBrains Mono Nerd Font kuruldu."

# Diğer yaygın Nerd Font'ler için kontrol (isteğe bağlı)
# Bu bölüm gelecekte genişletilebilir

# Font önbelleğini güncelle
echo ":: Font önbelleği güncelleniyor..."
fc-cache -f -v

echo ":: Font kurulumu tamamlandı!"
echo ":: Not: Bazı uygulamalarda font değişikliğini görmek için yeniden başlatmanız gerekebilir."