# JaKooLit Tarzı İnteraktif ve Modüler Kurulum Sihirbazı Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Eski 1660 satırlık `packages.txt` dosyasını temiz modüler paket listelerine (`packages/*.txt`) dönüştürmek, `stow_all.sh`'ı seçici bağlama yapabilecek şekilde güncellemek ve `install.sh`'ı JaKooLit tarzı kategorik soru-cevap, özet onay ekranı, sıralı yürütme motoru ve `--dry-run` destekleyen interaktif bir sihirbaza kavuşturmak.

**Architecture:** Paketler `packages/` altında bağımsız listelere bölünür. `install.sh` içinde bir Bileşen Kaydı (Registry) tanımlanır; her bileşen paket listesi, dotfile stow klasörü ve ayar betiği ile eşleştirilir. Sihirbaz seçimleri toplar, bir onay özeti sunar ve onay sonrası sıralı fazlar (Temel araçlar -> Paketler -> Stow -> Betikler) halinde yürütür. `--dry-run` bayrağı ile simülasyon yapılabilir.

**Tech Stack:** Bash, GNU Stow, pacman, yay.

**Spec:** [`docs/superpowers/specs/2026-09-08-interactive-modular-installer-design.md`](file:///home/melih/Projects/dotfiles/docs/superpowers/specs/2026-09-08-interactive-modular-installer-design.md)

## Global Constraints

- `packages.txt` silinecek; yerine `packages/` dizini altında sadece gerekli ana programları içeren modüler listeler oluşturulacaktır.
- `stow_all.sh` argüman verildiğinde yalnızca belirtilen paketleri bağlayacak; argümansız çağrıldığında tüm paketleri bağlamaya devam edecektir.
- `install.sh` varsayılan olarak interaktif sihirbazı başlatacak; `--dry-run`, `--default`, `--all`, `--help` ve pozisyonel modül argümanlarını eksiksiz destekleyecektir.
- Varsayılan [Y/N] değerleri spec matrisine birebir sadık kalacaktır (hypr: N, niri: N, mango: N, ghostty: Y, kitty: N, fish: Y, nvim: Y, base_cli: Y, browser: Y, social: Y, dev: Y, productivity: Y, media: Y, networking: Y, sunshine: N, flatpak: N, hardware: N, keychron: N, fkeys: N, iwd: N, services: Y, fonts: Y).
- Tüm betikler geçerli sözdizimine (`bash -n`) sahip olacaktır.

---

### Task 1: Modüler Paket Listelerinin Oluşturulması ve Eski `packages.txt` Dosyasının Kaldırılması

**Files:**
- Create: `packages/` (directory)
- Create:
  - `packages/base.txt`
  - `packages/hypr.txt`
  - `packages/niri.txt`
  - `packages/mango.txt`
  - `packages/ghostty.txt`
  - `packages/kitty.txt`
  - `packages/fish.txt`
  - `packages/nvim.txt`
  - `packages/base_cli.txt`
  - `packages/browser.txt`
  - `packages/social.txt`
  - `packages/dev.txt`
  - `packages/productivity.txt`
  - `packages/media.txt`
  - `packages/networking.txt`
  - `packages/sunshine.txt`
  - `packages/hardware.txt`
- Delete: `packages.txt`

**Interfaces:**
- Produces: `packages/` dizini altında modüler ve temiz paket listeleri.

- [ ] **Step 1: `packages/` dizinini ve modüler paket dosyalarını oluştur**

Aşağıdaki içeriklerle dosyaları oluştur:
- `packages/base.txt`:
  ```text
  git
  base-devel
  stow
  which
  curl
  wget
  bash-completion
  sudo
  xdg-user-dirs
  ```
- `packages/hypr.txt`:
  ```text
  hyprland
  hyprpaper
  hyprlock
  hypridle
  xdg-desktop-portal-hyprland
  polkit-gnome
  nwg-displays
  waybar
  brightnessctl
  wl-clipboard
  ```
- `packages/niri.txt`:
  ```text
  niri
  xdg-desktop-portal-gnome
  polkit-gnome
  fuzzel
  ```
- `packages/mango.txt`:
  ```text
  mangowm
  ```
- `packages/ghostty.txt`:
  ```text
  ghostty
  ```
- `packages/kitty.txt`:
  ```text
  kitty
  ```
- `packages/fish.txt`:
  ```text
  fish
  fisher
  starship
  cachyos-fish-config
  ```
- `packages/nvim.txt`:
  ```text
  neovim
  ripgrep
  fd
  tree-sitter
  ```
- `packages/base_cli.txt`:
  ```text
  bat
  zoxide
  tree
  trash-cli
  duf
  jq
  unzip
  unrar
  7zip
  rsync
  topgrade
  multitail
  btop
  fastfetch
  ```
- `packages/browser.txt`:
  ```text
  vivaldi
  vivaldi-ffmpeg-codecs
  ```
- `packages/social.txt`:
  ```text
  vesktop
  telegram-desktop
  signal-desktop
  teams-for-linux
  ```
- `packages/dev.txt`:
  ```text
  code
  docker
  docker-compose
  docker-buildx
  lazydocker
  dbeaver
  github-cli
  nodejs
  npm
  ```
- `packages/productivity.txt`:
  ```text
  obsidian
  proton-pass
  proton-pass-cli-bin
  calibre
  keepassxc
  ```
- `packages/media.txt`:
  ```text
  haruna
  obs-studio
  kdenlive
  qbittorrent
  freedownloadmanager
  jdownloader2
  gwenview
  ```
- `packages/networking.txt`:
  ```text
  tailscale
  cloudflare-warp-bin
  cloudflare-speed-cli
  syncthing
  rclone
  rustdesk-bin
  termius
  ```
- `packages/sunshine.txt`:
  ```text
  sunshine
  ```
- `packages/hardware.txt`:
  ```text
  tlp
  tlp-pd
  tlp-rdw
  tlpui
  ufw
  ```

- [ ] **Step 2: Eski `packages.txt` dosyasını `git rm` ile kaldır**

```bash
git rm packages.txt
```

- [ ] **Step 3: Paket dosyalarının doğrulanması**

Tüm `packages/*.txt` dosyalarının mevcut olduğunu ve satır sayılarını doğrula:
```bash
wc -l packages/*.txt
```

- [ ] **Step 4: Commit**

```bash
git add packages/ packages.txt
git commit -m "refactor(packages): replace monolithic packages.txt with modular package lists"
```

---

### Task 2: `stow_all.sh` Betiğinin Dinamik Paket Argümanları Alacak Şekilde Güncellenmesi

**Files:**
- Modify: `stow_all.sh`

**Interfaces:**
- Consumes: İsteğe bağlı `$@` paket listesi argümanı.
- Produces: Belirtilen paketleri veya tüm paketleri bağlayan dinamik `stow_all.sh`.

- [ ] **Step 1: `stow_all.sh` betiğinde dinamik argüman mantığını ekle**

`stow_all.sh` dosyasında `PACKAGES` tanımlandığı bloğu güncelle:
```bash
# Eğer dışarıdan argüman verilmişse sadece o paketleri bağla, verilmemişse varsayılan tüm paketleri bağla
if [ $# -gt 0 ]; then
    TARGET_PACKAGES=()
    for pkg in "$@"; do
        if [ -d "$DOTFILES_DIR/$pkg" ]; then
            TARGET_PACKAGES+=("$pkg")
        else
            echo "⚠️ Uyarı: '$pkg' dotfiles paketi bulunamadı, atlanıyor."
        fi
    done
    if [ ${#TARGET_PACKAGES[@]} -eq 0 ]; then
        echo "⚠️ Bağlanacak geçerli dotfiles paketi bulunamadı."
        exit 0
    fi
else
    TARGET_PACKAGES=(
        btop
        fastfetch
        fish
        ghostty
        hypr
        kitty
        mango
        niri
        nvim
        ssh
        starship
        sunshine
        systemd
        user-dirs
        vivaldi
        zshrc.d
    )
fi

echo ":: Dotfiles 'stow' ile ana dizine bağlanıyor ($HOME)..."
echo "   Bağlanan paketler: ${TARGET_PACKAGES[*]}"
stow -R -t "$HOME" "${TARGET_PACKAGES[@]}"
```

- [ ] **Step 2: Sözdizimi kontrolü ve test**

Run: `bash -n stow_all.sh`
Expected: 0 çıkış kodu.

- [ ] **Step 3: Commit**

```bash
git add stow_all.sh
git commit -m "feat(stow): support selective package linking via arguments in stow_all.sh"
```

---

### Task 3: `install.sh` İçerisinde JaKooLit Tarzı UI, Bileşen Kaydı ve İnteraktif Soru Motorunun Geliştirilmesi

**Files:**
- Modify: `install.sh`

**Interfaces:**
- Produces: Kategorik soruları soran, kullanıcı yanıtlarını toplayan ve onay özeti sunan interaktif fonksiyonlar.

- [ ] **Step 1: ANSI renkleri, banner ve `ask_yn` fonksiyonunu tanımla**

```bash
# Renk Tanımlamaları
BOLD='\033[1m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

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
```

- [ ] **Step 2: İnteraktif anket fonksiyonunu (`run_wizard`) uygula**

Kategorileri ve spesifikasyonda belirlenen varsayılanları soran fonksiyonu yaz:
- Compositor: Hyprland [N], Niri [N], MangoWM [N]
- Terminal: Ghostty [Y], Kitty [N]
- Shell & Editör: Fish & Starship [Y], Neovim [Y], Temel CLI [Y]
- Uygulamalar: Vivaldi [Y], İletişim [Y], Dev [Y], Üretkenlik [Y], Medya [Y], Ağ & VPN [Y], Sunshine [N], Flatpaks [N]
- Donanım & Sistem: Güç/UFW [N], Keychron [N], Apple F-keys [N], iwd [N], Servisler [Y], Fontlar [Y]

Seçilenleri `SELECTED_MODULES` dizisinde biriktir.

- [ ] **Step 3: Onay özeti fonksiyonunu (`show_summary_and_confirm`) uygula**

Seçilen paket dosyalarını, bağlanacak stow paketlerini ve çalıştırılacak scriptleri listeleyen şık bir özet kutusu yazdır:
```text
================================================================
📋 SEÇİLEN KURULUM PLANI
================================================================
...
================================================================
```
Kullanıcıya `ask_yn "Kuruluma başlansın mı?" "Y"` sorusu sor; kullanıcı hayır derse `exit 0` ile iptal et.

- [ ] **Step 4: Sözdizimi kontrolü**

Run: `bash -n install.sh`
Expected: 0 çıkış kodu.

- [ ] **Step 5: Commit**

```bash
git add install.sh
git commit -m "feat(install): implement JaKooLit-style interactive question flow and summary box"
```

---

### Task 4: `install.sh` İçerisinde Sıralı Yürütme Motoru, `--dry-run` ve CLI Bayraklarının Eklenmesi

**Files:**
- Modify: `install.sh`

**Interfaces:**
- Produces: Sıralı 4 fazlı yürütme motoru, `--dry-run`, `--default`, `--all`, `--help` ve pozisyonel argüman desteği.

- [ ] **Step 1: `--dry-run`, `--default`, `--all`, `--help` argüman ayrıştırıcısını (CLI Parser) ekle**

`main()` fonksiyonunu güncelle:
```bash
DRY_RUN=false
MODE="interactive"
POSITIONAL_MODULES=()

for arg in "$@"; do
    case "$arg" in
        -n|--dry-run) DRY_RUN=true ;;
        -d|--default) MODE="default" ;;
        -a|--all) MODE="all" ;;
        -h|--help) show_help; exit 0 ;;
        *) POSITIONAL_MODULES+=("$arg") ;;
    esac
done
```

- [ ] **Step 2: Sıralı yürütme motorunu (`execute_plan`) uygula**

1. **Faz 1: Temel Bootstrap:**
   - `install_base_packages` (git, base-devel, stow).
   - `install_package_manager` (yay).
   - `packages/base.txt` paketlerini kur.
2. **Faz 2: Seçilen Modül Paketlerini Toplu Kur:**
   - Seçilen modüllerin `packages/<modul>.txt` dosyalarını birleştirip `sort -u` ile tek seferde yay'a ver (`yay -Syu --needed - < /tmp/selected_packages.txt`).
3. **Faz 3: Seçilen Dotfiles'ları Bağla:**
   - Seçilen stow paketlerini belirle ve `run_script "$DOTFILES_DIR/stow_all.sh" "${STOW_LIST[@]}"` çağrısı yap.
4. **Faz 4: Donanım ve Sistem Betiklerini Çalıştır:**
   - Seçilen `setup_*.sh` betiklerini `run_script` ile tetikle.
5. **Dry-Run Desteği:**
   - Eğer `DRY_RUN=true` ise sistem komutlarını çalıştırma; yerine ne yapılacağını renkli metinle yazdır ve çık.

- [ ] **Step 3: Sözdizimi kontrolü**

Run: `bash -n install.sh`
Expected: 0 çıkış kodu.

- [ ] **Step 4: Commit**

```bash
git add install.sh
git commit -m "feat(install): add sequential execution engine, --dry-run and CLI flags"
```

---

### Task 5: Dokümantasyonun Güncellenmesi (`README.md`)

**Files:**
- Modify: `README.md`

**Interfaces:**
- Produces: İnteraktif sihirbazı, yeni bayrakları (`--dry-run`, `--default`, `--all`) ve modüler `packages/` yapısını açıklayan güncel dokümantasyon.

- [ ] **Step 1: `README.md` dosyasını güncelle**

1. `## 🚀 Hızlı Kurulum` bölümüne interaktif sihirbazın varsayılan olduğunu ve `--dry-run` seçeneğini ekle.
2. `## 🧩 Modüler Kurulum Seçenekleri` bölümünü güncelle:
   - `--dry-run` / `-n`
   - `--default` / `-d`
   - `--all` / `-a`
   - Modüler argümanlar: `./install.sh hypr fish ghostty`
3. `packages/` yapısının mantığını ve bağımlılıklardan arındırılmış temiz yapısını açıkla.

- [ ] **Step 2: Commit**

```bash
git add README.md
git commit -m "docs: update README with interactive installer, dry-run flags and modular packages"
```

---

### Task 6: Kapsamlı Test ve Doğrulama

**Files:**
- Test: `install.sh`, `stow_all.sh`, `packages/*.txt`

- [ ] **Step 1: Tüm betiklerin sözdizimi doğrulaması**

Run:
```bash
bash -n install.sh && bash -n stow_all.sh
for f in scripts/*.sh; do bash -n "$f" || exit 1; done
```
Expected: 0 çıkış kodu (hata yok).

- [ ] **Step 2: `--dry-run --default` simülasyon testi**

Run:
```bash
./install.sh --dry-run --default
```
Expected: Varsayılan modüllerin (Ghostty, Fish, Neovim, Vivaldi, Social, Dev, Productivity, Media, Networking, Services, Fonts) seçildiğini, paket listelerinin ve stow paketlerinin doğru listelendiğini teyit et.

- [ ] **Step 3: `--dry-run` pozisyonel argüman testi**

Run:
```bash
./install.sh --dry-run hypr mango
```
Expected: Yalnızca Hyprland ve MangoWM bileşenlerinin seçildiğini teyit et.

- [ ] **Step 4: `stow_all.sh` seçici test**

Run:
```bash
./stow_all.sh ghostty
```
Expected: Yalnızca `ghostty` paketinin bağlandığını doğrula.

- [ ] **Step 5: Git durumu kontrolü**

Run:
```bash
git status
```
Expected: `nothing to commit, working tree clean`.
