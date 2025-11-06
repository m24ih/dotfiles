#!/bin/bash

# Hata durumunda script'i durdur
set -e

echo "Arch/CachyOS Kurulum Script'i Başlıyor..."

# -----------------------------------------------------------------
# 1. Gerekli Temel Paketler (git ve base-devel)
# -----------------------------------------------------------------
echo "'git' ve 'base-devel' grubu kontrol ediliyor/kuruluyor..."
# 'yay' kurmak için bunlara ihtiyaç var
sudo pacman -Syu --needed git base-devel --noconfirm

# -----------------------------------------------------------------
# 2. 'yay' AUR Yardımcısını Kur
# -----------------------------------------------------------------
if ! command -v yay &>/dev/null; then
  echo "'yay' bulunamadı. AUR'dan kuruluyor..."

  # 'yay' reposunu klonla, derle ve kur
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  (cd /tmp/yay && makepkg -si --noconfirm)

  # Geçici kurulum dosyalarını temizle
  rm -rf /tmp/yay

  echo "'yay' başarıyla kuruldu."
else
  echo "'yay' zaten kurulu."
fi

# -----------------------------------------------------------------
# 3. Tüm Paketleri 'yay' ile Kur
# -----------------------------------------------------------------
echo "'packages.txt' dosyasındaki tüm paketler kuruluyor..."

# - < packages.txt : 'packages.txt' dosyasının içeriğini komuta standart girdi (stdin) olarak besler.
# --needed         : Sadece kurulu olmayan veya daha yeni sürümü olan paketleri kurar.
yay -Syu --needed - <packages.txt

echo "Tüm paketler başarıyla kuruldu veya güncellendi."
echo "Kurulum tamamlandı!"
