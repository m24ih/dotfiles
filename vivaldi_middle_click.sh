#!/bin/bash

# Değişkenler
SOURCE_FILE="/usr/share/applications/vivaldi-stable.desktop"
DEST_DIR="$HOME/.local/share/applications"
DEST_FILE="$DEST_DIR/vivaldi-stable.desktop"
FLAG="--enable-features=MiddleClickAutoscroll"

# 1. Kaynak dosya var mı kontrol et
if [ ! -f "$SOURCE_FILE" ]; then
  echo "HATA: Vivaldi kaynak dosyası bulunamadı ($SOURCE_FILE)."
  exit 1
fi

# 2. Hedef klasör yoksa oluştur
if [ ! -d "$DEST_DIR" ]; then
  mkdir -p "$DEST_DIR"
  echo "Klasör oluşturuldu: $DEST_DIR"
fi

# 3. Dosyayı işle ve yeni yerine kaydet
# sed komutu 'Exec=/usr/bin/vivaldi-stable' gördüğü yere flag'i ekler.
echo "Ayar ekleniyor..."
sed "s|Exec=/usr/bin/vivaldi-stable|Exec=/usr/bin/vivaldi-stable $FLAG|g" "$SOURCE_FILE" >"$DEST_FILE"

# 4. Dosya izinlerini ayarla (Çalıştırılabilir yap)
chmod +x "$DEST_FILE"

# 5. Masaüstü veritabanını güncelle (Değişikliğin hemen algılanması için)
update-desktop-database "$DEST_DIR" 2>/dev/null

echo "✅ İşlem tamamlandı! Vivaldi artık Autoscroll ile başlayacak."
echo "Dosya konumu: $DEST_FILE"
