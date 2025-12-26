#!/bin/bash
#
# ANA KURULUM SCRIPT'İ
# 1. Paketleri kurar (Pacman/Yay)
# 2. Flatpak'leri kurar (diğer script'i çağırır)
# 3. Dotfile'ları bağlar (stow)
# 4. Donanım ayarlarını yapar (diğer script'i çağırır)

# Hata durumunda script'i durdur
set -e

# --- Değişkenler ---
# Betiğin çalıştığı klasörü (yani ~/Documents/Dotfiles) bul
DOTFILES_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

echo "Ana Kurulum Script'i Başlıyor..."
echo "Dotfiles Dizini: $DOTFILES_DIR"

# -----------------------------------------------------------------
# 1. Gerekli Temel Paketler (git ve base-devel)
# -----------------------------------------------------------------
echo ":: 'git' ve 'base-devel' grubu kontrol ediliyor/kuruluyor..."
sudo pacman -Syu --needed git base-devel --noconfirm

# -----------------------------------------------------------------
# 2. 'yay' AUR Yardımcısını Kur
# -----------------------------------------------------------------
if ! command -v yay &>/dev/null; then
  echo ":: 'yay' bulunamadı. AUR'dan kuruluyor..."
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  (cd /tmp/yay && makepkg -si --noconfirm)
  rm -rf /tmp/yay
  echo ":: 'yay' başarıyla kuruldu."
else
  echo ":: 'yay' zaten kurulu."
fi

# -----------------------------------------------------------------
# 3. Tüm Paketleri 'yay' ile Kur
# -----------------------------------------------------------------
echo ":: 'packages.txt' dosyasındaki tüm paketler kuruluyor..."
# 'packages.txt' dosyasının tam yolunu belirtmek daha güvenlidir
yay -Syu --needed - <"$DOTFILES_DIR/packages.txt"
echo ":: Paket kurulumu tamamlandı."

# -----------------------------------------------------------------
# 4. MODÜL: Flatpak Paketlerini Kur
# -----------------------------------------------------------------
echo ":: 'install_flatpaks.sh' script'i çalıştırılıyor..."
# Diğer betiğe çalıştırma izni ver (gerekliyse)
chmod +x "$DOTFILES_DIR/install_flatpaks.sh"
# Çalıştır
"$DOTFILES_DIR/install_flatpaks.sh"
echo ":: Flatpak kurulumu tamamlandı."

# -----------------------------------------------------------------
# 5. MODÜL: 'stow' ile Dotfile'ları Bağla (En Önemli Adım)
# -----------------------------------------------------------------
echo ":: 'stow' ile dotfile'lar ana dizine bağlanıyor..."

# 'stow' paketinin kurulu olduğundan emin ol (packages.txt içinde olmalı,
# ama burada garantiye almak iyi bir pratiktir)
if ! command -v stow &>/dev/null; then
  echo "Uyarı: 'stow' kurulu değil. 'yay -S stow' ile kuruluyor..."
  yay -S --needed stow --noconfirm
fi

# 'stow' edilecek tüm paketlerin (klasörlerin) listesi
# Bu liste, Dotfiles klasöründeki alt-klasörlerinle eşleşmeli
STOW_PACKAGES=(
  "alacritty"
  "btop"
  "cava"
  "fastfetch"
  "fish"
  "foot"
  "fuzzel"
  "ghostty"
  "gtk"
  "hypr"
  "kitty"
  "Kvantum"
  "mpv"
  "niri"
  "nvim"
  "qt5ct"
  "qt6ct"
  "starship"
  "user-dirs"
  "wlogout"
  "zshrc.d"
)

# Betiğin bulunduğu (Dotfiles) dizine git
cd "$DOTFILES_DIR"

echo "  -> Şu paketler bağlanacak: ${STOW_PACKAGES[*]}"
# -R (Re-stow): Mevcut linkleri (varsa) kaldırır ve yeniden bağlar.
# -t (Target): Hedef dizin, yani senin home dizinin ($HOME)
stow -R -t "$HOME" "${STOW_PACKAGES[@]}"

echo ":: 'Stow' işlemi tamamlandı."

# -----------------------------------------------------------------
# 6. MODÜL: Donanım Ayarlarını Uygula
# -----------------------------------------------------------------
echo ":: 'setup_fkeys.sh' script'i çalıştırılıyor..."
chmod +x "$DOTFILES_DIR/setup_fkeys.sh"
# Bu betik 'sudo' komutları içeriyor, şifren zaten istendiği için sorunsuz çalışmalı.
"$DOTFILES_DIR/setup_fkeys.sh"
echo ":: F tuslari Donanım ayarları tamamlandı."

echo ":: 'setup_keychron.sh' script'i çalıştırılıyor..."
chmod +x "$DOTFILES_DIR/setup_keychron.sh"
# Bu betik 'sudo' komutları içeriyor, şifren zaten istendiği için sorunsuz çalışmalı.
"$DOTFILES_DIR/setup_keychron.sh"
echo ":: Keychron Klavye Donanım ayarları tamamlandı."

# -----------------------------------------------------------------
# 7. MODÜL: Yazilim Ayarlarını Uygula
# -----------------------------------------------------------------
echo ":: 'switch_to_iwd.sh' script'i çalıştırılıyor..."
chmod +x "$DOTFILES_DIR/switch_to_iwd.sh"
# Bu betik 'sudo' komutları içeriyor, şifren zaten istendiği için sorunsuz çalışmalı.
"$DOTFILES_DIR/switch_to_iwd"
echo ":: Oyunlarda Jitter azaltmak icin iwd gecisi tamamlandı."

echo ":: 'vivaldi_middle_click.sh' script'i çalıştırılıyor..."
chmod +x "$DOTFILES_DIR/vivaldi_middle_click.sh"
# Bu betik 'sudo' komutları içeriyor, şifren zaten istendiği için sorunsuz çalışmalı.
"$DOTFILES_DIR/vivaldi_middle_click.sh"
echo ":: Vivaldi de middle click kullanarak kaydirma aktif edildi."

echo "--------------------------------"
echo "🎉 TÜM KURULUM TAMAMLANDI! 🎉"
echo "Değişikliklerin tamamının etkili olması için sistemi yeniden başlatman gerekebilir."
