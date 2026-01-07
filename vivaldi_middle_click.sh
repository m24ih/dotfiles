#!/bin/bash

# Değişkenler
CONF_FILE="$HOME/.config/vivaldi-stable.conf"
FLAG="--enable-features=MiddleClickAutoscroll"
LOCAL_DESKTOP="$HOME/.local/share/applications/vivaldi-stable.desktop"

echo "Vivaldi Autoscroll Yapılandırması Başlatılıyor..."

# 1. Eski (ve artık gereksiz) yerel desktop dosyasını temizle
# Bu sayede sistemdeki orijinal vivaldi.desktop dosyası kullanılır,
# parametreler conf dosyasından çekilir.
if [ -f "$LOCAL_DESKTOP" ]; then
  rm "$LOCAL_DESKTOP"
  echo "Gereksiz yerel .desktop dosyası kaldırıldı."
fi

# 2. Config klasörünün varlığını kontrol et
mkdir -p "$(dirname "$CONF_FILE")"

# 3. Flag kontrolü ve ekleme
if [ -f "$CONF_FILE" ]; then
  if grep -qF "$FLAG" "$CONF_FILE"; then
    echo "✅ Bayrak zaten $CONF_FILE içerisinde mevcut."
  else
    echo "$FLAG" >>"$CONF_FILE"
    echo "✅ Bayrak $CONF_FILE dosyasına eklendi."
  fi
else
  echo "$FLAG" >"$CONF_FILE"
  echo "✅ Yapılandırma dosyası oluşturuldu ve bayrak eklendi."
fi

# 4. Vivaldi'nin temiz bir şekilde yeniden başlatılması için uyarı
echo "---"
echo "İşlem tamamlandı. Değişikliklerin aktif olması için Vivaldi'yi tamamen kapatıp açın."
echo "Eğer çalışmazsa: 'pkill vivaldi' komutunu kullanabilirsiniz."
