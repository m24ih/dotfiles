# Zsh Modülü Entegrasyonu ve Varsayılan Kabuk Seçicisi Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** `MyZsh` reposunu dotfiles içine entegre ederek tek bir `zsh` Stow paketi altında toplamak, `install.sh`'a 23. modül olarak `zsh`'i ve etkileşimli varsayılan kabuk (login shell) seçicisini (`chsh -s`) kazandırmak.

**Architecture:** `MyZsh/.zshrc` ve mevcut `zshrc.d/` modülleri tek bir `zsh/` Stow paketinde birleştirilir. `packages/zsh.txt` ve `scripts/setup_zsh.sh` oluşturulur. `install.sh` bileşen kaydı güncellenerek sihirbazda Zsh için soru ve kabuk tercihi için `prompt_default_shell` mekanizması eklenir. `--dry-run` simülasyonu ve dokümantasyon tam uyumlu hale getirilir.

**Tech Stack:** Bash, GNU Stow, Zsh, Oh My Zsh, pacman, yay.

**Spec:** [`docs/superpowers/specs/2026-09-08-zsh-integration-and-default-shell-design.md`](file:///home/melih/Projects/dotfiles/docs/superpowers/specs/2026-09-08-zsh-integration-and-default-shell-design.md)

## Global Constraints

- `zshrc.d` dizini bağımsız stow paketi olmaktan çıkarılıp `zsh/` altında toplanacak.
- `zsh` modülü `install.sh` içinde varsayılan `[Y]` olacak.
- `scripts/setup_zsh.sh` Oh My Zsh ve 5 eklentiyi (`zsh-autosuggestions`, `zsh-syntax-highlighting`, `zsh-completions`, `zsh-history-substring-search`, `zsh-autopair`) kuracak; sembolik bağları Stow'a bırakacak.
- Varsayılan kabuk seçicisi `--dry-run` modunda sisteme müdahale etmeyecek, sadece planlanan `chsh -s` değişikliğini ekrana yazacak.

---

### Task 1: Zsh Stow Paketinin Konsolidasyonu ve `stow_all.sh` Güncellemesi

**Files:**
- Create: `zsh/.zshrc` (copied from `/home/melih/Projects/MyZsh/.zshrc` with `~/.config/zshrc.d` sourcing snippet appended)
- Create: `zsh/.config/zshrc.d/` (move files from `zshrc.d/.config/zshrc.d/`)
- Delete: `zshrc.d/` directory
- Modify: `stow_all.sh`

**Interfaces:**
- Produces: `zsh` stow target linking `~/.zshrc` and `~/.config/zshrc.d/`.

- [ ] **Step 1: `zsh/` dizinini oluştur ve `MyZsh/.zshrc` dosyasını kopyala**

```bash
mkdir -p zsh/.config/zshrc.d
cp /home/melih/Projects/MyZsh/.zshrc zsh/.zshrc
```

- [ ] **Step 2: `zsh/.zshrc` sonuna `zshrc.d` yükleme bloğunu ekle**

`zsh/.zshrc` dosyasının en sonuna ekle:
```zsh

# =============================================================================
# MODÜLER YAPILANDIRMALAR (~/.config/zshrc.d)
# =============================================================================
if [ -d "$HOME/.config/zshrc.d" ]; then
  for file in "$HOME/.config/zshrc.d"/*.{zsh,sh}(N); do
    [ -f "$file" ] && source "$file"
  done
fi
```

- [ ] **Step 3: `zshrc.d/.config/zshrc.d/` altındaki dosyaları `zsh/.config/zshrc.d/` içine taşı ve eski `zshrc.d` dizinini sil**

```bash
cp -r zshrc.d/.config/zshrc.d/* zsh/.config/zshrc.d/
git rm -r zshrc.d
```

- [ ] **Step 4: `stow_all.sh` içerisindeki hedef paket listesini güncelle**

`stow_all.sh` içindeki `TARGET_PACKAGES` dizisindeki `zshrc.d` yerine `zsh` koy:
```bash
# zshrc.d -> zsh
```

- [ ] **Step 5: Doğrulama ve test**

Run:
```bash
bash -n stow_all.sh
./stow_all.sh zsh
test -L "$HOME/.zshrc" && echo "ZSHRC_LINKED_OK"
```

- [ ] **Step 6: Commit**

```bash
git add zsh/ stow_all.sh
git commit -m "feat(zsh): consolidate MyZsh and zshrc.d into unified zsh stow package"
```

---

### Task 2: Modüler Paket Listesi (`packages/zsh.txt`) ve Kurulum Betiği (`scripts/setup_zsh.sh`)

**Files:**
- Create: `packages/zsh.txt`
- Create: `scripts/setup_zsh.sh`

**Interfaces:**
- Produces: `packages/zsh.txt` for batch pacman/yay installation.
- Produces: `scripts/setup_zsh.sh` for unattended Oh My Zsh and plugin cloning.

- [ ] **Step 1: `packages/zsh.txt` dosyasını oluştur**

`packages/zsh.txt` içeriği:
```text
zsh
fzf
zsh-completions
zsh-autosuggestions
zsh-syntax-highlighting
eza
```

- [ ] **Step 2: `scripts/setup_zsh.sh` betiğini oluştur ve yetkilendir**

`scripts/setup_zsh.sh` içeriği:
```bash
#!/usr/bin/env bash
#
# Zsh & Oh My Zsh Kurulum ve Eklenti Yapılandırma Betiği
#

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}:: Zsh ve Oh My Zsh ortamı yapılandırılıyor...${NC}"

# 1. Oh My Zsh Kurulumu
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${GREEN}:: Oh My Zsh kuruluyor (unattended)...${NC}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo -e "${GREEN}:: Oh My Zsh zaten kurulu.${NC}"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# 2. Özel Eklentilerin Kurulumu
declare -A PLUGINS=(
    ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions"
    ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
    ["zsh-completions"]="https://github.com/zsh-users/zsh-completions"
    ["zsh-history-substring-search"]="https://github.com/zsh-users/zsh-history-substring-search"
    ["zsh-autopair"]="https://github.com/hlissner/zsh-autopair"
)

mkdir -p "$ZSH_CUSTOM/plugins"

for plugin in "${!PLUGINS[@]}"; do
    if [ ! -d "$ZSH_CUSTOM/plugins/$plugin" ]; then
        echo -e "${GREEN}:: Eklenti indiriliyor: $plugin...${NC}"
        git clone --depth=1 "${PLUGINS[$plugin]}" "$ZSH_CUSTOM/plugins/$plugin" 2>/dev/null || {
            echo -e "${YELLOW}⚠️ Uyarı: $plugin klonlanamadı.${NC}"
        }
    else
        echo -e "${GREEN}:: Eklenti hazır: $plugin${NC}"
    fi
done

echo -e "${GREEN}✅ Zsh ve Oh My Zsh ortamı başarıyla hazırlandı.${NC}"
```
`chmod +x scripts/setup_zsh.sh`

- [ ] **Step 3: Sözdizimi kontrolü**

Run: `bash -n scripts/setup_zsh.sh`
Expected: 0 çıkış kodu.

- [ ] **Step 4: Commit**

```bash
git add packages/zsh.txt scripts/setup_zsh.sh
git commit -m "feat(zsh): add packages/zsh.txt and scripts/setup_zsh.sh for Oh My Zsh automation"
```

---

### Task 3: `install.sh` İçerisine `zsh` Modülü, Soru Motoru ve Varsayılan Kabuk Seçicisinin Eklenmesi

**Files:**
- Modify: `install.sh`

**Interfaces:**
- Produces: 23-module component registry with `zsh`.
- Produces: `prompt_default_shell()` wizard step and `chsh -s` integration in `execute_plan()`.

- [ ] **Step 1: Bileşen kaydına `zsh` ekle**

`install.sh` içinde:
- `ALL_MODULES`: `fish` ardına `zsh` ekle.
- `DEFAULT_MODULES`: `zsh` ekle.
- `get_module_title()`: `zsh) echo "Zsh Kabuğu & Oh My Zsh Ortamı" ;;`
- `get_module_package_file()`: `zsh) echo "packages/zsh.txt" ;;`
- `get_module_stow_packages()`: `zsh) echo "zsh" ;;`
- `get_module_scripts()`: `zsh) echo "scripts/setup_zsh.sh" ;;`

- [ ] **Step 2: `prompt_default_shell()` fonksiyonunu ekle**

```bash
TARGET_SHELL_BIN=""

prompt_default_shell() {
    local current_sh
    current_sh="$(basename "$SHELL" 2>/dev/null || echo "bash")"
    
    echo -e "\n${PURPLE}┌──────────────────────────────────────────────────────────────┐${NC}"
    echo -e "${PURPLE}│${NC} ${BOLD}${CYAN}[Kabuk Tercihi]${NC} ${BOLD}Varsayılan Oturum Kabuğu (Default Login Shell)${NC}"
    echo -e "${PURPLE}└──────────────────────────────────────────────────────────────┘${NC}"
    echo -e "Mevcut kabuğunuz: ${BOLD}${GREEN}$current_sh${NC} ($SHELL)\n"
    echo -e "Kullanılabilir Seçenekler:"
    echo -e "  ${CYAN}1) fish${NC} : Modern, zengin otomatik tamamlama ve renklendirme"
    echo -e "  ${CYAN}2) zsh${NC}  : Güçlü, POSIX uyumlu, Oh My Zsh ve zengin eklenti ekosistemi"
    echo -e "  ${CYAN}3) bash${NC} : Standart sistem kabuğu"
    echo -e "  ${CYAN}4) atla${NC} : Mevcut kabuğu koru (Değişiklik yapma)\n"

    local choice
    read -r -p "$(echo -e "${CYAN}?${NC} Varsayılan kabuğunuz hangisi olsun? ${YELLOW}[1/2/3/4 veya fish/zsh/bash/atla]${NC} (Varsayılan: atla): ")" choice
    choice="${choice:-atla}"
    choice="$(echo "$choice" | tr '[:upper:]' '[:lower:]')"

    local selected_name=""
    case "$choice" in
        1|fish) selected_name="fish" ;;
        2|zsh)  selected_name="zsh" ;;
        3|bash) selected_name="bash" ;;
        4|atla|skip|none) selected_name="" ;;
        *)
            echo -e "${YELLOW}⚠️ Geçersiz seçim yapıldı. Mevcut kabuk korunuyor.${NC}"
            selected_name=""
            ;;
    esac

    if [ -n "$selected_name" ]; then
        local target_bin
        target_bin="$(command -v "$selected_name" 2>/dev/null || which "$selected_name" 2>/dev/null || echo "/bin/$selected_name")"
        if [ "$target_bin" != "$SHELL" ]; then
            TARGET_SHELL_BIN="$target_bin"
        fi
    fi
}
```

- [ ] **Step 3: `run_wizard()`, `show_summary_and_confirm()`, `execute_plan()` ve `show_help()` fonksiyonlarını güncelle**

- In `run_wizard()`:
  In Category 3, ask:
  ```bash
  if ask_yn "Zsh kabuğu ve Oh My Zsh ortamı kurulsun mu?" "Y"; then
      SELECTED_MODULES+=("zsh")
  fi
  ```
  At end of Category 3, call: `prompt_default_shell`.

- In `show_summary_and_confirm()`:
  If `[ -n "$TARGET_SHELL_BIN" ]`:
  Display: `   • Varsayılan Oturum Kabuğu: $SHELL -> $TARGET_SHELL_BIN (chsh -s)`

- In `execute_plan()`:
  - Dry-run block:
    If `[ -n "$TARGET_SHELL_BIN" ]`:
    Print `   • Varsayılan kabuk değiştirilecek: $SHELL -> $TARGET_SHELL_BIN (chsh -s $TARGET_SHELL_BIN)`
  - Live Phase 4:
    If `[ -n "$TARGET_SHELL_BIN" ]`:
    Check `/etc/shells`. If `$TARGET_SHELL_BIN` is in `/etc/shells` or `command -v chsh`:
    Run: `chsh -s "$TARGET_SHELL_BIN" || echo -e "${YELLOW}⚠️ Kabuk değiştirilemedi.${NC}"`

- In `show_help()`:
  Add `zsh` under Category 3 in the module list.

- [ ] **Step 4: Sözdizimi kontrolü ve CLI testleri**

Run:
```bash
bash -n install.sh
./install.sh --help
./install.sh --dry-run --default
./install.sh --dry-run zsh
```

- [ ] **Step 5: Commit**

```bash
git add install.sh
git commit -m "feat(install): add zsh module and interactive default shell selector"
```

---

### Task 4: Dokümantasyonun Güncellenmesi (`README.md`)

**Files:**
- Modify: `README.md`

**Interfaces:**
- Produces: Updated `README.md` reflecting 23 modules, `packages/zsh.txt`, `zsh/` stow package, and default shell selector.

- [ ] **Step 1: `README.md` dosyasını güncelle**

1. `## 🧩 Modüler Kurulum Seçenekleri` tablosundaki modül sayısını 23 yap ve `zsh` modülünü (`packages/zsh.txt`, `zsh` stow paketi, `scripts/setup_zsh.sh`) ekle.
2. `## 📦 Modüler Paket Yapısı (packages/)` tablosuna `packages/zsh.txt` dosyasını ekle (toplam 18 dosya).
3. `## 📦 Paket Yapısı & Modüler Dokümantasyon` tablosundaki `zshrc.d/` satırını `zsh/` ile güncelle.
4. `## 🛠️ Donanım & Sistem Betikleri` listesine `scripts/setup_zsh.sh` betiğini ekle.
5. Varsayılan kabuk seçici özelliğini `README.md` içinde açıkla.

- [ ] **Step 2: Commit**

```bash
git add README.md
git commit -m "docs: document zsh module, packages/zsh.txt, and default shell selector"
```

---

### Task 5: Uçtan Uca Doğrulama ve Test

**Files:**
- Test: `install.sh`, `stow_all.sh`, `scripts/*.sh`, `packages/*.txt`

- [ ] **Step 1: Tüm betiklerin sözdizimi doğrulaması**

Run:
```bash
bash -n install.sh && bash -n stow_all.sh
for f in scripts/*.sh; do bash -n "$f" || exit 1; done
```
Expected: 0 çıkış kodu.

- [ ] **Step 2: `--dry-run --default` simülasyonu**

Run:
```bash
./install.sh --dry-run --default
```
Expected: `packages/zsh.txt` paketlerinin (eza, fzf, zsh vb.) ve `zsh` stow paketinin dahil edildiğini doğrula.

- [ ] **Step 3: `--dry-run zsh` pozisyonel argüman simülasyonu**

Run:
```bash
./install.sh --dry-run zsh
```
Expected: Sadece Zsh paketlerinin, `zsh` stow paketinin ve `scripts/setup_zsh.sh` betiğinin seçildiğini doğrula.

- [ ] **Step 4: Git çalışma ağacı kontrolü**

Run:
```bash
git status
```
Expected: `nothing to commit, working tree clean`.
