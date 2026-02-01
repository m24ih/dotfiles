#!/bin/bash

# Hata oluşursa betiği durdur
set -e

# Konfigürasyon
TARGET_DIR="/etc/1password"
TARGET_FILE="$TARGET_DIR/custom_allowed_browsers"

# İzin verilecek tarayıcı listesi
BROWSERS=(
  vivaldi-bin
  zen-bin
  brave-bin
  chromium-bin
)

echo "🚀 1Password özel tarayıcı izinleri yapılandırılıyor..."

# Root yetkisi kontrolü
if [ "$EUID" -ne 0 ]; then
  echo "❌ Lütfen bu betiği 'sudo' ile çalıştırın."
  exit 1
fi

# Klasörü oluştur
if [ ! -d "$TARGET_DIR" ]; then
  mkdir -p "$TARGET_DIR"
  echo "✅ Klasör oluşturuldu: $TARGET_DIR"
fi

# Dosyayı oluştur ve tarayıcıları içine yaz
printf "%s\n" "${BROWSERS[@]}" >"$TARGET_FILE"
echo "✅ Tarayıcı listesi yazıldı."

# İzinleri ve sahipliği ayarla
chown root:root "$TARGET_FILE"
chmod 755 "$TARGET_FILE"
echo "✅ İzinler ayarlandı (root:root, 755)."

echo -e "\n🎉 İşlem başarıyla tamamlandı!"
echo "Değişikliklerin etkili olması için 1Password uygulamasını tamamen kapatıp tekrar açman gerekebilir."
