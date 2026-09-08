#!/bin/bash

# Renk Tanımlamaları
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 1. Root Yetkisi Kontrolü
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}[HATA] Bu script root yetkisi gerektirir. Lütfen 'sudo' ile çalıştırın.${NC}"
  exit 1
fi

echo -e "${YELLOW}[BİLGİ] NetworkManager backend değişimi başlatılıyor (wpa_supplicant -> iwd)...${NC}"

# 2. iwd Paketinin Kurulumu
echo -e "${YELLOW}[ADIM 1] iwd paketi kontrol ediliyor...${NC}"
if pacman -S --needed --noconfirm iwd; then
  echo -e "${GREEN}[OK] iwd paketi hazır.${NC}"
else
  echo -e "${RED}[HATA] iwd paketi yüklenemedi. İnternet bağlantınızı kontrol edin.${NC}"
  exit 1
fi

# 3. Konfigürasyon Dosyasının Oluşturulması
CONF_FILE="/etc/NetworkManager/conf.d/iwd.conf"
echo -e "${YELLOW}[ADIM 2] $CONF_FILE dosyası oluşturuluyor...${NC}"

# Eğer dosya varsa yedeğini al
if [ -f "$CONF_FILE" ]; then
  cp "$CONF_FILE" "$CONF_FILE.bak"
  echo -e "${YELLOW}[BİLGİ] Mevcut konfigürasyon yedeklendi: $CONF_FILE.bak${NC}"
fi

# Dosyayı yaz
echo -e "[device]\nwifi.backend=iwd" >"$CONF_FILE"

if [ -f "$CONF_FILE" ]; then
  echo -e "${GREEN}[OK] Konfigürasyon dosyası yazıldı.${NC}"
else
  echo -e "${RED}[HATA] Dosya oluşturulamadı!${NC}"
  exit 1
fi

# 4. Servis Yönetimi (wpa_supplicant -> OFF, iwd -> ON)
echo -e "${YELLOW}[ADIM 3] Servisler yeniden yapılandırılıyor...${NC}"

# wpa_supplicant'ı durdur ve kilitle
systemctl stop wpa_supplicant 2>/dev/null
systemctl disable wpa_supplicant 2>/dev/null
systemctl mask wpa_supplicant 2>/dev/null
echo -e "${GREEN}[OK] wpa_supplicant devre dışı bırakıldı ve maskelendi.${NC}"

# iwd'yi başlat
systemctl enable --now iwd
if systemctl is-active --quiet iwd; then
  echo -e "${GREEN}[OK] iwd servisi başarıyla başlatıldı.${NC}"
else
  echo -e "${RED}[HATA] iwd servisi başlatılamadı!${NC}"
  exit 1
fi

# 5. NetworkManager'ı Yeniden Başlatma
echo -e "${YELLOW}[ADIM 4] NetworkManager yeniden başlatılıyor...${NC}"
systemctl restart NetworkManager

if systemctl is-active --quiet NetworkManager; then
  echo -e "${GREEN}[BAŞARILI] İşlem tamamlandı. NetworkManager artık iwd backend'ini kullanıyor.${NC}"
  echo -e "${YELLOW}[NOT] Wi-Fi bağlantınız kesilmiş olabilir. Şifrenizi tekrar girmeniz gerekebilir.${NC}"
else
  echo -e "${RED}[HATA] NetworkManager yeniden başlatılamadı. 'systemctl status NetworkManager' ile kontrol edin.${NC}"
  exit 1
fi
