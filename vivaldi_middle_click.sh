#!/bin/bash

# Değişkenler
DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
DOTFILES_CONF="$DOTFILES_DIR/vivaldi/.config/vivaldi-stable.conf"
CONF_FILE="$HOME/.config/vivaldi-stable.conf"
LOCAL_DESKTOP_DIR="$HOME/.local/share/applications"
LOCAL_DESKTOP="$LOCAL_DESKTOP_DIR/vivaldi-stable.desktop"
SYSTEM_DESKTOP="/usr/share/applications/vivaldi-stable.desktop"

# Blink/Chromium orta tuş kaydırma (autoscroll) bayrakları
FLAGS="--enable-blink-features=MiddleClickAutoscroll --enable-features=MiddleClickAutoscroll"

echo "Vivaldi Middle Click Scroll Yapılandırması Başlatılıyor..."

# 1. Dotfiles içindeki vivaldi-stable.conf dosyasını oluştur / güncelle
if [ -d "$DOTFILES_DIR/vivaldi/.config" ]; then
  cat << EOF > "$DOTFILES_CONF"
--enable-blink-features=MiddleClickAutoscroll
--enable-features=MiddleClickAutoscroll
EOF
  echo "✅ Dotfiles yapılandırma dosyası güncellendi: $DOTFILES_CONF"
  
  # Stow ile bağla (eğer stow mevcutsa)
  if command -v stow &>/dev/null; then
    (cd "$DOTFILES_DIR" && stow -R -t "$HOME" vivaldi)
    echo "✅ Dotfiles 'stow' ile senkronize edildi."
  fi
fi

# 2. Home dizinindeki conf dosyasını da doğrudan garantiye al
if [ ! -L "$CONF_FILE" ]; then
  mkdir -p "$(dirname "$CONF_FILE")"
  cat << EOF > "$CONF_FILE"
--enable-blink-features=MiddleClickAutoscroll
--enable-features=MiddleClickAutoscroll
EOF
  echo "✅ Kullanıcı yapılandırma dosyası güncellendi: $CONF_FILE"
fi

# 3. Masaüstü (.desktop) dosyasını güncelle
mkdir -p "$LOCAL_DESKTOP_DIR"
if [ -f "$SYSTEM_DESKTOP" ]; then
  cp "$SYSTEM_DESKTOP" "$LOCAL_DESKTOP"
  
  # Exec satırlarını bayraklarla güncelle (%U ve diğer parametrelerden önce bayrakları ekle)
  sed -i "s|^Exec=/usr/bin/vivaldi-stable %U|Exec=/usr/bin/vivaldi-stable $FLAGS %U|" "$LOCAL_DESKTOP"
  sed -i "s|^Exec=/usr/bin/vivaldi-stable --new-window|Exec=/usr/bin/vivaldi-stable $FLAGS --new-window|" "$LOCAL_DESKTOP"
  sed -i "s|^Exec=/usr/bin/vivaldi-stable --incognito|Exec=/usr/bin/vivaldi-stable $FLAGS --incognito|" "$LOCAL_DESKTOP"
  
  echo "✅ Yerel masaüstü dosyası güncellendi: $LOCAL_DESKTOP"
fi

# 4. Bilgilendirme
echo "---"
echo "🎉 İşlem tamamlandı! MangoWM ve diğer masaüstü ortamlarında:"
echo "   - 'SUPER + b' kısayolu ile açıldığında"
echo "   - Terminal üzerinden 'vivaldi' komutuyla açıldığında"
echo "   - Uygulama menüsünden (Noctalia vb.) açıldığında"
echo "artık Middle Click Autoscroll otomatik olarak aktif olacaktır."
echo ""
echo "Değişikliklerin geçerli olması için açık olan Vivaldi pencerelerini kapatıp yeniden başlatın."
echo "Hızlı yeniden başlatmak için: 'killall -9 vivaldi-bin vivaldi 2>/dev/null'"