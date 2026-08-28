#!/bin/bash
#
# migrate_dotfiles.sh
# Mevcut .config dosyalarını Dotfiles klasörüne taşır ve "stow" ile bağlar.
# Sadece BİR KEZ çalıştırılmalıdır.

# --- Değişkenler ---
# Dotfiles klasörünün yolu
DOTFILES_DIR="$HOME/Documents/Dotfiles"
# Yapılandırma dosyalarının (config) ana dizini
CONFIG_DIR="$HOME/.config"

# --- Kategori 1: Standart Klasörler ---
# ~/.config/klasor şeklinde olanlar
STOW_FOLDERS=(
  "btop"
  "fastfetch"
  "fish"
  "ghostty"
  "hypr"
  "kitty"
  "mango"
  "niri"
  "nvim"
  "sunshine"
  "systemd"
  "vivaldi"
  "zshrc.d"
)

# --- Kategori 2: Tekil Dosyalar ---
# ~/.config/dosya.conf şeklinde olanlar
STOW_FILES=(
  "starship.toml"
  "user-dirs.dirs"
)

# --- Kategori 3: Gruplanmış Paketler (GTK) ---
STOW_GROUP_GTK=(
  "gtk-3.0"
  "gtk-4.0"
  "gtkrc"
  "gtkrc-2.0"
)

# --- İşlem Başlangıcı ---
echo "Dotfiles taşıma ve 'stow' işlemi başlıyor..."
echo "Dotfiles Dizinim: $DOTFILES_DIR"
echo "Hedef Dizinim: $HOME"
echo "--------------------------------"
cd "$DOTFILES_DIR" || exit

# --- Kategori 1 İşlemi ---
echo "📦 Kategori 1: Klasörler işleniyor..."
for pkg in "${STOW_FOLDERS[@]}"; do
  echo "  -> İşleniyor: $pkg"
  # Eğer kaynak dosya yoksa atla
  if [ ! -d "$CONFIG_DIR/$pkg" ]; then
    echo "     Uyarı: $CONFIG_DIR/$pkg bulunamadı, atlanıyor."
    continue
  fi

  # 1. Stow paket yapısını oluştur
  mkdir -p "$DOTFILES_DIR/$pkg/.config"
  # 2. Mevcut yapılandırmayı taşı
  mv "$CONFIG_DIR/$pkg" "$DOTFILES_DIR/$pkg/.config/"
  # 3. Stow et
  stow -R -t "$HOME" "$pkg"
  echo "     Başarılı: $pkg taşındı ve bağlandı."
done

# --- Kategori 2 İşlemi ---
echo "📄 Kategori 2: Tekil dosyalar işleniyor..."
for file in "${STOW_FILES[@]}"; do
  # starship.toml -> paket adı "starship"
  pkg_name=$(basename "$file" .toml | sed 's/\.dirs$//')
  echo "  -> İşleniyor: $file (Paket: $pkg_name)"

  if [ ! -f "$CONFIG_DIR/$file" ]; then
    echo "     Uyarı: $CONFIG_DIR/$file bulunamadı, atlanıyor."
    continue
  fi

  # 1. Stow paket yapısını oluştur
  mkdir -p "$DOTFILES_DIR/$pkg_name/.config"
  # 2. Mevcut dosyayı taşı
  mv "$CONFIG_DIR/$file" "$DOTFILES_DIR/$pkg_name/.config/"
  # 3. Stow et
  stow -R -t "$HOME" "$pkg_name"
  echo "     Başarılı: $file taşındı ve bağlandı."
done

# --- Kategori 3 İşlemi ---
echo "🎨 Kategori 3: Gruplanmış paket (GTK) işleniyor..."
pkg_name="gtk"
mkdir -p "$DOTFILES_DIR/$pkg_name/.config"
moved_count=0

for item in "${STOW_GROUP_GTK[@]}"; do
  if [ -e "$CONFIG_DIR/$item" ]; then # -e hem dosya hem klasörü kontrol eder
    mv "$CONFIG_DIR/$item" "$DOTFILES_DIR/$pkg_name/.config/"
    ((moved_count++))
  fi
done

if [ $moved_count -gt 0 ]; then
  stow -t "$HOME" "$pkg_name"
  echo "     Başarılı: $moved_count adet GTK yapılandırması taşındı ve bağlandı."
else
  echo "     Uyarı: Taşınacak GTK yapılandırması bulunamadı."
fi

echo "--------------------------------"
echo "✅ Tüm işlemler tamamlandı!"
