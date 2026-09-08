# Dotfiles Betiklerinin Modülerleştirilmesi (Scripts Refactor) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Kök dizindeki 13 kurulum ve sistem betiğini `scripts/` dizini altına taşımak, `install.sh` ve `stow_all.sh`'ı kök dizinde korumak, çoklu dağıtım (Arch/CachyOS, Fedora, Ubuntu/Debian) desteğini geri kazandırmak ve isteğe bağlı `1password` modülünü eklemek.

**Architecture:** Betikler bağımsız (self-contained) düz bir yapıda `scripts/` altında toplanır. `install.sh` ana orkestrasyonu sağlar ve `$DOTFILES_DIR/scripts/<betik>.sh` yollarını çağırır. Göreceli dosya yolları dinamik çözümlenir, GNU Stow uyumluluğu `.stow-local-ignore` ile korunur.

**Tech Stack:** Bash, GNU Stow, systemd, pacman/yay, dnf, apt, ufw.

**Spec:** [`docs/superpowers/specs/2026-09-08-scripts-refactor-design.md`](file:///home/melih/Projects/dotfiles/docs/superpowers/specs/2026-09-08-scripts-refactor-design.md)

## Global Constraints

- Kök dizinde yalnızca `install.sh` ve `stow_all.sh` kalacaktır; diğer tüm `setup_*.sh`, `install_flatpaks.sh`, `switch_to_iwd.sh`, `vivaldi_middle_click.sh` betikleri `scripts/` altında toplanacaktır.
- Çoklu dağıtım (Arch/CachyOS, Fedora, Ubuntu/Debian) algılama ve dallanma mantığı korunacaktır.
- `setup_1password.sh` varsayılan argümansız tam kurulumda çalışmayacak; yalnızca `./install.sh 1password` (veya `onepassword`) istendiğinde çalışacaktır.
- Tüm betikler çalıştırılabilir (`chmod +x`) ve sözdizimi açısından geçerli (`bash -n`) olacaktır.
- `.stow-local-ignore` güncellenerek `scripts/` dizininin `$HOME` dizinine stowlanması engellenecektir.

---

### Task 1: Dizin Oluşturma, Betiklerin Taşınması ve Stow İhmal Kuralı

**Files:**
- Create: `scripts/` (directory)
- Move via git:
  - `install_flatpaks.sh` -> `scripts/install_flatpaks.sh`
  - `setup_1password.sh` -> `scripts/setup_1password.sh`
  - `setup_discord_proxy.sh` -> `scripts/setup_discord_proxy.sh`
  - `setup_fkeys.sh` -> `scripts/setup_fkeys.sh`
  - `setup_fonts.sh` -> `scripts/setup_fonts.sh`
  - `setup_keychron.sh` -> `scripts/setup_keychron.sh`
  - `setup_npm.sh` -> `scripts/setup_npm.sh`
  - `setup_services.sh` -> `scripts/setup_services.sh`
  - `setup_sshd.sh` -> `scripts/setup_sshd.sh`
  - `setup_ufw.sh` -> `scripts/setup_ufw.sh`
  - `setup_warp.sh` -> `scripts/setup_warp.sh`
  - `switch_to_iwd.sh` -> `scripts/switch_to_iwd.sh`
  - `vivaldi_middle_click.sh` -> `scripts/vivaldi_middle_click.sh`
- Modify: `.stow-local-ignore`

**Interfaces:**
- Produces: `scripts/` dizini altında toplanmış 13 adet çalıştırılabilir betik.

- [ ] **Step 1: Dizin oluştur ve betikleri git mv ile taşı**

```bash
mkdir -p scripts
git mv install_flatpaks.sh scripts/
git mv setup_1password.sh scripts/
git mv setup_discord_proxy.sh scripts/
git mv setup_fkeys.sh scripts/
git mv setup_fonts.sh scripts/
git mv setup_keychron.sh scripts/
git mv setup_npm.sh scripts/
git mv setup_services.sh scripts/
git mv setup_sshd.sh scripts/
git mv setup_ufw.sh scripts/
git mv setup_warp.sh scripts/
git mv switch_to_iwd.sh scripts/
git mv vivaldi_middle_click.sh scripts/
chmod +x scripts/*.sh
```

- [ ] **Step 2: `.stow-local-ignore` dosyasına `scripts/` kalıbını ekle**

`.stow-local-ignore` dosyasına `scripts` ve `scripts/` satırlarını ekle:
```
# GNU Stow Ignore List
# Bu dosyadaki kalıplar 'stow' işlemi sırasında $HOME dizinine bağlanmaz.

README.*
README.md
LICENSE.*
*.md
.gitignore
scripts
scripts/
```

- [ ] **Step 3: Taşıma ve izinleri doğrula**

Run: `ls -la scripts/ && git status -s`
Expected: 13 betik `scripts/` altında listelenmeli ve `git status` taşımaları (`R`) göstermeli.

- [ ] **Step 4: Commit**

```bash
git add .stow-local-ignore scripts/
git commit -m "refactor(scripts): move helper and setup scripts to scripts/ directory"
```

---

### Task 2: `scripts/install_flatpaks.sh` ve `scripts/setup_fonts.sh` Güncellemeleri

**Files:**
- Modify: `scripts/install_flatpaks.sh`
- Modify: `scripts/setup_fonts.sh`

**Interfaces:**
- Consumes: Repo kökündeki `flat_packages.txt`
- Produces: Kök dizindeki dosyayı dinamik çözen `install_flatpaks.sh` ve çoklu dağıtım destekleyen `setup_fonts.sh`.

- [ ] **Step 1: `scripts/install_flatpaks.sh` dosyasında `DOTFILES_DIR` yol çözümlemesini güncelle**

`scripts/install_flatpaks.sh` dosyasında `baseDir` tanımını ana repo dizinini bulacak şekilde güncelle:
```bash
# Dizini bul (repo kök dizini)
DOTFILES_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." &>/dev/null && pwd)"

# flat_packages.txt dosyasından paket listesini al
if [ -f "${DOTFILES_DIR}/flat_packages.txt" ]; then
    flats=$(awk -F '#' '{print $1}' "${DOTFILES_DIR}/flat_packages.txt" 2>/dev/null | sed 's/ //g' | xargs)
...
```

- [ ] **Step 2: `scripts/setup_fonts.sh` dosyasında çoklu dağıtım desteğini geri kazandır**

`scripts/setup_fonts.sh` içeriğini Arch için pacman, diğer sistemler için doğrudan Nerd Fonts GitHub sürümünden indiren mantıkla güncelle:
```bash
#!/bin/bash
# ==============================================================================
# Font Kurulumu ve Yapılandırması
# ==============================================================================
# Bu betik, JetBrains Mono Nerd Font yazı tipini kurar ve font önbelleğini günceller.
# Arch tabanlı dağıtımlarda (CachyOS, Arch, Manjaro vb.) resmi paketi kurar.
# Diğer dağıtımlarda GitHub üzerinden en güncel sürümü indirerek kurar.

set -e

echo ":: Font kurulumu başlıyor..."

DETECTED_OS=""
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DETECTED_OS="$ID"
fi

case "$DETECTED_OS" in
    arch|manjaro|endeavouros|artix|cachyos)
        sudo pacman -S --needed --noconfirm ttf-jetbrains-mono-nerd
        ;;
    *)
        FONT_DIR="$HOME/.local/share/fonts"
        mkdir -p "$FONT_DIR"
        echo ":: JetBrains Mono Nerd Font GitHub'dan indiriliyor..."
        TEMP_DIR=$(mktemp -d)
        curl -fsSL -o "$TEMP_DIR/JetBrainsMono.tar.xz" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz"
        tar -xf "$TEMP_DIR/JetBrainsMono.tar.xz" -C "$FONT_DIR"
        rm -rf "$TEMP_DIR"
        ;;
esac

# Font önbelleğini güncelle
echo ":: Font önbelleği güncelleniyor..."
fc-cache -f

echo ":: Font kurulumu tamamlandı!"
```

- [ ] **Step 3: Sözdizimi ve yol kontrolü**

Run: `bash -n scripts/install_flatpaks.sh && bash -n scripts/setup_fonts.sh`
Expected: 0 çıkış kodu (hata yok).

- [ ] **Step 4: Commit**

```bash
git add scripts/install_flatpaks.sh scripts/setup_fonts.sh
git commit -m "refactor(scripts): resolve root path in install_flatpaks and restore multi-distro fonts"
```

---

### Task 3: `scripts/setup_services.sh` İçinde Çoklu Dağıtım Desteğini Geri Kazandırma

**Files:**
- Modify: `scripts/setup_services.sh`

**Interfaces:**
- Produces: Arch, Fedora ve Debian dağıtımlarına göre dinamik sistem servis listesi oluşturan ve kullanıcı servislerini etkinleştiren betik.

- [ ] **Step 1: `scripts/setup_services.sh` dosyasında OS tespiti ve servis dizilerini güncelle**

`scripts/setup_services.sh` dosyasında `SYSTEM_SERVICES` bölümüne `DETECTED_OS` tespiti ve case yapısını ekle:
```bash
# OS Tespiti
DETECTED_OS=""
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DETECTED_OS="$ID"
fi

case "$DETECTED_OS" in
    arch|manjaro|endeavouros|artix|cachyos)
        SYSTEM_SERVICES=(
            "bluetooth.service"             # Bluetooth Servisi
            "ufw.service"                   # UFW Güvenlik Duvarı
            "avahi-daemon.service"          # Yerel Ağ Cihaz Keşif Servisi (mDNS)
            "ananicy-cpp.service"           # Otomatik Süreç Önceliklendirici (Performans/Oyun)
            "bpftune.service"               # BPF Otomatik Ağ Optimizasyon Servisi
            "warp-svc.service"              # Cloudflare WARP Daemon Servisi
            "docker.service"                # Docker Konteyner Servisi
            "tailscaled.service"            # Tailscale VPN Servisi
            "fstrim.timer"                  # SSD TRIM Otomatik Bakım Zamanlayıcısı
            "cachyos-rate-mirrors.timer"    # CachyOS Yansıma Hızı Zamanlayıcısı
            "snapper-cleanup.timer"         # Btrfs Snapper Temizlik Zamanlayıcısı
            "grub-btrfs-snapper.path"       # Btrfs GRUB Yansıma Güncelleyici
            "cachyos-iw-set-regdomain.path" # Kablosuz Ağ Bölge Ayarı Servisi
        )
        ;;
    fedora|rhel|centos|rocky|almalinux)
        SYSTEM_SERVICES=(
            "bluetooth.service"             # Bluetooth Servisi
            "firewalld.service"             # Firewall Servisi
            "avahi-daemon.service"          # Yerel Ağ Cihaz Keşif Servisi (mDNS)
            "tuned.service"                 # Sistem Performans Tuning Servisi
            "bpftune.service"               # BPF Otomatik Ağ Optimizasyon Servisi
            "warp-svc.service"              # Cloudflare WARP Daemon Servisi
            "docker.service"                # Docker Konteyner Servisi
            "tailscaled.service"            # Tailscale VPN Servisi
            "fstrim.timer"                  # SSD TRIM Otomatik Bakım Zamanlayıcısı
            "dnf-makecache.timer"           # DNF Önbellek Güncelleme Zamanlayıcısı
            "snapper-cleanup.timer"         # Btrfs Snapper Temizlik Zamanlayıcısı
            "grubby.service"                # GRUB Yapılandırma Aracı
        )
        ;;
    ubuntu|debian|linuxmint|pop|elementary)
        SYSTEM_SERVICES=(
            "bluetooth.service"             # Bluetooth Servisi
            "ufw.service"                   # UFW Güvenlik Duvarı
            "avahi-daemon.service"          # Yerel Ağ Cihaz Keşif Servisi (mDNS)
            "warp-svc.service"              # Cloudflare WARP Daemon Servisi
            "docker.service"                # Docker Konteyner Servisi
            "tailscaled.service"            # Tailscale VPN Servisi
            "fstrim.timer"                  # SSD TRIM Otomatik Bakım Zamanlayıcısı
            "apt-daily.timer"               # Günlük APT Güncelleme Zamanlayıcısı
            "apt-daily-upgrade.timer"       # Günlük APT Yükseltme Zamanlayıcısı
        )
        ;;
    *)
        SYSTEM_SERVICES=(
            "bluetooth.service"
            "ufw.service"
            "avahi-daemon.service"
            "warp-svc.service"
            "docker.service"
            "tailscaled.service"
            "fstrim.timer"
        )
        ;;
esac
```

- [ ] **Step 2: Sözdizimi kontrolü**

Run: `bash -n scripts/setup_services.sh`
Expected: 0 çıkış kodu.

- [ ] **Step 3: Commit**

```bash
git add scripts/setup_services.sh
git commit -m "refactor(scripts): restore multi-distro system services in setup_services.sh"
```

---

### Task 4: `install.sh` Dosyasının Güncellenmesi (Yollar, Çoklu Dağıtım ve `1password` Modülü)

**Files:**
- Modify: `install.sh`

**Interfaces:**
- Consumes: `$DOTFILES_DIR/scripts/*.sh` ve `$DOTFILES_DIR/stow_all.sh`
- Produces: Tüm modülleri `scripts/` altından çalıştıran, OS algılamalı ve `1password` destekli ana CLI.

- [ ] **Step 1: `install.sh` dosyasında OS tespiti ve paket yöneticisi mantığını geri getir**

`install.sh` başındaki OS tespitini ve `install_base_packages`, `install_package_manager` fonksiyonlarını çoklu dağıtım destekleyecek şekilde güncelle:
```bash
# OS Tespiti
DETECTED_OS=""
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DETECTED_OS="$ID"
fi
```
`install_base_packages`:
```bash
install_base_packages() {
    print_section "'git' ve temel geliştirme paketleri kontrol ediliyor..."
    case "$DETECTED_OS" in
        arch|manjaro|endeavouros|artix|cachyos)
            sudo pacman -Syu --needed git base-devel --noconfirm
            ;;
        fedora|rhel|centos|rocky|almalinux)
            sudo dnf install -y git @development-tools
            ;;
        ubuntu|debian|linuxmint|pop|elementary)
            sudo apt update && sudo apt install -y git build-essential
            ;;
        *)
            echo "Desteklenmeyen dağıtım: $DETECTED_OS. pacman deneniyor..."
            sudo pacman -Syu --needed git base-devel --noconfirm 2>/dev/null || true
            ;;
    esac
}
```
`install_package_manager`:
```bash
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
```

- [ ] **Step 2: Betik yollarını `$DOTFILES_DIR/scripts/` olarak güncelle**

`install.sh` içindeki modül fonksiyonlarını güncelle:
- `install_flatpaks()` -> `run_script "$DOTFILES_DIR/scripts/install_flatpaks.sh"`
- `link_dotfiles()` -> `run_script "$DOTFILES_DIR/stow_all.sh"` (stow_all kök dizinde)
- `apply_hardware_settings()` -> `run_script "$DOTFILES_DIR/scripts/setup_fkeys.sh" sudo` ve `run_script "$DOTFILES_DIR/scripts/setup_keychron.sh" sudo`
- `apply_network_settings()` -> `run_script "$DOTFILES_DIR/scripts/switch_to_iwd.sh" sudo` ve `run_script "$DOTFILES_DIR/scripts/vivaldi_middle_click.sh"`
- `apply_discord_settings()` -> `run_script "$DOTFILES_DIR/scripts/setup_discord_proxy.sh"`
- `configure_services()` -> `run_script "$DOTFILES_DIR/scripts/setup_services.sh"`
- `apply_ufw_rules()` -> `run_script "$DOTFILES_DIR/scripts/setup_ufw.sh" sudo`
- `apply_warp_settings()` -> `run_script "$DOTFILES_DIR/scripts/setup_warp.sh"`
- `install_fonts()` -> `run_script "$DOTFILES_DIR/scripts/setup_fonts.sh"`
- `configure_npm()` -> `run_script "$DOTFILES_DIR/scripts/setup_npm.sh"`
- `apply_sshd_settings()` -> `run_script "$DOTFILES_DIR/scripts/setup_sshd.sh"`
- Yeni fonksiyon `apply_1password_settings()`:
  ```bash
  apply_1password_settings() {
      print_section "1Password özel tarayıcı izinleri yapılandırılıyor..."
      run_script "$DOTFILES_DIR/scripts/setup_1password.sh" sudo
      echo ":: 1Password yapılandırması tamamlandı."
  }
  ```

- [ ] **Step 3: CLI argümanlarında `1password` seçeneğini ekle**

`main()` içindeki `case "$section" in` bloğuna ekle:
```bash
1password|onepassword) apply_1password_settings ;;
```
Not: Varsayılan tam kurulum akışına (`if [ $# -eq 0 ]`) `apply_1password_settings` çağrısı eklenmez (kullanıcı tercihine uygun olarak).

- [ ] **Step 4: Sözdizimi kontrolü**

Run: `bash -n install.sh`
Expected: 0 çıkış kodu.

- [ ] **Step 5: Commit**

```bash
git add install.sh
git commit -m "refactor(install): update script paths to scripts/, restore multi-distro logic, add 1password module"
```

---

### Task 5: Dokümantasyon Güncellemeleri (`README.md`, `ssh/README.md`, `vivaldi/README.md`)

**Files:**
- Modify: `README.md`
- Modify: `ssh/README.md`
- Modify: `vivaldi/README.md`

**Interfaces:**
- Produces: Yeni `scripts/` yolunu ve `1password` modülünü yansıtan güncel dokümanlar.

- [ ] **Step 1: `README.md` dosyasını güncelle**

1. `## 🧩 Modüler Kurulum Seçenekleri` tablosuna `1password` satırını ekle:
   ```markdown
   | `1password` | 1Password için özel tarayıcı izinlerini (`scripts/setup_1password.sh`) uygular |
   ```
2. `## 🛠️ Donanım & Sistem Betikleri` bölümündeki yolları `scripts/` olarak güncelle:
   - `scripts/setup_fkeys.sh`
   - `scripts/setup_keychron.sh`
   - `scripts/setup_ufw.sh`
   - `scripts/setup_sshd.sh`
   - `scripts/setup_services.sh`
   - `scripts/vivaldi_middle_click.sh`
   - `scripts/setup_1password.sh` (yeni ekle)
3. İlgili açıklamalarda `./setup_*.sh` yerine `./scripts/setup_*.sh` örneklerini kullan.

- [ ] **Step 2: `ssh/README.md` dosyasını güncelle**

Satır 60 civarındaki referansı güncelle:
```markdown
sudo ./scripts/setup_sshd.sh
# veya
./install.sh sshd
```

- [ ] **Step 3: `vivaldi/README.md` dosyasını güncelle**

Satır 37 civarındaki referansı güncelle:
```markdown
* İlgili ayarı sisteme uygulamak için `./scripts/vivaldi_middle_click.sh` betiği de kullanılabilir.
```

- [ ] **Step 4: Commit**

```bash
git add README.md ssh/README.md vivaldi/README.md
git commit -m "docs: update script paths to scripts/ and add 1password module to README"
```

---

### Task 6: Kapsamlı Doğrulama ve Bütünlük Kontrolleri

**Files:**
- Test: `install.sh`, `stow_all.sh`, `scripts/*.sh`
- Verify: `git status`, `grep`

- [ ] **Step 1: Tüm betiklerin sözdizimini doğrula**

Run:
```bash
bash -n install.sh
bash -n stow_all.sh
for f in scripts/*.sh; do bash -n "$f" || exit 1; done
```
Expected: Tüm dosyalar hatasız geçer.

- [ ] **Step 2: Eski kök betik referanslarını ara**

Run:
```bash
git grep "setup_" || true
git grep "vivaldi_middle_click" || true
git grep "switch_to_iwd" || true
git grep "install_flatpaks" || true
```
Expected: Kök dizindeki `./setup_*.sh` şeklindeki tüm eski yolların `scripts/` veya `install.sh <module>` olarak güncellendiğini doğrula.

- [ ] **Step 3: `flat_packages.txt` çözümleme simülasyonu**

Run:
```bash
bash -c 'DOTFILES_DIR="$(cd -- scripts/.. && pwd)"; test -f "$DOTFILES_DIR/flat_packages.txt" && echo "FOUND OK"'
```
Expected: "FOUND OK"

- [ ] **Step 4: Git çalışma ağacını kontrol et**

Run:
```bash
git status
```
Expected: `nothing to commit, working tree clean`

- [ ] **Step 5: Final onay ve raporlama**

Tüm adımların başarıyla tamamlandığını doğrula.
