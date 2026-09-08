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
DRY_RUN=false

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

show_help() {
    echo -e "${BOLD}${CYAN}Melih's Dotfiles Installer${NC}"
    echo -e "Kullanım:"
    echo -e "  $0 [SEÇENEKLER] [MODÜLLER...]\n"
    echo -e "${BOLD}SEÇENEKLER:${NC}"
    echo -e "  ${GREEN}-n, --dry-run${NC}      Simülasyon modu. Hiçbir değişiklik yapmadan yapılacak işlemleri gösterir."
    echo -e "  ${GREEN}-d, --default${NC}      Soru sormadan varsayılan modülleri kurar."
    echo -e "  ${GREEN}-a, --all${NC}          Soru sormadan tüm modülleri kurar."
    echo -e "  ${GREEN}-h, --help${NC}         Bu yardım mesajını gösterir ve çıkar.\n"
    echo -e "${BOLD}KULLANILABİLİR MODÜLLER:${NC}"
    echo -e "  ${PURPLE}Masaüstü & Pencere Yöneticileri:${NC}"
    echo -e "    hypr, niri, mango"
    echo -e "  ${PURPLE}Terminal Emülatörleri:${NC}"
    echo -e "    ghostty, kitty"
    echo -e "  ${PURPLE}Kabuk, Editör & CLI:${NC}"
    echo -e "    fish, nvim, base_cli"
    echo -e "  ${PURPLE}Uygulamalar & Üretkenlik:${NC}"
    echo -e "    browser, social, dev, productivity, media, networking, sunshine, flatpak"
    echo -e "  ${PURPLE}Donanım, Sistem & Fontlar:${NC}"
    echo -e "    hardware, keychron, fkeys, iwd, services, fonts\n"
    echo -e "${BOLD}ÖRNEKLER:${NC}"
    echo -e "  $0                             # İnteraktif kurulum sihirbazını başlatır"
    echo -e "  $0 --dry-run                   # İnteraktif seçimlerle simülasyon çalıştırır"
    echo -e "  $0 --dry-run --default         # Varsayılan modüller için simülasyon çıktısı üretir"
    echo -e "  $0 -d                          # Varsayılan modülleri hemen kurar"
    echo -e "  $0 -a                          # Tüm modülleri hemen kurar"
    echo -e "  $0 hypr fish ghostty           # Sadece belirtilen modülleri kurar"
    echo -e "  $0 --dry-run hypr mango        # Belirtilen modüller için simülasyon çalıştırır"
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
# 3. Flatpak Paketlerini Kur
# -----------------------------------------------------------------
install_flatpaks() {
    print_section "'install_flatpaks.sh' script'i çalıştırılıyor..."
    run_script "$DOTFILES_DIR/scripts/install_flatpaks.sh"
    echo ":: Flatpak kurulum adımı tamamlandı."
}

# -----------------------------------------------------------------
# Sıralı Yürütme Motoru (Execution Engine) & Dry-Run
# -----------------------------------------------------------------
execute_plan() {
    # 1. Paket listelerini topla ve birleştir
    local pkg_files=()
    if [ -f "$DOTFILES_DIR/packages/base.txt" ]; then
        pkg_files+=("$DOTFILES_DIR/packages/base.txt")
    fi

    for mod in "${SELECTED_MODULES[@]}"; do
        local pf
        pf=$(get_module_package_file "$mod")
        if [ -n "$pf" ] && [[ "$pf" == packages/*.txt ]] && [ -f "$DOTFILES_DIR/$pf" ]; then
            if ! contains_element "$DOTFILES_DIR/$pf" "${pkg_files[@]}"; then
                pkg_files+=("$DOTFILES_DIR/$pf")
            fi
        fi
    done

    local combined_packages=()
    if [ ${#pkg_files[@]} -gt 0 ]; then
        mapfile -t combined_packages < <(
            sed -e 's/#.*$//' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' "${pkg_files[@]}" | \
            grep -v '^$' | \
            sort -u
        )
    fi

    # 2. Stow hedeflerini topla
    local stow_targets=()
    for mod in "${SELECTED_MODULES[@]}"; do
        local spkgs
        spkgs=$(get_module_stow_packages "$mod")
        for sp in $spkgs; do
            if ! contains_element "$sp" "${stow_targets[@]}"; then
                stow_targets+=("$sp")
            fi
        done
    done

    # 3. Sistem & ayar betiklerini topla
    local script_targets=()
    for mod in "${SELECTED_MODULES[@]}"; do
        local scripts
        scripts=$(get_module_scripts "$mod")
        for sc in $scripts; do
            # Flatpak paket kurulumu Faz 2'de ele alınır
            if [ "$sc" = "scripts/install_flatpaks.sh" ]; then
                continue
            fi
            if ! contains_element "$sc" "${script_targets[@]}"; then
                script_targets+=("$sc")
            fi
        done
    done

    # -------------------------------------------------------------
    # Dry-Run (Simülasyon Modu) Kontrolü
    # -------------------------------------------------------------
    if [ "$DRY_RUN" = true ]; then
        echo -e "\n${CYAN}================================================================${NC}"
        echo -e "${BOLD}${YELLOW}🔍 [DRY-RUN SIMULASYON MODU]${NC}"
        echo -e "${PURPLE}Hiçbir sistem değişikliği yapılmayacak. Planlanan adımlar simüle ediliyor.${NC}"
        echo -e "${CYAN}================================================================${NC}"

        # Faz 1 Simülasyonu
        echo -e "\n${BOLD}${BLUE}:: [FAZ 1/4] Temel Sistem Bootstrap (Simülasyon)${NC}"
        echo -e "   ${CYAN}•${NC} Temel Paketler (pacman): git, base-devel, stow"
        echo -e "   ${CYAN}•${NC} Paket Yöneticisi Kontrolü: yay (AUR yardımcısı)"
        if [ -f "$DOTFILES_DIR/packages/base.txt" ]; then
            local base_list
            base_list=$(sed -e 's/#.*$//' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' "$DOTFILES_DIR/packages/base.txt" | grep -v '^$' | tr '\n' ' ')
            echo -e "   ${CYAN}•${NC} packages/base.txt paketleri: $base_list"
        fi

        # Faz 2 Simülasyonu
        echo -e "\n${BOLD}${BLUE}:: [FAZ 2/4] Toplu Paket Kurulumu (Simülasyon)${NC}"
        echo -e "   ${BOLD}Dahil edilen paket dosyaları:${NC}"
        for pf in "${pkg_files[@]}"; do
            echo -e "   ${CYAN}•${NC} ${pf#$DOTFILES_DIR/}"
        done
        echo -e "\n   ${BOLD}Yay ile kurulacak paket listesi (${#combined_packages[@]} adet):${NC}"
        echo -e "   ${CYAN}${combined_packages[*]}${NC}"
        if contains_element "flatpak" "${SELECTED_MODULES[@]}"; then
            echo -e "\n   ${BOLD}Flatpak Durumu:${NC} 'scripts/install_flatpaks.sh' betiği çalıştırılacak (flat_packages.txt)"
        else
            echo -e "\n   ${BOLD}Flatpak Durumu:${NC} Seçilmedi (atlanıyor)"
        fi

        # Faz 3 Simülasyonu
        echo -e "\n${BOLD}${BLUE}:: [FAZ 3/4] Dotfiles Bağlama (Stow Simülasyonu)${NC}"
        if [ ${#stow_targets[@]} -gt 0 ]; then
            echo -e "   ${BOLD}stow_all.sh ile bağlanacak dotfiles paketleri (${#stow_targets[@]} adet):${NC}"
            echo -e "   ${CYAN}•${NC} ${stow_targets[*]}"
            echo -e "   ${BOLD}Çalıştırılacak komut:${NC} $DOTFILES_DIR/stow_all.sh ${stow_targets[*]}"
        else
            echo -e "   ${YELLOW}• Hiçbir stow hedefi seçilmedi.${NC}"
        fi

        # Faz 4 Simülasyonu
        echo -e "\n${BOLD}${BLUE}:: [FAZ 4/4] Ayar ve Sistem Betikleri (Simülasyon)${NC}"
        if [ ${#script_targets[@]} -gt 0 ]; then
            echo -e "   ${BOLD}Çalıştırılacak betikler (${#script_targets[@]} adet):${NC}"
            for sc in "${script_targets[@]}"; do
                if is_sudo_script "$sc"; then
                    echo -e "   ${CYAN}•${NC} $sc ${PURPLE}(sudo ile)${NC}"
                else
                    echo -e "   ${CYAN}•${NC} $sc ${GREEN}(kullanıcı haklarıyla)${NC}"
                fi
            done
        else
            echo -e "   ${YELLOW}• Hiçbir betik seçilmedi.${NC}"
        fi

        echo -e "\n${CYAN}================================================================${NC}"
        echo -e "${BOLD}${GREEN}✅ Simülasyon tamamlandı. Hiçbir sistem değişikliği yapılmadı.${NC}"
        echo -e "${CYAN}================================================================${NC}\n"
        exit 0
    fi

    # -------------------------------------------------------------
    # Gerçek Yürütme (Faz 1 - Faz 4)
    # -------------------------------------------------------------

    # Faz 1: Temel Bootstrap
    print_section "[FAZ 1/4] Temel Sistem Bootstrap..."
    install_base_packages
    install_package_manager
    if [ -f "$DOTFILES_DIR/packages/base.txt" ]; then
        case "$DETECTED_OS" in
            arch|manjaro|endeavouros|artix|cachyos)
                local base_pkgs=()
                mapfile -t base_pkgs < <(
                    sed -e 's/#.*$//' -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' "$DOTFILES_DIR/packages/base.txt" | \
                    grep -v '^$'
                )
                if [ ${#base_pkgs[@]} -gt 0 ]; then
                    echo ":: packages/base.txt içerisindeki temel paketler kuruluyor..."
                    sudo pacman -S --needed --noconfirm "${base_pkgs[@]}"
                fi
                ;;
        esac
    fi

    # Faz 2: Toplu Paket Kurulumu
    print_section "[FAZ 2/4] Toplu Paket Kurulumu..."
    case "$DETECTED_OS" in
        arch|manjaro|endeavouros|artix|cachyos)
            if [ ${#combined_packages[@]} -gt 0 ]; then
                local tmp_pkg_list
                tmp_pkg_list=$(mktemp)
                trap 'rm -f "$tmp_pkg_list"' EXIT INT TERM
                printf '%s\n' "${combined_packages[@]}" > "$tmp_pkg_list"
                echo ":: Toplam ${#combined_packages[@]} paket 'yay' ile kuruluyor..."
                yay -Syu --needed --noconfirm - < "$tmp_pkg_list" || {
                    rm -f "$tmp_pkg_list"
                    trap - EXIT INT TERM
                    exit 1
                }
                rm -f "$tmp_pkg_list"
                trap - EXIT INT TERM
            else
                echo ":: Kurulacak paket seçilmedi."
            fi
            ;;
        *)
            echo -e "${YELLOW}⚠️ Paketler Arch Linux / AUR formatındadır ($DETECTED_OS). Paket kurulum adımı atlanıyor.${NC}"
            ;;
    esac

    if contains_element "flatpak" "${SELECTED_MODULES[@]}"; then
        install_flatpaks
    fi

    # Faz 3: Dotfiles Bağlama
    print_section "[FAZ 3/4] Dotfiles 'stow' ile ana dizine bağlanıyor..."
    if [ ${#stow_targets[@]} -gt 0 ]; then
        run_script "$DOTFILES_DIR/stow_all.sh" "${stow_targets[@]}"
    else
        echo ":: Bağlanacak dotfiles paketi seçilmedi, atlanıyor."
    fi

    # Faz 4: Ayar ve Sistem Betikleri
    print_section "[FAZ 4/4] Sistem ve Yapılandırma Betikleri Çalıştırılıyor..."
    for sc in "${script_targets[@]}"; do
        if is_sudo_script "$sc"; then
            run_script "$DOTFILES_DIR/$sc" sudo
        else
            run_script "$DOTFILES_DIR/$sc"
        fi
    done

    echo -e "\n${CYAN}----------------------------------------------------------------${NC}"
    echo -e "${BOLD}${GREEN}🎉 TÜM KURULUM TAMAMLANDI! 🎉${NC}"
    echo -e "Değişikliklerin tamamının etkili olması için sistemi yeniden başlatman gerekebilir.\n"
}

# -----------------------------------------------------------------
# Ana Fonksiyon (CLI Parser & Akış Yönetimi)
# -----------------------------------------------------------------
main() {
    DRY_RUN=false
    local mode=""
    local positional_modules=()

    while [ $# -gt 0 ]; do
        case "$1" in
            -n|--dry-run)
                DRY_RUN=true
                ;;
            -d|--default)
                mode="default"
                ;;
            -a|--all)
                mode="all"
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            -*)
                echo -e "${RED}Hata: Bilinmeyen seçenek '$1'${NC}" >&2
                echo "Yardım için: $0 --help" >&2
                exit 1
                ;;
            *)
                positional_modules+=("$1")
                ;;
        esac
        shift
    done

    # Modül seçimlerini çözümle
    if [ ${#positional_modules[@]} -gt 0 ]; then
        SELECTED_MODULES=()
        for mod in "${positional_modules[@]}"; do
            if ! contains_element "$mod" "${ALL_MODULES[@]}"; then
                echo -e "${RED}Hata: Geçersiz modül adı: '$mod'${NC}" >&2
                echo -e "Kullanılabilir modüller: ${ALL_MODULES[*]}" >&2
                exit 1
            fi
            if ! contains_element "$mod" "${SELECTED_MODULES[@]}"; then
                SELECTED_MODULES+=("$mod")
            fi
        done
    elif [ "$mode" = "default" ]; then
        SELECTED_MODULES=("${DEFAULT_MODULES[@]}")
    elif [ "$mode" = "all" ]; then
        SELECTED_MODULES=("${ALL_MODULES[@]}")
    fi

    # Başlığı yazdır
    print_header

    # Yürütme moduna karar ver
    if [ -z "$mode" ] && [ ${#positional_modules[@]} -eq 0 ]; then
        # Hiçbir mod veya argüman verilmedi (veya sadece --dry-run verildi)
        if [ "$DRY_RUN" = true ]; then
            # Sadece --dry-run: Soruları interaktif sor, onay istemeden simülasyonu çalıştır
            run_wizard
            execute_plan
        else
            # Varsayılan interaktif akış: Soru -> Özet/Onay -> Yürütme
            run_wizard
            show_summary_and_confirm
            execute_plan
        fi
    else
        # --default, --all veya pozisyonel modüller verildi:
        # Soru sormadan hemen yürüt (veya simülasyonu çalıştır)
        execute_plan
    fi
}

# Script doğrudan çalıştırılıyorsa main fonksiyonunu çağır
# (Bu, fonksiyonların sourcing'ini izin verir ancak otomatik çalıştırmamış olur)
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi