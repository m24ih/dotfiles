#!/bin/bash

# Hata durumunda script'i durdur
set -e

echo -e "\n--- Flatpak Kurulum Script'i Başlıyor ---"

# -----------------------------------------------------------------
# 1. 'flatpak' Kurulumu ve Yapılandırması
# -----------------------------------------------------------------

# 1.A: flatpak paketini kur (eğer kurulu değilse)
if ! command -v flatpak &>/dev/null; then
  echo "'flatpak' bulunamadı. Pacman ile kuruluyor..."
  # 'yay' zaten kurulu olmalı, ama bu temel paket için pacman kullanmak daha güvenli.
  sudo pacman -S flatpak --noconfirm --needed
  echo "'flatpak' başarıyla kuruldu."
else
  echo "'flatpak' zaten kurulu."
fi

# 1.B: Flathub deposunu ekle (Flatpak için şart)
echo "Flathub deposu ekleniyor (gerekirse)..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# 1.C: flatpak.txt dosyasından paketleri kur
echo "'flatpak.txt' dosyasındaki paketler kuruluyor..."
if [ -f flatpak.txt ]; then
  # 'flatpak.txt' dosyasını oku, yorumları (#) ve boş satırları filtrele,
  # ve 'xargs' ile hepsini tek bir 'flatpak install' komutuna besle.
  grep -vE '^\s*#|^\s*$' flatpak.txt | xargs -r flatpak install flathub -y --noninteractive

  echo "Flatpak paketleri başarıyla kuruldu."
else
  echo "Uyarı: 'flatpak.txt' dosyası bulunamadı. Flatpak kurulumu atlanıyor."
fi

echo "--- Flatpak Kurulum Script'i Tamamlandı ---"
