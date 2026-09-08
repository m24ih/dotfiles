#!/bin/bash
#
# ANA KURULUM SCRIPT'İ
# Daha modüler ve yapılandırılabilir hale getirilmiştir.
# Her bölüm bağımsız fonksiyon olarak tanımlanmıştır ve
# komut satırı argümanlarıyla seçively çalıştırılabilir.
# Çeşitli Linux dağıtımlarını destekler (Arch-based, Fedora-based ve Debian-based)

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

# ANSI Renk Tanımlamaları
BOLD='\033[1m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# -----------------------------------------------------------------
# Bileşen Kaydı (Component Registry)
# -----------------------------------------------------------------
ALL_MODULES=(
    hypr
    niri
    mango
    ghostty
    kitty
    fish
    nvim
    base_cli
    browser
    social
    dev
    productivity
    media
    networking
    sunshine
    flatpak
    hardware
    keychron
    fkeys
    iwd
    services
    fonts
)

DEFAULT_MODULES=(
    ghostty
    fish
    nvim
    base_cli
    browser
    social
    dev
    productivity
    media
    networking
    services
    fonts
)

SELECTED_MODULES=()

contains_element() {
    local match="$1"
    shift
    local e
    for e in "$@"; do
        [ "$e" = "$match" ] && return 0
    done
    return 1
}

get_module_title() {
    case "$1" in
        hypr)         echo "Hyprland Pencere Yöneticisi" ;;
        niri)         echo "Niri Pencere Yöneticisi" ;;
        mango)        echo "MangoWM Pencere Yöneticisi" ;;
        ghostty)      echo "Ghostty Terminal Emülatörü" ;;
        kitty)        echo "Kitty Terminal Emülatörü" ;;
        fish)         echo "Fish Kabuğu & Starship Prompt" ;;
        nvim)         echo "Neovim Editör" ;;
        base_cli)     echo "Temel CLI Araçları" ;;
        browser)      echo "Vivaldi Tarayıcı" ;;
        social)       echo "İletişim & Sosyal (Vesktop, Telegram, Signal)" ;;
        dev)          echo "Geliştirici Araçları (VS Code, Docker, DBeaver)" ;;
        productivity) echo "Üretkenlik Araçları (Obsidian, Proton Pass)" ;;
        media)        echo "Medya & İndirme (Haruna, OBS, qBittorrent)" ;;
        networking)   echo "Ağ & VPN (Tailscale, WARP, Syncthing)" ;;
        sunshine)     echo "Sunshine GameStream" ;;
        flatpak)      echo "Flatpak Paketleri" ;;
        hardware)     echo "Donanım & Güç Yönetimi (TLP/UFW)" ;;
        keychron)     echo "Keychron Klavye Ayarları" ;;
        fkeys)        echo "Apple F-Tuşları Modu" ;;
        iwd)          echo "Wi-Fi iwd Optimizasyonu" ;;
        services)     echo "Sistem ve Kullanıcı Servisleri" ;;
        fonts)        echo "Nerd Fontlar" ;;
        *)            echo "$1" ;;
    esac
}

get_module_package_file() {
    case "$1" in
        hypr)         echo "packages/hypr.txt" ;;
        niri)         echo "packages/niri.txt" ;;
        mango)        echo "packages/mango.txt" ;;
        ghostty)      echo "packages/ghostty.txt" ;;
        kitty)        echo "packages/kitty.txt" ;;
        fish)         echo "packages/fish.txt" ;;
        nvim)         echo "packages/nvim.txt" ;;
        base_cli)     echo "packages/base_cli.txt" ;;
        browser)      echo "packages/browser.txt" ;;
        social)       echo "packages/social.txt" ;;
        dev)          echo "packages/dev.txt" ;;
        productivity) echo "packages/productivity.txt" ;;
        media)        echo "packages/media.txt" ;;
        networking)   echo "packages/networking.txt" ;;
        sunshine)     echo "packages/sunshine.txt" ;;
        flatpak)      echo "flat_packages.txt" ;;
        hardware)     echo "packages/hardware.txt" ;;
        *)            echo "" ;;
    esac
}

get_module_stow_packages() {
    case "$1" in
        hypr)         echo "hypr" ;;
        niri)         echo "niri" ;;
        mango)        echo "mango" ;;
        ghostty)      echo "ghostty" ;;
        kitty)        echo "kitty" ;;
        fish)         echo "fish starship" ;;
        nvim)         echo "nvim" ;;
        base_cli)     echo "btop fastfetch user-dirs" ;;
        browser)      echo "vivaldi" ;;
        networking)   echo "ssh" ;;
        sunshine)     echo "sunshine" ;;
        services)     echo "systemd" ;;
        *)            echo "" ;;
    esac
}

get_module_scripts() {
    case "$1" in
        browser)      echo "scripts/vivaldi_middle_click.sh" ;;
        social)       echo "scripts/setup_discord_proxy.sh" ;;
        dev)          echo "scripts/setup_npm.sh" ;;
        productivity) echo "scripts/setup_1password.sh" ;;
        networking)   echo "scripts/setup_warp.sh scripts/setup_sshd.sh" ;;
        sunshine)     echo "scripts/setup_ufw.sh" ;;
        flatpak)      echo "scripts/install_flatpaks.sh" ;;
        hardware)     echo "scripts/setup_ufw.sh" ;;
        keychron)     echo "scripts/setup_keychron.sh" ;;
        fkeys)        echo "scripts/setup_fkeys.sh" ;;
        iwd)          echo "scripts/switch_to_iwd.sh" ;;
        services)     echo "scripts/setup_services.sh" ;;
        fonts)        echo "scripts/setup_fonts.sh" ;;
        *)            echo "" ;;
    esac
}

is_sudo_script() {
    case "$1" in
        *setup_fkeys.sh|*setup_keychron.sh|*switch_to_iwd.sh|*setup_ufw.sh|*setup_1password.sh)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# -----------------------------------------------------------------
# UI & Yardımcı Fonksiyonlar
# -----------------------------------------------------------------
print_header() {
    if [ -t 0 ] && [ -t 1 ]; then
        clear 2>/dev/null || true
    fi
    echo -e "${CYAN}"
    cat << "EOF"
  __  __      _ _ _     _       ____        _   __ _ _           
 |  \/  |    | (_) |   ( )     |  _ \  ___ | |_/ _(_) | ___  ___ 
 | |\/| | ___| |_| |__  \| ___ | | | |/ _ \| __| |_| | |/ _ \/ __|
 | |  | |/ _ \ | | '_ \   / __|| |_| | (_) | |_|  _| | |  __/\__ \
 |_|  |_|\___/_|_|_| |_|  \___||____/ \___/ \__|_| |_|_|\___||___/
EOF
    echo -e "${PURPLE}       :: Melih's Dotfiles Installer (JaKooLit Tarzı) ::${NC}"
    echo -e "${BLUE}  Dotfiles Dizini  :${NC} $DOTFILES_DIR"
    echo -e "${BLUE}  Tespit Edilen OS :${NC} ${DETECTED_OS:-Bilinmiyor}"
    echo -e "${CYAN}================================================================${NC}\n"
}

print_section() {
    echo -e "\n${BLUE}:: ${BOLD}$1${NC}"
    echo -e "${BLUE}:: $(printf '=%.0s' $(seq 1 ${#1}))${NC}"
}

print_category() {
    local cat_num="$1"
    local cat_title="$2"
    echo -e "\n${PURPLE}┌──────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${PURPLE}│${NC} ${BOLD}${CYAN}[Kategori ${cat_num}]${NC} ${BOLD}${cat_title}${NC}"
    echo -e "${PURPLE}└──────────────────────────────────────────────────────────────┘${NC}"
}

ask_yn() {
    local prompt="$1"
    local default="$2" # "Y" veya "N"
    local prompt_suffix="[Y/n]"
    if [ "$default" = "N" ]; then
        prompt_suffix="[y/N]"
    fi
    local response
    read -r -p "$(echo -e "${CYAN}?${NC} ${prompt} ${YELLOW}${prompt_suffix}${NC}: ")" response
    response="${response:-$default}"
    case "$response" in
        [yY]|[yY][eE][sS]) return 0 ;;
        *) return 1 ;;
    esac
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
            echo -e "${YELLOW}⚠️ UYARI: $(basename "$script_path") çalıştırılırken bir hata oluştu veya iptal edildi. Kurulum devam ediyor...${NC}"
            return 0
        fi
    else
        if "$script_path" "$@"; then
            return 0
        else
            echo -e "${YELLOW}⚠️ UYARI: $(basename "$script_path") çalıştırılırken bir hata oluştu. Kurulum devam ediyor...${NC}"
            return 0
        fi
    fi
}

# -----------------------------------------------------------------
# İnteraktif Soru Motoru (Wizard)
# -----------------------------------------------------------------
run_wizard() {
    SELECTED_MODULES=()
    echo -e "${BOLD}${YELLOW}İnteraktif Kurulum Sihirbazına Hoş Geldiniz!${NC}"
    echo -e "Lütfen her bileşen için seçiminizi yapın (Enter = varsayılan değer).\n"

    # Kategori 1: Masaüstü & Pencere Yöneticileri (Compositors)
    print_category "1" "Masaüstü & Pencere Yöneticileri (Compositors)"
    if ask_yn "Hyprland dinamik döşemeli Wayland pencere yöneticisi kurulsun mu?" "N"; then
        SELECTED_MODULES+=("hypr")
    fi
    if ask_yn "Niri kaydırmalı (scrollable-tiling) pencere yöneticisi kurulsun mu?" "N"; then
        SELECTED_MODULES+=("niri")
    fi
    if ask_yn "MangoWM hafif pencere yöneticisi kurulsun mu?" "N"; then
        SELECTED_MODULES+=("mango")
    fi

    # Kategori 2: Terminal Emülatörleri
    print_category "2" "Terminal Emülatörleri"
    if ask_yn "Ghostty modern GPU hızlandırmalı terminal kurulsun mu?" "Y"; then
        SELECTED_MODULES+=("ghostty")
    fi
    if ask_yn "Kitty GPU hızlandırmalı terminal kurulsun mu?" "N"; then
        SELECTED_MODULES+=("kitty")
    fi

    # Kategori 3: Kabuk, Editör & Temel CLI
    print_category "3" "Kabuk, Editör & Temel CLI"
    if ask_yn "Fish kabuğu ve Starship prompt kurulsun mu?" "Y"; then
        SELECTED_MODULES+=("fish")
    fi
    if ask_yn "Neovim modern metin editörü kurulsun mu?" "Y"; then
        SELECTED_MODULES+=("nvim")
    fi
    if ask_yn "Temel CLI araçları (bat, zoxide, btop, fastfetch vb.) kurulsun mu?" "Y"; then
        SELECTED_MODULES+=("base_cli")
    fi

    # Kategori 4: Uygulamalar & Üretkenlik
    print_category "4" "Uygulamalar & Üretkenlik"
    if ask_yn "Vivaldi internet tarayıcısı kurulsun mu?" "Y"; then
        SELECTED_MODULES+=("browser")
    fi
    if ask_yn "İletişim & Sosyal uygulamaları (Vesktop, Telegram, Signal) kurulsun mu?" "Y"; then
        SELECTED_MODULES+=("social")
    fi
    if ask_yn "Geliştirici araçları (VS Code, Docker, DBeaver) kurulsun mu?" "Y"; then
        SELECTED_MODULES+=("dev")
    fi
    if ask_yn "Üretkenlik araçları (Obsidian, Proton Pass) kurulsun mu?" "Y"; then
        SELECTED_MODULES+=("productivity")
    fi
    if ask_yn "Medya & İndirme araçları (Haruna, OBS, qBittorrent) kurulsun mu?" "Y"; then
        SELECTED_MODULES+=("media")
    fi
    if ask_yn "Ağ & VPN araçları (Tailscale, WARP, Syncthing) kurulsun mu?" "Y"; then
        SELECTED_MODULES+=("networking")
    fi
    if ask_yn "Sunshine GameStream sunucusu kurulsun mu?" "N"; then
        SELECTED_MODULES+=("sunshine")
    fi
    if ask_yn "Flatpak paketleri kurulsun mu?" "N"; then
        SELECTED_MODULES+=("flatpak")
    fi

    # Kategori 5: Donanım & Sistem Ayarları
    print_category "5" "Donanım & Sistem Ayarları"
    if ask_yn "Donanım & Güç Yönetimi (TLP) ve UFW güvenlik duvarı kurulsun mu?" "N"; then
        SELECTED_MODULES+=("hardware")
    fi
    if ask_yn "Keychron klavye ayarları uygulansın mı?" "N"; then
        SELECTED_MODULES+=("keychron")
    fi
    if ask_yn "Apple F-Tuşları modu (fonksiyon tuşları varsayılan) uygulansın mı?" "N"; then
        SELECTED_MODULES+=("fkeys")
    fi
    if ask_yn "Wi-Fi iwd optimizasyonu (jitter azaltma) uygulansın mı?" "N"; then
        SELECTED_MODULES+=("iwd")
    fi
    if ask_yn "Sistem ve kullanıcı servisleri yapılandırılsın mı?" "Y"; then
        SELECTED_MODULES+=("services")
    fi
    if ask_yn "Nerd Fontlar ve font yapılandırması kurulsun mu?" "Y"; then
        SELECTED_MODULES+=("fonts")
    fi
}

# -----------------------------------------------------------------
# Onay Özeti (Summary Box)
# -----------------------------------------------------------------
show_summary_and_confirm() {
    local selected_pkgs=()
    local selected_stow=()
    local selected_scripts=()

    # Zorunlu temel paket dosyası
    selected_pkgs+=("packages/base.txt (Temel Sistem Paketleri)")

    for mod in "${SELECTED_MODULES[@]}"; do
        local pkg_file
        pkg_file=$(get_module_package_file "$mod")
        if [ -n "$pkg_file" ]; then
            selected_pkgs+=("$pkg_file ($(get_module_title "$mod"))")
        fi

        local stow_pkgs
        stow_pkgs=$(get_module_stow_packages "$mod")
        for sp in $stow_pkgs; do
            if ! contains_element "$sp" "${selected_stow[@]}"; then
                selected_stow+=("$sp")
            fi
        done

        local scripts
        scripts=$(get_module_scripts "$mod")
        for sc in $scripts; do
            if ! contains_element "$sc" "${selected_scripts[@]}"; then
                selected_scripts+=("$sc")
            fi
        done
    done

    echo -e "\n${CYAN}================================================================${NC}"
    echo -e "${BOLD}${PURPLE}📋 SEÇİLEN KURULUM PLANI (ÖZET)${NC}"
    echo -e "${CYAN}================================================================${NC}"

    echo -e "\n${BOLD}${GREEN}📦 Kurulacak Paket Listeleri (packages/*.txt):${NC}"
    if [ ${#selected_pkgs[@]} -eq 0 ]; then
        echo -e "   ${YELLOW}(Hiçbiri seçilmedi)${NC}"
    else
        for p in "${selected_pkgs[@]}"; do
            echo -e "   ${CYAN}•${NC} $p"
        done
    fi

    echo -e "\n${BOLD}${BLUE}🔗 Bağlanacak Dotfiles Paketleri (Stow):${NC}"
    if [ ${#selected_stow[@]} -eq 0 ]; then
        echo -e "   ${YELLOW}(Hiçbiri seçilmedi)${NC}"
    else
        echo -e "   ${CYAN}•${NC} ${selected_stow[*]}"
    fi

    echo -e "\n${BOLD}${YELLOW}⚙️  Çalıştırılacak Sistem & Yapılandırma Betikleri:${NC}"
    if [ ${#selected_scripts[@]} -eq 0 ]; then
        echo -e "   ${YELLOW}(Hiçbiri seçilmedi)${NC}"
    else
        for s in "${selected_scripts[@]}"; do
            echo -e "   ${CYAN}•${NC} $s"
        done
    fi

    echo -e "\n${CYAN}================================================================${NC}\n"

    if ask_yn "Kuruluma başlansın mı?" "Y"; then
        echo -e "\n${GREEN}✅ Kuruluma başlanıyor...${NC}\n"
        return 0
    else
        echo -e "\n${YELLOW}⚠️  Kurulum kullanıcı tarafından iptal edildi.${NC}\n"
        exit 0
    fi
}

# -----------------------------------------------------------------
# 1. Gerekli Temel Paketler (git ve base-devel)
# -----------------------------------------------------------------
install_base_packages() {
    print_section "'git' ve temel geliştirme paketleri kontrol ediliyor..."
    case "$DETECTED_OS" in
        arch|manjaro|endeavouros|artix|cachyos)
            sudo pacman -Syu --needed git base-devel stow --noconfirm
            ;;
        fedora|rhel|centos|rocky|almalinux)
            sudo dnf install -y git @development-tools stow
            ;;
        ubuntu|debian|linuxmint|pop|elementary)
            sudo apt update && sudo apt install -y git build-essential stow
            ;;
        *)
            echo "Desteklenmeyen dağıtım: $DETECTED_OS. pacman deneniyor..."
            sudo pacman -Syu --needed git base-devel stow --noconfirm 2>/dev/null || true
            ;;
    esac
}

# -----------------------------------------------------------------
# 2. Dağıtım Özel Paket Yöneticisini Kur
# -----------------------------------------------------------------
install_package_manager() {
    print_section "Paket Yöneticisi Kontrolü..."
    case "$DETECTED_OS" in
        arch|manjaro|endeavouros|artix|cachyos)
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
            echo ":: Fedora tabanlı sistemde dnf hazır."
            ;;
        ubuntu|debian|linuxmint|pop|elementary)
            echo ":: Debian tabanlı sistemde apt hazır."
            ;;
        *)
            echo ":: Dağıtım: $DETECTED_OS"
            ;;
    esac
}

# -----------------------------------------------------------------
# 3. Tüm Paketleri 'yay' ile Kur
# -----------------------------------------------------------------
install_all_packages() {
    print_section "Paketler kuruluyor..."
    case "$DETECTED_OS" in
        arch|manjaro|endeavouros|artix|cachyos)
            if [ -f "$DOTFILES_DIR/packages.txt" ]; then
                yay -Syu --needed - <"$DOTFILES_DIR/packages.txt"
            else
                echo "⚠️ 'packages.txt' bulunamadı. Modüler paket listeleri kullanılmalıdır."
            fi
            echo ":: Paket kurulumu tamamlandı."
            ;;
        *)
            echo "⚠️ Paketler Arch Linux / pacman formatındadır. Farklı bir dağıtımda olduğunuz için paket kurulum adımı atlanıyor."
            ;;
    esac
}

# -----------------------------------------------------------------
# 4. MODÜL: Flatpak Paketlerini Kur
# -----------------------------------------------------------------
install_flatpaks() {
    print_section "'install_flatpaks.sh' script'i çalıştırılıyor..."
    run_script "$DOTFILES_DIR/scripts/install_flatpaks.sh"
    echo ":: Flatpak kurulum adımı tamamlandı."
}

# -----------------------------------------------------------------
# 5. MODÜL: 'stow' ile Dotfile'ları Bağla (En Önemli Adım)
# -----------------------------------------------------------------
link_dotfiles() {
    print_section "'stow' ile dotfile'lar ana dizine bağlanıyor..."
    run_script "$DOTFILES_DIR/stow_all.sh"
    echo ":: 'Stow' işlemi tamamlandı."
}

# -----------------------------------------------------------------
# 6. MODÜL: Donanım Ayarlarını Uygula
# -----------------------------------------------------------------
apply_hardware_settings() {
    print_section "'setup_fkeys.sh' script'i çalıştırılıyor..."
    run_script "$DOTFILES_DIR/scripts/setup_fkeys.sh" sudo
    echo ":: F tuslari Donanım ayarları tamamlandı."

    echo ":: 'setup_keychron.sh' script'i çalıştırılıyor..."
    run_script "$DOTFILES_DIR/scripts/setup_keychron.sh" sudo
    echo ":: Keychron Klavye Donanım ayarları tamamlandı."
}

# -----------------------------------------------------------------
# 7. MODÜL: Ağ ve Ağ Sürücü Ayarlarını Uygula
# -----------------------------------------------------------------
apply_network_settings() {
    print_section "'switch_to_iwd.sh' script'i çalıştırılıyor..."
    run_script "$DOTFILES_DIR/scripts/switch_to_iwd.sh" sudo
    echo ":: Oyunlarda Jitter azaltmak icin iwd gecisi tamamlandı."

    echo ":: 'vivaldi_middle_click.sh' script'i çalıştırılıyor..."
    run_script "$DOTFILES_DIR/scripts/vivaldi_middle_click.sh"
    echo ":: Vivaldi de middle click kullanarak kaydirma aktif edildi."
}

# -----------------------------------------------------------------
# 8. MODÜL: Discord Proxy ve Güvenli Erişim Ayarları
# -----------------------------------------------------------------
apply_discord_settings() {
    print_section "'setup_discord_proxy.sh' script'i çalıştırılıyor..."
    run_script "$DOTFILES_DIR/scripts/setup_discord_proxy.sh"
    echo ":: Digital Ocean Amsterdam Serverina proxy ile baglanildi."
    echo ":: Artik discord-secure yazarak veya discord iconuna tiklayarak girebilirsin"
}

# -----------------------------------------------------------------
# 9. MODÜL: Sistem ve Kullanıcı Servislerini Otomatik Etkinleştirme
# -----------------------------------------------------------------
configure_services() {
    print_section "'setup_services.sh' script'i çalıştırılıyor..."
    run_script "$DOTFILES_DIR/scripts/setup_services.sh"
    echo ":: Sistem ve Kullanıcı Servisleri başarıyla yapılandırıldı."
}

# -----------------------------------------------------------------
# 10. MODÜL: UFW Güvenlik Duvarı Kurallarını Uygula
# -----------------------------------------------------------------
apply_ufw_rules() {
    print_section "'setup_ufw.sh' script'i çalıştırılıyor..."
    run_script "$DOTFILES_DIR/scripts/setup_ufw.sh" sudo
    echo ":: UFW güvenlik duvarı kuralları uygulandı."
}

# -----------------------------------------------------------------
# 11. MODÜL: Cloudflare WARP Split Tunnel Kurallarını Uygula
# -----------------------------------------------------------------
apply_warp_settings() {
    print_section "'setup_warp.sh' script'i çalıştırılıyor..."
    run_script "$DOTFILES_DIR/scripts/setup_warp.sh"
    echo ":: WARP Split Tunnel kuralları uygulandı."
}

# -----------------------------------------------------------------
# 12. MODÜL: Font Kurulumu
# -----------------------------------------------------------------
install_fonts() {
    print_section "Font kurulumu ve yapılandırması..."
    run_script "$DOTFILES_DIR/scripts/setup_fonts.sh"
    echo ":: Font kurulumu tamamlandı."
}

# -----------------------------------------------------------------
# 13. MODÜL: NPM Global Dizin Yapılandırması (Sudo'suz Kurulum)
# -----------------------------------------------------------------
configure_npm() {
    print_section "npm global dizin yapılandırması..."
    run_script "$DOTFILES_DIR/scripts/setup_npm.sh"
    echo ":: npm yapılandırması tamamlandı."
}

# -----------------------------------------------------------------
# 14. MODÜL: SSH Sunucusu Güvenlik Yapılandırması
# -----------------------------------------------------------------
apply_sshd_settings() {
    print_section "SSH Sunucusu (sshd) güvenlik kısıtlamaları uygulanıyor..."
    run_script "$DOTFILES_DIR/scripts/setup_sshd.sh"
    echo ":: SSH sunucusu güvenlik yapılandırması tamamlandı."
}

# -----------------------------------------------------------------
# 15. MODÜL: 1Password Özel Tarayıcı İzinleri Yapılandırması
# -----------------------------------------------------------------
apply_1password_settings() {
    print_section "1Password özel tarayıcı izinleri yapılandırılıyor..."
    run_script "$DOTFILES_DIR/scripts/setup_1password.sh" sudo
    echo ":: 1Password yapılandırması tamamlandı."
}

# -----------------------------------------------------------------
# Ana fonksiyon - sihirbazı veya belirtilen bölümleri çalıştırır
# -----------------------------------------------------------------
main() {
    print_header

    # Komut satırı argümanları kontrolü
    # Eğer argüman verilmediyse interaktif sihirbazı çalıştır
    if [ $# -eq 0 ]; then
        run_wizard
        show_summary_and_confirm
        echo -e "${GREEN}Kurulum planı onaylandı. (Yürütme motoru Task 4 ile bağlanacaktır.)${NC}"
        return 0
    else
        # Belirtilen bölümleri çalıştır (Task 4'te CLI ayrıştırıcı ile genişletilecek)
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
                npm) configure_npm ;;
                sshd|ssh) apply_sshd_settings ;;
                1password|onepassword) apply_1password_settings ;;
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