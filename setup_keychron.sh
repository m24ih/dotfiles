#!/bin/bash
# ==============================================================================
# Keychron K5 Max Klavye İçin Udev Kuralları
# ==============================================================================
# Bu betik, Keychron K5 Max klavyesinin (hem kablolu hem dongle üzerinden)
# sistem tarafından doğru şekilde tanınmasını ve gerekli izinlerin verilmesini sağlar.

set -e

# Renkler
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo ":: Keychron K5 Max udev kurallarının yapılandırılması..."

# Root kontrolü
if [ "$EUID" -ne 0 ]; then
  echo "Hata: Bu script root yetkisi gerektirir. Lutfen 'sudo' ile calistirin."
  exit 1
fi

RULE_FILE="/etc/udev/rules.d/99-keychron.rules"

echo "-> Udev kural dosyasi olusturuluyor: $RULE_FILE"

# Kuralları dosyaya yaz (Hem Kablolu hem Dongle için)
sudo tee "$RULE_FILE" > /dev/null <<'EOF'
# Keychron K5 Max (Wired - 0a51)
SUBSYSTEM=="usb", ATTR{idVendor}=="3434", ATTR{idProduct}=="0a51", MODE="0666"
KERNEL=="hidraw*", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="0a51", MODE="0666", TAG+="uaccess"

# Keychron Link (Dongle - d030)
SUBSYSTEM=="usb", ATTR{idVendor}=="3434", ATTR{idProduct}=="d030", MODE="0666"
KERNEL=="hidraw*", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="d030", MODE="0666", TAG+="uaccess"
EOF

if [ -f "$RULE_FILE" ]; then
  echo "  -> Kural dosyasi basariyla olusturuldu: $RULE_FILE"
else
  echo "  -> Hata: Kural dosyasi olusturulamadi!"
  exit 1
fi

# Kurallari reload et ve triggerla
echo "-> Udev kurallari yeniden yukleniyor ve tetikleniyor..."
sudo udevadm control --reload-rules && sudo udevadm trigger

if [ $? -eq 0 ]; then
  echo "  -> Islem basariyla tamamlandi!"
  echo "  -> Not: Degisikligin tam uygulanmasi icin:"
  echo "      1. Klavyenin kablosunu ve Dongle'i cikarin."
  echo "      2. 3 saniye bekleyin."
  echo "      3. Tekrar takin."
else
  echo "  -> Hata: Udev reload sirasinda bir hata olustu."
  exit 1
fi
