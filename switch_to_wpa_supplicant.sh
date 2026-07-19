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

echo -e "${YELLOW}[BİLGİ] NetworkManager backend değişimi başlatılıyor (iwd -> wpa_supplicant)...${NC}"

# 2. wpa_supplicant Paketinin Kontrolü
echo -e "${YELLOW}[ADIM 1] wpa_supplicant paketi kontrol ediliyor...${NC}"
if pacman -S --needed --noconfirm wpa_supplicant; then
  echo -e "${GREEN}[OK] wpa_supplicant paketi hazır.${NC}"
else
  echo -e "${RED}[HATA] wpa_supplicant paketi yüklenemedi. İnternet bağlantınızı kontrol edin.${NC}"
  exit 1
fi

# 3. iwd Konfigürasyonunun Kaldırılması
CONF_FILE="/etc/NetworkManager/conf.d/iwd.conf"
echo -e "${YELLOW}[ADIM 2] iwd konfigürasyonu kaldırılıyor...${NC}"

if [ -f "$CONF_FILE" ]; then
  rm -f "$CONF_FILE"
  echo -e "${GREEN}[OK] $CONF_FILE silindi.${NC}"
else
  echo -e "${YELLOW}[BİLGİ] $CONF_FILE zaten mevcut değil.${NC}"
fi

# Jitter (Ping Spike) Sorununu Çözmek için Güç Tasarrufunu Kapatma
POWERSAVE_CONF="/etc/NetworkManager/conf.d/default-wifi-powersave-on.conf"
echo -e "${YELLOW}[ADIM 3] Jitter (Ping Spike) sorununu azaltmak için Wi-Fi güç tasarrufu (powersave) kapatılıyor...${NC}"
echo -e "[connection]\nwifi.powersave = 2" > "$POWERSAVE_CONF"
echo -e "${GREEN}[OK] Güç tasarrufu devre dışı bırakıldı ($POWERSAVE_CONF).${NC}"

# 4. Servis Yönetimi (iwd -> OFF, wpa_supplicant -> ON)
echo -e "${YELLOW}[ADIM 4] Servisler yeniden yapılandırılıyor...${NC}"

# iwd'yi durdur ve devre dışı bırak
systemctl stop iwd 2>/dev/null
systemctl disable iwd 2>/dev/null
echo -e "${GREEN}[OK] iwd devre dışı bırakıldı.${NC}"

# wpa_supplicant'ı maskeden çıkar ve başlat
systemctl unmask wpa_supplicant 2>/dev/null
systemctl enable --now wpa_supplicant
if systemctl is-active --quiet wpa_supplicant; then
  echo -e "${GREEN}[OK] wpa_supplicant servisi başarıyla başlatıldı.${NC}"
else
  echo -e "${RED}[HATA] wpa_supplicant servisi başlatılamadı!${NC}"
  exit 1
fi

# 5. NetworkManager'ı Yeniden Başlatma
echo -e "${YELLOW}[ADIM 5] NetworkManager yeniden başlatılıyor...${NC}"
systemctl restart NetworkManager

if systemctl is-active --quiet NetworkManager; then
  echo -e "${GREEN}[BAŞARILI] İşlem tamamlandı. NetworkManager artık wpa_supplicant backend'ini kullanıyor.${NC}"
  echo -e "${YELLOW}[NOT] Jitter sorununu en aza indirmek için powersave devre dışı bırakıldı.${NC}"
  echo -e "${YELLOW}[NOT] Eğer hala spike yaşıyorsanız, kullandığınız ağın BSSID'sini NetworkManager üzerinden kilitlemeyi (BSSID lock) deneyebilirsiniz.${NC}"
else
  echo -e "${RED}[HATA] NetworkManager yeniden başlatılamadı. 'systemctl status NetworkManager' ile kontrol edin.${NC}"
  exit 1
fi
