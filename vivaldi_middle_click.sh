#!/bin/bash

# Değişkenler
FLAG="--enable-features=MiddleClickAutoscroll"
LOCAL_DESKTOP="$HOME/.local/share/applications/vivaldi-stable.desktop"
SYSTEM_DESKTOP="/usr/share/applications/vivaldi-stable.desktop"
CONF_FILE="$HOME/.config/vivaldi-stable.conf"

echo "Vivaldi Middle Click Scroll Yapılandırması Başlatılıyor..."

# 1. Sistem desktop dosyasını kopyala (eğer yerel dosya yoksa)
if [ ! -f "$LOCAL_DESKTOP" ]; then
  if [ -f "$SYSTEM_DESKTOP" ]; then
    cp "$SYSTEM_DESKTOP" "$LOCAL_DESKTOP"
    echo "✅ Sistem masaüstü dosyası yerel kopyalandı: $LOCAL_DESKTOP"
  else
    echo "❌ Sistem masaüstü dosyası bulunamadı: $SYSTEM_DESKTOP"
    exit 1
  fi
fi

# 2. Yerel desktop dosyasındaki Exec satırlarını güncelle
if [ -f "$LOCAL_DESKTOP" ]; then
  # Tüm Exec satırlarının 끝에 flag ekle (eğer zaten yoksa)
  if grep -q "^Exec=" "$LOCAL_DESKTOP"; then
    # Her Exec satırının 끝에 flag ekle (eğer yoksa)
    sed -i "s|^Exec=\(.*\)$|Exec=\1 $FLAG|" "$LOCAL_DESKTOP"
    # Ardından duplicated flagları temizle (boşlukla بدأت یا�la)
    sed -i "s|$FLAG $FLAG|$FLAG|g" "$LOCAL_DESKTOP"
    # Başta duplicated flagı da temizle (ExecutableFlag boşluk hiçbir şey olmadan)
    sed -i "s|^Exec=$FLAG $FLAG|^Exec=$FLAG|" "$LOCAL_DESKTOP"
    echo "✅ tüm Exec satırları flag ile güncellendi: $FLAG"
  else
    echo "❌ Yerel masaüstü dosyasında Exec satırı bulunamadı: $LOCAL_DESKTOP"
    exit 1
  fi
else
  echo "❌ Yerel masaüstü dosyası bulunamadı: $LOCAL_DESKTOP"
  exit 1
fi

# 3. yapılandırma dosyasını da güncelle (geriye dönük uyumluluk ve alternatif yöntem için)
mkdir -p "$(dirname "$CONF_FILE")"
echo "$FLAG" > "$CONF_FILE"
echo "✅ Yapılandırma dosyası güncellendi: $CONF_FILE"

# 4. Vivaldi'nin temiz bir şekilde yeniden başlatılması için uyarı
echo "---"
echo "İşlem tamamlandı. Değişikliklerin aktif olması için Vivaldi'yi tamamen kapatıp açın."
echo "Eğer çalışmazsa: 'pkill vivaldi' komutunu kullanabilirsiniz."
echo "Not: Bu script, Vivaldi'yi komut satırı flag'ı ile başlatmak için yerel .desktop dosyasını modifier."