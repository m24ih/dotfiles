#!/usr/bin/env bash
# ==============================================================================
# Flatpak Paketlerini Kur ve Yapılandır
# ==============================================================================
# Bu betik, Flatpak'i kurar, Flathub deposunu ekler, belirtilen paketleri kurar
# ve GTK tema/simgeleri uygular.

set -e

# Başlangıç mesajı
echo ":: Flatpak kurulumu ve yapılandırması başlıyor..."

# Dizini bul
baseDir=$(dirname "$(realpath "$0")")
scrDir=$(dirname "$(dirname "$(realpath "$0")")")

# OS Tespiti
DETECTED_OS=""
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DETECTED_OS="$ID"
fi

# Paket kontrol ve yükleme fonksiyonları OS'e göre tanımlanır
is_pkg_installed() {
    local pkg_name="$1"
    case "$DETECTED_OS" in
        arch|manjaro|endeavouros|artix|cachyos)
            pacman -Q "$pkg_name" &>/dev/null
            ;;
        fedora|rhel|centos|rocky|almalinux)
            rpm -q "$pkg_name" &>/dev/null
            ;;
        ubuntu|debian|linuxmint|pop|elementary)
            dpkg -s "$pkg_name" &>/dev/null
            ;;
        *)
            # Bilinmeyen dağıtım için pacman kullanmayı dene (Arch-based varsayım)
            pacman -Q "$pkg_name" &>/dev/null
            ;;
    esac
}

install_package() {
    local pkg_name="$1"
    case "$DETECTED_OS" in
        arch|manjaro|endeavouros|artix|cachyos)
            sudo pacman -S --needed --noconfirm "$pkg_name"
            ;;
        fedora|rhel|centos|rocky|almalinux)
            sudo dnf install -y "$pkg_name"
            ;;
        ubuntu|debian|linuxmint|pop|elementary)
            sudo apt install -y "$pkg_name"
            ;;
        *)
            # Bilinmeyen dağıtım için pacman kullanmayı dene
            echo "Uyarı: Bilinmeyen dağıtım '$DETECTED_OS'. Pacman kullanmayı deniyorum..."
            sudo pacman -S --needed --noconfirm "$pkg_name"
            ;;
    esac
}

# Flatpak'in kurulu olup olmadığını kontrol et
if ! is_pkg_installed flatpak; then
    echo ":: Flatpak kurulu değil. Kuruluyor..."
    install_package flatpak
else
    echo ":: Flatpak zaten kurulu."
fi

# Flathub deposunu ekle
echo ":: Flathub deposu ekleniyor..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# flat_packages.txt dosyasından paket listesini al
if [ -f "${baseDir}/flat_packages.txt" ]; then
    flats=$(awk -F '#' '{print $1}' "${baseDir}/flat_packages.txt" 2>/dev/null | sed 's/ //g' | xargs)
    if [ -n "${flats}" ]; then
        echo ":: Flatpak paketleri kuruluyor: $flats"
        flatpak install -y flathub ${flats}
    else
        echo ":: flat_packages.txt dosyasında paket bulunamadı veya boş."
    fi
else
    echo ":: Uyarı: flat_packages.txt dosyası bulunamadı. Paket kurulumu atlanıyor."
fi

# Kullanılmayan Flatpak paketlerini kaldır
echo ":: Kullanılmayan Flatpak paketleri kaldırılıyor..."
flatpak remove --unused -y

# GTK tema ve simge ayarlarını Flatpak uygulama için dışa aktar
echo ":: GTK tema ve simge ayarları yapılandırılıyor..."
gtkTheme=$(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null | sed "s/'//g")
gtkIcon=$(gsettings get org.gnome.desktop.interface icon-theme 2>/dev/null | sed "s/'//g")

# Temel dizinlere erişim izni ver
flatpak --user override --filesystem=~/.themes
flatpak --user override --filesystem=~/.icons
flatpak --user override --filesystem=~/.local/share/themes
flatpak --user override --filesystem=~/.local/share/icons

# GTK tema ve simge çevresel değişkenlerini ayarla (если são definidos)
if [ -n "${gtkTheme}" ]; then
    flatpak --user override --env=GTK_THEME=${gtkTheme}
    echo "  -> GTK_THEME ayarlandı: ${gtkTheme}"
fi
if [ -n "${gtkIcon}" ]; then
    flatpak --user override --env=ICON_THEME=${gtkIcon}
    echo "  -> ICON_THEME ayarlandı: ${gtkIcon}"
fi

echo ":: Flatpak kurulumu ve yapılandırması tamamlandı!"
