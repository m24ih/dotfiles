#!/bin/bash
#
# ANA KURULUM SCRIPT'İ
# Daha modüler ve yapılandırılabilir hale getirilmiştir.
# Her bölüm bağımsız fonksiyon olarak tanımlanmıştır ve
# komut satırı argümanlarıyla seçively çalıştırılabilir.
# Çeşitli Linux dağıtımlarını destekler (Arch-based ve Fedora-based)

# Hata durumunda script'i durdur
set -e

# --- Değişkenler ---
# Betiğin çalıştığı klasörü (yani ~/Documents/Dotfiles) bul
DOTFILES_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# OS Tespiti
DETECTED_OS=""
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DETECTED_OS="$ID"
fi

# Başlangıç mesajı
print_header() {
    echo "================================================================"
    echo "Ana Kurulum Script'i Başlıyor..."
    echo "Dotfiles Dizini: $DOTFILES_DIR"
    echo "================================================================"
}

# Sub-script çalıştırma yardımcısı:
# Hata alsa bile ana script'in durmasını engeller ve sudo gerektiren betikleri güvenle çağırır.
run_script() {
    local script_path="$1"
    shift
    chmod +x "$script_path" 2>/dev/null || true

    if [ "$1" = "sudo" ]; then
        shift
        if sudo "$script_path" "$@"; then
            return 0
        else
            echo "⚠️ UYARI: $(basename "$script_path") çalıştırılırken bir hata oluştu veya iptal edildi. Kurulum devam ediyor..."
            return 0
        fi
    else
        if "$script_path" "$@"; then
            return 0
        else
            echo "⚠️ UYARI: $(basename "$script_path") çalıştırılırken bir hata oluştu. Kurulum devam ediyor..."
            return 0
        fi
    fi
}

# Bölüm başlıkları yazdırma fonksiyonu
print_section() {
    echo -e "\n:: $1"
    echo ":: $(printf '=%.0s' {1..${#1}})"
}

# -----------------------------------------------------------------
# 1. Gerekli Temel Paketler (git ve base-devel)
# -----------------------------------------------------------------
install_base_packages() {
    print_section "'git' ve 'base-devel' grubu kontrol ediliyor/kuruluyor..."
    case "$DETECTED_OS" in
        arch|manjaro|endeavouros|artix|cachyos)
            sudo pacman -Syu --needed git base-devel --noconfirm
            ;;
        fedora|rhel|centos|rocky|almalinux)
            sudo dnf install -y git @development-tools
            ;;
        ubuntu|debian|linuxmint|pop|elementary)
            sudo apt update
            sudo apt install -y git build-essential
            ;;
        *)
            echo "Desteklenmeyen dağıtım: $DETECTED_OS. Arch-based paket yöneticisi kullanılıyor."
            sudo pacman -Syu --needed git base-devel --noconfirm
            ;;
    esac
}

# -----------------------------------------------------------------
# 2. Dağıtım Özel Paket Yöneticisini Kur
# -----------------------------------------------------------------
install_package_manager() {
    print_section "Dağıtım Özel Paket Yöneticisini Kur"

    case "$DETECTED_OS" in
        arch|manjaro|endeavouros|artix|cachyos)
            # Arch-based: yay (AUR helper)
            if ! command -v yay &>/dev/null; then
                echo ":: 'yay' bulunamadı. AUR'dan kuruluyor..."
                git clone https://aur.archlinux.org/yay.git /tmp/yay
                (cd /tmp/yay && makepkg -si --noconfirm)
                rm -rf /tmp/yay
                echo ":: 'yay' başarıyla kuruldu."
            else
                echo ":: 'yay' zaten kurulu."
            fi
            ;;
        fedora|rhel|centos|rocky|almalinux)
            # Fedora-based: dnf is already installed, but we can add copr if needed
            echo ":: Fedora tabanlı sistemde dnf zaten mevcut."
            # Optionally enable RPM Fusion or other repos if needed
            ;;
        ubuntu|debian|linuxmint|pop|elementary)
            # Debian-based: apt is already installed
            echo ":: Debian tabanlı sistemde apt zaten mevcut."
            ;;
        *)
            echo "Bilinmeyen dağıtım: $DETECTED_OS. Yay kurulmayı deniyor."
            if ! command -v yay &>/dev/null; then
                git clone https://aur.archlinux.org/yay.git /tmp/yay
                (cd /tmp/yay && makepkg -si --noconfirm)
                rm -rf /tmp/yay
            fi
            ;;
    esac
}

# -----------------------------------------------------------------
# 3. Tüm Paketleri 'yay' ile Kur
# -----------------------------------------------------------------
install_all_packages() {
    print_section "'packages.txt' dosyasındaki tüm paketler kuruluyor..."
    yay -Syu --needed - <"$DOTFILES_DIR/packages.txt"
    echo ":: Paket kurulumu tamamlandı."
}

# -----------------------------------------------------------------
# 4. MODÜL: Flatpak Paketlerini Kur
# -----------------------------------------------------------------
install_flatpaks() {
    print_section "'install_flatpaks.sh' script'i çalıştırılıyor..."
    run_script "$DOTFILES_DIR/install_flatpaks.sh"
    echo ":: Flatpak kurulum adımı tamamlandı."
}

# -----------------------------------------------------------------
# 5. MODÜL: 'stow' ile Dotfile'ları Bağla (En Önemli Adım)
# -----------------------------------------------------------------
link_dotfiles() {
    print_section "'stow' ile dotfile'lar ana dizine bağlanıyor..."

    # 'stow' paketinin kurulu olduğundan emin ol
    if ! command -v stow &>/dev/null; then
        echo "Uyarı: 'stow' kurulu değil. 'yay -S stow' ile kuruluyor..."
        yay -S --needed stow --noconfirm
    fi

    # 'stow' edilecek tüm paketlerin (klasörlerin) listesi
    STOW_PACKAGES=(
        "alacritty"
        "btop"
        "cava"
        "fastfetch"
        "fish"
        "foot"
        "fuzzel"
        "ghostty"
        "hypr"
        "kitty"
        "Kvantum"
        "mango"
        "mpv"
        "niri"
        "nvim"
        "quickshell"
        "ssh"
        "starship"
        "systemd"
        "user-dirs"
        "vivaldi"
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

    # Fastfetch OS logosunu mevcut sisteme göre bağla
    if [ -f "$DOTFILES_DIR/fastfetch/.config/fastfetch/update-logo.sh" ]; then
        bash "$DOTFILES_DIR/fastfetch/.config/fastfetch/update-logo.sh" "$HOME/.config/fastfetch/logo"
    fi

    # Servisleri başlat
    systemctl --user enable vicinae --now
    systemctl --user daemon-reload
    systemctl --user enable --now proton-pass-ssh-agent.service
}

# -----------------------------------------------------------------
# 6. MODÜL: Donanım Ayarlarını Uygula
# -----------------------------------------------------------------
apply_hardware_settings() {
    print_section "'setup_fkeys.sh' script'i çalıştırılıyor..."
    run_script "$DOTFILES_DIR/setup_fkeys.sh" sudo
    echo ":: F tuslari Donanım ayarları tamamlandı."

    echo ":: 'setup_keychron.sh' script'i çalıştırılıyor..."
    run_script "$DOTFILES_DIR/setup_keychron.sh" sudo
    echo ":: Keychron Klavye Donanım ayarları tamamlandı."
}

# -----------------------------------------------------------------
# 7. MODÜL: Ağ ve Ağ Sürücü Ayarlarını Uygula
# -----------------------------------------------------------------
apply_network_settings() {
    print_section "'switch_to_iwd.sh' script'i çalıştırılıyor..."
    run_script "$DOTFILES_DIR/switch_to_iwd.sh" sudo
    echo ":: Oyunlarda Jitter azaltmak icin iwd gecisi tamamlandı."

    echo ":: 'vivaldi_middle_click.sh' script'i çalıştırılıyor..."
    run_script "$DOTFILES_DIR/vivaldi_middle_click.sh"
    echo ":: Vivaldi de middle click kullanarak kaydirma aktif edildi."
}

# -----------------------------------------------------------------
# 8. MODÜL: Discord Proxy ve Güvenli Erişim Ayarları
# -----------------------------------------------------------------
apply_discord_settings() {
    print_section "'setup_discord_proxy.sh' script'i çalıştırılıyor..."
    run_script "$DOTFILES_DIR/setup_discord_proxy.sh"
    echo ":: Digital Ocean Amsterdam Serverina proxy ile baglanildi."
    echo ":: Artik discord-secure yazarak veya discord iconuna tiklayarak girebilirsin"
}

# -----------------------------------------------------------------
# 9. MODÜL: Sistem ve Kullanıcı Servislerini Otomatik Etkinleştirme
# -----------------------------------------------------------------
configure_services() {
    print_section "'setup_services.sh' script'i çalıştırılıyor..."
    run_script "$DOTFILES_DIR/setup_services.sh"
    echo ":: Sistem ve Kullanıcı Servisleri başarıyla yapılandırıldı."
}

# -----------------------------------------------------------------
# 10. MODÜL: UFW Güvenlik Duvarı Kurallarını Uygula
# -----------------------------------------------------------------
apply_ufw_rules() {
    print_section "'setup_ufw.sh' script'i çalıştırılıyor..."
    run_script "$DOTFILES_DIR/setup_ufw.sh" sudo
    echo ":: UFW güvenlik duvarı kuralları uygulandı."
}

# -----------------------------------------------------------------
# 11. MODÜL: Cloudflare WARP Split Tunnel Kurallarını Uygula
# -----------------------------------------------------------------
apply_warp_settings() {
    print_section "'setup_warp.sh' script'i çalıştırılıyor..."
    run_script "$DOTFILES_DIR/setup_warp.sh"
    echo ":: WARP Split Tunnel kuralları uygulandı."
}

# -----------------------------------------------------------------
# 12. MODÜL: Font Kurulumu
# -----------------------------------------------------------------
install_fonts() {
    print_section "Font kurulumu ve yapılandırması..."
    run_script "$DOTFILES_DIR/setup_fonts.sh"
    echo ":: Font kurulumu tamamlandı."
}

# -----------------------------------------------------------------

# -----------------------------------------------------------------
# Ana fonksiyon - tüm bölümleri sırayla çalıştırır
# -----------------------------------------------------------------
main() {
    print_header

    # Komut satırı argümanları kontrolü
    # Eğer belirli bölümler verildiyse sadece onları çalıştır, yoksa tümünü çalıştır
    if [ $# -eq 0 ]; then
        # Varsayılan: tüm bölümleri çalıştır
        install_base_packages
        install_package_manager
        install_all_packages
        install_flatpaks
        link_dotfiles
        apply_hardware_settings
        apply_network_settings
        apply_discord_settings
        configure_services
        apply_ufw_rules
        apply_warp_settings
        install_fonts
    else
        # Belirtilen bölümleri çalıştır
        for section in "$@"; do
            case "$section" in
                base|packages) install_base_packages ;;
                package-manager|pm) install_package_manager ;;
                all) install_all_packages ;;
                flatpak) install_flatpaks ;;
                stow|dotfiles) link_dotfiles ;;
                hardware) apply_hardware_settings ;;
                network) apply_network_settings ;;
                discord) apply_discord_settings ;;
                services) configure_services ;;
                ufw) apply_ufw_rules ;;
                warp) apply_warp_settings ;;
                fonts) install_fonts ;;
                *) echo "Bilinmeyen bölüm: $section" ;;
            esac
        done
    fi

    echo "--------------------------------"
    echo "🎉 TÜM KURULUM TAMAMLANDI! 🎉"
    echo "Değişikliklerin tamamının etkili olması için sistemi yeniden başlatman gerekebilir."
}

# Script doğrudan çalıştırılıyorsa main fonksiyonunu çağır
# (Bu, fonksiyonların sourcing'ini izin verir ancak otomatik çalıştırmamış olur)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi