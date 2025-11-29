#!/bin/bash

# Renkler
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Root kontrolü
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}[!] Bu script root yetkisi gerektirir. Lutfen 'sudo' ile calistirin.${NC}"
  exit 1
fi

RULE_FILE="/etc/udev/rules.d/99-keychron.rules"

echo -e "${YELLOW}[*] Keychron K5 Max icin udev kurallari olusturuluyor...${NC}"

# Kuralları dosyaya yaz (Hem Kablolu hem Dongle için)
cat >"$RULE_FILE" <<EOF
# Keychron K5 Max (Wired - 0a51)
SUBSYSTEM=="usb", ATTR{idVendor}=="3434", ATTR{idProduct}=="0a51", MODE="0666"
KERNEL=="hidraw*", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="0a51", MODE="0666", TAG+="uaccess"

# Keychron Link (Dongle - d030)
SUBSYSTEM=="usb", ATTR{idVendor}=="3434", ATTR{idProduct}=="d030", MODE="0666"
KERNEL=="hidraw*", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="d030", MODE="0666", TAG+="uaccess"
EOF

if [ -f "$RULE_FILE" ]; then
  echo -e "${GREEN}[+] Kural dosyasi basariyla olusturuldu: $RULE_FILE${NC}"
else
  echo -e "${RED}[!] Dosya olusturulamadi!${NC}"
  exit 1
fi

echo -e "${YELLOW}[*] Udev kurallari yeniden yukleniyor ve tetikleniyor...${NC}"

# Kuralları reload et ve triggerla
udevadm control --reload-rules && udevadm trigger

if [ $? -eq 0 ]; then
  echo -e "${GREEN}[+] Islem tamamlandi!${NC}"
  echo -e "${YELLOW}[!] ONEMLI: Script calisti ancak degisikligin tam uygulanmasi icin:${NC}"
  echo -e "    1. Klavyenin kablosunu ve Dongle'i cikar."
  echo -e "    2. 3 saniye bekle."
  echo -e "    3. Tekrar tak."
else
  echo -e "${RED}[!] Udev reload sirasinda bir hata olustu.${NC}"
fi
