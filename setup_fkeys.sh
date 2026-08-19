#!/bin/bash
# ==============================================================================
# F tuşlarını Fonksiyon tuşu olarak yapılandırma (Apple klavye için)
# ==============================================================================
# Bu betik, Apple klavye feczerlerinde F tuşlarının varsayılan olarak
# fonksiyon tuşu olarak çalışmasını sağlar (Fn tuşuna Basmadan)

set -e

echo ":: Apple klavye F tuşu yapılandırması..."

# hid_apple modülü yapılandırma dosyasını oluştur/güncelle
CONFIG_FILE="/etc/modprobe.d/hid_apple.conf"
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "options hid_apple fnmode=2" | sudo tee "$CONFIG_FILE" >/dev/null
    echo "  -> Yapılandırma dosyası oluşturuldu: $CONFIG_FILE"
else
    # Mevcut dosyayı güncelle (fnmode=2 satırını ensure et)
    if ! grep -q "options hid_apple fnmode=2" "$CONFIG_FILE"; then
        echo "options hid_apple fnmode=2" | sudo tee -a "$CONFIG_FILE" >/dev/null
        echo "  -> Yapılandırma dosyası güncellendi: $CONFIG_FILE"
    else
        echo "  -> Yapılandırma zaten mevcut: $CONFIG_FILE"
    fi
fi

# Modülü yeniden yükle
echo ":: hid_apple modülü yeniden yükleniyor..."
sudo rmmod hid_apple 2>/dev/null || true  # hata olsa devreye devam et
sudo modprobe hid_apple

echo ":: F tuşu yapılandırması tamamlandı!"
echo ":: Not: Bazı sistemlerde bu ayarın etkili olması için yeniden başlatma gerekebilir."